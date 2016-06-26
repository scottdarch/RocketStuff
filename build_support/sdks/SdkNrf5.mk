#  
#  Tinker Build
#                                                                    [.+]
#
# -----------------------------------------------------------------------------
#
# Copyright (c) 2016 Scott A Dixon.  All right reserved.
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#

# +----------------------------------------------------------------------------+
# | NORDIC SDK
# +----------------------------------------------------------------------------+
SDK_NRF5_SOFTDEVICE       ?= s132
SDK_NRF5_PATH             ?= $(BUILD_SUPPORT_DIR)/sdks/nRF5_SDK_11.0.0_89a8197
SDK_NRF5_CMSIS_PATH       := $(SDK_NRF5_PATH)/components/toolchain/CMSIS
SDK_NRF5_LIBS_PATH        := $(SDK_NRF5_PATH)/components/libraries
SDK_NRF5_DRV_PATH         := $(SDK_NRF5_PATH)/components/drivers_nrf
SDK_NRF5_COMPONENTS_PATH  := $(SDK_NRF5_PATH)/components
SDK_NRF5_TOOLCHAIN_GCC    := $(SDK_NRF5_COMPONENTS_PATH)/toolchain/gcc
SDK_NRF5_EXAMPLES_PATH    := $(SDK_NRF5_PATH)/examples

SDK_NRF5_BIN_PATH         := $(SDK_NRF5_PATH)/bin/$(LOCAL_ENV_OS)
SDK_NRF5_JPROG            := $(SDK_NRF5_BIN_PATH)/nrfjprog/nrfjprog
SDK_NRF5_SOFTDEVICE_HEX   := $(wildcard $(SDK_NRF5_COMPONENTS_PATH)/softdevice/$(BOARD_SOFT_DEVICE)/hex/*.hex)

GLOBAL_INCLUDE_PATHS      += $(SDK_NRF5_CMSIS_PATH)/Include \
                             $(SDK_NRF5_COMPONENTS_PATH)/device \
                             $(SDK_NRF5_COMPONENTS_PATH)/toolchain \
                             $(SDK_NRF5_COMPONENTS_PATH)/softdevice/$(SDK_NRF5_SOFTDEVICE)/headers \
                             

GLOBAL_INCLUDE_PATHS := $(sort $(call to_abs,$(GLOBAL_INCLUDE_PATHS)))
GLOBAL_LDFLAGS       += --library-path=$(ROOT_DIR)/$(SDK_NRF5_TOOLCHAIN_GCC)

define TOOL_PROGRAM
	@echo "Flashing: $(1)"
	$(SDK_NRF5_JPROG) --program $(1) -f $(BOARD_DEVICE) --sectorerase
	$(SDK_NRF5_JPROG) --reset -f $(BOARD_DEVICE)
endef

flash_softdevice: $(SDK_NRF5_SOFTDEVICE_HEX)
	@echo Flashing: $(notdir $<)
	$(SDK_NRF5_JPROG) --program $< -f $(BOARD_DEVICE) --chiperase
	$(SDK_NRF5_JPROG) --reset -f $(BOARD_DEVICE)

GLOBAL_GOALS += $(SDK_NRF5_SOFTDEVICE_HEX)
GLOBAL_PHONIES += flash_softdevice
