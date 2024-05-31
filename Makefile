# Global configurations
include config.mk


# Default rule
all: 


# Initializing the environment (i.e. install all required packages, .. etc.)
init_env:
	@echo
	@echo "[INFO] Installing all required packages for \"Crosstool-ng\" .."
	@sudo apt install build-essential git autoconf bison flex texinfo help2man gawk libtool-bin libncurses5-dev unzip
	@echo
	@echo "[INFO] Installing all required packages for \"U-BOOT\" .."
	@sudo apt install libssl-dev device-tree-compiler swig python3-distutils python3-dev python3-setuptools


######################################################################################
######################### "crosstool-NG" Toolchain Section ###########################
######################################################################################
# Cloning and building the "Crosstool-NG" toolchain 
init_crosstool-ng:
	@echo
	@echo "[INFO] Cloning the \"Crosstool-NG\" toolchain to \"$(CROSSTOOL_NG_SOURCE_PATH)/\" .."
	@mkdir $(CROSSTOOL_NG_SOURCE_PATH) && cd $(CROSSTOOL_NG_PATH) && git clone --depth 1 $(CROSSTOOL_NG_REPO) -b $(CROSSTOOL_NG_BRANCH) source
	@echo
	@echo "[INFO] Building the \"Crosstool-NG\" toolchain framework and generating the configuration samples .."
	@cd $(CROSSTOOL_NG_SOURCE_PATH) && ./bootstrap
	@cd $(CROSSTOOL_NG_SOURCE_PATH) && ./configure --enable-local
	@cd $(CROSSTOOL_NG_SOURCE_PATH) && $(MAKE)

# Building the "Crosstool-NG" compiler for the given "BOARD TYPE"
build_crosstool-ng:
	@echo
	@echo "[INFO] Moving the saved configuration for the \"$(BOARD_TYPE)\" board to the building folder .."
	@cp $(CROSSTOOL_NG_CFG_PATH)/$(BOARD_TYPE)/.config $(CROSSTOOL_NG_SOURCE_PATH)
	@echo "[INFO] Starting the \"menuconfig\" for configuration refinement .."
	@cd $(CROSSTOOL_NG_SOURCE_PATH) && ./ct-ng menuconfig
	@echo "[INFO] Saving back the new \".config\" .."
	@cp $(CROSSTOOL_NG_SOURCE_PATH)/.config $(CROSSTOOL_NG_CFG_PATH)/$(BOARD_TYPE)
	@echo "[INFO] Building the \"Crosstool-NG\" compiler for the \"$(BOARD_TYPE)\" board .."
	@cd $(CROSSTOOL_NG_SOURCE_PATH) && ./ct-ng build


######################################################################################
################################# "U-Boot" Section ###################################
######################################################################################	
# Cloning and preparing the "U-Boot" building environment 
init_u-boot:
	@echo
	@echo "[INFO] Cloning the \"U-BOOT\" source code to \"$(UBOOT_SOURCE_PATH)/\" .."
	@mkdir $(UBOOT_SOURCE_PATH) && cd $(UBOOT_PATH) && git clone --depth 1 $(UBOOT_REPO) -b $(UBOOT_BRANCH) source

# Building the "U-Boot" binary for the given "BOARD TYPE"
build_u-boot:
	@echo
	@echo "[INFO] Moving the saved configuration for the \"$(BOARD_TYPE)\" board to the building folder .."
	@cp $(UBOOT_CFG_PATH)/$(BOARD_TYPE)/.config $(UBOOT_SOURCE_PATH)
	@echo "[INFO] Starting the \"menuconfig\" for configuration refinement .."
	@cd $(UBOOT_SOURCE_PATH) && $(MAKE) menuconfig
	@echo "[INFO] Saving back the new \".config\" .."
	@cp $(UBOOT_SOURCE_PATH)/.config $(UBOOT_CFG_PATH)/$(BOARD_TYPE)
	@echo "[INFO] Building the \"U-Boot\" for the \"$(BOARD_TYPE)\" board .."
	@cd $(UBOOT_SOURCE_PATH) && $(MAKE)
	@echo "[INFO] Moving the output generated images to the \"/bin\" folder of the \"$(BOARD_TYPE)\" board .."
	@cp $(UBOOT_SOURCE_PATH)/MLO $(UBOOT_BIN_PATH)/$(BOARD_TYPE)
	@cp $(UBOOT_SOURCE_PATH)/u-boot.img $(UBOOT_BIN_PATH)/$(BOARD_TYPE)	