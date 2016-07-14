#  Nify (by 32bits.io)
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
#

# +---------------------------------------------------------------------------+

LOCAL_MODULE_NAME := blue_blinky

$(eval $(call local_add_and_include_c_file, $(LOCAL_DIR), main.c))

LOCAL_INCLUDES += $(LOCAL_DIR)/$(LOCAL_ENV_BOARDS_DIR)/$(BOARD) \
                  $(SDK_NRF5_TOOLCHAIN) \
                  $(SDK_NRF5_COMPONENTS_PATH)/device \
                  $(SDK_NRF5_DRV_PATH)/hal \
                  $(SDK_NRF5_DRV_PATH)/

LOCAL_SRC_C    += $(SDK_NRF5_COMMON_SRC) \
                  $(LOCAL_DIR)/gcc_startup_$(BOARD_DEVICE).s \


$(eval $(call local_add_and_include_all_c_at, $(SDK_NRF5_DRV_PATH)/common))
$(eval $(call local_add_and_include_all_c_at, $(SDK_NRF5_DRV_PATH)/uart))
$(eval $(call local_add_and_include_all_c_at, $(SDK_NRF5_DRV_PATH)/pwm))
$(eval $(call local_add_and_include_all_c_at, $(SDK_NRF5_DRV_PATH)/clock))
$(eval $(call local_add_and_include_all_c_at, $(SDK_NRF5_DRV_PATH)/delay))
$(eval $(call local_add_and_include_all_c_at, $(SDK_NRF5_DRV_PATH)/gpiote))


$(eval $(call local_add_and_include_all_c_at, $(SDK_NRF5_LIBS_PATH)/uart, %/app_uart.c))
$(eval $(call local_add_and_include_all_c_at, $(SDK_NRF5_LIBS_PATH)/button))
$(eval $(call local_add_and_include_all_c_at, $(SDK_NRF5_LIBS_PATH)/util, %/nrf_log.c))
$(eval $(call local_add_and_include_all_c_at, $(SDK_NRF5_LIBS_PATH)/fifo))
$(eval $(call local_add_and_include_c_file, $(SDK_NRF5_LIBS_PATH)/timer, app_timer.c))

$(eval $(call local_add_and_include_c_file, $(SDK_NRF5_EXAMPLES_PATH)/bsp, bsp.c))

LOCAL_LINKER_SCRIPT := $(LOCAL_DIR)/blinky_gcc_$(BOARD_DEVICE).ld

LOCAL_CFLAGS += 

LOCAL_LIBS += m \

include $(COMMAND_MAKE_BINARY)
