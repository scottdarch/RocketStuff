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