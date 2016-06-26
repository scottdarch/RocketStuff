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
include $(BUILD_SUPPORT_DIR)/BoardDef.mk

# +----------------------------------------------------------------------------+
# | BOARD DEFINITION :: GENERIC
# +----------------------------------------------------------------------------+
BOARD                         := BOARD_PCA10040
BOARD_MCU                     := cortex-m0
BOARD_MCU_CLK                 := 8000000UL
BOARD_MCU_ARCH                := armv6-m
BOARD_SDKS                    := SdkNrf5
BOARD_TOOLCHAIN               := gcc-arm-none-eabi
BOARD_GCC_PREFIX              := arm-none-eabi-

# +----------------------------------------------------------------------------+
# | BOARD DEFINITION :: ARM
# +----------------------------------------------------------------------------+
BOARD_ARM_ABI                 := aapcs
BOARD_ARM_FLOAT_ABI           := soft

# +----------------------------------------------------------------------------+
# | BOARD DEFINITION :: NORDIC
# +----------------------------------------------------------------------------+
BOARD_DEVICE                  := nrf52
BOARD_TARGET_CHIP             := nRF52832
BOARD_SOFT_DEVICE             := s130

# +----------------------------------------------------------------------------+
# | GCC
# +----------------------------------------------------------------------------+
GLOBAL_ASFLAGS  := -x assembler-with-cpp \

GLOBAL_CFLAGS += -mthumb \
                 -mabi=$(BOARD_ARM_ABI) \
                 -D$(BOARD_DEVICE) \
                 -D$(BOARD_TARGET_CHIP) \
                 -mfloat-abi=$(BOARD_ARM_FLOAT_ABI) \
                 -D$(BOARD) \
                 -DSOFTDEVICE_PRESENT \
                 -D$(call TOOL_TOUPPER,$(BOARD_SOFT_DEVICE)) \
                 -DBLE_STACK_SUPPORT_REQD \
                 -DBSP_DEFINES_ONLY \
                 -ffunction-sections \
                 -fdata-sections \
                 -fno-strict-aliasing \
                 -fno-builtin \
                 --short-enums \
                 --specs=nano.specs -lc -lnosys

GLOBAL_LDFLAGS += --gc-sections \

# +----------------------------------------------------------------------------+
# | BOARD INFO
# +----------------------------------------------------------------------------+
info-board-$(BOARD): info
	@echo "+----------------------------------------------------------------------------+"
	@echo "| BOARD :: ARM OPTIONS :: $(ANSI_TEXT_GREEN)$(BOARD)$(ANSI_CLEAR)"
	@echo "+----------------------------------------------------------------------------+"
	@echo "$(ANSI_BLONWHT)ARM_ABI:        $(ANSI_CLEAR) $(BOARD_ARM_ABI)"
	@echo "$(ANSI_BLONWHT)ARM_FLOAT_ABI:  $(ANSI_CLEAR) $(BOARD_ARM_FLOAT_ABI)"
	@echo
	@echo "+----------------------------------------------------------------------------+"
	@echo "| BOARD :: NORDIC OPTIONS :: $(ANSI_TEXT_GREEN)$(BOARD)$(ANSI_CLEAR)"
	@echo "+----------------------------------------------------------------------------+"
	@echo "$(ANSI_BLONWHT)TARGET_CHIP:    $(ANSI_CLEAR) $(BOARD_TARGET_CHIP)"
	@echo "$(ANSI_BLONWHT)DEVICE:         $(ANSI_CLEAR) $(BOARD_DEVICE)"
	@echo "$(ANSI_BLONWHT)SOFTDEVICE:     $(ANSI_CLEAR) $(SDK_NRF5_SOFTDEVICE_HEX)"

GLOBAL_PHONIES += info-board-$(BOARD)

