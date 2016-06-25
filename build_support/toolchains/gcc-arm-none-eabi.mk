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

TOOL_PROGRAM         := openocd
TOOL_OBJDUMP         := $(BOARD_GCC_PREFIX)objdump -d $(1)

# +----------------------------------------------------------------------------+
# | GCC
# +----------------------------------------------------------------------------+
GNU_INSTALL_ROOT ?= /usr/local/gcc-arm-none-eabi-4_9-2015q1
GNU_VERSION      ?= 4.9.3

GLOBAL_ASFLAGS  := -mcpu=$(BOARD_MCU) \
                   -gsstabs \
                   -x assembler-with-cpp \

GLOBAL_CFLAGS   +=  \
                    -mcpu=$(BOARD_MCU) \
                    -mthumb \
                    -mabi=aapcs \
                    -D$(BOARD_DEVICE) \
                    -D$(BOARD_TARGET_CHIP) \
                    -mfloat-abi=soft \


GLOBAL_CFLAGS   += $(LOCAL_ENV_CFLAGS)

GLOBAL_LDFLAGS         += \
                   -Wl,--unresolved-symbols=report-all \
                   -Wl,--warn-common \
                   -Wl,--warn-section-align \
                   -Xlinker \
                   -Map=$(LISTING_DIRECTORY)/$(OUTPUT_FILENAME).map \
                   -mthumb \
                   -mabi=aapcs \
                   -L $(TEMPLATE_PATH) \
                   -T$(LINKER_SCRIPT) \

GLOBAL_BINFLAGS  = -j .text -j .data

ifndef DEBUG
GLOBAL_BINFLAGS += -S
endif
