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
#include <avr/interrupt.h>
#include "board.h"
#include "Context.h"
#include "Shift8.h"
#include "Led.h"
#include "Button.h"
#include "Timer.h"

typedef enum {
    LAUNCHER_STATE_DISARMED,
    LAUNCHER_STATE_ARMED,
    LAUNCHER_STATE_COUNTDOWN,
    LAUNCHER_STATE_FIRING
} LauncherState;

LauncherState g_launcher_state = LAUNCHER_STATE_DISARMED;
Context g_app_context;

extern Context *init_context(Context *self);

void on_launch_button(Button *button)
{
    if (LAUNCHER_STATE_DISARMED == g_launcher_state) {
        g_launcher_state = LAUNCHER_STATE_COUNTDOWN;
    } else {
        g_launcher_state = LAUNCHER_STATE_DISARMED;
    }
}

void button_driver(volatile Timer *timer, void *user_data)
{
    Button *b = (Button *)user_data;
    b->drive(b);
}

int main(void)
{
    cli();
    init_context(&g_app_context);
    init_board(&g_app_context);
    Shift8 *shift = g_app_context.get_driver(&g_app_context, DRIVER_SHIFTREG_8);
    uint8_t number_to_display = 0;
    Led *led = g_app_context.get_driver(&g_app_context, DRIVER_LED_0);
    Button *launch_button = g_app_context.get_driver(&g_app_context, DRIVER_BUTTON_LAUNCH);
    launch_button->callback = on_launch_button;
    Timer *timer0 __attribute__((unused)) = g_app_context.get_driver(&g_app_context, DRIVER_TIMER0);
    timer0->add_timer(timer0, button_driver, launch_button);
    while (1) {
        launch_button->drive(launch_button);
        if (LAUNCHER_STATE_COUNTDOWN == g_launcher_state) {
            number_to_display = (number_to_display == 255) ? 0 : number_to_display + 1;
            GPOUT_ON(led, io);
            shift->shift_out(shift, MSBFIRST, number_to_display);
            sei();
            _delay_ms(500);
            cli();
            GPOUT_OFF(led, io);
        } else {
            GPOUT_OFF(led, io);
        }
        sei();
        _delay_ms(500);
        cli();
    }
}
