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

# The board makefile must advertise the toolchains it supports by adding the
# toolchain to its BOARD_TOOLCHAINS list.
ifeq ($(BUILD_SUPPORT_DIR),) 
$(error BUILD_SUPPORT_DIR must be set with the path this makefile was included from)
endif

ifeq ($(PROJECT_NAME),)
$(error PROJECT_NAME was not defined.)
endif

GLOBAL_PHONIES         :=
GLOBAL_GOALS           :=
GLOBAL_INCLUDE_PATHS   :=
GLOBAL_CFLAGS          :=
GLOBAL_SOURCE          :=

INFO_OBJS              :=
INFO_SOURCE            :=


# +----------------------------------------------------------------------------+
# | BUILD SUPPORT
# +----------------------------------------------------------------------------+
LOCAL_MAKEFILE      := $(lastword $(MAKEFILE_LIST))

include $(BUILD_SUPPORT_DIR)/Terminal.mk

COMMAND_MAKE_BINARY := $(BUILD_SUPPORT_DIR)/MakeBinary.mk
COMMAND_RESET       := $(BUILD_SUPPORT_DIR)/Reset.mk

# +----------------------------------------------------------------------------+
# | ENVIRONMENT
# +----------------------------------------------------------------------------+
LOCAL_ENV_FLAVOR    ?= debug
LOCAL_ENV_TOOLCHAIN ?=
LOCAL_ENV_BOARD     ?=

# use `make [target] DEBUG=1` to override environment setting
ifndef DEBUG
ifeq "$(LOCAL_ENV_FLAVOR)" "debug"
DEBUG           := 1
endif
endif

BUILD_ROOT      := .build
ifdef DEBUG
BUILD_FOLDER    := $(BUILD_ROOT)/Debug
else
BUILD_FOLDER    := $(BUILD_ROOT)/Release
endif

# +----------------------------------------------------------------------------+
# | CONFIGURATION
# +----------------------------------------------------------------------------+
include boards/$(LOCAL_ENV_BOARD).mk

# The board makefile must advertise the toolchains it supports by adding the
# toolchain to its BOARD_TOOLCHAINS list.
ifneq ($(filter $(LOCAL_ENV_TOOLCHAIN),$(BOARD_TOOLCHAINS)),) 
include $(BUILD_SUPPORT_DIR)/$(LOCAL_ENV_TOOLCHAIN)/Toolchain.mk
else
$(error board "$(LOCAL_ENV_BOARD)" cannot be built using the "$(LOCAL_ENV_TOOLCHAIN)" toolchain)
endif

