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

BOARD                         := np_v1
BOARD_DEVICE
BOARD_TARGET_CHIP             := nRF51822
BOARD_MCU                     := cortex-m0
BOARD_MCU_CLK                 := 8000000UL
BOARD_MCU_ARCH                := arm-none-eabi
BOARD_GCC_PREFIX              := $(BOARD_MCU_ARCH)-
BOARD_TOOLCHAINS              := gcc-arm-none-eabi
