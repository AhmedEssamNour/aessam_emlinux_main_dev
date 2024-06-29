#!/bin/bash


# Checking the "op_dev" is valid
ls ${3}

if [ $? -ne 0 ]; then
    echo -e "${RED}[INFO] Device name provided does not exist, script will be terminated!${RESET_COLOR}"
    exit 1
else
    # Create a temp directory
    sudo mkdir -p ~/sdcard_temp_00

    # Unmount the drive to mount it to a know place, could be handled more illegantly xD
    sudo umount ${3}1

    # Mount the drive back to the new temp directory
    sudo mount -o rw ${3}1 ~/sdcard_temp_00

    # Move the uboot files to the partition (Forst partition = boot partition)
    sudo cp -r ${2}/${1}/* ~/sdcard_temp_00
    sudo sync
fi
