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

BOARD                         := nl_v1
BOARD_MCU                     := attiny84
BOARD_MCU_CLK                 := 8000000UL
BOARD_MCU_ARCH                := avr
BOARD_GCC_PREFIX              := $(BOARD_MCU_ARCH)-
BOARD_HFUSE                   := DF
BOARD_LFUSE                   := E2
BOARD_EFUSE                   := FF
BOARD_LKFUSE_UNLOCKED         := FF
BOARD_PROGRAM_FUSE            := -e -u -U lock:w:0x$(BOARD_LKFUSE_UNLOCKED):m -U efuse:w:0x$(BOARD_EFUSE):m -U hfuse:w:0x$(BOARD_HFUSE):m -U lfuse:w:0x$(BOARD_LFUSE):m
BOARD_PROGRAM_FIRMWARE         = -U flash:w:$<
CFLAGS                        += -D__AVR_ATtiny84__
