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

GLOBAL_MODULES         :=
GLOBAL_ARCHIVES        :=
GLOBAL_BINARIES        :=

.SUFFIXES:

# +----------------------------------------------------------------------------+
# | BUILD SUPPORT
# +----------------------------------------------------------------------------+
LOCAL_MAKEFILE      := $(lastword $(MAKEFILE_LIST))
ROOT_DIR            := $(abspath $(BUILD_SUPPORT_DIR)/../)
COMMA               = ,

include $(BUILD_SUPPORT_DIR)/Terminal.mk

COMMAND_MAKE_ARCHIVE:= $(BUILD_SUPPORT_DIR)/MakeArchive.mk
COMMAND_MAKE_BINARY := $(BUILD_SUPPORT_DIR)/MakeBinary.mk
COMMAND_RESET       := $(BUILD_SUPPORT_DIR)/Reset.mk

define to_abs
$(addprefix $(ROOT_DIR)/,$(1))
endef

SDKS_DIR            := $(BUILD_SUPPORT_DIR)/sdks
TOOLCHAINS_DIR      := $(BUILD_SUPPORT_DIR)/toolchains

# +----------------------------------------------------------------------------+
# | ENVIRONMENT
# +----------------------------------------------------------------------------+
LOCAL_ENV_FLAVOR    ?= debug
LOCAL_ENV_TOOLCHAIN ?=
LOCAL_ENV_BOARD     ?=
LOCAL_ENV_OS        ?= $(shell uname)

# use `make [target] DEBUG=1` to override environment setting
ifndef DEBUG
ifeq "$(LOCAL_ENV_FLAVOR)" "debug"
DEBUG           := 1
endif
endif

BUILD_ROOT      := build
ifdef DEBUG
BUILD_FOLDER    := $(BUILD_ROOT)/Debug
else
BUILD_FOLDER    := $(BUILD_ROOT)/Release
endif

# +----------------------------------------------------------------------------+
# | THE DEFAULT RULE
# +----------------------------------------------------------------------------+
GLOBAL_PHONIES += all

.SECONDEXPANSION:

# because the GLOBAL_GOALS is populated by the SDK and module rules we need to
# expand all's prerequisites after they have all been defined.
all: $$(GLOBAL_GOALS)

# +----------------------------------------------------------------------------+
# | CONFIGURATION
# +----------------------------------------------------------------------------+
include $(LOCAL_ENV_BOARD)/Board.mk

# The board makefile must advertise the toolchains it supports by adding the
# toolchain to its BOARD_TOOLCHAINS list.
ifneq ($(BOARD_TOOLCHAIN),) 
include $(TOOLCHAINS_DIR)/$(BOARD_TOOLCHAIN).mk
else
$(error board "$(LOCAL_ENV_BOARD)" did not define BOARD_TOOLCHAIN)
endif

$(foreach BOARD_SDK, $(BOARD_SDKS), $(eval include $(SDKS_DIR)/$(BOARD_SDK).mk))

