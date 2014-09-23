#pragma once 
#include "gen.h"

#define SEG0 "L18"
#define SEG1 "F18"
#define SEG2 "D17"
#define SEG3 "D16"
#define SEG4 "G14"
#define SEG5 "J17"
#define SEG6 "H14"
#define DP   "C17"

#define CA SEG0
#define CB SEG1
#define CC SEG2
#define CD SEG3
#define CE SEG4
#define CF SEG5
#define CG SEG6

#define AN0 "F17"
#define AN1 "H17"
#define AN2 "C18"
#define AN3 "F15"

#define SSD(signal)\
	NET S(signal<0>) LOC = SEG0;\
	NET S(signal<1>) LOC = SEG1;\
	NET S(signal<2>) LOC = SEG2;\
	NET S(signal<3>) LOC = SEG3;\
	NET S(signal<4>) LOC = SEG4;\
	NET S(signal<5>) LOC = SEG5;\
	NET S(signal<6>) LOC = SEG6;
