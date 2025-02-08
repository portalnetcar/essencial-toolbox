#!/bin/bash

# ==============================================
# MicroSD Performance Test Script (Samsung EVO Plus 128GB)
# - Tests real-time write/read performance without OS caching
# - Uses O_DIRECT to bypass kernel page cache
# - Checks for missing packages and installs them
# - Generates a report with sequential and random tests
# ==============================================

SD_PATH=$1

if [ -n "$SD_PATH" ]; then
    echo "Checking device: $SD_PATH"
else 
    echo "PATH is required"
fi

SDCARD_MOUNTPOINT=$SD_PATH
REPORT_FILE="sdcard_test_report.txt"

# List of required packages
REQUIRED_PACKAGES=("fio" "f3" "dd")
MISSING_PACKAGES=()

echo "Checking for required packages..."
for pkg in "${REQUIRED_PACKAGES[@]}"; do
    if ! command -v "$pkg" &> /dev/null; then
        MISSING_PACKAGES+=("$pkg")
    fi
done

if [ ${#MISSING_PACKAGES[@]} -gt 0 ]; then
    echo "Installing missing packages: ${MISSING_PACKAGES[*]}"
    sudo apt update && sudo apt install -y "${MISSING_PACKAGES[@]}"
else
    echo "All required packages are installed."
fi

# Ensure mount point exists
mkdir -p "$SDCARD_MOUNTPOINT"

# Verify if microSD is mounted
if ! mount | grep -q "$SDCARD_MOUNTPOINT"; then
    echo "Error: microSD is not mounted at $SDCARD_MOUNTPOINT."
    echo "Please mount it manually and run the script again."
    exit 1
fi

# Disable OS caching (forces direct disk access)
echo "Disabling Linux write cache for accurate results..."
sync && echo 3 | sudo tee /proc/sys/vm/drop_caches

# Start Report
echo "=== MicroSD Performance Test (Samsung EVO Plus 128GB) ===" > "$REPORT_FILE"
echo "Test Date: $(date)" >> "$REPORT_FILE"
echo "Mount Point: $SDCARD_MOUNTPOINT" >> "$REPORT_FILE"
echo "--------------------------------------------------------" >> "$REPORT_FILE"

# Integrity Test (F3)
echo "Running F3 integrity test..."
f3write "$SDCARD_MOUNTPOINT" > "$SDCARD_MOUNTPOINT/f3write.log"
f3read "$SDCARD_MOUNTPOINT" > "$SDCARD_MOUNTPOINT/f3read.log"

echo ">>> F3 Write Test Results:" >> "$REPORT_FILE"
tail -n 10 "$SDCARD_MOUNTPOINT/f3write.log" >> "$REPORT_FILE"

echo ">>> F3 Read Test Results:" >> "$REPORT_FILE"
tail -n 10 "$SDCARD_MOUNTPOINT/f3read.log" >> "$REPORT_FILE"

# Sequential Write/Read Test (DD with O_DIRECT)
echo "Running sequential write speed test..."
WRITE_SPEED=$(dd if=/dev/zero of="$SDCARD_MOUNTPOINT/testfile" bs=4M count=1000 oflag=direct status=progress 2>&1 | tail -n 1 | awk '{print $(NF-1), $NF}')

echo "Running sequential read speed test..."
READ_SPEED=$(dd if="$SDCARD_MOUNTPOINT/testfile" of=/dev/null bs=4M iflag=direct status=progress 2>&1 | tail -n 1 | awk '{print $(NF-1), $NF}')

echo ">>> Sequential Write Speed: $WRITE_SPEED" >> "$REPORT_FILE"
echo ">>> Sequential Read Speed: $READ_SPEED" >> "$REPORT_FILE"

# Random IOPS Test with FIO
echo "Running random IOPS test with FIO..."
FIO_RESULT=$(fio --name=microsd-test --filename="$SDCARD_MOUNTPOINT/testfile" --rw=randwrite --bs=4k --size=500M --numjobs=1 --time_based --runtime=30s --group_reporting --direct=1 2>&1)

echo ">>> Random Write IOPS Test:" >> "$REPORT_FILE"
echo "$FIO_RESULT" | grep -E "iops|READ|WRITE" >> "$REPORT_FILE"

# Cleanup test files
rm -f "$SDCARD_MOUNTPOINT/testfile"
rm -f "$SDCARD_MOUNTPOINT/f3write.log"
rm -f "$SDCARD_MOUNTPOINT/f3read.log"

# Complete report
echo "MicroSD test completed. Report saved to: $REPORT_FILE"
