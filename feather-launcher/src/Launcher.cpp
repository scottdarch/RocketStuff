#include "Launcher.h"

namespace Launcher {

State::State()
    : m_count(0)
    , m_state(States::SAFE)
    , m_ble(BLUEFRUIT_SPI_CS, BLUEFRUIT_SPI_IRQ, BLUEFRUIT_SPI_RST)
    , m_count_clock_millis(0)
{}

void
State::init() {
    if (!m_ble.begin(VERBOSE_MODE)) {
        Serial.println(F("Couldn't find Bluefruit, make sure it's in CoMmanD mode & check wiring?"));
        while(1);
    }
    Serial.println(F("OK!"));

    /* Disable command echo from Bluefruit */
    m_ble.echo(false);

    Serial.println("Requesting Bluefruit info:");
    /* Print Bluefruit information */
    m_ble.info();

    m_ble.verbose(false); // debug info is a little annoying after this point!
}

bool
State::run_cycle() {

    bool activity = false;

    if (!m_ble.isConnected()) {
        if (States::SAFE_NC != m_state) {
            m_state = States::SAFE_NC;
            activity = true;
        }
    } else if (m_state == States::SAFE_NC) {
        if (m_ble.isVersionAtLeast(MINIMUM_FIRMWARE_VERSION)) {
            // Change Mode LED Activity
            m_ble.sendCommandCheckOK("AT+HWModeLED=" MODE_LED_BEHAVIOUR);
        }

        // Set Bluefruit to DATA mode
        Serial.println(F("Switching to DATA mode!"));
        m_ble.setMode(BLUEFRUIT_MODE_DATA);

        m_state = States::SAFE;
        activity = true;
    } else {
        uint8_t buttnum = 0xFF;
        bool pressed = false;

        /* Wait for new data to arrive */
        uint8_t len = readPacket(&m_ble, (States::COUNTING_DOWN == m_state) ? 50 : BLE_READPACKET_TIMEOUT);

        if (len > 0) {
            /* Got a packet! */
            // printHex(packetbuffer, len);

            // Buttons
            if (packetbuffer[1] == 'B') {
                buttnum = packetbuffer[2] - '0';
                pressed = packetbuffer[3] - '0';
                Serial.print("Button ");
                Serial.print(buttnum);
            }

            if(m_state == States::SAFE) {
                if (buttnum == 1 && !pressed) {
                    m_state = States::ARMED;
                    activity = true;
                }
            } else if (buttnum != 2 || !pressed) {
                m_state = States::SAFE;
                activity = true;
            } else if (buttnum == 2) {
                // Launch sequence
                if (States::ARMED == m_state) {
                    m_state = States::COUNTING_DOWN;
                    m_count_clock_millis = millis();
                    m_count = 3;
                    activity = true;
                }
            }
        }

        if (States::COUNTING_DOWN == m_state) {
            const uint32_t now_millis = millis();
            if (now_millis - m_count_clock_millis >= 1000) {
                --m_count;
                activity = true;
                m_count_clock_millis = now_millis;
            }
            if (0 == m_count) {
                m_state = States::FIRING;
                activity = true;
            }
        }
    }
    return activity;
}

bool State::is_connected() const
{
    return (m_state != States::SAFE_NC);
}

bool State::is_safe() const
{
    return (m_state == States::SAFE || m_state == States::SAFE_NC);
}

bool State::is_firing() const
{
    return (m_state == States::FIRING);
}

bool State::is_counting_down(uint8_t &out_count) const
{
    out_count = m_count;
    return (m_state == States::COUNTING_DOWN);
}

} // namespace Launcher
