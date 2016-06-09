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
#include "Shift8.h"
#include "Context.h"
#include "util/atomic.h"

static void _shift_out(struct Shift8_t *self, uint8_t bit_order, uint8_t value)
{

    assert(self);
    ATOMIC_BLOCK(ATOMIC_RESTORESTATE)
    {
        GPOUT_OFF(self, str_clock);

        uint8_t i;

        for (i = 0; i < 8; ++i) {
            if (bit_order == LSBFIRST) {
                GPOUT_WRITE(self, ds, !!(value & (1 << i)));
            } else {
                GPOUT_WRITE(self, ds, !!(value & (1 << (7 - i))));
            }
            GPOUT_ON(self, shr_clock);
            GPOUT_OFF(self, shr_clock);
        }

        GPOUT_ON(self, str_clock);
    }
}

static void _shift_reset(Shift8 *self)
{
    GPOUT_OFF(self, str_clock);
    GPOUT_ON(self, str_clock);
}

Shift8 *init_shift8(Shift8 *self, Context *app_context, GPOut data_serial, GPOut str_clock,
                    GPOut shr_clock)
{
    if (self) {
        assert(app_context);
        self->app_context = app_context;
        self->shift_out = _shift_out;
        self->reset = _shift_reset;
        self->_ds = data_serial;
        self->_str_clock = str_clock;
        self->_shr_clock = shr_clock;
        GPOUT_ON(self, str_clock);
    }
    return self;
}