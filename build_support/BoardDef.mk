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
# +----------------------------------------------------------------------------+
# | BOARD DEFINITION :: GENERIC
# +----------------------------------------------------------------------------+
BOARD                         = $(error Required BOARD variable was not defined)
BOARD_MCU                     = $(error Required BOARD_MCU variable was not defined)
BOARD_MCU_CLOCK              :=
BOARD_MCU_ARCH                = $(error Required BOARD_MCU_ARCH variable was not defined)
BOARD_GCC_PREFIX              = $(error Required BOARD_GCC_PREFIX variable was not defined)
BOARD_SDKS                   :=
BOARD_TOOLCHAIN               = $(error Required BOARD_TOOLCHAIN variable was not defined)

# +----------------------------------------------------------------------------+
# | BOARD INFO TARGETS
# +----------------------------------------------------------------------------+
.SECONDEXPANSION: 

info-board-$$(BOARD): info ;

info-board: info-board-$$(BOARD)
	@echo "+----------------------------------------------------------------------------+"
	@echo "| BOARD :: $(ANSI_TEXT_GREEN)$(BOARD)$(ANSI_CLEAR)"
	@echo "+----------------------------------------------------------------------------+"
	@echo "$(ANSI_BLONWHT)GCC_PREFIX:     $(ANSI_CLEAR) $(BOARD_GCC_PREFIX)"
	@echo "$(ANSI_BLONWHT)MCU:            $(ANSI_CLEAR) $(BOARD_MCU)"
	@echo "$(ANSI_BLONWHT)MCU_CLK:        $(ANSI_CLEAR) $(BOARD_MCU_CLK)"
	@echo "$(ANSI_BLONWHT)MCU_ARCH:       $(ANSI_CLEAR) $(BOARD_MCU_ARCH)"
	@echo "$(ANSI_BLONWHT)TOOLCHAIN:      $(ANSI_CLEAR) $(BOARD_TOOLCHAIN)"
	@echo "$(ANSI_BLONWHT)SDKS:           $(ANSI_CLEAR) $(BOARD_SDKS)"
	@echo
