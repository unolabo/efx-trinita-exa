
build/bootloader.elf:     file format elf32-littleriscv


Disassembly of section .text:

f9007840 <clint_uDelay>:
    
        return (((u64)hi) << 32) | lo;
    }
    
    static void clint_uDelay(u32 usec, u32 hz, u32 reg){
        u32 mTimePerUsec = hz/1000000;
f9007840:	000f47b7          	lui	a5,0xf4
f9007844:	24078793          	addi	a5,a5,576 # f4240 <_start-0xf8f135c0>
f9007848:	02f5d5b3          	divu	a1,a1,a5
    readReg_u32 (clint_getTimeLow , CLINT_TIME_ADDR)
f900784c:	0000c7b7          	lui	a5,0xc
f9007850:	ff878793          	addi	a5,a5,-8 # bff8 <_start-0xf8ffb808>
f9007854:	00f60633          	add	a2,a2,a5
#include "type.h"
#include "soc.h"


    static inline u32 read_u32(u32 address){
        return *((volatile u32*) address);
f9007858:	00062783          	lw	a5,0(a2)
        u32 limit = clint_getTimeLow(reg) + usec*mTimePerUsec;
f900785c:	02a58533          	mul	a0,a1,a0
f9007860:	00f50533          	add	a0,a0,a5
f9007864:	00062783          	lw	a5,0(a2)
        while((int32_t)(limit-(clint_getTimeLow(reg))) >= 0);
f9007868:	40f507b3          	sub	a5,a0,a5
f900786c:	fe07dce3          	bgez	a5,f9007864 <clint_uDelay+0x24>
    }
f9007870:	00008067          	ret

f9007874 <spi_cmdAvailability>:
f9007874:	00452503          	lw	a0,4(a0)
        u32 ssDisable;
    } Spi_Config;
    
    static u32 spi_cmdAvailability(u32 reg){
        return read_u32(reg + SPI_BUFFER) & 0xFFFF;
    }
f9007878:	01051513          	slli	a0,a0,0x10
f900787c:	01055513          	srli	a0,a0,0x10
f9007880:	00008067          	ret

f9007884 <spi_rspOccupancy>:
f9007884:	00452503          	lw	a0,4(a0)
    static u32 spi_rspOccupancy(u32 reg){
        return read_u32(reg + SPI_BUFFER) >> 16;
    }
f9007888:	01055513          	srli	a0,a0,0x10
f900788c:	00008067          	ret

f9007890 <spi_write>:
    
    static void spi_write(u32 reg, u8 data){
f9007890:	ff010113          	addi	sp,sp,-16
f9007894:	00112623          	sw	ra,12(sp)
f9007898:	00812423          	sw	s0,8(sp)
f900789c:	00912223          	sw	s1,4(sp)
f90078a0:	00050413          	mv	s0,a0
f90078a4:	00058493          	mv	s1,a1
        while(spi_cmdAvailability(reg) == 0);
f90078a8:	00040513          	mv	a0,s0
f90078ac:	fc9ff0ef          	jal	ra,f9007874 <spi_cmdAvailability>
f90078b0:	fe050ce3          	beqz	a0,f90078a8 <spi_write+0x18>
        write_u32(data | SPI_CMD_WRITE, reg + SPI_DATA);
f90078b4:	1004e493          	ori	s1,s1,256
    }
    
    static inline void write_u32(u32 data, u32 address){
        *((volatile u32*) address) = data;
f90078b8:	00942023          	sw	s1,0(s0)
    }
f90078bc:	00c12083          	lw	ra,12(sp)
f90078c0:	00812403          	lw	s0,8(sp)
f90078c4:	00412483          	lw	s1,4(sp)
f90078c8:	01010113          	addi	sp,sp,16
f90078cc:	00008067          	ret

f90078d0 <spi_read>:
    
    static u8 spi_read(u32 reg){
f90078d0:	ff010113          	addi	sp,sp,-16
f90078d4:	00112623          	sw	ra,12(sp)
f90078d8:	00812423          	sw	s0,8(sp)
f90078dc:	00050413          	mv	s0,a0
        while(spi_cmdAvailability(reg) == 0);
f90078e0:	00040513          	mv	a0,s0
f90078e4:	f91ff0ef          	jal	ra,f9007874 <spi_cmdAvailability>
f90078e8:	fe050ce3          	beqz	a0,f90078e0 <spi_read+0x10>
f90078ec:	20000793          	li	a5,512
f90078f0:	00f42023          	sw	a5,0(s0)
        write_u32(SPI_CMD_READ, reg + SPI_DATA);
        while(spi_rspOccupancy(reg) == 0);
f90078f4:	00040513          	mv	a0,s0
f90078f8:	f8dff0ef          	jal	ra,f9007884 <spi_rspOccupancy>
f90078fc:	fe050ce3          	beqz	a0,f90078f4 <spi_read+0x24>
        return *((volatile u32*) address);
f9007900:	00042503          	lw	a0,0(s0)
        return read_u32(reg + SPI_DATA);
    }
f9007904:	0ff57513          	andi	a0,a0,255
f9007908:	00c12083          	lw	ra,12(sp)
f900790c:	00812403          	lw	s0,8(sp)
f9007910:	01010113          	addi	sp,sp,16
f9007914:	00008067          	ret

f9007918 <spi_select>:
        write_u32(SPI_CMD_READ, reg + SPI_DATA);
        while(spi_rspOccupancy(reg) == 0);
        return read_u32(reg + SPI_READ_LARGE);
    }
    
    static void spi_select(u32 reg, u32 slaveId){
f9007918:	ff010113          	addi	sp,sp,-16
f900791c:	00112623          	sw	ra,12(sp)
f9007920:	00812423          	sw	s0,8(sp)
f9007924:	00912223          	sw	s1,4(sp)
f9007928:	00050413          	mv	s0,a0
f900792c:	00058493          	mv	s1,a1
        while(spi_cmdAvailability(reg) == 0);
f9007930:	00040513          	mv	a0,s0
f9007934:	f41ff0ef          	jal	ra,f9007874 <spi_cmdAvailability>
f9007938:	fe050ce3          	beqz	a0,f9007930 <spi_select+0x18>
        write_u32(slaveId | 0x80 | SPI_CMD_SS, reg + SPI_DATA);
f900793c:	000017b7          	lui	a5,0x1
f9007940:	88078793          	addi	a5,a5,-1920 # 880 <_start-0xf9006f80>
f9007944:	00f4e4b3          	or	s1,s1,a5
        *((volatile u32*) address) = data;
f9007948:	00942023          	sw	s1,0(s0)
    }
f900794c:	00c12083          	lw	ra,12(sp)
f9007950:	00812403          	lw	s0,8(sp)
f9007954:	00412483          	lw	s1,4(sp)
f9007958:	01010113          	addi	sp,sp,16
f900795c:	00008067          	ret

f9007960 <spi_diselect>:
    
    static void spi_diselect(u32 reg, u32 slaveId){
f9007960:	ff010113          	addi	sp,sp,-16
f9007964:	00112623          	sw	ra,12(sp)
f9007968:	00812423          	sw	s0,8(sp)
f900796c:	00912223          	sw	s1,4(sp)
f9007970:	00050413          	mv	s0,a0
f9007974:	00058493          	mv	s1,a1
        while(spi_cmdAvailability(reg) == 0);
f9007978:	00040513          	mv	a0,s0
f900797c:	ef9ff0ef          	jal	ra,f9007874 <spi_cmdAvailability>
f9007980:	fe050ce3          	beqz	a0,f9007978 <spi_diselect+0x18>
        write_u32(slaveId | 0x00 | SPI_CMD_SS, reg + SPI_DATA);
f9007984:	000017b7          	lui	a5,0x1
f9007988:	80078793          	addi	a5,a5,-2048 # 800 <_start-0xf9007000>
f900798c:	00f4e4b3          	or	s1,s1,a5
f9007990:	00942023          	sw	s1,0(s0)
    }
f9007994:	00c12083          	lw	ra,12(sp)
f9007998:	00812403          	lw	s0,8(sp)
f900799c:	00412483          	lw	s1,4(sp)
f90079a0:	01010113          	addi	sp,sp,16
f90079a4:	00008067          	ret

f90079a8 <spi_applyConfig>:
    
    static void spi_applyConfig(u32 reg, Spi_Config *config){
        write_u32((config->cpol << 0) | (config->cpha << 1) | (config->mode << 4), reg + SPI_CONFIG);
f90079a8:	0005a783          	lw	a5,0(a1)
f90079ac:	0045a703          	lw	a4,4(a1)
f90079b0:	00171713          	slli	a4,a4,0x1
f90079b4:	00e7e7b3          	or	a5,a5,a4
f90079b8:	0085a703          	lw	a4,8(a1)
f90079bc:	00471713          	slli	a4,a4,0x4
f90079c0:	00e7e7b3          	or	a5,a5,a4
f90079c4:	00f52423          	sw	a5,8(a0)
        write_u32(config->clkDivider, reg + SPI_CLK_DIVIDER);
f90079c8:	00c5a783          	lw	a5,12(a1)
f90079cc:	02f52023          	sw	a5,32(a0)
        write_u32(config->ssSetup, reg + SPI_SS_SETUP);
f90079d0:	0105a783          	lw	a5,16(a1)
f90079d4:	02f52223          	sw	a5,36(a0)
        write_u32(config->ssHold, reg + SPI_SS_HOLD);
f90079d8:	0145a783          	lw	a5,20(a1)
f90079dc:	02f52423          	sw	a5,40(a0)
        write_u32(config->ssDisable, reg + SPI_SS_DISABLE);
f90079e0:	0185a783          	lw	a5,24(a1)
f90079e4:	02f52623          	sw	a5,44(a0)
    }
f90079e8:	00008067          	ret

f90079ec <spiFlash_select>:
    static void spiFlash_diselect_withGpioCs(u32 gpio, u32 cs){
        gpio_setOutput(gpio, gpio_getOutput(gpio) | (1 << cs));
        bsp_uDelay(1);
    }
    
    static void spiFlash_select(u32 spi, u32 cs){
f90079ec:	ff010113          	addi	sp,sp,-16
f90079f0:	00112623          	sw	ra,12(sp)
        spi_select(spi, cs);
f90079f4:	f25ff0ef          	jal	ra,f9007918 <spi_select>
    }
f90079f8:	00c12083          	lw	ra,12(sp)
f90079fc:	01010113          	addi	sp,sp,16
f9007a00:	00008067          	ret

f9007a04 <spiFlash_diselect>:
    
    static void spiFlash_diselect(u32 spi, u32 cs){
f9007a04:	ff010113          	addi	sp,sp,-16
f9007a08:	00112623          	sw	ra,12(sp)
        spi_diselect(spi, cs);
f9007a0c:	f55ff0ef          	jal	ra,f9007960 <spi_diselect>
    }
f9007a10:	00c12083          	lw	ra,12(sp)
f9007a14:	01010113          	addi	sp,sp,16
f9007a18:	00008067          	ret

f9007a1c <spiFlash_init_>:
    
    static void spiFlash_init_(u32 spi){
f9007a1c:	fd010113          	addi	sp,sp,-48
f9007a20:	02112623          	sw	ra,44(sp)
        Spi_Config spiCfg;
        spiCfg.cpol = 0;
f9007a24:	00012223          	sw	zero,4(sp)
        spiCfg.cpha = 0;
f9007a28:	00012423          	sw	zero,8(sp)
        spiCfg.mode = 0;
f9007a2c:	00012623          	sw	zero,12(sp)
        spiCfg.clkDivider = 2;
f9007a30:	00200793          	li	a5,2
f9007a34:	00f12823          	sw	a5,16(sp)
        spiCfg.ssSetup = 2;
f9007a38:	00f12a23          	sw	a5,20(sp)
        spiCfg.ssHold = 2;
f9007a3c:	00f12c23          	sw	a5,24(sp)
        spiCfg.ssDisable = 2;
f9007a40:	00f12e23          	sw	a5,28(sp)
        spi_applyConfig(spi, &spiCfg);
f9007a44:	00410593          	addi	a1,sp,4
f9007a48:	f61ff0ef          	jal	ra,f90079a8 <spi_applyConfig>
    }
f9007a4c:	02c12083          	lw	ra,44(sp)
f9007a50:	03010113          	addi	sp,sp,48
f9007a54:	00008067          	ret

f9007a58 <spiFlash_init>:
        spiFlash_init_(spi);
        gpio_setOutputEnable(gpio, gpio_getOutputEnable(gpio) | (1 << cs));
        spiFlash_diselect_withGpioCs(gpio,cs);
    }
    
    static void spiFlash_init(u32 spi, u32 cs){
f9007a58:	ff010113          	addi	sp,sp,-16
f9007a5c:	00112623          	sw	ra,12(sp)
f9007a60:	00812423          	sw	s0,8(sp)
f9007a64:	00912223          	sw	s1,4(sp)
f9007a68:	00050413          	mv	s0,a0
f9007a6c:	00058493          	mv	s1,a1
        spiFlash_init_(spi);
f9007a70:	fadff0ef          	jal	ra,f9007a1c <spiFlash_init_>
        spiFlash_diselect(spi, cs);
f9007a74:	00048593          	mv	a1,s1
f9007a78:	00040513          	mv	a0,s0
f9007a7c:	f89ff0ef          	jal	ra,f9007a04 <spiFlash_diselect>
    }
f9007a80:	00c12083          	lw	ra,12(sp)
f9007a84:	00812403          	lw	s0,8(sp)
f9007a88:	00412483          	lw	s1,4(sp)
f9007a8c:	01010113          	addi	sp,sp,16
f9007a90:	00008067          	ret

f9007a94 <spiFlash_wake_>:
    
    static void spiFlash_wake_(u32 spi){
f9007a94:	ff010113          	addi	sp,sp,-16
f9007a98:	00112623          	sw	ra,12(sp)
        spi_write(spi, 0xAB);
f9007a9c:	0ab00593          	li	a1,171
f9007aa0:	df1ff0ef          	jal	ra,f9007890 <spi_write>
#ifdef DEFAULT_ADDRESS_BYTE
        //return to 3-byte addressing
        bsp_uDelay(300);
        spi_write(spi, 0xE9);
#endif
    }
f9007aa4:	00c12083          	lw	ra,12(sp)
f9007aa8:	01010113          	addi	sp,sp,16
f9007aac:	00008067          	ret

f9007ab0 <spiFlash_wake>:
        spiFlash_wake_(spi);
        spiFlash_diselect_withGpioCs(gpio,cs);
        bsp_uDelay(200);
    }
    
    static void spiFlash_wake(u32 spi, u32 cs){
f9007ab0:	ff010113          	addi	sp,sp,-16
f9007ab4:	00112623          	sw	ra,12(sp)
f9007ab8:	00812423          	sw	s0,8(sp)
f9007abc:	00912223          	sw	s1,4(sp)
f9007ac0:	00050413          	mv	s0,a0
f9007ac4:	00058493          	mv	s1,a1
        spiFlash_select(spi,cs);
f9007ac8:	f25ff0ef          	jal	ra,f90079ec <spiFlash_select>
        spiFlash_wake_(spi);
f9007acc:	00040513          	mv	a0,s0
f9007ad0:	fc5ff0ef          	jal	ra,f9007a94 <spiFlash_wake_>
        spiFlash_diselect(spi,cs);
f9007ad4:	00048593          	mv	a1,s1
f9007ad8:	00040513          	mv	a0,s0
f9007adc:	f29ff0ef          	jal	ra,f9007a04 <spiFlash_diselect>
        bsp_uDelay(200);
f9007ae0:	f8b00637          	lui	a2,0xf8b00
f9007ae4:	047875b7          	lui	a1,0x4787
f9007ae8:	8c058593          	addi	a1,a1,-1856 # 47868c0 <_start-0xf4880f40>
f9007aec:	0c800513          	li	a0,200
f9007af0:	d51ff0ef          	jal	ra,f9007840 <clint_uDelay>
    }
f9007af4:	00c12083          	lw	ra,12(sp)
f9007af8:	00812403          	lw	s0,8(sp)
f9007afc:	00412483          	lw	s1,4(sp)
f9007b00:	01010113          	addi	sp,sp,16
f9007b04:	00008067          	ret

f9007b08 <spiFlash_f2m_>:
        id = spiFlash_read_id_(spi);
        spiFlash_diselect(spi,cs);
        return id;
    }
    
    static void spiFlash_f2m_(u32 spi, u32 flashAddress, u32 memoryAddress, u32 size){
f9007b08:	fe010113          	addi	sp,sp,-32
f9007b0c:	00112e23          	sw	ra,28(sp)
f9007b10:	00812c23          	sw	s0,24(sp)
f9007b14:	00912a23          	sw	s1,20(sp)
f9007b18:	01212823          	sw	s2,16(sp)
f9007b1c:	01312623          	sw	s3,12(sp)
f9007b20:	00050913          	mv	s2,a0
f9007b24:	00058493          	mv	s1,a1
f9007b28:	00060413          	mv	s0,a2
f9007b2c:	00068993          	mv	s3,a3
        spi_write(spi, 0x0B);
f9007b30:	00b00593          	li	a1,11
f9007b34:	d5dff0ef          	jal	ra,f9007890 <spi_write>
        spi_write(spi, flashAddress >> 16);
f9007b38:	0104d593          	srli	a1,s1,0x10
f9007b3c:	0ff5f593          	andi	a1,a1,255
f9007b40:	00090513          	mv	a0,s2
f9007b44:	d4dff0ef          	jal	ra,f9007890 <spi_write>
        spi_write(spi, flashAddress >>  8);
f9007b48:	0084d593          	srli	a1,s1,0x8
f9007b4c:	0ff5f593          	andi	a1,a1,255
f9007b50:	00090513          	mv	a0,s2
f9007b54:	d3dff0ef          	jal	ra,f9007890 <spi_write>
        spi_write(spi, flashAddress >>  0);
f9007b58:	0ff4f593          	andi	a1,s1,255
f9007b5c:	00090513          	mv	a0,s2
f9007b60:	d31ff0ef          	jal	ra,f9007890 <spi_write>
        spi_write(spi, 0);
f9007b64:	00000593          	li	a1,0
f9007b68:	00090513          	mv	a0,s2
f9007b6c:	d25ff0ef          	jal	ra,f9007890 <spi_write>
        uint8_t *ram = (uint8_t *) memoryAddress;
        for(u32 idx = 0;idx < size;idx++){
f9007b70:	00000493          	li	s1,0
f9007b74:	0134fe63          	bgeu	s1,s3,f9007b90 <spiFlash_f2m_+0x88>
            u8 value = spi_read(spi);
f9007b78:	00090513          	mv	a0,s2
f9007b7c:	d55ff0ef          	jal	ra,f90078d0 <spi_read>
            *ram++ = value;
f9007b80:	00a40023          	sb	a0,0(s0)
        for(u32 idx = 0;idx < size;idx++){
f9007b84:	00148493          	addi	s1,s1,1
            *ram++ = value;
f9007b88:	00140413          	addi	s0,s0,1
f9007b8c:	fe9ff06f          	j	f9007b74 <spiFlash_f2m_+0x6c>
        }
    }
f9007b90:	01c12083          	lw	ra,28(sp)
f9007b94:	01812403          	lw	s0,24(sp)
f9007b98:	01412483          	lw	s1,20(sp)
f9007b9c:	01012903          	lw	s2,16(sp)
f9007ba0:	00c12983          	lw	s3,12(sp)
f9007ba4:	02010113          	addi	sp,sp,32
f9007ba8:	00008067          	ret

f9007bac <spiFlash_f2m>:
        spiFlash_select_withGpioCs(gpio,cs);
        spiFlash_f2m_(spi, flashAddress, memoryAddress, size);
        spiFlash_diselect_withGpioCs(gpio,cs);
    }
    
    static void spiFlash_f2m(u32 spi, u32 cs, u32 flashAddress, u32 memoryAddress, u32 size){
f9007bac:	fe010113          	addi	sp,sp,-32
f9007bb0:	00112e23          	sw	ra,28(sp)
f9007bb4:	00812c23          	sw	s0,24(sp)
f9007bb8:	00912a23          	sw	s1,20(sp)
f9007bbc:	01212823          	sw	s2,16(sp)
f9007bc0:	01312623          	sw	s3,12(sp)
f9007bc4:	01412423          	sw	s4,8(sp)
f9007bc8:	00050413          	mv	s0,a0
f9007bcc:	00058493          	mv	s1,a1
f9007bd0:	00060913          	mv	s2,a2
f9007bd4:	00068993          	mv	s3,a3
f9007bd8:	00070a13          	mv	s4,a4
        spiFlash_select(spi,cs);
f9007bdc:	e11ff0ef          	jal	ra,f90079ec <spiFlash_select>
        spiFlash_f2m_(spi, flashAddress, memoryAddress, size);
f9007be0:	000a0693          	mv	a3,s4
f9007be4:	00098613          	mv	a2,s3
f9007be8:	00090593          	mv	a1,s2
f9007bec:	00040513          	mv	a0,s0
f9007bf0:	f19ff0ef          	jal	ra,f9007b08 <spiFlash_f2m_>
        spiFlash_diselect(spi,cs);
f9007bf4:	00048593          	mv	a1,s1
f9007bf8:	00040513          	mv	a0,s0
f9007bfc:	e09ff0ef          	jal	ra,f9007a04 <spiFlash_diselect>
    }
f9007c00:	01c12083          	lw	ra,28(sp)
f9007c04:	01812403          	lw	s0,24(sp)
f9007c08:	01412483          	lw	s1,20(sp)
f9007c0c:	01012903          	lw	s2,16(sp)
f9007c10:	00c12983          	lw	s3,12(sp)
f9007c14:	00812a03          	lw	s4,8(sp)
f9007c18:	02010113          	addi	sp,sp,32
f9007c1c:	00008067          	ret

f9007c20 <bspMain>:
#define USER_SOFTWARE_SIZE_INST   0x7000
#define USER_SOFTWARE_MEMORY_DATA 0xF9080000
#define USER_SOFTWARE_FLASH_DATA  0x00100000 + ( USER_SOFTWARE_MEMORY_DATA - USER_SOFTWARE_MEMORY_INST )
#define USER_SOFTWARE_SIZE_DATA   0x7800

void bspMain() {
f9007c20:	ff010113          	addi	sp,sp,-16
f9007c24:	00112623          	sw	ra,12(sp)
#ifndef SIM
	spiFlash_init(SPI, SPI_CS);
f9007c28:	00000593          	li	a1,0
f9007c2c:	f8014537          	lui	a0,0xf8014
f9007c30:	e29ff0ef          	jal	ra,f9007a58 <spiFlash_init>
	spiFlash_wake(SPI, SPI_CS);
f9007c34:	00000593          	li	a1,0
f9007c38:	f8014537          	lui	a0,0xf8014
f9007c3c:	e75ff0ef          	jal	ra,f9007ab0 <spiFlash_wake>
	spiFlash_f2m(SPI, SPI_CS, USER_SOFTWARE_FLASH_INST, USER_SOFTWARE_MEMORY_INST, USER_SOFTWARE_SIZE_INST);
f9007c40:	00007737          	lui	a4,0x7
f9007c44:	f90006b7          	lui	a3,0xf9000
f9007c48:	00100637          	lui	a2,0x100
f9007c4c:	00000593          	li	a1,0
f9007c50:	f8014537          	lui	a0,0xf8014
f9007c54:	f59ff0ef          	jal	ra,f9007bac <spiFlash_f2m>
	spiFlash_f2m(SPI, SPI_CS, USER_SOFTWARE_FLASH_DATA, USER_SOFTWARE_MEMORY_DATA, USER_SOFTWARE_SIZE_DATA);
f9007c58:	00008737          	lui	a4,0x8
f9007c5c:	80070713          	addi	a4,a4,-2048 # 7800 <_start-0xf9000000>
f9007c60:	f90806b7          	lui	a3,0xf9080
f9007c64:	00180637          	lui	a2,0x180
f9007c68:	00000593          	li	a1,0
f9007c6c:	f8014537          	lui	a0,0xf8014
f9007c70:	f3dff0ef          	jal	ra,f9007bac <spiFlash_f2m>
#endif

	asm("fence.i; nop; nop; nop; nop; nop; nop"); 
f9007c74:	0000100f          	fence.i
f9007c78:	00000013          	nop
f9007c7c:	00000013          	nop
f9007c80:	00000013          	nop
f9007c84:	00000013          	nop
f9007c88:	00000013          	nop
f9007c8c:	00000013          	nop
	void (*userMain)() = (void (*)())USER_SOFTWARE_MEMORY_INST;
#ifdef SMP
    smp_unlock(userMain);
#endif
	userMain();
f9007c90:	f90007b7          	lui	a5,0xf9000
f9007c94:	000780e7          	jalr	a5 # f9000000 <_bss_end+0xfff78800>
}
f9007c98:	00c12083          	lw	ra,12(sp)
f9007c9c:	01010113          	addi	sp,sp,16
f9007ca0:	00008067          	ret

f9007ca4 <main>:
///////////////////////////////////////////////////////////////////////////////////
#include "type.h"
#include "bsp.h"
#include "bootloaderConfig.h"

void main() {
f9007ca4:	ff010113          	addi	sp,sp,-16
f9007ca8:	00112623          	sw	ra,12(sp)
    bsp_init();
    bspMain();
f9007cac:	f75ff0ef          	jal	ra,f9007c20 <bspMain>
}
f9007cb0:	00c12083          	lw	ra,12(sp)
f9007cb4:	01010113          	addi	sp,sp,16
f9007cb8:	00008067          	ret

Disassembly of section .text.init:

f9007800 <_start>:
    .section .text.init
    .align 6
    .globl _start
    .globl _bss_end
_start:
    j reset_vector
f9007800:	0040006f          	j	f9007804 <other_exception>

f9007804 <other_exception>:
other_exception:
#    <<<他のハンドラの内容>>>
reset_vector:
#    <<<初期化内容>>>
#    li sp, 4096     # スタックポインタのアドレス
    la sp, STACK_TOP # スタックポインタのアドレス
f9007804:	00080117          	auipc	sp,0x80
f9007808:	3fc10113          	addi	sp,sp,1020 # f9087c00 <_bss_end+0x400>

    auipc t0,0x0    # PCをレジスタに退避
f900780c:	00000297          	auipc	t0,0x0
    addi  t0,t0,16  # mretのアドレス
f9007810:	01028293          	addi	t0,t0,16 # f900781c <other_exception+0x18>
    csrw  mepc,t0   # MEPCにアドレスをセット
f9007814:	34129073          	csrw	mepc,t0

    li    t0,0x4    # 0x4をセット
f9007818:	00400293          	li	t0,4
    csrw  mtvec,t0  # MTVECにアドレスをセット
f900781c:	30529073          	csrw	mtvec,t0

    li    t0,0x800  # 割り込みセット
f9007820:	000012b7          	lui	t0,0x1
f9007824:	80028293          	addi	t0,t0,-2048 # 800 <_start-0xf9007000>
    csrw  mie,t0    # mieに割り込みイネーブルをセット
f9007828:	30429073          	csrw	mie,t0

    li    t0,0x8    # 割り込みセット
f900782c:	00800293          	li	t0,8
    csrw  mstatus,t0 # mieに割り込みイネーブルをセット
f9007830:	30029073          	csrw	mstatus,t0

    call  main      # mainへジャンプ
f9007834:	470000ef          	jal	ra,f9007ca4 <main>

    mret            # MEPCへ飛んでいく
f9007838:	30200073          	mret
f900783c:	0000                	unimp
	...
