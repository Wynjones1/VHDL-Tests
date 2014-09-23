#pragma once
#include "buttons.h"
#include "led.h"
#include "serial.h"
#include "ssd.h"
#include "switches.h"
#include "vga.h"
#include "clock.h"

#define SIGNAL(signal, pin) NET #signal LOC = pin;

#define SUB_SIGNAL(signal, num, pin) NET signal<num> LOC = pin;
#define S(x) #x

#define SIGNAL2(signal, pin)\
	NET S(signal<0>) LOC = pin ## 0;\
	NET S(signal<1>) LOC = pin ## 1;\

#define SIGNAL3(signal, pin)\
	NET S(signal<0>) LOC = pin ## 0;\
	NET S(signal<1>) LOC = pin ## 1;\
	NET S(signal<2>) LOC = pin ## 2;\

#define SIGNAL4(signal, pin)\
	NET S(signal<0>) LOC = pin ## 0;\
	NET S(signal<1>) LOC = pin ## 1;\
	NET S(signal<2>) LOC = pin ## 2;\
	NET S(signal<3>) LOC = pin ## 3;\

#define SIGNAL8(signal, pin)\
	NET S(signal<0>) LOC = pin ## 0;\
	NET S(signal<1>) LOC = pin ## 1;\
	NET S(signal<2>) LOC = pin ## 2;\
	NET S(signal<3>) LOC = pin ## 3;\
	NET S(signal<4>) LOC = pin ## 4;\
	NET S(signal<5>) LOC = pin ## 5;\
	NET S(signal<6>) LOC = pin ## 6;\
	NET S(signal<7>) LOC = pin ## 7;

#define SIGNAL16(signal, pin)\
	NET S(signal<0>) LOC = pin ## 0;\
	NET S(signal<1>) LOC = pin ## 1;\
	NET S(signal<2>) LOC = pin ## 2;\
	NET S(signal<3>) LOC = pin ## 3;\
	NET S(signal<4>) LOC = pin ## 4;\
	NET S(signal<5>) LOC = pin ## 5;\
	NET S(signal<6>) LOC = pin ## 6;\
	NET S(signal<7>) LOC = pin ## 7;\
	NET S(signal<8>) LOC = pin ## 8;\
	NET S(signal<9>) LOC = pin ## 9;\
	NET S(signal<10>) LOC = pin ## 10;\
	NET S(signal<11>) LOC = pin ## 11;\
	NET S(signal<12>) LOC = pin ## 12;\
	NET S(signal<13>) LOC = pin ## 13;\
	NET S(signal<14>) LOC = pin ## 14;\
	NET S(signal<15>) LOC = pin ## 15;
