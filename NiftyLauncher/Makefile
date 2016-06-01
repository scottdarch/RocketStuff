#  NiftyLauncher (by 32bits.io)
#
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
PROJECT_NAME    := NiftyLauncher
LOCAL_MAKEFILE  := $(lastword $(MAKEFILE_LIST))

# +----------------------------------------------------------------------------+
# | RESET
# +----------------------------------------------------------------------------+
GLOBAL_PHONIES         :=
GLOBAL_GOALS           :=
GLOBAL_INCLUDE_PATHS   :=

INFO_OBJS              :=
INFO_SOURCE            :=

CFLAGS          :=
SOURCE          :=
ASSMBLY         :=
LIBS            :=
LIB_PATH        :=

# +----------------------------------------------------------------------------+
# | BUILD SUPPORT
# +----------------------------------------------------------------------------+
BUILD_SUPPORT_DIR   := build_support

include $(BUILD_SUPPORT_DIR)/Terminal.mk

COMMAND_MAKE_BINARY := $(BUILD_SUPPORT_DIR)/MakeBinary.mk
COMMAND_RESET       := $(BUILD_SUPPORT_DIR)/Reset.mk

# +----------------------------------------------------------------------------+
# | ENVIRONMENT
# +----------------------------------------------------------------------------+
LOCAL_ENV_FLAVOR ?= debug


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
include Board.mk
include Toolchain.mk

# +----------------------------------------------------------------------------+
# | MODULES
# +----------------------------------------------------------------------------+
include $(COMMAND_RESET)
LOCAL_DIR := src
include src/Module.mk
include $(COMMAND_REST)

# +----------------------------------------------------------------------------+
# | TARGETS
# +----------------------------------------------------------------------------+
GLOBAL_PHONIES += all clean info

.PHONY: $(GLOBAL_PHONIES)
all: $(GLOBAL_GOALS)

clean:
	$(TOOL_RMDIR) $(BUILD_ROOT)
	
info:
	@echo "+----------------------------------------------------------------------------+"
	@echo "| $(PROJECT_NAME)"
	@echo "| $(ANSI_TEXT_GREEN)$(BOARD)-$(LOCAL_ENV_FLAVOR) :: $(GCCPREFIX)$(ANSI_CLEAR)"
	@echo "+----------------------------------------------------------------------------+"
	@echo
	@echo "$(ANSI_BLONWHT)SOURCE:$(ANSI_CLEAR)" $(addprefix "\n\t", $(sort $(INFO_SOURCE)))
	@echo
	@echo "$(ANSI_BLONWHT)OBJS:$(ANSI_CLEAR)" $(addprefix "\n\t", $(sort $(INFO_OBJS)))
	@echo
	@echo "$(ANSI_BLONWHT)INCLUDES:$(ANSI_CLEAR)" $(addprefix "\n\t", $(sort $(GLOBAL_INCLUDE_PATHS)))
	@echo
	@echo "$(ANSI_BLONWHT)OUTPUTS:$(ANSI_CLEAR)" $(addprefix "\n\t", $(sort $(GLOBAL_GOALS)))
	@echo
	@echo "$(ANSI_BLONWHT)TARGETS:$(ANSI_CLEAR)" $(addprefix "\n\t", $(sort $(GLOBAL_PHONIES)))
	@echo

# +----------------------------------------------------------------------------+
# | AUTO DEPENDENCIES
# +----------------------------------------------------------------------------+
%.d : ;
.PRECIOUS: %.d

-include $(OBJS:.o=.d)

.DELETE_ON_ERROR: ;

