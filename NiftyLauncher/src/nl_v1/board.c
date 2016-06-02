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
#include <assert.h>
#include "board.h"
#include "Context.h"
#include "Shift8.h"
#include "Led.h"

extern Shift8 *init_shift8(Shift8 *self, Context *app_context);
extern Led *init_led(Led *self, Context *app_context, volatile uint8_t *ddr, volatile uint8_t *port,
                     uint8_t pin);

static Shift8 g_shift8;
static Led g_led0;

void init_board(Context *app_context)
{
    assert(app_context);
    app_context->_drivers[DRIVERTYPE_SHIFTREG_8] = init_shift8(&g_shift8, app_context);
    app_context->_drivers[DRIVERTYPE_LED_0] = init_led(&g_led0, app_context, &DDRA, &PORTA, PA0);
}
