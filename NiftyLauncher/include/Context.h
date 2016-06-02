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
#pragma once

typedef enum {
    DRIVERTYPE_SHIFTREG_8 = 0,
    DRIVERTYPE_LED_0 = 1,
    DRIVERTYPE_MAX = 2,

} DriverType;

struct Context_t;

typedef void *(*get_driver_func)(struct Context_t *self, DriverType type);

typedef struct Context_t {
    get_driver_func get_driver;
    void *_drivers[2];
} Context;
