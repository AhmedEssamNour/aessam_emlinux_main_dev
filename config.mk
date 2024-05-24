# Global path configurations:
export MAIN_DEV_PATH       := $(shell pwd)

export DOC_PATH            := $(MAIN_DEV_PATH)/1_doc
export PRODUCT_PATH        := $(MAIN_DEV_PATH)/2_product
export TOOLS_PATH          := $(MAIN_DEV_PATH)/3_tools

export SOFTWARE_PATH       := $(PRODUCT_PATH)/1_software
export EXTERNAL_PATH       := $(PRODUCT_PATH)/2_external
export PRODUCT_TOOLS_PATH  := $(PRODUCT_PATH)/3_tools

export CROSSTOOL_NG_PATH        := $(PRODUCT_TOOLS_PATH)/crosstool-ng
export CROSSTOOL_NG_BIN_PATH    := $(PRODUCT_TOOLS_PATH)/crosstool-ng/bin
export CROSSTOOL_NG_CFG_PATH    := $(PRODUCT_TOOLS_PATH)/crosstool-ng/config
export CROSSTOOL_NG_SOURCE_PATH := $(PRODUCT_TOOLS_PATH)/crosstool-ng/source


# Board type configuration
export BOARD_TYPE ?= bbb


# "crosstool-NG" toolchain configurations:
export CROSSTOOL_NG_REPO   = https://github.com/crosstool-ng/crosstool-ng
export CROSSTOOL_NG_BRANCH = crosstool-ng-1.26.0
