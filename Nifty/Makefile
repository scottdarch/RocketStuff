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
PROJECT_NAME        := NiftyPayload
BUILD_SUPPORT_DIR   := Tinker/tbuild
ROOT_DIR            := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
SDKS_DIR            := SDKs

# +----------------------------------------------------------------------------+
# | DEFAULTS
# +----------------------------------------------------------------------------+
ifeq ($(TBOARD),)
$(error TBOARD was not defined!)
endif

LOCAL_ENV_BOARD      := $(TBOARD)
LOCAL_ENV_BOARDS_DIR := boards

# +----------------------------------------------------------------------------+
include $(BUILD_SUPPORT_DIR)/Common.mk

AVR_FIRMWARES := firmware/tiny_blink \

ARM_FIRMWARES := firmware/blue_blinky \
                 firmware/sam_ser \

# +----------------------------------------------------------------------------+
# | MODULES
# +----------------------------------------------------------------------------+
ifeq ($(BOARD_TOOLCHAIN),avr-gcc)
MODULE_DIR := firmware/tiny_blink
include $(COMMAND_MAKE_MODULE)
else
MODULE_DIR := firmware/blue_blinky
include $(COMMAND_MAKE_MODULE)

#MODULE_DIR := firmware/sam_ser
#include $(COMMAND_MAKE_MODULE)
endif

# +----------------------------------------------------------------------------+

include $(BUILD_SUPPORT_DIR)/CommonTargets.mk

