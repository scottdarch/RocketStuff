#pragma once

#include <stdint.h>

#include <Arduino.h>

#include "BluefruitConfig.h"
#include "Adafruit_BLE.h"
#include "Adafruit_BluefruitLE_SPI.h"
#include "Adafruit_GFX.h"

#if SOFTWARE_SERIAL_AVAILABLE
#include <SoftwareSerial.h>
#endif

// +--------------------------------------------------------------------------+
/*
    APPLICATION SETTINGS
    MINIMUM_FIRMWARE_VERSION  Minimum firmware version to have some new features
    MODE_LED_BEHAVIOUR        LED activity, valid options are
                              "DISABLE" or "MODE" or "BLEUART" or
                              "HWUART"  or "SPI"  or "MANUAL"
*/
#define MINIMUM_FIRMWARE_VERSION "0.6.6"
#define MODE_LED_BEHAVIOUR "MODE"
// +--------------------------------------------------------------------------+

// function prototypes over in packetparser.cpp
uint8_t readPacket(Adafruit_BLE *ble, uint16_t timeout);
float parsefloat(uint8_t *buffer);
void printHex(const uint8_t *data, const uint32_t numBytes);

// the packet buffer
extern uint8_t packetbuffer[];

namespace Launcher {

class State {
public:
    State();

    void init();
    bool run_cycle();
    bool is_connected() const;
    bool is_safe() const;
    bool is_firing() const;
    bool is_counting_down(uint8_t& out_count) const;

private:
    enum struct States {
        SAFE_NC,
        SAFE,
        ARMED,
        COUNTING_DOWN,
        FIRING,
    };

    uint8_t m_count;
    States m_state;
    Adafruit_BluefruitLE_SPI m_ble;
    uint32_t m_count_clock_millis;

};

} // end namespace Launcher
