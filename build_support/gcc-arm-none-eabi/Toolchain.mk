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
# | TOOLS
# +----------------------------------------------------------------------------+
TOOL_MKDIRS          ?= mkdir -p
TOOL_RMDIR           ?= rm -rf
TOOL_PYTHON          ?= python
TOOL_AWK             ?= awk
TOOL_CC              ?= "$(BOARD_GCC_PREFIX)gcc"
TOOL_AS              ?= "$(BOARD_GCC_PREFIX)as"
TOOL_AR              ?= "$(BOARD_GCC_PREFIX)ar"
TOOL_LD              ?= "$(BOARD_GCC_PREFIX)ld"

TOOL_NM              ?= "$(BOARD_GCC_PREFIX)nm"
TOOL_OBJCOPY         ?= "$(BOARD_GCC_PREFIX)objcopy"

TOOL_PROGRAM         ?= openocd
TOOL_BOARD_TERM      ?= 
TOOL_DBGSVR          ?= 
TOOL_BINSIZE         ?= 
TOOL_OBJDUMP         ?= $(BOARD_GCC_PREFIX)objdump -d $(1)

# +----------------------------------------------------------------------------+
# | GCC
# +----------------------------------------------------------------------------+
GNU_INSTALL_ROOT ?= /usr/local/gcc-arm-none-eabi-4_9-2015q1
GNU_VERSION      ?= 4.9.3

ASFLAGS         := -mcpu=$(BOARD_MCU) \
                   -gsstabs \
                   -march=$(BOARD_MCU_ARCH) \
                   -x assembler-with-cpp \

# See http://make.mad-scientist.net/papers/advanced-auto-dependency-generation/
# for an explaination of this dependency scheme.
DEPFLAGS         = -MT $@ -MMD -MP -MF "$(patsubst %.o,%.Td,$@)"

POSTCOMPILE      = mv -f $(patsubst %.o,%.Td,$@) $(patsubst %.o,%.d,$@)

GLOBAL_CFLAGS   +=  \
                    -mcpu=$(BOARD_MCU) \
                    -std=c99 \
                    -Wall \
                    -Werror \
                    -mthumb \
                    -mabi=aapcs \
                    -D$(BOARD_DEVICE) \
                    -D$(BOARD_TARGET_CHIP) \
                    -mfloat-abi=soft \

ifdef DEBUG
GLOBAL_CFLAGS   += -ggdb \
                   -DDEBUG \
                   -Og \

else
GLOBAL_CFLAGS   += -Os \

endif

GLOBAL_CFLAGS   += $(LOCAL_ENV_CFLAGS)

GLOBAL_LDFLAGS         := $(foreach LIB,$(LIBS),-l$(LIB))
GLOBAL_LDFLAGS         += $(foreach _LIB_PATH,$(LIB_PATH),-L$(_LIB_PATH))
GLOBAL_LDFLAGS         += -pipe \
                   -Wl,--unresolved-symbols=report-all \
                   -Wl,--warn-common \
                   -Wl,--warn-section-align \
                   -Xlinker \
                   -Map=$(LISTING_DIRECTORY)/$(OUTPUT_FILENAME).map \
                   -mthumb \
                   -mabi=aapcs \
                   -L $(TEMPLATE_PATH) \
                   -T$(LINKER_SCRIPT) \

BINFLAGS         = -j .text -j .data

ifndef DEBUG
BINFLAGS        += -S
endif

ASMFLAGS += -x assembler-with-cpp

GCCPREFIX       := $(strip $(shell $(TOOL_CC) -v 2>&1 | $(TOOL_AWK) '{FS="--|="; if ( $$2 ~ /prefix/ ) print $$3 }'))
GCCHEADERS      := $(GCCPREFIX)/$(BOARD_MCU_ARCH)/include



# +----------------------------------------------------------------------------+
# | NORDIC SDK
# +----------------------------------------------------------------------------+
SDK_NRF5_PATH             ?= $(BUILD_SUPPORT_DIR)/nRF5_SDK
SDK_NRF5_CMSIS_PATH       := $(SDK_NRF5_PATH)/components/toolchain/CMSIS
SDK_NRF5_LIBS_PATH        := $(SDK_NRF5_PATH)/components/libraries
SDK_NRF5_COMPONENTS_PATH  := $(SDK_NRF5_PATH)/components
GLOBAL_INCLUDE_PATHS      += $(SDK_NRF5_CMSIS_PATH)/Include \


# +----------------------------------------------------------------------------+
# | TARGETS
# +----------------------------------------------------------------------------+
define generate_object_recipes

GLOBAL_INCLUDE_PATHS += $(sort $(3))

$$(BUILD_FOLDER)/%.o : %.s $$(BUILD_FOLDER)/%.d
	@[ -d $$(dir $$@) ] || $$(TOOL_MKDIRS) $$(dir $$@)
	$$(TOOL_AS) $$(DEPFLAGS) $$(ASFLAGS) $(addprefix -I,$(sort $(3))) -D__ASSEMBLY__ -c $$< -o $$@
	$$(POSTCOMPILE)

$$(BUILD_FOLDER)/%.o : %.c $$(BUILD_FOLDER)/%.d
	@[ -d $$(dir $$@) ] || $$(TOOL_MKDIRS) $$(dir $$@)
	$$(TOOL_CC) $$(DEPFLAGS) $$(GLOBAL_CFLAGS) $(addprefix -I,$(sort $(3))) -c $$< -o $$@
	$$(POSTCOMPILE)

endef
# +----------------------------------------------------------------------------+


define generate_archive_recipes

GLOBAL_GOALS += $$(addprefix $$(BUILD_FOLDER)/,$(1).a)

$$(addprefix $$(BUILD_FOLDER)/,$(1).a) : $(2)
	@[ -d $$(dir $$@) ] || $$(TOOL_MKDIRS) $$(dir $$@)
	$$(TOOL_AR) -ruc $$@ $$^


endef
# +----------------------------------------------------------------------------+


define generate_binary_recipes

GLOBAL_PHONIES += $(strip $(1))-size \
                  $(strip $(1))-cat \
                  $(strip $(1))-board \
                  $(strip $(1))-flash \
                  $(strip $(1))-flash-fuse-nl-v1 \
                  $(strip $(1))-flash-fuse-default \
                  $(strip $(1))-debug-server \

GLOBAL_GOALS += $$(addprefix $$(BUILD_FOLDER)/,$(1).hex)

$(strip $(1))-size: $$(addprefix $$(BUILD_FOLDER)/,$(1).elf)
	$$(call TOOL_BINSIZE, $$<)

$(strip $(1))-flash: $$(addprefix $$(BUILD_FOLDER)/,$(1).hex)
	$$(call TOOL_PROGRAM, $$(BOARD_PROGRAM_FIRMWARE))

$(strip $(1))-board:
	$$(call TOOL_BOARD_TERM)

$(strip $(1))-flash-fuse-nl-v1: 
	$$(call TOOL_PROGRAM, $$(BOARD_PROGRAM_FUSE_NL_V1))

$(strip $(1))-flash-fuse-default: 
	$$(call TOOL_PROGRAM, $$(BOARD_PROGRAM_FUSE_DEFAULT))

$(strip $(1))-cat: $$(addprefix $$(BUILD_FOLDER)/,$(1).elf)
	$$(call TOOL_OBJDUMP, $$<)

$(strip $(1))-debug-server:
	$$(call TOOL_DBGSVR)

$$(addprefix $$(BUILD_FOLDER)/,$(1).hex) : $$(addprefix $$(BUILD_FOLDER)/,$(1).elf)
	@[ -d $$(dir $$@) ] || $$(TOOL_MKDIRS) $$(dir $$@)
	$$(TOOL_OBJCOPY) $$(BINFLAGS) -O ihex $$< $$@

$$(addprefix $$(BUILD_FOLDER)/,$(1).elf) : $(2)
	@[ -d $$(dir $$@) ] || $$(TOOL_MKDIRS) $$(dir $$@)
	$$(TOOL_CC) $$(GLOBAL_CFLAGS) $$(GLOBAL_LDFLAGS) -o $$@ $$^

endef
# +----------------------------------------------------------------------------+
