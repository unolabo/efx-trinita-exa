//*------------------------------------------------------------------------------------------
//  MIT License
//  
//  Copyright (c) 2022 SaxonSoc contributors
//  
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//  
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//  
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//*-----------------------------------------------------------------------------------------
#pragma once

#include "bsp.h"
#include "io.h"
#include "spiFlash.h"
#include "start.h"

#define SPI SYSTEM_SPI_0_IO_CTRL
#define SPI_CS 0

#define USER_SOFTWARE_MEMORY_INST 0xF9000000
#define USER_SOFTWARE_FLASH_INST  0x00100000
#define USER_SOFTWARE_SIZE_INST   0x7000
#define USER_SOFTWARE_MEMORY_DATA 0xF9080000
#define USER_SOFTWARE_FLASH_DATA  0x00100000 + ( USER_SOFTWARE_MEMORY_DATA - USER_SOFTWARE_MEMORY_INST )
#define USER_SOFTWARE_SIZE_DATA   0x7800

void bspMain() {
#ifndef SIM
	spiFlash_init(SPI, SPI_CS);
	spiFlash_wake(SPI, SPI_CS);
	spiFlash_f2m(SPI, SPI_CS, USER_SOFTWARE_FLASH_INST, USER_SOFTWARE_MEMORY_INST, USER_SOFTWARE_SIZE_INST);
	spiFlash_f2m(SPI, SPI_CS, USER_SOFTWARE_FLASH_DATA, USER_SOFTWARE_MEMORY_DATA, USER_SOFTWARE_SIZE_DATA);
#endif

	asm("fence.i; nop; nop; nop; nop; nop; nop"); 
	void (*userMain)() = (void (*)())USER_SOFTWARE_MEMORY_INST;
#ifdef SMP
    smp_unlock(userMain);
#endif
	userMain();
}
