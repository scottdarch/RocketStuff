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
# | GCC
# +----------------------------------------------------------------------------+
GLOBAL_CFLAGS   +=  \
                    -mmcu=$(BOARD_MCU) \
                    -ffunction-sections \
                    -fdata-sections \
                    -Dprintf=iprintf \
                    -Dscanf=iscanf \
                    -DF_CPU=$(BOARD_MCU_CLK) \
                    -gstabs \

GLOBAL_LDFLAGS  += \
                   --no-gc-sections \
                   --print-gc-sections \

GLOBAL_BINFLAGS := -j .text -j .data

ifndef DEBUG
GLOBAL_BINFLAGS += -S
endif

# +----------------------------------------------------------------------------+
# | AVR TOOLS
# +----------------------------------------------------------------------------+
TOOL_PROGRAM          = avrdude -p $(BOARD_MCU) -c dragon_isp $(1)
TOOL_BOARD_TERM       = avrdude -p $(BOARD_MCU) -c dragon_isp -t
TOOL_DBGSVR           = avarice -g -w -P $(BOARD_MCU) :4242
TOOL_BINSIZE          = $(BOARD_GCC_PREFIX)size --mcu=$(BOARD_MCU) --format=avr $(1)
TOOL_OBJDUMP          = $(BOARD_GCC_PREFIX)objdump -d $(1)
