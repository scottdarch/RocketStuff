/*  Nifty Launcher (by 32bits.io)
 *                                                                       .
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
#pragma once
#include <stdbool.h>
#include <avr/io.h>

// +---------------------------------------------------------------------------+
// | PINOUT
// +---------------------------------------------------------------------------+

//                                  attiny84
//                                  +--V--+
//                              VCC |     | GND
//                  [D10] XTAL1/PB0 |     | PA0/AREF [D0] PIN_FIRE_IND
//                  [ D9] XTAL2/PB1 |     | PA1      [D1] PIN_SR_DS
//                        RESET/PB3 |     | PA2      [D2] PIN_SR_SH
// PIN_LAUNCH_BUTT  [ D8]* INT0/PB2 |     | PA3      [D3] PIN_SR_ST
//     PIN_I_SENSE  [ D7]*      PA7 |     | PA4      [D4] PIN_LAUNCH_VIN
//     PIN_ARM_IND  [ D6]*      PA6 |     | PA5     *[D5] PIN_LAUNCH_FUSE
//                                  +-----+
//                                                                     (*==PWM)
//
//                                  74HC595
//                                   +-V-+
//                                Q1 |   | vcc
//                                Q2 |   | Q0
//                                Q3 |   | DS
//                                Q4 |   | OE (LOW)
//                                Q5 |   | ST
//                                Q6 |   | SH
//                                Q7 |   | MR (LOW)
//                               GND |   | Q7S
//                                   +---+
//
//
//                      YSD-160AB3C-8 (sparkfun COM-08546)
//                              Q1 Q0  +  Q4 Q5
//                               A  9  8  7  6
//                                 +-------+
//                                 |  -7-  |
//                                 | 9   6 |
//                                 |  -A-  |
//                                 | 1   4 |
//                                 |  -2- o|
//                                 \-------+
//                               1  2  3  4  5
//                              Q3 Q6  +  Q2 D6
//
//                              7-seqment -> 595
//                                 +-------+
//                                 |  -4-  |
//                                 | 0   5 |
//                                 |  -1-  |
//                                 | 3   2 |
//                                 |  -6-  |
//                                 \-------+
//
// +---------------------------------------------------------------------------+
// | PINS
// +---------------------------------------------------------------------------+
/**
 * PIN_LAUNCH_BUTT - Button input used to initiate launch sequence.
 */
#define PIN_LAUNCH_BUTT
#define PIN_LAUNCH_BUTT_DDRx DDRB
#define PIN_LAUNCH_BUTT_DDxn DDB2
#define PIN_LAUNCH_BUTT_IS_OUTPUT 0
#define PIN_LAUNCH_BUTT_ENABLE_PULLUP 1

/**
 * PIN_LAUNCH_FUSE - Connects to mosfet to actually fire the e-match.
 */
#define PIN_LAUNCH_FUSE
#define PIN_LAUNCH_FUSE_PORT A
#define PIN_LAUNCH_FUSE_DDxn 5
#define PIN_LAUNCH_FUSE_IS_OUTPUT 1

/**
 * PIN_LAUNCH_VIN - A2D used to detect voltage and therefore continuity on the
 * e-match circuit.
 */
#define PIN_LAUNCH_VIN
#define PIN_LAUNCH_VIN_PORT A
#define PIN_LAUNCH_VIN_DDxn 4

/**
 * Visual indicator used to warn that the rocket is about to fire, then
 * flash as the e-match is lit, then remain on to confirm that the fire
 * operation occurred.
 */
#define PIN_FIRE_IND
#define PIN_FIRE_IND_PORT A
#define PIN_FIRE_IND_DDxn 0

/**
 * Visual indicator that the launcher is armed.
 */
#define PIN_ARM_IND
#define PIN_ARM_IND_PORT A
#define PIN_ARM_IND_DDxn 6

/**
 * Shift register serial input.
 */
#define PIN_SR_DS
#define PIN_SR_DS_PORT A
#define PIN_SR_DS_DDxn 1

/**
 * Shirt register storage register clock.
 */
#define PIN_SR_ST
#define PIN_SR_ST_PORT A
#define PIN_SR_ST_DDxn 3

/**
 * Shift register serial clock.
 */
#define PIN_SR_SH
#define PIN_SR_SH_PORT A
#define PIN_SR_SH_DDxn 2

/**
 * S22P hall effect current sense input. Fuse line runs through
 * this sensor. Used to test that enough current was delivered to the
 * e-match to light the motor.
 */
#define PIN_I_SENSE
#define PIN_I_SENSE_PORT A
#define PIN_I_SENSE_DDxn 7

// +---------------------------------------------------------------------------+
// | AVR MACROS
// +---------------------------------------------------------------------------+
#define AVR_IO_INIT_PIN(PIN_NAME)                              \
    if (PIN_##PIN_NAME##_IS_OUTPUT) {                          \
        PIN_##PIN_NAME##_DDRx |= (1 << PIN_##PIN_NAME##_DDxn); \
    }

// +---------------------------------------------------------------------------+
// | BOARD FUNCTIONS
// +---------------------------------------------------------------------------+
void init_board();
