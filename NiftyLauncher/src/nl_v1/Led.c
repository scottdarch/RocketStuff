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
#include "Led.h"
#include "Context.h"

static void _turn_off(Led *self)
{
    *(self->port) &= ~(1 << self->pin);
}

static void _turn_on(Led *self)
{
    *(self->port) |= (1 << self->pin);
}

Led *init_led(Led *self, Context *app_context, volatile uint8_t *ddr, volatile uint8_t *port,
              uint8_t pin)
{
    if (self) {
        self->app_context = app_context;
        *ddr |= (1 << pin);
        self->port = port;
        self->pin = pin;
        self->turn_off = _turn_off;
        self->turn_on = _turn_on;
    }
    return self;
}
