//                                                                     /
//
//                                                                   (
//                                                                  C)
//                                                                (C))
//                                                              )()C))C
//                                                            (C))C)()C)
// +--------------------------------------------------------------------------+
// | BLE Launcher
// |
// | Version 1.0
// |    The first version is basically some hacks on top of Adafruit's BLE
// | control demo. If this prototype is successful then in version 2 we'll
// | define a real rocket launcher GATT service and move the state machine
// | into the nrf51. The ultimate goal is to enable kids to program a launch
// | controller using scratch and a BBC microbit.
// +--------------------------------------------------------------------------+

#include <string.h>

#include <Arduino.h>
#include <SPI.h>

#include "Adafruit_LEDBackpack.h"

#include "Launcher.h"


/*
 * The pin the non-latching relay used to fire the rocket is on.
 */
static constexpr unsigned int PIN_RELAY = 6;

static Adafruit_7segment matrix = Adafruit_7segment();

static Launcher::State s_state;

// +--------------------------------------------------------------------------+
// | ARDUINO PROTOCOL
// +--------------------------------------------------------------------------+
void setup(void)
{
    delay(500);
    pinMode(PIN_RELAY, OUTPUT);

    Serial.begin(115200);
    Serial.println(F("Bluetooth Rocket Launcher"));
    Serial.println(F("-----------------------------------------"));

    /* Initialise the module */
    Serial.print(F("Initialising the Bluefruit LE module: "));

    s_state.init();
    matrix.begin(0x70);
}

// +--------------------------------------------------------------------------+

void loop(void)
{
  if (s_state.run_cycle()) {
    uint8_t count;

    if (s_state.is_safe()) {
      matrix.blinkRate(0);
      matrix.print(0x5AFE, HEX);
    } else if (s_state.is_counting_down(count)) {
      matrix.blinkRate(0);
      matrix.print(count, DEC);
    } else if (s_state.is_firing()) {
      matrix.print(0xF1AE, HEX);
      matrix.blinkRate(1);
      digitalWrite(PIN_RELAY, HIGH);
    } else {
      matrix.blinkRate(0);
      matrix.print(0xAAAA, HEX);
    }
    
    matrix.writeDisplay();
  }

  if (!s_state.is_firing()) {
    digitalWrite(PIN_RELAY, LOW);
  }

  if (!s_state.is_connected()) {
    // TODO: sleep
    delay(500);
  }
}

// +--------------------------------------------------------------------------+
