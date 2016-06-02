/*  NiftyLauncher (by 32bits.io)
 *
 *                                                                      /
 *
 *                                                                    (
 *                                                                   C)
 *                                                                 (C))
 *                                                               )()C))C
 * ___________________________________________________________(C))C)()C)________
 *
 * Copyright (c) 2016 Scott A Dixon.  All right reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

#include <util/delay.h>
#include <assert.h>
#include "board.h"
#include "Context.h"
#include "Shift8.h"
#include "Led.h"

Context g_app_context;

extern Context *init_context(Context *self);

int main(void)
{
    init_context(&g_app_context);
    init_board(&g_app_context);
    Shift8 *shift = g_app_context.get_driver(&g_app_context, DRIVERTYPE_SHIFTREG_8);
    assert(shift);
    Led *led = g_app_context.get_driver(&g_app_context, DRIVERTYPE_LED_0);
    assert(led);
    shift->shift_out(shift, MSBFIRST, 0xFF);
    while (1) {
        led->turn_on(led);
        _delay_ms(500);
        led->turn_off(led);
        _delay_ms(500);
    }
}
