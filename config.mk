######################################################################################
############################# Global Path Configurations #############################
######################################################################################
export MAIN_DEV_PATH       := $(shell pwd)

export DOC_PATH            := $(MAIN_DEV_PATH)/1_doc
export PRODUCT_PATH        := $(MAIN_DEV_PATH)/2_product
export TOOLS_PATH          := $(MAIN_DEV_PATH)/3_tools

export SOFTWARE_PATH       := $(PRODUCT_PATH)/1_software
export EXTERNAL_SW_PATH    := $(PRODUCT_PATH)/2_external_sw
export PRODUCT_TOOLS_PATH  := $(PRODUCT_PATH)/3_tools

export CROSSTOOL_NG_PATH        := $(PRODUCT_TOOLS_PATH)/crosstool-ng
export CROSSTOOL_NG_BIN_PATH    := $(CROSSTOOL_NG_PATH)/bin
export CROSSTOOL_NG_CFG_PATH    := $(CROSSTOOL_NG_PATH)/config
export CROSSTOOL_NG_SOURCE_PATH := $(CROSSTOOL_NG_PATH)/source

export UBOOT_PATH        := $(EXTERNAL_SW_PATH)/u-boot
export UBOOT_BIN_PATH    := $(UBOOT_PATH)/bin
export UBOOT_CFG_PATH    := $(UBOOT_PATH)/config
export UBOOT_SOURCE_PATH := $(UBOOT_PATH)/source

export KERNEL_PATH          := $(EXTERNAL_SW_PATH)/kernel
export KERNEL_BIN_PATH      := $(KERNEL_PATH)/bin
export KERNEL_CFG_PATH      := $(KERNEL_PATH)/config
export KERNEL_SOURCE_PATH   := $(KERNEL_PATH)/source
export KERNEL_RT_PATCH_PATH := $(KERNEL_PATH)/rt-patch


######################################################################################
################################ Board Configurations ################################
######################################################################################
export BOARD_TYPE ?= bbb


######################################################################################
############################## Compiler Configurations ###############################
######################################################################################
export PATH:=${PATH}:${CROSSTOOL_NG_BIN_PATH}/${BOARD_TYPE}/x-tools/arm-${BOARD_TYPE}-linux-musleabihf/bin
export CROSS_COMPILE=arm-${BOARD_TYPE}-linux-


######################################################################################
###################### "Crosstool-NG" Toolchain Configurations #######################
######################################################################################
export CROSSTOOL_NG_REPO   = https://github.com/crosstool-ng/crosstool-ng
export CROSSTOOL_NG_BRANCH = crosstool-ng-1.26.0


######################################################################################
############################## "U-Boot" Configurations ###############################
######################################################################################
export UBOOT_REPO   = https://gitlab.denx.de/u-boot/u-boot
export UBOOT_BRANCH = v2024.04


######################################################################################
############################## "kernel" Configurations ###############################
######################################################################################
export KERNEL_REPO   = https://github.com/torvalds/linux.git
export KERNEL_BRANCH = v6.6
export KERNEL_REL   ?= ${KERNEL_BRANCH}