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
#include <avr/io.h>
#include <avr/interrupt.h>
#include <util/atomic.h>
#include "Timer.h"
#include "Context.h"

// THIS IS ALL CRAP CODE. DO NOT C&P!

volatile Timer *g_timers[1] = {0};

ISR(TIM0_OVF_vect)
{
    volatile Timer *t = g_timers[0];
    if (t) {
        t->_isr(t);
    }
}

static void _add_timer(Timer *self, timer_callback_func callback, void *userdata)
{
    self->_timers[0].callback = callback;
    self->_timers[0].userdata = userdata;
}

static void _isr(volatile Timer *self)
{
    _TimerReg r = self->_timers[0];
    if (r.callback) {
        r.callback(self, r.userdata);
    }
}

Timer *init_timer(Timer *timer, Context *app_context)
{
    if (timer) {
        timer->add_timer = _add_timer;
        timer->_isr = _isr;
        timer->_timers[0].callback = 0;
        TIMSK0 |= (1 << TOIE0);
        TCCR0A = 0;
        TCCR0B = (1 << CS00);
        g_timers[0] = timer;
    }
    return timer;
}
