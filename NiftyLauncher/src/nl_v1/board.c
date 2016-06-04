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
#include "Button.h"
#include "Timer.h"

extern Shift8 *init_shift8(Shift8 *self, Context *app_context, GPOut data_serial, GPOut str_clock,
                           GPOut shr_clock);
extern Led *init_led(Led *self, Context *app_context, GPOut io);

extern Button *init_button(Button *button, Context *app_context, GPIn io);

extern Timer *init_timer(Timer *timer, Context *app_context);

static Shift8 g_shift8;
static Led g_led0;
static Button g_launch_button;
static Timer g_timer;

void init_board(Context *app_context)
{
    assert(app_context);

    DDRA |= (1 << DDA0) | (1 << DDA1) | (1 << DDA2) | (1 << DDA3);
    DDRB = 0;

    app_context->_drivers[DRIVER_SHIFTREG_8] = init_shift8(
        &g_shift8, app_context, (GPOut){&PORTA, PA1}, (GPOut){&PORTA, PA2}, (GPOut){&PORTA, PA3});

    app_context->_drivers[DRIVER_LED_0] = init_led(&g_led0, app_context, (GPOut){&PORTA, PA0});

    // enable pullup
    PORTB |= (1 << PB2);
    app_context->_drivers[DRIVER_BUTTON_LAUNCH] =
        init_button(&g_launch_button, app_context, (GPIn){&PINB, PINB2});

    app_context->_drivers[DRIVER_TIMER0] = init_timer(&g_timer, app_context);
}
