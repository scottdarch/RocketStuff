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

include $(BUILD_SUPPORT_DIR)/ToolchainDef.mk

# +----------------------------------------------------------------------------+
# | TOOLS
# +----------------------------------------------------------------------------+
TOOL_CC              := "$(BOARD_GCC_PREFIX)gcc"
TOOL_AS              := "$(BOARD_GCC_PREFIX)as"
TOOL_AR              := "$(BOARD_GCC_PREFIX)ar"
TOOL_LD              := "$(BOARD_GCC_PREFIX)ld"

TOOL_NM              := "$(BOARD_GCC_PREFIX)nm"
TOOL_OBJCOPY         := "$(BOARD_GCC_PREFIX)objcopy"

TOOL_OBJDUMP         := $(BOARD_GCC_PREFIX)objdump -d $(1)

# +----------------------------------------------------------------------------+
# | GCC
# +----------------------------------------------------------------------------+
# see https://gcc.gnu.org/onlinedocs/gcc/ARM-Options.html for the GCC reference.
GLOBAL_CFLAGS   +=  $(LOCAL_ENV_CFLAGS) \
                    -mcpu=$(BOARD_MCU) \

GLOBAL_BINFLAGS  = -j .text -j .data

ifndef DEBUG
GLOBAL_BINFLAGS += -S
endif
