#!/bin/bash

# ANSI color codes
RED='\033[0;31m'
RESET_COLOR='\033[0m' # Reset to default color

# List all connected devices
sudo lsblk

# Get the device name
echo ""
read -p "[Prompt] From the above list, what is the \"SD. Card\" device name? /dev/" SDCARD_DEV_NAME
SDCARD_DEV_NAME="/dev/${SDCARD_DEV_NAME}"

# Checking the input value
ls ${SDCARD_DEV_NAME}

if [ $? -ne 0 ]; then
    echo -e "${RED}[INFO] Device name provided does not exist, script will be terminated!${RESET_COLOR}"
    exit 1
else
    echo -e "[INFO] Device name provided exist .."
fi

read -p "[Warning] All data on ${SDCARD_DEV_NAME} will be lost, are you sure? (yes/no): " CONFIRMATION

# Convert user input to lowercase for case insensitivity
CONFIRMATION=$(echo "$CONFIRMATION" | tr '[:upper:]' '[:lower:]')

# Check the confirmation
if [[ "$CONFIRMATION" == "yes" ]]; then
    echo -e "[INFO] Device is confirmed .."
else
    echo -e "${RED}[INFO] Device is not confirmed, the script will be terminated!${RESET_COLOR}"
fi

# List all mounted partitions of the device
MOUNTED_PARTITIONS=$(lsblk -ln -o MOUNTPOINT "$SDCARD_DEV_NAME" | grep -v "^$")

if [ -z "$MOUNTED_PARTITIONS" ]; then
    echo "[INFO] No mounted partitions found on $SDCARD_DEV_NAME."
fi

# Unmount each partition
for MOUNTPOINT in $MOUNTED_PARTITIONS; do
    echo "[INFO] Unmounting $MOUNTPOINT"
    sudo umount "$MOUNTPOINT"
    if [ $? -ne 0 ]; then
        echo -e "${RED}[INFO] Failed to unmount $MOUNTPOINT${RED}"
        exit 1
    fi
done

echo -e "[INFO] All partitions of $SDCARD_DEV_NAME have been unmounted .."
sudo sync

# Delete the partition table
sudo dd if=/dev/zero of=${SDCARD_DEV_NAME} bs=1M count=16
sudo sync

# Start parted in non-interactive mode and partition the device
sudo parted -s ${SDCARD_DEV_NAME} mklabel msdos                     # Create a new MS-DOS partition table
sudo parted -s ${SDCARD_DEV_NAME} mkpart primary fat32 1MiB 129MiB  # Create the first partition: primary, FAT32, 128MB starting at 1MiB
sudo parted -s ${SDCARD_DEV_NAME} set 1 boot on                     # Set the boot flag on the first partition
sudo parted -s ${SDCARD_DEV_NAME} mkpart primary ext4 129MiB 100%   # Create the second partition: primary, fat32, rest of the space
sudo sync

sudo mkfs.fat ${SDCARD_DEV_NAME}1 -F 32 -n BOOT                     # Format first partition as FAT32
sudo sync
sudo mkfs.ext4 ${SDCARD_DEV_NAME}2 -L ROOTFS                        # Format second partition as ext4 with label
sudo sync

sudo parted -s ${SDCARD_DEV_NAME} print                             # Print the partition table for verification

