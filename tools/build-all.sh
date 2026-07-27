#!/bin/bash
# Builds every program in the repository. Threaded programs go through g++ with the
# scd support library that sits next to them; MPI programs go through mpic++.
# Binaries land in build/, which is git-ignored.
#
# Programs listed in known-build-failures.txt are expected not to build. If one of
# them builds, this script fails: the list would be lying.
set -u

root="$(cd "$(dirname "$0")/.." && pwd)"
out="$root/build"
known="$(dirname "$0")/known-build-failures.txt"
mkdir -p "$out"
failed=0
stale=0

is_known() {
  local rel="${1#"$root"/}"
  grep -v '^#' "$known" | grep -q "^$rel[[:space:]]*\(#.*\)\?$"
}

compile() {
  local src="$1" name dir scd
  name="$(basename "${src%.cpp}")"
  dir="$(dirname "$src")"
  scd="$dir/scd.cpp"

  if grep -q '#include *<mpi.h>' "$src"; then
    mpic++ -std=c++11 "$src" -o "$out/$name"
  elif [ -f "$scd" ]; then
    g++ -std=c++11 -pthread -I"$dir" "$src" "$scd" -o "$out/$name"
  elif grep -q '"scd.h"' "$src"; then
    # The exams reuse the scd library of practice 1.
    local lib="$root/src/practice-1-semaphores/producer-consumer"
    g++ -std=c++11 -pthread -I"$lib" "$src" "$lib/scd.cpp" -o "$out/$name"
  else
    g++ -std=c++11 -pthread -I"$dir" "$src" -o "$out/$name"
  fi
}

while IFS= read -r src; do
  [ "$(basename "$src")" = scd.cpp ] && continue
  rel="${src#"$root"/}"

  if is_known "$src"; then
    if compile "$src" 2>/dev/null; then
      echo "STALE  $rel builds, but it is listed as a known failure"
      stale=1
    else
      echo "skip   $rel (known failure)"
    fi
    continue
  fi

  echo "build  $rel"
  compile "$src" || failed=1
done < <(find "$root/src" "$root/docs/exams" -name '*.cpp' | sort)

if [ "$stale" -ne 0 ]; then
  echo "known-build-failures.txt is out of date"
  exit 1
fi
if [ "$failed" -ne 0 ]; then
  echo "some programs did not build"
  exit 1
fi
echo "all programs built, except the known failures"
