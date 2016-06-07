/*  ArduinoLauncher (by 32bits.io)

                                                                        /

                                                                      (
                                                                     C)
                                                                   (C))
                                                                 )()C))C
   ___________________________________________________________(C))C)()C)________

   Copyright (c) 2016 Scott A Dixon.  All right reserved.

   Permission is hereby granted, free of charge, to any person obtaining a copy
   of this software and associated documentation files (the "Software"), to deal
   in the Software without restriction, including without limitation the rights
   to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
   copies of the Software, and to permit persons to whom the Software is
   furnished to do so, subject to the following conditions:

   The above copyright notice and this permission notice shall be included in
   all copies or substantial portions of the Software.

   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
   IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
   FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
   AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
   LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
   OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
   SOFTWARE.
*/
#include <Arduino.h>

// +---------------------------------------------------------------------------+
// | WIRING
// +---------------------------------------------------------------------------+

//                                  attiny84
//                                  +--V--+
//                              VCC |     | GND
//                  [D10] XTAL1/PB0 |     | PA0/AREF [D0]
//                  [ D9] XTAL2/PB1 |     | PA1      [D1] PIN_SR_DS
//                        RESET/PB3 |     | PA2      [D2] PIN_SR_SH
// PIN_LAUNCH_BUTT  [ D8]* INT0/PB2 |     | PA3      [D3] PIN_SR_ST
//   PIN_CONT_READ  [ D7]*      PA7 |     | PA4      [D4] PIN_LAUNCH_VIN
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
#define PIN_LAUNCH_BUTT 8
#define PIN_LAUNCH_FUSE 5
#define PIN_LAUNCH_VIN 4
#define PIN_FIRE_IND 0
#define PIN_ARM_IND 6
#define PIN_CONT_READ 7
#define PIN_SR_DS 1
#define PIN_SR_ST 3
#define PIN_SR_SH 2

// +---------------------------------------------------------------------------+
// | CONSTANTS
// +---------------------------------------------------------------------------+
#define VIN_DROPOUTS_TH 10
#define COUNTDOWN_MAX 10
#define FIRE_FOR_MILLIS 4000UL
#define ARM_COOLING_OFF_PERIOD 1000UL

// +---------------------------------------------------------------------------+
// | DATA TYPES
// +---------------------------------------------------------------------------+
typedef enum {
  LAUNCHSTATE_DISARMED,
  LAUNCHSTATE_ARMED,
  LAUNCHSTATE_COUNTDOWN,
  LAUNCHSTATE_FIRING,
  LAUNCHSTATE_POST_FIRE,
} LaunchState;

// +---------------------------------------------------------------------------+
// | DATA
// +---------------------------------------------------------------------------+
typedef struct Sketch_t {
  uint8_t button_state;
  uint8_t launch_state;
  uint8_t countdown;
  uint8_t button_tripped;
  uint8_t vread_dropouts;
  unsigned long last_tick;
  unsigned long ind_timer;
  unsigned long state_timer;
  uint8_t ssmap[11];
} Sketch;

Sketch sketch = {
  0,
  LAUNCHSTATE_DISARMED,
  COUNTDOWN_MAX,
  0,
  0,
  0,
  0,
  0,
  {
    0x2, 0x5B, 0x05, 0x09, 0x58, 0x28, 0x20, 0x4B, 0, 0x48, 0x40
  }
};

// +---------------------------------------------------------------------------+
// | FUNCTIONS
// +---------------------------------------------------------------------------+
void change_state(uint8_t newstate) {
  if (LAUNCHSTATE_ARMED == newstate && millis() - sketch.state_timer < ARM_COOLING_OFF_PERIOD) {
    return;
  }
  sketch.launch_state = newstate;
  sketch.countdown = COUNTDOWN_MAX;
  sketch.state_timer = millis();
}

void print_state() {
  switch (sketch.launch_state) {
    case LAUNCHSTATE_DISARMED:
      digitalWrite(PIN_ARM_IND, HIGH);
      break;
    case LAUNCHSTATE_ARMED:
      digitalWrite(PIN_ARM_IND, LOW);
      break;
  }
}

void update_fire_ind() {
  switch (sketch.launch_state) {
    case LAUNCHSTATE_COUNTDOWN: {
        // blink
        unsigned long now = millis();
        if (now - sketch.ind_timer > 500) {
          digitalWrite(PIN_FIRE_IND, !digitalRead(PIN_FIRE_IND));
          sketch.ind_timer = now;
        }
      }
      break;
    case LAUNCHSTATE_POST_FIRE:
    case LAUNCHSTATE_FIRING: {
        digitalWrite(PIN_FIRE_IND, HIGH);
      }
      break;
    default:
      digitalWrite(PIN_FIRE_IND, LOW);
  }

}

void on_button() {
  const unsigned long now = millis();
  switch (sketch.launch_state) {
    case LAUNCHSTATE_ARMED:
      change_state(LAUNCHSTATE_COUNTDOWN);
      sketch.last_tick = now;
      break;
    case LAUNCHSTATE_FIRING:
    case LAUNCHSTATE_POST_FIRE:
    case LAUNCHSTATE_COUNTDOWN:
      change_state(LAUNCHSTATE_DISARMED);
      break;
  }
  sketch.countdown = COUNTDOWN_MAX;
}

void check_continuity() {
  if (LAUNCHSTATE_FIRING != sketch.launch_state) {
    if (digitalRead(PIN_LAUNCH_VIN)) {
      sketch.vread_dropouts = 0;
      if (LAUNCHSTATE_DISARMED == sketch.launch_state) {
        change_state(LAUNCHSTATE_ARMED);
        digitalWrite(PIN_CONT_READ, HIGH);
      }
    } else if (++sketch.vread_dropouts < VIN_DROPOUTS_TH) {
      change_state(LAUNCHSTATE_DISARMED);
      digitalWrite(PIN_CONT_READ, LOW);
    }
  }
}

void update_7segment() {
  digitalWrite(PIN_SR_ST, LOW);
  switch (sketch.launch_state) {
    case LAUNCHSTATE_FIRING: {
        shiftOut(PIN_SR_DS, PIN_SR_SH, MSBFIRST, sketch.ssmap[0]);
      }
      break;
    case LAUNCHSTATE_COUNTDOWN: {
        shiftOut(PIN_SR_DS, PIN_SR_SH, MSBFIRST, sketch.ssmap[sketch.countdown]);
      }
      break;
    default: {
        shiftOut(PIN_SR_DS, PIN_SR_SH, MSBFIRST, 0xFF);
      }
  }
  digitalWrite(PIN_SR_ST, HIGH);
}

// +---------------------------------------------------------------------------+
// | SKETCH
// +---------------------------------------------------------------------------+
void setup() {
  pinMode(PIN_LAUNCH_BUTT, INPUT_PULLUP);
  pinMode(PIN_LAUNCH_FUSE, OUTPUT);
  pinMode(PIN_LAUNCH_VIN, INPUT);
  pinMode(PIN_FIRE_IND, OUTPUT);
  pinMode(PIN_ARM_IND, OUTPUT);
  pinMode(PIN_CONT_READ, OUTPUT);
  pinMode(PIN_SR_DS, OUTPUT);
  pinMode(PIN_SR_ST, OUTPUT);
  pinMode(PIN_SR_SH, OUTPUT);
  digitalWrite(PIN_LAUNCH_FUSE, LOW);
  PORTA &= ~(1 << PINA4);
  DDRA &= ~(1 << DDA4);
  sketch.button_state = LAUNCHSTATE_ARMED;
}

// +---------------------------------------------------------------------------+
void loop() {
  const unsigned long now = millis();
  check_continuity();
  update_7segment();
  update_fire_ind();
  print_state();
  sketch.button_state = (sketch.button_state << 1) | !digitalRead(PIN_LAUNCH_BUTT);
  if (0xF == (0xF & sketch.button_state)) {
    if (!sketch.button_tripped) {
      sketch.button_tripped = true;
      on_button();
    }
  } else if (0x00 == (0xF & sketch.button_state)) {
    sketch.button_tripped = 0;
  }
  if (LAUNCHSTATE_COUNTDOWN == sketch.launch_state) {
    if (now - sketch.last_tick >= 1000) {
      sketch.last_tick = now;
      --sketch.countdown;
    }
    if (!sketch.countdown) {
      change_state(LAUNCHSTATE_FIRING);
    }
  }
  if (LAUNCHSTATE_FIRING == sketch.launch_state) {
    digitalWrite(PIN_LAUNCH_FUSE, HIGH);
    if (now - sketch.state_timer > FIRE_FOR_MILLIS) {
      change_state(LAUNCHSTATE_POST_FIRE);
    }
  } else {
    digitalWrite(PIN_LAUNCH_FUSE, LOW);
  }
}
