# Global path configurations:
MAIN_DEV_PATH       := $(shell pwd)

DOC_PATH            := $(MAIN_DEV_PATH)/1_doc
PRODUCT_PATH        := $(MAIN_DEV_PATH)/2_product
TOOLS_PATH          := $(MAIN_DEV_PATH)/3_tools

SOFTWARE_PATH       := $(PRODUCT_PATH)/1_software
EXTERNAL_PATH       := $(PRODUCT_PATH)/2_external
PRODUCT_TOOLS_PATH  := $(PRODUCT_PATH)/3_tools

CROSSTOOL-NG_BIN    := $(PRODUCT_TOOLS_PATH)/crosstool-ng/bin
CROSSTOOL-NG_CFG    := $(PRODUCT_TOOLS_PATH)/crosstool-ng/config
CROSSTOOL-NG_SOURCE := $(PRODUCT_TOOLS_PATH)/crosstool-ng/source


# "crosstool-NG" toolchain configurations:
CROSSTOOL-NG_REPO   = https://github.com/crosstool-ng/crosstool-ng
CROSSTOOL-NG_BRANCH = crosstool-ng-1.26.0