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
# See http://wiki.bash-hackers.org/scripting/terminalcodes for reference
ANSI_CLEAR      := \033[0m
ANSI_TEXT_BLK   := \033[30m
ANSI_TEXT_RED   := \033[31m
ANSI_TEXT_GREEN := \033[32m
ANSI_TEXT_YELO  := \033[33m
ANSI_TEXT_BLUE  := \033[34m
ANSI_TEXT_MAG   := \033[35m
ANSI_TEXT_CYAN  := \033[36m
ANSI_TEXT_WHT   := \033[37m
ANSI_TEXT_DEF   := \033[39m
ANSI_BG_WHT     := \033[47m
ANSI_REDONWHT   := $(ANSI_TEXT_RED)$(ANSI_BG_WHT)
ANSI_BLONWHT    := $(ANSI_TEXT_BLUE)$(ANSI_BG_WHT)
