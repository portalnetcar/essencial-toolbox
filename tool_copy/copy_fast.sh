#!/usr/bin/env bash
#
# Usage: copy_to_pendrive.sh <source_folder> <destination_folder>
# Example: ./copy_to_pendrive.sh /home/user/Documents /media/user/USB-PENDRIVE

# Exit on any error
set -e

# Check arguments
if [ $# -ne 2 ]; then
  echo "Usage: $0 <source_directory> <destination_directory>"
  exit 1
fi

SRC="$1"
DEST="$2"

# Optional: Verify that SRC exists
if [ ! -d "$SRC" ]; then
  echo "Source directory '$SRC' does not exist."
  exit 1
fi

# Optional: Create destination if it doesn't exist
if [ ! -d "$DEST" ]; then
  echo "Destination directory '$DEST' does not exist. Creating it..."
  mkdir -p "$DEST"
fi

# Attempt to minimize page caching side effects (Requires sudo)
# Flush writes from filesystem buffers
echo "Flushing and dropping caches (requires sudo)..."
sudo sync
sudo sh -c 'echo 3 > /proc/sys/vm/drop_caches'

echo "Starting copy from '$SRC' to '$DEST'..."

# -a (archive): recursive, preserves permissions and timestamps
# -v (verbose): to show the file names
# -h (human-readable): for easier-to-read output
# --progress: shows progress per file
# --stats: provides final statistics after the copy
rsync -avh --progress --stats "$SRC/" "$DEST/"

echo "Copy operation complete."

# (Optional) Drop caches again if you want minimal residual cache
echo "Flushing and dropping caches again after copy..."
sudo sync
sudo sh -c 'echo 3 > /proc/sys/vm/drop_caches'

echo "Done."
