#include <Arduino.h>

#define PIN_LAUNCH_BUTT A1
#define PIN_LAUNCH_FUSE 6
#define PIN_LAUNCH_VIN A0
#define PIN_IND A2
#define PIN_BAR0 0
#define PIN_BAR1 1
#define PIN_BAR2 2
#define PIN_BAR3 3

#define VIN_DROPOUTS_TH 10
#define COUNTDOWN_MAX 4

typedef enum {
  LAUNCHSTATE_DISARMED,
  LAUNCHSTATE_ARMED,
  LAUNCHSTATE_COUNTDOWN,
  LAUNCHSTATE_FIRING,

} LaunchState;

uint8_t g_button_state = 0;
uint8_t g_launch_state = LAUNCHSTATE_DISARMED;
uint8_t g_countdown = COUNTDOWN_MAX;
uint8_t g_button_tripped = 0;
uint8_t g_vread_dropouts = 0;

unsigned long g_last_tick = 0;
unsigned long g_ind_timer = 0;


void change_state(uint8_t newstate) {
  g_launch_state = newstate;
  g_countdown = COUNTDOWN_MAX;
}

void print_state() {
  switch (g_launch_state) {
    case LAUNCHSTATE_DISARMED:
      digitalWrite(PIN_IND, LOW);
      break;
    case LAUNCHSTATE_ARMED:
      digitalWrite(PIN_IND, HIGH);
      break;
    case LAUNCHSTATE_COUNTDOWN:
      break;
    case LAUNCHSTATE_FIRING:
      break;
  }
}

void update_ind() {
  if (LAUNCHSTATE_COUNTDOWN == g_launch_state) {
    // blink
    unsigned long now = millis();
    if (now - g_ind_timer > 500) {
      digitalWrite(PIN_IND, !digitalRead(PIN_IND));
      g_ind_timer = now;
    }
  } else if (LAUNCHSTATE_FIRING == g_launch_state) {
    digitalWrite(PIN_IND, HIGH);
  } else {
    digitalWrite(PIN_IND, LOW);
  }
}

void on_button() {
  switch (g_launch_state) {
    case LAUNCHSTATE_ARMED:
      change_state(LAUNCHSTATE_COUNTDOWN);
      g_last_tick = millis();
      break;
    case LAUNCHSTATE_FIRING:
    case LAUNCHSTATE_COUNTDOWN:
      change_state(LAUNCHSTATE_DISARMED);
      break;
  }
  g_countdown = COUNTDOWN_MAX;
}

void check_continuity() {
  if (LAUNCHSTATE_FIRING != g_launch_state) {
    if (digitalRead(PIN_LAUNCH_VIN)) {
      g_vread_dropouts = 0;
      if (LAUNCHSTATE_DISARMED == g_launch_state) {
        change_state(LAUNCHSTATE_ARMED);
      }
    } else if (++g_vread_dropouts < VIN_DROPOUTS_TH) {
      change_state(LAUNCHSTATE_DISARMED);
    }
  }
}

void update_bargraph() {
  if (LAUNCHSTATE_COUNTDOWN == g_launch_state) {
    if (g_countdown >= 4) {
      digitalWrite(PIN_BAR3, LOW);
      digitalWrite(PIN_BAR2, LOW);
      digitalWrite(PIN_BAR1, LOW);
      digitalWrite(PIN_BAR0, LOW);
    } else if (g_countdown == 3) {
      digitalWrite(PIN_BAR3, HIGH);
      digitalWrite(PIN_BAR2, LOW);
      digitalWrite(PIN_BAR1, LOW);
      digitalWrite(PIN_BAR0, LOW);
    } else if (g_countdown == 2) {
      digitalWrite(PIN_BAR3, HIGH);
      digitalWrite(PIN_BAR2, HIGH);
      digitalWrite(PIN_BAR1, LOW);
      digitalWrite(PIN_BAR0, LOW);
    } else if (g_countdown == 1) {
      digitalWrite(PIN_BAR3, HIGH);
      digitalWrite(PIN_BAR2, HIGH);
      digitalWrite(PIN_BAR1, HIGH);
      digitalWrite(PIN_BAR0, LOW);
    } else {
      digitalWrite(PIN_BAR3, HIGH);
      digitalWrite(PIN_BAR2, HIGH);
      digitalWrite(PIN_BAR1, HIGH);
      digitalWrite(PIN_BAR0, HIGH);
    }
  } else {
    digitalWrite(PIN_BAR3, HIGH);
    digitalWrite(PIN_BAR2, HIGH);
    digitalWrite(PIN_BAR1, HIGH);
    digitalWrite(PIN_BAR0, HIGH);
  }
}

void setup() {
  pinMode(PIN_LAUNCH_BUTT, INPUT_PULLUP);
  pinMode(PIN_LAUNCH_FUSE, OUTPUT);
  pinMode(PIN_LAUNCH_VIN, INPUT);
  pinMode(PIN_IND, OUTPUT);
  pinMode(PIN_BAR0, OUTPUT);
  pinMode(PIN_BAR1, OUTPUT);
  pinMode(PIN_BAR2, OUTPUT);
  pinMode(PIN_BAR3, OUTPUT);
  digitalWrite(PIN_LAUNCH_FUSE, LOW);
  g_button_state = LAUNCHSTATE_ARMED;
}

void loop() {
  check_continuity();
  update_bargraph();
  update_ind();
  print_state();
  g_button_state = (g_button_state << 1) | !digitalRead(PIN_LAUNCH_BUTT);
  if (0xF == (0xF & g_button_state)) {
    if (!g_button_tripped) {
      g_button_tripped = true;
      on_button();
    }
  } else if (0x00 == (0xF & g_button_state)) {
    g_button_tripped = 0;
  }
  if (LAUNCHSTATE_COUNTDOWN == g_launch_state) {
    const unsigned long now = millis();
    if (now - g_last_tick >= 1000) {
      g_last_tick = now;
      --g_countdown;
    }
    if (!g_countdown) {
      change_state(LAUNCHSTATE_FIRING);
    }
  }
  if (LAUNCHSTATE_FIRING == g_launch_state) {
    digitalWrite(PIN_LAUNCH_FUSE, HIGH);
  } else {
    digitalWrite(PIN_LAUNCH_FUSE, LOW);
  }
}
