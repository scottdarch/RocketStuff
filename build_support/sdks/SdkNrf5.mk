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
SDK_NRF5_EXAMPLES_PATH    := $(SDK_NRF5_PATH)/examples
GLOBAL_INCLUDE_PATHS      += $(SDK_NRF5_CMSIS_PATH)/Include \
                             $(SDK_NRF5_COMPONENTS_PATH)/device \
                             $(SDK_NRF5_COMPONENTS_PATH)/toolchain \
                             $(SDK_NRF5_COMPONENTS_PATH)/softdevice/$(SDK_NRF5_SOFTDEVICE)/headers \
                             

GLOBAL_INCLUDE_PATHS := $(sort $(call to_abs,$(GLOBAL_INCLUDE_PATHS)))
