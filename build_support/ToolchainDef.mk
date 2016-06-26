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

ifndef BOARD_TOOLCHAIN
$(error "No BOARD_TOOLCHAIN variable defined. This is required.")
endif

# +----------------------------------------------------------------------------+
# | UNIFIED TOOLS
# +----------------------------------------------------------------------------+
TOOL_MKDIRS             = mkdir -p
TOOL_RMDIR              = rm -rf
TOOL_PYTHON             = python
TOOL_AWK                = awk
TOOL_TOUPPER            = $(shell echo $(1) | tr '[:lower:]' '[:upper:]')

# - PROGRAMMING AND DEBUG TOOLS
TOOL_PROGRAM            = $(error "no TOOL_PROGRAM defined for toolchain $(BOARD_TOOLCHAIN)")
TOOL_DBGSVR             = $(error "no TOOL_DBGSVR defined for toolchain $(BOARD_TOOLCHAIN)")

# BINARY TOOLS
TOOL_BINSIZE            = $(error "no TOOL_BINSIZE defined for toolchain $(BOARD_TOOLCHAIN)")
TOOL_OBJDUMP            = $(error "no TOOL_OBJDUMP defined for toolchain $(BOARD_TOOLCHAIN)")
TOOL_NM                 = $(error "no TOOL_NM defined for toolchain $(BOARD_TOOLCHAIN)")

# COMPILER TOOLS
TOOL_CC                 = $(error "no TOOL_CC defined for toolchain $(BOARD_TOOLCHAIN)")
TOOL_AS                 = $(error "no TOOL_AS defined for toolchain $(BOARD_TOOLCHAIN)")
TOOL_AR                 = $(error "no TOOL_AR defined for toolchain $(BOARD_TOOLCHAIN)")
TOOL_LD                 = $(error "no TOOL_LD defined for toolchain $(BOARD_TOOLCHAIN)")
TOOL_OBJCOPY            = $(error "no TOOL_OBJCOPY defined for toolchain $(BOARD_TOOLCHAIN)")

# FILESYSTEM TOOLS
TOOL_ENSURE_RULE_TARGET_DIR = [ -d $(dir $@) ] || $(TOOL_MKDIRS) $(dir $@)


# +----------------------------------------------------------------------------+
# | GCC
# +----------------------------------------------------------------------------+
# See http://make.mad-scientist.net/papers/advanced-auto-dependency-generation/
# for an explaination of this dependency scheme.
GLOBAL_DEPFLAGS  = -MT $@ -MMD -MP -MF "$(patsubst %.o,%.Td,$@)"

POSTCOMPILE      = mv -f $(patsubst %.o,%.Td,$@) $(patsubst %.o,%.d,$@)

GLOBAL_ASFLAGS  := \

GLOBAL_CFLAGS   +=  \
                    -std=c99 \
                    -pipe \
                    -Wall \
                    -Werror \
                    -march=$(BOARD_MCU_ARCH) \
                    $(BOARD_CFLAGS)

ifdef DEBUG
GLOBAL_CFLAGS   += -ggdb \
                   -DDEBUG \
                   -Og \

else
GLOBAL_CFLAGS   += -Os \

endif

GLOBAL_CFLAGS   += $(LOCAL_ENV_CFLAGS)

GLOBAL_LDFLAGS  += --unresolved-symbols=report-all \
                   --warn-common \
                   --warn-section-align \

# +----------------------------------------------------------------------------+
# | TARGET GENERATION
# +----------------------------------------------------------------------------+
#
# $(eval $(call generate_object_recipes, param1, param2, param3))
#
# @param $(1) LOCAL_MODULE_NAME
# @param $(2) list of source files (.c or .s)
# @param $(3) list of local include paths
#
# @output $(1)_OBJS is created with target object files
# @output $(1)_SOURCE is created with provided source files
# @output $(1)_INCLUDES is created with provided local include paths
#
define generate_object_recipes

TMP_SOURCE    := $(filter %.c,$(2))
TMP_ASSMBLY   := $(filter %.s,$(2))

TMP_SRC_OBJS  := $(addprefix $(BUILD_FOLDER)/, $(TMP_SOURCE:.c=.o))
TMP_ASM_OBJS  := $(addprefix $(BUILD_FOLDER)/, $(TMP_ASSMBLY:.s=.o))

TMP_SRC_DEPS  := $(addprefix $(BUILD_FOLDER)/, $(TMP_SOURCE:.c=.d))
TMP_ASM_DEPS  := $(addprefix $(BUILD_FOLDER)/, $(TMP_ASSMBLY:.s=.d))

$(1)_SOURCE   := $(TMP_SOURCE)
$(1)_ASSMBLY  := $(TMP_ASSMBLY)

$(1)_OBJS     := $(TMP_SRC_OBJS) $(TMP_ASM_OBJS)

$(1)_INCLUDES := $(3)


$(TMP_ASM_OBJS) : $(TMP_ASSMBLY) $(TMP_ASM_DEPS)
	@$$(TOOL_ENSURE_RULE_TARGET_DIR)
	$(TOOL_AS) $$(GLOBAL_ASFLAGS) $$(GLOBAL_DEPFLAGS) $$(GLOBAL_CFLAGS) $$(addprefix -I,$$(GLOBAL_INCLUDE_PATHS)) \
        $(addprefix -I,$(sort $(3))) -D__ASSEMBLY__ -c $$< -o $$@
	$(POSTCOMPILE)

$(TMP_SRC_OBJS) : $(TMP_SOURCE) $(TMP_SRC_DEPS)
	@$$(TOOL_ENSURE_RULE_TARGET_DIR)
	$(TOOL_CC) $$(GLOBAL_DEPFLAGS) $$(GLOBAL_CFLAGS) $$(addprefix -I,$$(GLOBAL_INCLUDE_PATHS)) \
        $(addprefix -I,$(sort $(3))) -c $$< -o $$@
	$(POSTCOMPILE)

endef

# +--[ARCHIVE]----------------------------------------------------------------+
#
# $(eval $(call generate_archive_recipes, param1))
#
# @param $(1) LOCAL_MODULE_NAME
#
# @output LOCAL_ARCHIVE is create with archive target file.
# @output GLOBAL_GOALS is appended with archive target file
# @output GLOBAL_ARCHIVES is appended with the module name
#
define generate_archive_recipes

LOCAL_ARCHIVE := $(addprefix $(BUILD_FOLDER)/,$(1).a)
GLOBAL_GOALS  += $(addprefix $(BUILD_FOLDER)/,$(1).a)
GLOBAL_ARCHIVES += $(1)


$(addprefix $(BUILD_FOLDER)/,$(1).a) : $$($(1)_OBJS)
	@$$(TOOL_ENSURE_RULE_TARGET_DIR)
	$$(TOOL_AR) -ruc $$@ $$^

endef

# +---[BINARY]----------------------------------------------------------------+
#
# $(eval $(call generate_binary_recipes, param1, param2, param3))
#
# @param $(1) LOCAL_MODULE_NAME
# @param $(2) list of archive dependencies
# @param $(3) linker script
#
# @output GLOBAL_PHONIES is appended with binary tool targets
# @output GLOBAL_GOALS is appended with binary targets
# @output $(1)_ARCHIVES is appended with archive dependencies
# @output GLOBAL_BINARIES is appended with the module name
#
define generate_binary_recipes

$(1)_ARCHIVES := $(2)
GLOBAL_PHONIES += $(strip $(1))-size \
                  $(strip $(1))-cat \
                  $(strip $(1))-board \
                  $(strip $(1))-flash \
                  $(strip $(1))-flash-fuse-nl-v1 \
                  $(strip $(1))-flash-fuse-default \
                  $(strip $(1))-debug-server \

GLOBAL_GOALS += $(addprefix $(BUILD_FOLDER)/,$(1).hex)
GLOBAL_BINARIES += $(1)

$(strip $(1))-size: $$(addprefix $$(BUILD_FOLDER)/,$(1).elf)
	$$(call TOOL_BINSIZE, $$<)

$(strip $(1))-flash: $$(addprefix $$(BUILD_FOLDER)/,$(1).hex)
	$$(call TOOL_PROGRAM, $$<)

$(strip $(1))-cat: $$(addprefix $$(BUILD_FOLDER)/,$(1).elf)
	$$(call TOOL_OBJDUMP, $$<)

$(strip $(1))-debug-server:
	$$(call TOOL_DBGSVR)

$$(addprefix $$(BUILD_FOLDER)/,$(1).hex) : $$(addprefix $$(BUILD_FOLDER)/,$(1).elf)
	@$$(TOOL_ENSURE_RULE_TARGET_DIR)
	$$(BOARD_GCC_PREFIX)objcopy $$(GLOBAL_BINFLAGS) -O ihex $$< $$@

$$(addprefix $$(BUILD_FOLDER)/,$(1).elf) : $(3) $$($(1)_OBJS) $(2)
	@$$(TOOL_ENSURE_RULE_TARGET_DIR)
	$$(BOARD_GCC_PREFIX)gcc $(GLOBAL_CFLAGS) $$(filter-out $$<,$$^) \
        $$(addprefix -Wl$$(strip $$(COMMA)),$$(GLOBAL_LDFLAGS) -Map=$$(dir $$@)$(strip $(1)).map) \
        -o $$@ \
        -Wl,--script=$$<

endef

# +---[INFO]------------------------------------------------------------------+
#
# $(eval $(call generate_info_phony_target, param1, param2))
#
# @param $(1) list of "all" dependencies
# @param $(2) list of all phony targets
# @param $(3) list of archives defined in the makefile
# @param $(4) list of binaries defined in the makefile
#
define generate_info_phony_targets

GLOBAL_PHONIES += info info-all info-board info-tools

info:
	@echo
	@echo "$$(ANSI_BLONWHT)                                                                              $$(ANSI_CLEAR)"
	@echo "+----------------------------------------------------------------------------+"
	@echo "| $$(PROJECT_NAME)-$$(LOCAL_ENV_FLAVOR)"
	@echo "+----------------------------------------------------------------------------+"
	@echo "$$(ANSI_BLONWHT)ALL:            $$(ANSI_CLEAR)" $$(addprefix "\n\t", $(sort $(1)))
	@echo
	@echo "$$(ANSI_BLONWHT)TARGETS:        $$(ANSI_CLEAR)" $$(addprefix "\n\t", $(sort $(2) info info-all info-board info-tools))
	@echo

info-tools: info
	@echo "+----------------------------------------------------------------------------+"
	@echo "| TOOLS :: $$(ANSI_TEXT_GREEN)$$(BOARD_TOOLCHAIN)$$(ANSI_CLEAR)"
	@echo "+----------------------------------------------------------------------------+"
	@echo "$$(ANSI_BLONWHT)CC:             $$(ANSI_CLEAR) $$(TOOL_CC)"
	@echo "$$(ANSI_BLONWHT)AS              $$(ANSI_CLEAR) $$(TOOL_AS)"
	@echo "$$(ANSI_BLONWHT)AR              $$(ANSI_CLEAR) $$(TOOL_AR)"
	@echo "$$(ANSI_BLONWHT)LD              $$(ANSI_CLEAR) $$(TOOL_LD)"
	@echo "$$(ANSI_BLONWHT)NM              $$(ANSI_CLEAR) $$(TOOL_NM)"
	@echo "$$(ANSI_BLONWHT)OBJCOPY         $$(ANSI_CLEAR) $$(TOOL_OBJCOPY)"
	@echo "$$(ANSI_BLONWHT)OBJDUMP         $$(ANSI_CLEAR) $$(TOOL_OBJDUMP)"
	@echo

info-all: info-tools info-board
	@echo "$$(ANSI_BLONWHT)GLOBAL INCLUDES:$$(ANSI_CLEAR)" $$(addprefix "\n\t", $$(sort $(GLOBAL_INCLUDE_PATHS)))
	@echo
	$(foreach MODULE,$(3),$(call generate_module_info,ARCHIVE,$(MODULE)))
	$(foreach MODULE,$(4),$(call generate_module_info,BINARY,$(MODULE)))

endef

#
# PRIVATE, use $(eval $(call generate_info_phony_target, param1, param2))
#
define generate_module_info
	
	@echo "+----------------------------------------------------------------------------+"
	@echo "| $(1) :: $$(ANSI_TEXT_GREEN)$(2)$$(ANSI_CLEAR)"
	@echo "+----------------------------------------------------------------------------+"
	@echo "$$(ANSI_BLONWHT)SOURCE:        $$(ANSI_CLEAR)" $$(addprefix "\n\t", $$(sort $$($(2)_SOURCE)))
	@echo
	@echo "$$(ANSI_BLONWHT)ASSEMBLY:      $$(ANSI_CLEAR)" $$(addprefix "\n\t", $$(sort $$($(2)_ASSMBLY)))
	@echo
	@echo "$$(ANSI_BLONWHT)INCLUDES:      $$(ANSI_CLEAR)" $$(addprefix "\n\t", $$(sort $$($(2)_INCLUDES)))
	@echo
	@echo "$$(ANSI_BLONWHT)OBJS:          $$(ANSI_CLEAR)" $$(addprefix "\n\t", $$(sort $$($(2)_OBJS)))
	@echo
	@echo "$$(ANSI_BLONWHT)ARCHIVES:      $$(ANSI_CLEAR)" $$(addprefix "\n\t", $$(sort $$($(2)_ARCHIVES)))
	@echo
endef


