#!/bin/bash
# Rasylhan_Aldiyar_system.sh — prints student and system information
# Author: Rasylhan Aldiyar, group IT2-2309, Student ID 37838

# Folder of this script and the project root (one level up),
# so the script works no matter where it is started from.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
INFO_FILE="$PROJECT_DIR/Rasylhan_Aldiyar_info.txt"

LINE="=============================="

# Values can be overridden by environment variables (used by Jenkins)
NAME="${STUDENT_NAME:-Aldiyar}"
SURNAME="${STUDENT_SURNAME:-Rasylhan}"
GROUP="${STUDENT_GROUP:-IT2-2309}"
ID="${STUDENT_ID:-37838}"

# Operating system: pretty name from /etc/os-release if available
if [ -r /etc/os-release ]; then
    # read in a subshell so variables NAME/ID from os-release do not overwrite ours
    OS_NAME="$(. /etc/os-release && echo "$PRETTY_NAME") ($(uname -s) $(uname -r))"
else
    OS_NAME="$(uname -s) $(uname -r)"
fi

# hostname may be missing in minimal containers
HOST="$(hostname 2>/dev/null || cat /etc/hostname)"

DISK="$(df -h / | awk 'NR==2 {print $3 " used of " $2 " (" $5 ")"}')"
if command -v free >/dev/null 2>&1; then
    MEMORY="$(free -h | awk '/^Mem:/ {print $3 " used of " $2}')"
else
    MEMORY="free command not available"
fi

echo "$LINE"
echo "Student Information"
echo "$LINE"
echo "Name: $NAME"
echo "Surname: $SURNAME"
echo "Group: $GROUP"
echo "Student ID: $ID"
echo "$LINE"
echo "System Information"
echo "$LINE"
echo "Username: $(whoami)"
echo "Hostname: $HOST"
echo "Current Date: $(date '+%Y-%m-%d %H:%M:%S')"
echo "Operating System: $OS_NAME"
echo "Disk Usage: $DISK"
echo "Memory Usage: $MEMORY"
echo "$LINE"

if [ -f "$INFO_FILE" ]; then
    echo "Student information file exists."
else
    echo "Student information file does not exist."
fi
