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

# +----------------------------------------------------------------------------+
# | COMMANDS AND DEFINITIONS
# +----------------------------------------------------------------------------+
TOOL_MKDIRS          ?= mkdir -p
TOOL_RMDIR           ?= rm -rf
TOOL_PYTHON          ?= python
TOOL_AWK             ?= awk

# +----------------------------------------------------------------------------+
# | GCC
# +----------------------------------------------------------------------------+
ASFLAGS         := -mcpu=$(BOARD_MCU) \
                   -gsstabs \
                   -march=$(BOARD_MCU_ARCH) \

# See http://make.mad-scientist.net/papers/advanced-auto-dependency-generation/
# for an explaination of this dependency scheme.
DEPFLAGS         = -MT $@ -MMD -MP -MF "$(patsubst %.o,%.Td,$@)"

POSTCOMPILE      = mv -f $(patsubst %.o,%.Td,$@) $(patsubst %.o,%.d,$@)

CFLAGS          +=  \
                    -std=gnu99 \
                    -Wall \
                    -Werror \
                    -ffunction-sections \
                    -fdata-sections \
                    -fno-strict-aliasing \
                    -Dprintf=iprintf \
                    -Dscanf=iscanf \
                    -DF_CPU=$(BOARD_MCU_CLK) \

ifdef DEBUG
CFLAGS          += -ggdb \
                   -DDEBUG \
                   -Og \

else
CFLAGS          += -Os \

endif

CFLAGS          += $(LOCAL_ENV_CFLAGS)

LDFLAGS         := $(foreach LIB,$(LIBS),-l$(LIB))
LDFLAGS         += $(foreach _LIB_PATH,$(LIB_PATH),-L$(_LIB_PATH))
LDFLAGS         += -pipe \
                   -Wl,--no-gc-sections \
                   -Wl,--print-gc-sections \
                   -Wl,--unresolved-symbols=report-all \
                   -Wl,--warn-common \
                   -Wl,--warn-section-align \

BINFLAGS         = -j .text -j .data

ifndef DEBUG
BINFLAGS        += -S
endif

GCCPREFIX       := $(strip $(shell $(BOARD_GCC_PREFIX)gcc -v 2>&1 | $(TOOL_AWK) '{FS="--|="; if ( $$2 ~ /prefix/ ) print $$3 }'))
GCCHEADERS      := $(GCCPREFIX)/$(BOARD_MCU_ARCH)/include

# +----------------------------------------------------------------------------+
# | AVR TOOLS
# +----------------------------------------------------------------------------+
TOOL_PROGRAM          = avrdude -p $(BOARD_MCU) $(1)
TOOL_DBGSVR           = avarice -g -w -P $(BOARD_MCU) :4242
TOOL_BINSIZE          = $(BOARD_GCC_PREFIX)size --mcu=$(BOARD_MCU) --format=avr --target=binary $(1)

# +----------------------------------------------------------------------------+
# | TARGETS
# +----------------------------------------------------------------------------+
define generate_binary_recipes

GLOBAL_PHONIES += $(strip $(1))-size $(strip $(1))-flash $(strip $(1))-flash-fuse $(strip $(1))-debug-server
GLOBAL_INCLUDE_PATHS += $(sort $(3))
GLOBAL_GOALS += $$(addprefix $$(BUILD_FOLDER)/,$(1).hex)

$(strip $(1))-size: $$(addprefix $$(BUILD_FOLDER)/,$(1).hex)
	$$(call TOOL_BINSIZE, $$<)

$(strip $(1))-flash: $$(addprefix $$(BUILD_FOLDER)/,$(1).hex)
	$$(call TOOL_PROGRAM, $$(BOARD_PROGRAM_FIRMWARE))

$(strip $(1))-flash-fuse: 
	$$(call TOOL_PROGRAM, $$(BOARD_PROGRAM_FUSE))

$(strip $(1))-debug-server:
	$$(call TOOL_DBGSVR)

$$(addprefix $$(BUILD_FOLDER)/,$(1).hex) : $$(addprefix $$(BUILD_FOLDER)/,$(1).elf)
	@[ -d $$(dir $$@) ] || $$(TOOL_MKDIRS) $$(dir $$@)
	$$(BOARD_GCC_PREFIX)objcopy $$(BINFLAGS) -O ihex $$< $$@

$$(addprefix $$(BUILD_FOLDER)/,$(1).elf) : $(2)
	@[ -d $$(dir $$@) ] || $$(TOOL_MKDIRS) $$(dir $$@)
	$$(BOARD_GCC_PREFIX)gcc $$(LDFLAGS) -o $$@ $$^

$$(BUILD_FOLDER)/%.o : %.s $$(BUILD_FOLDER)/%.d
	@[ -d $$(dir $$@) ] || $$(TOOL_MKDIRS) $$(dir $$@)
	$$(BOARD_GCC_PREFIX)as $$(DEPFLAGS) $$(ASFLAGS) -D__ASSEMBLY__ -c $$< -o $$@
	$$(POSTCOMPILE)

$$(BUILD_FOLDER)/%.o : %.c $$(BUILD_FOLDER)/%.d
	@[ -d $$(dir $$@) ] || $$(TOOL_MKDIRS) $$(dir $$@)
	$$(BOARD_GCC_PREFIX)gcc $$(DEPFLAGS) $$(CFLAGS) $(addprefix -I,$(sort $(3))) -c $$< -o $$@
	$$(POSTCOMPILE)

endef

