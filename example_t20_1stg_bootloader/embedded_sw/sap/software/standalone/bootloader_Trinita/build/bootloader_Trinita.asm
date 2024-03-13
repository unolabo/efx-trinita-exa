
build/bootloader_Trinita.elf:     file format elf32-littleriscv


Disassembly of section .rom_section.init:

f9007800 <_start>:

_start:
#ifdef USE_GP
.option push
.option norelax
	la gp, __global_pointer$
f9007800:	00080197          	auipc	gp,0x80
f9007804:	7f018193          	addi	gp,gp,2032 # f9087ff0 <__global_pointer$>

f9007808 <init>:
	sw a0, smp_lottery_lock, a1
    ret
#endif

init:
	la sp, _sp
f9007808:	c2018113          	addi	sp,gp,-992 # f9087c10 <__freertos_irq_stack_top>

	/* Load data section */
	la a0, _data_lma
f900780c:	81018513          	addi	a0,gp,-2032 # f9087800 <__init_array_end>
	la a1, _data
f9007810:	81018593          	addi	a1,gp,-2032 # f9087800 <__init_array_end>
	la a2, _edata
f9007814:	81c18613          	addi	a2,gp,-2020 # f908780c <__bss_start>
	bgeu a1, a2, 2f
f9007818:	00c5fc63          	bgeu	a1,a2,f9007830 <init+0x28>
1:
	lw t0, (a0)
f900781c:	00052283          	lw	t0,0(a0)
	sw t0, (a1)
f9007820:	0055a023          	sw	t0,0(a1)
	addi a0, a0, 4
f9007824:	00450513          	addi	a0,a0,4
	addi a1, a1, 4
f9007828:	00458593          	addi	a1,a1,4
	bltu a1, a2, 1b
f900782c:	fec5e8e3          	bltu	a1,a2,f900781c <init+0x14>
2:

	/* Clear bss section */
	la a0, __bss_start
f9007830:	81c18513          	addi	a0,gp,-2020 # f908780c <__bss_start>
	la a1, _end
f9007834:	82018593          	addi	a1,gp,-2016 # f9087810 <_end>
	bgeu a0, a1, 2f
f9007838:	00b57863          	bgeu	a0,a1,f9007848 <init+0x40>
1:
	sw zero, (a0)
f900783c:	00052023          	sw	zero,0(a0)
	addi a0, a0, 4
f9007840:	00450513          	addi	a0,a0,4
	bltu a0, a1, 1b
f9007844:	feb56ce3          	bltu	a0,a1,f900783c <init+0x34>
2:

#ifndef NO_LIBC_INIT_ARRAY
	call __libc_init_array
f9007848:	010000ef          	jal	ra,f9007858 <__libc_init_array>
#endif

	call main
f900784c:	548000ef          	jal	ra,f9007d94 <main>

f9007850 <mainDone>:
mainDone:
    j mainDone
f9007850:	0000006f          	j	f9007850 <mainDone>

f9007854 <_init>:


	.globl _init
_init:
    ret
f9007854:	00008067          	ret

Disassembly of section .rom_section.text:

f9007858 <__libc_init_array>:
f9007858:	ff010113          	addi	sp,sp,-16
f900785c:	00812423          	sw	s0,8(sp)
f9007860:	01212023          	sw	s2,0(sp)
f9007864:	81018413          	addi	s0,gp,-2032 # f9087800 <__init_array_end>
f9007868:	81018913          	addi	s2,gp,-2032 # f9087800 <__init_array_end>
f900786c:	40890933          	sub	s2,s2,s0
f9007870:	00112623          	sw	ra,12(sp)
f9007874:	00912223          	sw	s1,4(sp)
f9007878:	40295913          	srai	s2,s2,0x2
f900787c:	00090e63          	beqz	s2,f9007898 <__libc_init_array+0x40>
f9007880:	00000493          	li	s1,0
f9007884:	00042783          	lw	a5,0(s0)
f9007888:	00148493          	addi	s1,s1,1
f900788c:	00440413          	addi	s0,s0,4
f9007890:	000780e7          	jalr	a5
f9007894:	fe9918e3          	bne	s2,s1,f9007884 <__libc_init_array+0x2c>
f9007898:	81018413          	addi	s0,gp,-2032 # f9087800 <__init_array_end>
f900789c:	81018913          	addi	s2,gp,-2032 # f9087800 <__init_array_end>
f90078a0:	40890933          	sub	s2,s2,s0
f90078a4:	40295913          	srai	s2,s2,0x2
f90078a8:	00090e63          	beqz	s2,f90078c4 <__libc_init_array+0x6c>
f90078ac:	00000493          	li	s1,0
f90078b0:	00042783          	lw	a5,0(s0)
f90078b4:	00148493          	addi	s1,s1,1
f90078b8:	00440413          	addi	s0,s0,4
f90078bc:	000780e7          	jalr	a5
f90078c0:	fe9918e3          	bne	s2,s1,f90078b0 <__libc_init_array+0x58>
f90078c4:	00c12083          	lw	ra,12(sp)
f90078c8:	00812403          	lw	s0,8(sp)
f90078cc:	00412483          	lw	s1,4(sp)
f90078d0:	00012903          	lw	s2,0(sp)
f90078d4:	01010113          	addi	sp,sp,16
f90078d8:	00008067          	ret

f90078dc <clint_uDelay>:
    
        return (((u64)hi) << 32) | lo;
    }
    
    static void clint_uDelay(u32 usec, u32 hz, u32 reg){
        u32 mTimePerUsec = hz/1000000;
f90078dc:	000f47b7          	lui	a5,0xf4
f90078e0:	24078793          	addi	a5,a5,576 # f4240 <__stack_size+0xf3e40>
f90078e4:	02f5d5b3          	divu	a1,a1,a5
    readReg_u32 (clint_getTimeLow , CLINT_TIME_ADDR)
f90078e8:	0000c7b7          	lui	a5,0xc
f90078ec:	ff878793          	addi	a5,a5,-8 # bff8 <__stack_size+0xbbf8>
f90078f0:	00f60633          	add	a2,a2,a5
#include "type.h"
#include "soc.h"


    static inline u32 read_u32(u32 address){
        return *((volatile u32*) address);
f90078f4:	00062783          	lw	a5,0(a2)
        u32 limit = clint_getTimeLow(reg) + usec*mTimePerUsec;
f90078f8:	02a58533          	mul	a0,a1,a0
f90078fc:	00f50533          	add	a0,a0,a5
f9007900:	00062783          	lw	a5,0(a2)
        while((int32_t)(limit-(clint_getTimeLow(reg))) >= 0);
f9007904:	40f507b3          	sub	a5,a0,a5
f9007908:	fe07dce3          	bgez	a5,f9007900 <clint_uDelay+0x24>
    }
f900790c:	00008067          	ret

f9007910 <spi_cmdAvailability>:
f9007910:	00452503          	lw	a0,4(a0)
        u32 ssDisable;
    } Spi_Config;
    
    static u32 spi_cmdAvailability(u32 reg){
        return read_u32(reg + SPI_BUFFER) & 0xFFFF;
    }
f9007914:	01051513          	slli	a0,a0,0x10
f9007918:	01055513          	srli	a0,a0,0x10
f900791c:	00008067          	ret

f9007920 <spi_rspOccupancy>:
f9007920:	00452503          	lw	a0,4(a0)
    static u32 spi_rspOccupancy(u32 reg){
        return read_u32(reg + SPI_BUFFER) >> 16;
    }
f9007924:	01055513          	srli	a0,a0,0x10
f9007928:	00008067          	ret

f900792c <spi_write>:
    
    static void spi_write(u32 reg, u8 data){
f900792c:	ff010113          	addi	sp,sp,-16
f9007930:	00112623          	sw	ra,12(sp)
f9007934:	00812423          	sw	s0,8(sp)
f9007938:	00912223          	sw	s1,4(sp)
f900793c:	00050413          	mv	s0,a0
f9007940:	00058493          	mv	s1,a1
        while(spi_cmdAvailability(reg) == 0);
f9007944:	00040513          	mv	a0,s0
f9007948:	fc9ff0ef          	jal	ra,f9007910 <spi_cmdAvailability>
f900794c:	fe050ce3          	beqz	a0,f9007944 <spi_write+0x18>
        write_u32(data | SPI_CMD_WRITE, reg + SPI_DATA);
f9007950:	1004e493          	ori	s1,s1,256
    }
    
    static inline void write_u32(u32 data, u32 address){
        *((volatile u32*) address) = data;
f9007954:	00942023          	sw	s1,0(s0)
    }
f9007958:	00c12083          	lw	ra,12(sp)
f900795c:	00812403          	lw	s0,8(sp)
f9007960:	00412483          	lw	s1,4(sp)
f9007964:	01010113          	addi	sp,sp,16
f9007968:	00008067          	ret

f900796c <spi_read>:
    
    static u8 spi_read(u32 reg){
f900796c:	ff010113          	addi	sp,sp,-16
f9007970:	00112623          	sw	ra,12(sp)
f9007974:	00812423          	sw	s0,8(sp)
f9007978:	00050413          	mv	s0,a0
        while(spi_cmdAvailability(reg) == 0);
f900797c:	00040513          	mv	a0,s0
f9007980:	f91ff0ef          	jal	ra,f9007910 <spi_cmdAvailability>
f9007984:	fe050ce3          	beqz	a0,f900797c <spi_read+0x10>
f9007988:	20000793          	li	a5,512
f900798c:	00f42023          	sw	a5,0(s0)
        write_u32(SPI_CMD_READ, reg + SPI_DATA);
        while(spi_rspOccupancy(reg) == 0);
f9007990:	00040513          	mv	a0,s0
f9007994:	f8dff0ef          	jal	ra,f9007920 <spi_rspOccupancy>
f9007998:	fe050ce3          	beqz	a0,f9007990 <spi_read+0x24>
        return *((volatile u32*) address);
f900799c:	00042503          	lw	a0,0(s0)
        return read_u32(reg + SPI_DATA);
    }
f90079a0:	0ff57513          	andi	a0,a0,255
f90079a4:	00c12083          	lw	ra,12(sp)
f90079a8:	00812403          	lw	s0,8(sp)
f90079ac:	01010113          	addi	sp,sp,16
f90079b0:	00008067          	ret

f90079b4 <spi_select>:
        write_u32(SPI_CMD_READ, reg + SPI_DATA);
        while(spi_rspOccupancy(reg) == 0);
        return read_u32(reg + SPI_READ_LARGE);
    }
    
    static void spi_select(u32 reg, u32 slaveId){
f90079b4:	ff010113          	addi	sp,sp,-16
f90079b8:	00112623          	sw	ra,12(sp)
f90079bc:	00812423          	sw	s0,8(sp)
f90079c0:	00912223          	sw	s1,4(sp)
f90079c4:	00050413          	mv	s0,a0
f90079c8:	00058493          	mv	s1,a1
        while(spi_cmdAvailability(reg) == 0);
f90079cc:	00040513          	mv	a0,s0
f90079d0:	f41ff0ef          	jal	ra,f9007910 <spi_cmdAvailability>
f90079d4:	fe050ce3          	beqz	a0,f90079cc <spi_select+0x18>
        write_u32(slaveId | 0x80 | SPI_CMD_SS, reg + SPI_DATA);
f90079d8:	000017b7          	lui	a5,0x1
f90079dc:	88078793          	addi	a5,a5,-1920 # 880 <__stack_size+0x480>
f90079e0:	00f4e4b3          	or	s1,s1,a5
        *((volatile u32*) address) = data;
f90079e4:	00942023          	sw	s1,0(s0)
    }
f90079e8:	00c12083          	lw	ra,12(sp)
f90079ec:	00812403          	lw	s0,8(sp)
f90079f0:	00412483          	lw	s1,4(sp)
f90079f4:	01010113          	addi	sp,sp,16
f90079f8:	00008067          	ret

f90079fc <spi_diselect>:
    
    static void spi_diselect(u32 reg, u32 slaveId){
f90079fc:	ff010113          	addi	sp,sp,-16
f9007a00:	00112623          	sw	ra,12(sp)
f9007a04:	00812423          	sw	s0,8(sp)
f9007a08:	00912223          	sw	s1,4(sp)
f9007a0c:	00050413          	mv	s0,a0
f9007a10:	00058493          	mv	s1,a1
        while(spi_cmdAvailability(reg) == 0);
f9007a14:	00040513          	mv	a0,s0
f9007a18:	ef9ff0ef          	jal	ra,f9007910 <spi_cmdAvailability>
f9007a1c:	fe050ce3          	beqz	a0,f9007a14 <spi_diselect+0x18>
        write_u32(slaveId | 0x00 | SPI_CMD_SS, reg + SPI_DATA);
f9007a20:	000017b7          	lui	a5,0x1
f9007a24:	80078793          	addi	a5,a5,-2048 # 800 <__stack_size+0x400>
f9007a28:	00f4e4b3          	or	s1,s1,a5
f9007a2c:	00942023          	sw	s1,0(s0)
    }
f9007a30:	00c12083          	lw	ra,12(sp)
f9007a34:	00812403          	lw	s0,8(sp)
f9007a38:	00412483          	lw	s1,4(sp)
f9007a3c:	01010113          	addi	sp,sp,16
f9007a40:	00008067          	ret

f9007a44 <spi_applyConfig>:
    
    static void spi_applyConfig(u32 reg, Spi_Config *config){
        write_u32((config->cpol << 0) | (config->cpha << 1) | (config->mode << 4), reg + SPI_CONFIG);
f9007a44:	0005a783          	lw	a5,0(a1)
f9007a48:	0045a703          	lw	a4,4(a1)
f9007a4c:	00171713          	slli	a4,a4,0x1
f9007a50:	00e7e7b3          	or	a5,a5,a4
f9007a54:	0085a703          	lw	a4,8(a1)
f9007a58:	00471713          	slli	a4,a4,0x4
f9007a5c:	00e7e7b3          	or	a5,a5,a4
f9007a60:	00f52423          	sw	a5,8(a0)
        write_u32(config->clkDivider, reg + SPI_CLK_DIVIDER);
f9007a64:	00c5a783          	lw	a5,12(a1)
f9007a68:	02f52023          	sw	a5,32(a0)
        write_u32(config->ssSetup, reg + SPI_SS_SETUP);
f9007a6c:	0105a783          	lw	a5,16(a1)
f9007a70:	02f52223          	sw	a5,36(a0)
        write_u32(config->ssHold, reg + SPI_SS_HOLD);
f9007a74:	0145a783          	lw	a5,20(a1)
f9007a78:	02f52423          	sw	a5,40(a0)
        write_u32(config->ssDisable, reg + SPI_SS_DISABLE);
f9007a7c:	0185a783          	lw	a5,24(a1)
f9007a80:	02f52623          	sw	a5,44(a0)
    }
f9007a84:	00008067          	ret

f9007a88 <spi_waitXferBusy>:
    /**
    * Wait for SPI Transfer to complete
    * 
    * @param reg SPI base address 
    */
    static void spi_waitXferBusy(u32 reg){
f9007a88:	ff010113          	addi	sp,sp,-16
f9007a8c:	00112623          	sw	ra,12(sp)
f9007a90:	00812423          	sw	s0,8(sp)
f9007a94:	00050413          	mv	s0,a0
    	bsp_uDelay(1);
f9007a98:	f8b00637          	lui	a2,0xf8b00
f9007a9c:	017d85b7          	lui	a1,0x17d8
f9007aa0:	84058593          	addi	a1,a1,-1984 # 17d7840 <__stack_size+0x17d7440>
f9007aa4:	00100513          	li	a0,1
f9007aa8:	e35ff0ef          	jal	ra,f90078dc <clint_uDelay>
    	while(spi_cmdAvailability(reg) != 256);
f9007aac:	00040513          	mv	a0,s0
f9007ab0:	e61ff0ef          	jal	ra,f9007910 <spi_cmdAvailability>
f9007ab4:	10000793          	li	a5,256
f9007ab8:	fef51ae3          	bne	a0,a5,f9007aac <spi_waitXferBusy+0x24>
    }
f9007abc:	00c12083          	lw	ra,12(sp)
f9007ac0:	00812403          	lw	s0,8(sp)
f9007ac4:	01010113          	addi	sp,sp,16
f9007ac8:	00008067          	ret

f9007acc <spiFlash_select>:
    * Set SPI Flash device Chip Select
    * 
    * @param spi SPI port base address 
    * @param cs 32-bit bitwise setting. Set 1 to enable particular bit. 
    */
    static void spiFlash_select(u32 spi, u32 cs){
f9007acc:	ff010113          	addi	sp,sp,-16
f9007ad0:	00112623          	sw	ra,12(sp)
        spi_select(spi, cs);
f9007ad4:	ee1ff0ef          	jal	ra,f90079b4 <spi_select>
    }
f9007ad8:	00c12083          	lw	ra,12(sp)
f9007adc:	01010113          	addi	sp,sp,16
f9007ae0:	00008067          	ret

f9007ae4 <spiFlash_diselect>:
    * Clear SPI Flash device Chip Select
    * 
    * @param spi SPI port base address 
    * @param cs 32-bit bitwise setting. Set 1 to disable particular bit. 
    */ 
    static void spiFlash_diselect(u32 spi, u32 cs){
f9007ae4:	ff010113          	addi	sp,sp,-16
f9007ae8:	00112623          	sw	ra,12(sp)
        spi_diselect(spi, cs);
f9007aec:	f11ff0ef          	jal	ra,f90079fc <spi_diselect>
    }
f9007af0:	00c12083          	lw	ra,12(sp)
f9007af4:	01010113          	addi	sp,sp,16
f9007af8:	00008067          	ret

f9007afc <spiFlash_init_>:
    /**
    * Initialize SPI port with default settings 
    * 
    * @param spi SPI port base address
    */
    static void spiFlash_init_(u32 spi){
f9007afc:	fd010113          	addi	sp,sp,-48
f9007b00:	02112623          	sw	ra,44(sp)
f9007b04:	02812423          	sw	s0,40(sp)
f9007b08:	00050413          	mv	s0,a0
        Spi_Config spiCfg;
        spiCfg.cpol = 0;
f9007b0c:	00012223          	sw	zero,4(sp)
        spiCfg.cpha = 0;
f9007b10:	00012423          	sw	zero,8(sp)
        spiCfg.mode = 0;
f9007b14:	00012623          	sw	zero,12(sp)
        spiCfg.clkDivider = 2;
f9007b18:	00200793          	li	a5,2
f9007b1c:	00f12823          	sw	a5,16(sp)
        spiCfg.ssSetup = 2;
f9007b20:	00f12a23          	sw	a5,20(sp)
        spiCfg.ssHold = 2;
f9007b24:	00f12c23          	sw	a5,24(sp)
        spiCfg.ssDisable = 2;
f9007b28:	00f12e23          	sw	a5,28(sp)
        spi_applyConfig(spi, &spiCfg);
f9007b2c:	00410593          	addi	a1,sp,4
f9007b30:	f15ff0ef          	jal	ra,f9007a44 <spi_applyConfig>
        spi_waitXferBusy(spi); 
f9007b34:	00040513          	mv	a0,s0
f9007b38:	f51ff0ef          	jal	ra,f9007a88 <spi_waitXferBusy>
    }
f9007b3c:	02c12083          	lw	ra,44(sp)
f9007b40:	02812403          	lw	s0,40(sp)
f9007b44:	03010113          	addi	sp,sp,48
f9007b48:	00008067          	ret

f9007b4c <spiFlash_init>:
    * 
    * @param spi SPI port base address
    * @param gpio GPIO port base address 
    * @param cs 32-bit bitwise chip select setting.
    */
    static void spiFlash_init(u32 spi, u32 cs){
f9007b4c:	ff010113          	addi	sp,sp,-16
f9007b50:	00112623          	sw	ra,12(sp)
f9007b54:	00812423          	sw	s0,8(sp)
f9007b58:	00912223          	sw	s1,4(sp)
f9007b5c:	00050413          	mv	s0,a0
f9007b60:	00058493          	mv	s1,a1
        spiFlash_init_(spi);
f9007b64:	f99ff0ef          	jal	ra,f9007afc <spiFlash_init_>
        spiFlash_diselect(spi, cs);
f9007b68:	00048593          	mv	a1,s1
f9007b6c:	00040513          	mv	a0,s0
f9007b70:	f75ff0ef          	jal	ra,f9007ae4 <spiFlash_diselect>
    }
f9007b74:	00c12083          	lw	ra,12(sp)
f9007b78:	00812403          	lw	s0,8(sp)
f9007b7c:	00412483          	lw	s1,4(sp)
f9007b80:	01010113          	addi	sp,sp,16
f9007b84:	00008067          	ret

f9007b88 <spiFlash_wake_>:
    * Define DEFAULT_ADDRESS_BYTE to include command to return
    * to 3-byte addressing mode. 
    * 
    * @param spi SPI port base address
    */
    static void spiFlash_wake_(u32 spi){
f9007b88:	ff010113          	addi	sp,sp,-16
f9007b8c:	00112623          	sw	ra,12(sp)
        spi_write(spi, 0xAB);
f9007b90:	0ab00593          	li	a1,171
f9007b94:	d99ff0ef          	jal	ra,f900792c <spi_write>
#if defined(DEFAULT_ADDRESS_BYTE) || defined(MX25_FLASH)
        //return to 3-byte addressing
        bsp_uDelay(300);
        spi_write(spi, 0xE9);
#endif
    }
f9007b98:	00c12083          	lw	ra,12(sp)
f9007b9c:	01010113          	addi	sp,sp,16
f9007ba0:	00008067          	ret

f9007ba4 <spiFlash_wake>:
    * Wake up the Spi Flash with chip select
    * 
    * @param spi SPI port base address
    * @param cs 32-bit bitwise chip select setting.
    */
    static void spiFlash_wake(u32 spi, u32 cs){
f9007ba4:	ff010113          	addi	sp,sp,-16
f9007ba8:	00112623          	sw	ra,12(sp)
f9007bac:	00812423          	sw	s0,8(sp)
f9007bb0:	00912223          	sw	s1,4(sp)
f9007bb4:	00050413          	mv	s0,a0
f9007bb8:	00058493          	mv	s1,a1
        spiFlash_select(spi,cs);
f9007bbc:	f11ff0ef          	jal	ra,f9007acc <spiFlash_select>
        spiFlash_wake_(spi);
f9007bc0:	00040513          	mv	a0,s0
f9007bc4:	fc5ff0ef          	jal	ra,f9007b88 <spiFlash_wake_>
        spiFlash_diselect(spi,cs);
f9007bc8:	00048593          	mv	a1,s1
f9007bcc:	00040513          	mv	a0,s0
f9007bd0:	f15ff0ef          	jal	ra,f9007ae4 <spiFlash_diselect>
        spi_waitXferBusy(spi);
f9007bd4:	00040513          	mv	a0,s0
f9007bd8:	eb1ff0ef          	jal	ra,f9007a88 <spi_waitXferBusy>
    }
f9007bdc:	00c12083          	lw	ra,12(sp)
f9007be0:	00812403          	lw	s0,8(sp)
f9007be4:	00412483          	lw	s1,4(sp)
f9007be8:	01010113          	addi	sp,sp,16
f9007bec:	00008067          	ret

f9007bf0 <spiFlash_f2m_>:
    * @param spi SPI port base address
    * @param flashAddress The flash address to read the data
    * @param memoryAddress The RAM address to write the data
    * @param size The size of data to copy
    */
    static void spiFlash_f2m_(u32 spi, u32 flashAddress, u32 memoryAddress, u32 size){
f9007bf0:	fe010113          	addi	sp,sp,-32
f9007bf4:	00112e23          	sw	ra,28(sp)
f9007bf8:	00812c23          	sw	s0,24(sp)
f9007bfc:	00912a23          	sw	s1,20(sp)
f9007c00:	01212823          	sw	s2,16(sp)
f9007c04:	01312623          	sw	s3,12(sp)
f9007c08:	00050913          	mv	s2,a0
f9007c0c:	00058493          	mv	s1,a1
f9007c10:	00060413          	mv	s0,a2
f9007c14:	00068993          	mv	s3,a3
        spi_write(spi, 0x0B);
f9007c18:	00b00593          	li	a1,11
f9007c1c:	d11ff0ef          	jal	ra,f900792c <spi_write>
        spi_write(spi, flashAddress >> 16);
f9007c20:	0104d593          	srli	a1,s1,0x10
f9007c24:	0ff5f593          	andi	a1,a1,255
f9007c28:	00090513          	mv	a0,s2
f9007c2c:	d01ff0ef          	jal	ra,f900792c <spi_write>
        spi_write(spi, flashAddress >>  8);
f9007c30:	0084d593          	srli	a1,s1,0x8
f9007c34:	0ff5f593          	andi	a1,a1,255
f9007c38:	00090513          	mv	a0,s2
f9007c3c:	cf1ff0ef          	jal	ra,f900792c <spi_write>
        spi_write(spi, flashAddress >>  0);
f9007c40:	0ff4f593          	andi	a1,s1,255
f9007c44:	00090513          	mv	a0,s2
f9007c48:	ce5ff0ef          	jal	ra,f900792c <spi_write>
        spi_write(spi, 0);
f9007c4c:	00000593          	li	a1,0
f9007c50:	00090513          	mv	a0,s2
f9007c54:	cd9ff0ef          	jal	ra,f900792c <spi_write>
        uint8_t *ram = (uint8_t *) memoryAddress;
        for(u32 idx = 0;idx < size;idx++){
f9007c58:	00000493          	li	s1,0
f9007c5c:	0134fe63          	bgeu	s1,s3,f9007c78 <spiFlash_f2m_+0x88>
            u8 value = spi_read(spi);
f9007c60:	00090513          	mv	a0,s2
f9007c64:	d09ff0ef          	jal	ra,f900796c <spi_read>
            *ram++ = value;
f9007c68:	00a40023          	sb	a0,0(s0)
        for(u32 idx = 0;idx < size;idx++){
f9007c6c:	00148493          	addi	s1,s1,1
            *ram++ = value;
f9007c70:	00140413          	addi	s0,s0,1
f9007c74:	fe9ff06f          	j	f9007c5c <spiFlash_f2m_+0x6c>
        }
    }
f9007c78:	01c12083          	lw	ra,28(sp)
f9007c7c:	01812403          	lw	s0,24(sp)
f9007c80:	01412483          	lw	s1,20(sp)
f9007c84:	01012903          	lw	s2,16(sp)
f9007c88:	00c12983          	lw	s3,12(sp)
f9007c8c:	02010113          	addi	sp,sp,32
f9007c90:	00008067          	ret

f9007c94 <spiFlash_f2m>:
    * @param cs 32-bit bitwise chip select setting
    * @param flashAddress The flash address to read the data
    * @param memoryAddress The RAM address to write the data
    * @param size The size of data to copy
    */ 
    static void spiFlash_f2m(u32 spi, u32 cs, u32 flashAddress, u32 memoryAddress, u32 size){
f9007c94:	fe010113          	addi	sp,sp,-32
f9007c98:	00112e23          	sw	ra,28(sp)
f9007c9c:	00812c23          	sw	s0,24(sp)
f9007ca0:	00912a23          	sw	s1,20(sp)
f9007ca4:	01212823          	sw	s2,16(sp)
f9007ca8:	01312623          	sw	s3,12(sp)
f9007cac:	01412423          	sw	s4,8(sp)
f9007cb0:	00050413          	mv	s0,a0
f9007cb4:	00058493          	mv	s1,a1
f9007cb8:	00060913          	mv	s2,a2
f9007cbc:	00068993          	mv	s3,a3
f9007cc0:	00070a13          	mv	s4,a4
        spiFlash_select(spi,cs);
f9007cc4:	e09ff0ef          	jal	ra,f9007acc <spiFlash_select>
        spiFlash_f2m_(spi, flashAddress, memoryAddress, size);
f9007cc8:	000a0693          	mv	a3,s4
f9007ccc:	00098613          	mv	a2,s3
f9007cd0:	00090593          	mv	a1,s2
f9007cd4:	00040513          	mv	a0,s0
f9007cd8:	f19ff0ef          	jal	ra,f9007bf0 <spiFlash_f2m_>
        spiFlash_diselect(spi,cs);
f9007cdc:	00048593          	mv	a1,s1
f9007ce0:	00040513          	mv	a0,s0
f9007ce4:	e01ff0ef          	jal	ra,f9007ae4 <spiFlash_diselect>
    }
f9007ce8:	01c12083          	lw	ra,28(sp)
f9007cec:	01812403          	lw	s0,24(sp)
f9007cf0:	01412483          	lw	s1,20(sp)
f9007cf4:	01012903          	lw	s2,16(sp)
f9007cf8:	00c12983          	lw	s3,12(sp)
f9007cfc:	00812a03          	lw	s4,8(sp)
f9007d00:	02010113          	addi	sp,sp,32
f9007d04:	00008067          	ret

f9007d08 <bspMain>:
#define USER_SOFTWARE_SIZE_INST   0x7800
#define USER_SOFTWARE_MEMORY_DATA 0xF9080000
#define USER_SOFTWARE_FLASH_DATA  0x00100000 + ( USER_SOFTWARE_MEMORY_DATA - USER_SOFTWARE_MEMORY_INST )
#define USER_SOFTWARE_SIZE_DATA   0x7800

void bspMain() {
f9007d08:	ff010113          	addi	sp,sp,-16
f9007d0c:	00112623          	sw	ra,12(sp)
f9007d10:	00812423          	sw	s0,8(sp)
#ifndef SIM
	spiFlash_init(SPI, SPI_CS);
f9007d14:	00000593          	li	a1,0
f9007d18:	f8014537          	lui	a0,0xf8014
f9007d1c:	e31ff0ef          	jal	ra,f9007b4c <spiFlash_init>
	spiFlash_wake(SPI, SPI_CS);
f9007d20:	00000593          	li	a1,0
f9007d24:	f8014537          	lui	a0,0xf8014
f9007d28:	e7dff0ef          	jal	ra,f9007ba4 <spiFlash_wake>
	spiFlash_f2m(SPI, SPI_CS, USER_SOFTWARE_FLASH_INST, USER_SOFTWARE_MEMORY_INST, USER_SOFTWARE_SIZE_INST);
f9007d2c:	00008437          	lui	s0,0x8
f9007d30:	80040713          	addi	a4,s0,-2048 # 7800 <__stack_size+0x7400>
f9007d34:	f90006b7          	lui	a3,0xf9000
f9007d38:	00100637          	lui	a2,0x100
f9007d3c:	00000593          	li	a1,0
f9007d40:	f8014537          	lui	a0,0xf8014
f9007d44:	f51ff0ef          	jal	ra,f9007c94 <spiFlash_f2m>
	spiFlash_f2m(SPI, SPI_CS, USER_SOFTWARE_FLASH_DATA, USER_SOFTWARE_MEMORY_DATA, USER_SOFTWARE_SIZE_DATA);
f9007d48:	80040713          	addi	a4,s0,-2048
f9007d4c:	f90806b7          	lui	a3,0xf9080
f9007d50:	00180637          	lui	a2,0x180
f9007d54:	00000593          	li	a1,0
f9007d58:	f8014537          	lui	a0,0xf8014
f9007d5c:	f39ff0ef          	jal	ra,f9007c94 <spiFlash_f2m>
#endif

	asm("fence.i; nop; nop; nop; nop; nop; nop"); 
f9007d60:	0000100f          	fence.i
f9007d64:	00000013          	nop
f9007d68:	00000013          	nop
f9007d6c:	00000013          	nop
f9007d70:	00000013          	nop
f9007d74:	00000013          	nop
f9007d78:	00000013          	nop
	void (*userMain)() = (void (*)())USER_SOFTWARE_MEMORY_INST;
#ifdef SMP
    smp_unlock(userMain);
#endif
	userMain();
f9007d7c:	f90007b7          	lui	a5,0xf9000
f9007d80:	000780e7          	jalr	a5 # f9000000 <__global_pointer$+0xfff78010>
}
f9007d84:	00c12083          	lw	ra,12(sp)
f9007d88:	00812403          	lw	s0,8(sp)
f9007d8c:	01010113          	addi	sp,sp,16
f9007d90:	00008067          	ret

f9007d94 <main>:
///////////////////////////////////////////////////////////////////////////////////
#include "type.h"
#include "bsp.h"
#include "bootloaderConfig.h"

void main() {
f9007d94:	ff010113          	addi	sp,sp,-16
f9007d98:	00112623          	sw	ra,12(sp)
    bsp_init();
    bspMain();
f9007d9c:	f6dff0ef          	jal	ra,f9007d08 <bspMain>
}
f9007da0:	00c12083          	lw	ra,12(sp)
f9007da4:	01010113          	addi	sp,sp,16
f9007da8:	00008067          	ret
