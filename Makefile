# Global configurations
include config.mk


# Default rule
all: 


# Initializing the environment (i.e. install all required packages, .. etc.)
init_env:
	@echo
	@echo "[INFO] Installing all required packages for the \"Crosstool-ng\" .."
	@sudo apt install build-essential git autoconf bison flex texinfo help2man gawk libtool-bin libncurses5-dev unzip
	@echo
	@echo "[INFO] Installing all required packages for the \"U-BOOT\" .."
	@sudo apt install libssl-dev device-tree-compiler swig python3-distutils python3-dev python3-setuptools
	@echo
	@echo "[INFO] Installing all required packages for the \"SD. Card Preparations\" .."
	@sudo apt install parted


######################################################################################
################################ "SD. Card" Section ##################################
######################################################################################	
# Clean, format and create the partitions of the "SD. Card"
init_sd-card:
	@echo
	@echo "[INFO] Clean, format and create the partitions of the \"SD. Card\" .."
	@cd $(TOOLS_SCRIPTS_SDCARD_PATH) && sudo ./sdcard_prep.sh


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
	@echo "[INFO] Moving the saved configuration for the \"$(board)\" board to the building folder .."
	@cp $(CROSSTOOL_NG_CFG_PATH)/$(board)/.config $(CROSSTOOL_NG_SOURCE_PATH)
	@echo "[INFO] Starting the \"menuconfig\" for configuration refinement .."
	@cd $(CROSSTOOL_NG_SOURCE_PATH) && ./ct-ng menuconfig
	@echo "[INFO] Saving back the new \".config\" .."
	@cp $(CROSSTOOL_NG_SOURCE_PATH)/.config $(CROSSTOOL_NG_CFG_PATH)/$(board)
	@echo "[INFO] Building the \"Crosstool-NG\" compiler for the \"$(board)\" board .."
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
	@echo "[INFO] Moving the saved configuration for the \"$(board)\" board to the building folder .."
	@cp $(UBOOT_CFG_PATH)/$(board)/.config $(UBOOT_SOURCE_PATH)
	@echo "[INFO] Starting the \"menuconfig\" for configuration refinement .."
	@cd $(UBOOT_SOURCE_PATH) && $(MAKE) menuconfig
	@echo "[INFO] Saving back the new \".config\" .."
	@cp $(UBOOT_SOURCE_PATH)/.config $(UBOOT_CFG_PATH)/$(board)
	@echo "[INFO] Building the \"U-Boot\" for the \"$(board)\" board .."
ifeq ($(board), bbb)
	@cd $(UBOOT_SOURCE_PATH) && $(MAKE) DEVICE_TREE=am335x-boneblack
endif
	@echo "[INFO] Moving the output generated images to the \"/bin\" folder of the \"$(board)\" board .."
	@cp $(UBOOT_SOURCE_PATH)/MLO $(UBOOT_BIN_PATH)/$(board)
	@cp $(UBOOT_SOURCE_PATH)/u-boot.img $(UBOOT_BIN_PATH)/$(board)


######################################################################################
################################# "Kernel" Section ###################################
######################################################################################	
# Cloning and preparing the "kernel" building environment 
init_kernel:
	@echo
	@echo "[INFO] Cloning the \"Kernel\" source code .."
	@mkdir -p $(KERNEL_SOURCE_PATH)/$(KERNEL_REL) && cd $(KERNEL_SOURCE_PATH) && git clone --depth 1 $(KERNEL_REPO) -b $(KERNEL_BRANCH) $(KERNEL_REL)

# Building the kernel for the given "BOARD TYPE"
build_kernel:
	@echo
	@echo "[INFO] Building the \"Kernel\" source code .."
ifeq ($(menuconfig), 0)
	@cd $(KERNEL_SOURCE_PATH)/$(KERNEL_REL) && $(MAKE) ARCH=$(ARCH) multi_v7_defconfig -j16
else
	@cd $(KERNEL_SOURCE_PATH)/$(KERNEL_REL) && $(MAKE) ARCH=$(ARCH) multi_v7_defconfig -j16
	@cd $(KERNEL_SOURCE_PATH)/$(KERNEL_REL) && $(MAKE) ARCH=$(ARCH) menuconfig -j16
	@cd $(KERNEL_SOURCE_PATH)/$(KERNEL_REL) && $(MAKE) ARCH=$(ARCH) -j16
endif

build_dtb:
	@echo
	@echo "[INFO] Building the \"Kernel\" source code .."
	@cd $(KERNEL_SOURCE_PATH)/$(KERNEL_REL) && $(MAKE) ARCH=$(ARCH) dtbs -j16


######################################################################################
########################### Software Installation Section ############################
######################################################################################
# Installing the software (uboot, kernel, rootfs)
install:
	@if [ "$(bin)" = "uboot" ]; then \
		cd $(TOOLS_SCRIPTS_INSTALL_PATH) && ./install_uboot.sh $(board) $(UBOOT_BIN_PATH) $(out_dev) \
	else \
		echo "Argument is not correct"; \
	fi