# Global configurations
include config.mk

# Default rule
all: 

# Clone the "Crosstool-NG" toolchain 
init_crosstool-ng:
	@echo
	@echo "Cloning the \"Crosstool-NG\" toolchain to "$(CROSSTOOL-NG_SOURCE)/" .."
	@cd $(CROSSTOOL-NG_SOURCE)
	@git clone --depth 1 $(CROSSTOOL-NG_REPO) -b $(CROSSTOOL-NG_BRANCH) 

