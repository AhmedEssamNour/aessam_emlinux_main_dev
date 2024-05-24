# Global configurations
include config.mk


# Default rule
all: 


# Initializing the environment (i.e. install all required packages, .. etc.)
init_env:
	@echo
	@echo "[INFO] Installing all required packages .."
	@sudo apt install build-essential git autoconf bison flex texinfo help2man gawk libtool-bin libncurses5-dev unzip


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


# Building the "Crosstool-NG" toolchain for the given "BOARD TYPE"
build_crosstool-ng:
	@echo
	@echo "[INFO] Moving the saved configuration for the \"$(BOARD_TYPE)\" board to the building folder .."
	@cp $(CROSSTOOL_NG_CFG_PATH)/$(BOARD_TYPE)/.config $(CROSSTOOL_NG_SOURCE_PATH)
	@echo "[INFO] Starting the \"menuconfig\" for configuration refinement .."
	@cd $(CROSSTOOL_NG_SOURCE_PATH) && ./ct-ng menuconfig
	@echo "[INFO] Building the \"Crosstool-NG\" toolchain for the \"$(BOARD_TYPE)\" board .."
	@cd $(CROSSTOOL_NG_SOURCE_PATH) && ./ct-ng build