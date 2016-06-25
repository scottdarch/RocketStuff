#  NifyPayload (by 32bits.io)
#                                                                       .
#                                                                      /
#
#                                                                    (
#                                                                   C)
#                                                                 (C))
#                                                               )()C))C
# ___________________________________________________________(C))C)()C)________
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

# +---[NRF5 LIB UTIL]---------------------------------------------------------+
LOCAL_MODULE_NAME := nrf_library_util

LOCAL_INCLUDES := $(call to_abs,$(SDK_NRF5_LIBS_PATH)/util) \
                  $(call to_abs,$(SDK_NRF5_EXAMPLES_PATH)/bsp) \
                  $(call to_abs,$(SDK_NRF5_DRV_PATH)/hal) \

SDK_NRF5_LIB_INCLUDES_util := $(LOCAL_INCLUDES)

LOCAL_SRC_C += $(wildcard $(SDK_NRF5_LIBS_PATH)/util/*.c) \
               $(wildcard $(SDK_NRF5_EXAMPLES_PATH)/bsp/*.c) \
               $(wildcard $(SDK_NRF5_DRV_PATH)/hal/*.c) \

# TODO: make library which builds archives and creates named include and .a variables
include $(COMMAND_MAKE_ARCHIVE)
include $(COMMAND_RESET)

# +---[NRF5 LIB BUTTON]-------------------------------------------------------+
LOCAL_MODULE_NAME := nrf_library_button

LOCAL_INCLUDES := $(call to_abs,$(SDK_NRF5_LIBS_PATH)/button) \

SDK_NRF5_LIB_INCLUDES_button := $(LOCAL_INCLUDES)

LOCAL_SRC_C += $(wildcard $(SDK_NRF5_LIBS_PATH)/button/*.c) \

# TODO: make library which builds archives and creates named include and .a variables
include $(COMMAND_MAKE_ARCHIVE)
include $(COMMAND_RESET)

# +---------------------------------------------------------------------------+

LOCAL_MODULE_NAME := $(PROJECT_NAME)

LOCAL_INCLUDES += $(SDK_NRF5_LIB_INCLUDES_util) \
                  $(SDK_NRF5_LIB_INCLUDES_button) \
                  $(LOCAL_DIR) \
                  $(LOCAL_DIR)/$(BOARD) \

LOCAL_SRC_C     += $(LOCAL_DIR)/main.c \

include $(COMMAND_MAKE_BINARY)
