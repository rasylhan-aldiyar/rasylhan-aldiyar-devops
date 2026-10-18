#!/bin/bash
# Project checks used by the Jenkins "Test" stage.
# Exit code 0 = all checks passed, 1 = something is wrong (the stage fails).

cd "$(dirname "${BASH_SOURCE[0]}")/.." || exit 1

FAILED=0
pass() { echo "[PASS] $1"; }
fail() { echo "[FAIL] $1"; FAILED=1; }

echo "Running project checks..."

for dir in app scripts config; do
    [ -d "$dir" ] && pass "directory $dir/ exists" || fail "directory $dir/ is missing"
done

for file in Rasylhan_Aldiyar_info.txt config/app.conf scripts/Rasylhan_Aldiyar_system.sh app/app.py \
            Dockerfile docker-compose.yml Jenkinsfile .gitignore; do
    [ -f "$file" ] && pass "file $file exists" || fail "file $file is missing"
done

grep -q "Student ID: 37838" Rasylhan_Aldiyar_info.txt \
    && pass "info file contains Student ID" || fail "info file has no Student ID"

for keyword in FROM WORKDIR COPY RUN EXPOSE CMD; do
    grep -q "^$keyword" Dockerfile && pass "Dockerfile uses $keyword" || fail "Dockerfile has no $keyword"
done

for pattern in '\*.log' 'backup/' '.env'; do
    grep -q "^$pattern" .gitignore && pass ".gitignore ignores $pattern" || fail ".gitignore misses $pattern"
done

OUTPUT="$(bash scripts/Rasylhan_Aldiyar_system.sh)"
echo "$OUTPUT"
echo "$OUTPUT" | grep -q "Student information file exists." \
    && pass "system script finds the info file" || fail "system script did not find the info file"

if [ "$FAILED" -eq 0 ]; then
    echo "All checks passed."
else
    echo "Some checks failed."
fi
exit "$FAILED"
