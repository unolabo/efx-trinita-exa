
build/gpioDemo.elf:     file format elf32-littleriscv


Disassembly of section .text:

f9000040 <uart_writeAvailability>:
#include "type.h"
#include "soc.h"


    static inline u32 read_u32(u32 address){
        return *((volatile u32*) address);
f9000040:	00452503          	lw	a0,4(a0)
        enum UartStop stop;
        u32 clockDivider;
    } Uart_Config;
    
    static u32 uart_writeAvailability(u32 reg){
        return (read_u32(reg + UART_STATUS) >> 16) & 0xFF;
f9000044:	01055513          	srli	a0,a0,0x10
    }
f9000048:	0ff57513          	andi	a0,a0,255
f900004c:	00008067          	ret

f9000050 <uart_write>:
    static u32 uart_readOccupancy(u32 reg){
        return read_u32(reg + UART_STATUS) >> 24;
    }
    
    static void uart_write(u32 reg, char data){
f9000050:	ff010113          	addi	sp,sp,-16
f9000054:	00112623          	sw	ra,12(sp)
f9000058:	00812423          	sw	s0,8(sp)
f900005c:	00912223          	sw	s1,4(sp)
f9000060:	00050413          	mv	s0,a0
f9000064:	00058493          	mv	s1,a1
        while(uart_writeAvailability(reg) == 0);
f9000068:	00040513          	mv	a0,s0
f900006c:	fd5ff0ef          	jal	ra,f9000040 <uart_writeAvailability>
f9000070:	fe050ce3          	beqz	a0,f9000068 <uart_write+0x18>
    }
    
    static inline void write_u32(u32 data, u32 address){
        *((volatile u32*) address) = data;
f9000074:	00942023          	sw	s1,0(s0)
        write_u32(data, reg + UART_DATA);
    }
f9000078:	00c12083          	lw	ra,12(sp)
f900007c:	00812403          	lw	s0,8(sp)
f9000080:	00412483          	lw	s1,4(sp)
f9000084:	01010113          	addi	sp,sp,16
f9000088:	00008067          	ret

f900008c <clint_uDelay>:
    
        return (((u64)hi) << 32) | lo;
    }
    
    static void clint_uDelay(u32 usec, u32 hz, u32 reg){
        u32 mTimePerUsec = hz/1000000;
f900008c:	000f47b7          	lui	a5,0xf4
f9000090:	24078793          	addi	a5,a5,576 # f4240 <CUSTOM1+0xf4215>
f9000094:	02f5d5b3          	divu	a1,a1,a5
    readReg_u32 (clint_getTimeLow , CLINT_TIME_ADDR)
f9000098:	0000c7b7          	lui	a5,0xc
f900009c:	ff878793          	addi	a5,a5,-8 # bff8 <CUSTOM1+0xbfcd>
f90000a0:	00f60633          	add	a2,a2,a5
        return *((volatile u32*) address);
f90000a4:	00062783          	lw	a5,0(a2)
        u32 limit = clint_getTimeLow(reg) + usec*mTimePerUsec;
f90000a8:	02a58533          	mul	a0,a1,a0
f90000ac:	00f50533          	add	a0,a0,a5
f90000b0:	00062783          	lw	a5,0(a2)
        while((int32_t)(limit-(clint_getTimeLow(reg))) >= 0);
f90000b4:	40f507b3          	sub	a5,a0,a5
f90000b8:	fe07dce3          	bgez	a5,f90000b0 <clint_uDelay+0x24>
    }
f90000bc:	00008067          	ret

f90000c0 <bsp_printHex>:
#define ENABLE_BRIDGE_FULL_TO_LITE          1 // If this is enabled, bsp_printf_full can be called with bsp_printf. Enabling both ENABLE_BSP_PRINTF and ENABLE_BSP_PRINTF_FULL, bsp_printf_full will be remained as bsp_printf_full. Default: Enable
#define ENABLE_PRINTF_WARNING               1 // Print warning when the specifier not supported. Default: Enable

    //bsp_printHex is used in BSP_PRINTF
    static void bsp_printHex(uint32_t val)
    {
f90000c0:	ff010113          	addi	sp,sp,-16
f90000c4:	00112623          	sw	ra,12(sp)
f90000c8:	00812423          	sw	s0,8(sp)
f90000cc:	00912223          	sw	s1,4(sp)
f90000d0:	00050493          	mv	s1,a0
        uint32_t digits;
        digits =8;

        for (int i = (4*digits)-4; i >= 0; i -= 4) {
f90000d4:	01c00413          	li	s0,28
f90000d8:	0280006f          	j	f9000100 <bsp_printHex+0x40>
            uart_write(BSP_UART_TERMINAL, "0123456789ABCDEF"[(val >> i) % 16]);
f90000dc:	0084d7b3          	srl	a5,s1,s0
f90000e0:	00f7f713          	andi	a4,a5,15
f90000e4:	f90807b7          	lui	a5,0xf9080
f90000e8:	00078793          	mv	a5,a5
f90000ec:	00e787b3          	add	a5,a5,a4
f90000f0:	0007c583          	lbu	a1,0(a5) # f9080000 <_bss_end+0xffffff2c>
f90000f4:	f8010537          	lui	a0,0xf8010
f90000f8:	f59ff0ef          	jal	ra,f9000050 <uart_write>
        for (int i = (4*digits)-4; i >= 0; i -= 4) {
f90000fc:	ffc40413          	addi	s0,s0,-4
f9000100:	fc045ee3          	bgez	s0,f90000dc <bsp_printHex+0x1c>
        }
    }
f9000104:	00c12083          	lw	ra,12(sp)
f9000108:	00812403          	lw	s0,8(sp)
f900010c:	00412483          	lw	s1,4(sp)
f9000110:	01010113          	addi	sp,sp,16
f9000114:	00008067          	ret

f9000118 <bsp_printHex_lower>:

    static void bsp_printHex_lower(uint32_t val)
        {
f9000118:	ff010113          	addi	sp,sp,-16
f900011c:	00112623          	sw	ra,12(sp)
f9000120:	00812423          	sw	s0,8(sp)
f9000124:	00912223          	sw	s1,4(sp)
f9000128:	00050493          	mv	s1,a0
            uint32_t digits;
            digits =8;

            for (int i = (4*digits)-4; i >= 0; i -= 4) {
f900012c:	01c00413          	li	s0,28
f9000130:	0280006f          	j	f9000158 <bsp_printHex_lower+0x40>
                uart_write(BSP_UART_TERMINAL, "0123456789abcdef"[(val >> i) % 16]);
f9000134:	0084d7b3          	srl	a5,s1,s0
f9000138:	00f7f713          	andi	a4,a5,15
f900013c:	f90807b7          	lui	a5,0xf9080
f9000140:	01478793          	addi	a5,a5,20 # f9080014 <_bss_end+0xffffff40>
f9000144:	00e787b3          	add	a5,a5,a4
f9000148:	0007c583          	lbu	a1,0(a5)
f900014c:	f8010537          	lui	a0,0xf8010
f9000150:	f01ff0ef          	jal	ra,f9000050 <uart_write>
            for (int i = (4*digits)-4; i >= 0; i -= 4) {
f9000154:	ffc40413          	addi	s0,s0,-4
f9000158:	fc045ee3          	bgez	s0,f9000134 <bsp_printHex_lower+0x1c>
            }
        }
f900015c:	00c12083          	lw	ra,12(sp)
f9000160:	00812403          	lw	s0,8(sp)
f9000164:	00412483          	lw	s1,4(sp)
f9000168:	01010113          	addi	sp,sp,16
f900016c:	00008067          	ret

f9000170 <bsp_printf_c>:
    }

    #endif //#if (ENABLE_FLOATING_POINT_SUPPORT)

    static void bsp_printf_c(int c)
    {
f9000170:	ff010113          	addi	sp,sp,-16
f9000174:	00112623          	sw	ra,12(sp)
        bsp_putChar(c);
f9000178:	0ff57593          	andi	a1,a0,255
f900017c:	f8010537          	lui	a0,0xf8010
f9000180:	ed1ff0ef          	jal	ra,f9000050 <uart_write>
    }
f9000184:	00c12083          	lw	ra,12(sp)
f9000188:	01010113          	addi	sp,sp,16
f900018c:	00008067          	ret

f9000190 <bsp_printf_s>:
    
    static void bsp_printf_s(char *p)
    {
f9000190:	ff010113          	addi	sp,sp,-16
f9000194:	00112623          	sw	ra,12(sp)
f9000198:	00812423          	sw	s0,8(sp)
f900019c:	00050413          	mv	s0,a0
        while (*p)
f90001a0:	00044583          	lbu	a1,0(s0)
f90001a4:	00058a63          	beqz	a1,f90001b8 <bsp_printf_s+0x28>
            bsp_putChar(*(p++));
f90001a8:	00140413          	addi	s0,s0,1
f90001ac:	f8010537          	lui	a0,0xf8010
f90001b0:	ea1ff0ef          	jal	ra,f9000050 <uart_write>
f90001b4:	fedff06f          	j	f90001a0 <bsp_printf_s+0x10>
    }
f90001b8:	00c12083          	lw	ra,12(sp)
f90001bc:	00812403          	lw	s0,8(sp)
f90001c0:	01010113          	addi	sp,sp,16
f90001c4:	00008067          	ret

f90001c8 <bsp_printf_d>:
    
    static void bsp_printf_d(int val)
    {
f90001c8:	fd010113          	addi	sp,sp,-48
f90001cc:	02112623          	sw	ra,44(sp)
f90001d0:	02812423          	sw	s0,40(sp)
f90001d4:	02912223          	sw	s1,36(sp)
f90001d8:	00050493          	mv	s1,a0
        char buffer[32];
        char *p = buffer;
        if (val < 0) {
f90001dc:	00054663          	bltz	a0,f90001e8 <bsp_printf_d+0x20>
    {
f90001e0:	00010413          	mv	s0,sp
f90001e4:	02c0006f          	j	f9000210 <bsp_printf_d+0x48>
            bsp_printf_c('-');
f90001e8:	02d00513          	li	a0,45
f90001ec:	f85ff0ef          	jal	ra,f9000170 <bsp_printf_c>
            val = -val;
f90001f0:	409004b3          	neg	s1,s1
f90001f4:	fedff06f          	j	f90001e0 <bsp_printf_d+0x18>
        }
        while (val || p == buffer) {
            *(p++) = '0' + val % 10;
f90001f8:	00a00713          	li	a4,10
f90001fc:	02e4e7b3          	rem	a5,s1,a4
f9000200:	03078793          	addi	a5,a5,48
f9000204:	00f40023          	sb	a5,0(s0)
            val = val / 10;
f9000208:	02e4c4b3          	div	s1,s1,a4
            *(p++) = '0' + val % 10;
f900020c:	00140413          	addi	s0,s0,1
        while (val || p == buffer) {
f9000210:	fe0494e3          	bnez	s1,f90001f8 <bsp_printf_d+0x30>
f9000214:	00010793          	mv	a5,sp
f9000218:	fef400e3          	beq	s0,a5,f90001f8 <bsp_printf_d+0x30>
f900021c:	0100006f          	j	f900022c <bsp_printf_d+0x64>
        }
        while (p != buffer)
            bsp_printf_c(*(--p));
f9000220:	fff40413          	addi	s0,s0,-1
f9000224:	00044503          	lbu	a0,0(s0)
f9000228:	f49ff0ef          	jal	ra,f9000170 <bsp_printf_c>
        while (p != buffer)
f900022c:	00010793          	mv	a5,sp
f9000230:	fef418e3          	bne	s0,a5,f9000220 <bsp_printf_d+0x58>
    }
f9000234:	02c12083          	lw	ra,44(sp)
f9000238:	02812403          	lw	s0,40(sp)
f900023c:	02412483          	lw	s1,36(sp)
f9000240:	03010113          	addi	sp,sp,48
f9000244:	00008067          	ret

f9000248 <bsp_printf_x>:
    
    static void bsp_printf_x(int val)
    {
f9000248:	ff010113          	addi	sp,sp,-16
f900024c:	00112623          	sw	ra,12(sp)
        int i,digi=2;
    
        for(i=0;i<8;i++)
f9000250:	00000713          	li	a4,0
f9000254:	00700793          	li	a5,7
f9000258:	02e7c063          	blt	a5,a4,f9000278 <bsp_printf_x+0x30>
        {
            if((val & (0xFFFFFFF0 <<(4*i))) == 0)
f900025c:	00271693          	slli	a3,a4,0x2
f9000260:	ff000793          	li	a5,-16
f9000264:	00d797b3          	sll	a5,a5,a3
f9000268:	00f577b3          	and	a5,a0,a5
f900026c:	00078663          	beqz	a5,f9000278 <bsp_printf_x+0x30>
        for(i=0;i<8;i++)
f9000270:	00170713          	addi	a4,a4,1
f9000274:	fe1ff06f          	j	f9000254 <bsp_printf_x+0xc>
            {
                digi=i+1;
                break;
            }
        }
        bsp_printHex_lower(val);
f9000278:	ea1ff0ef          	jal	ra,f9000118 <bsp_printHex_lower>
    }
f900027c:	00c12083          	lw	ra,12(sp)
f9000280:	01010113          	addi	sp,sp,16
f9000284:	00008067          	ret

f9000288 <bsp_printf_X>:
    
    static void bsp_printf_X(int val)
        {
f9000288:	ff010113          	addi	sp,sp,-16
f900028c:	00112623          	sw	ra,12(sp)
            int i,digi=2;

            for(i=0;i<8;i++)
f9000290:	00000713          	li	a4,0
f9000294:	00700793          	li	a5,7
f9000298:	02e7c063          	blt	a5,a4,f90002b8 <bsp_printf_X+0x30>
            {
                if((val & (0xFFFFFFF0 <<(4*i))) == 0)
f900029c:	00271693          	slli	a3,a4,0x2
f90002a0:	ff000793          	li	a5,-16
f90002a4:	00d797b3          	sll	a5,a5,a3
f90002a8:	00f577b3          	and	a5,a0,a5
f90002ac:	00078663          	beqz	a5,f90002b8 <bsp_printf_X+0x30>
            for(i=0;i<8;i++)
f90002b0:	00170713          	addi	a4,a4,1
f90002b4:	fe1ff06f          	j	f9000294 <bsp_printf_X+0xc>
                {
                    digi=i+1;
                    break;
                }
            }
            bsp_printHex(val);
f90002b8:	e09ff0ef          	jal	ra,f90000c0 <bsp_printHex>
        }
f90002bc:	00c12083          	lw	ra,12(sp)
f90002c0:	01010113          	addi	sp,sp,16
f90002c4:	00008067          	ret

f90002c8 <plic_set_priority>:
#define PLIC_CLAIM_BASE         0x200004
#define PLIC_ENABLE_PER_HART    0x80
#define PLIC_CONTEXT_PER_HART   0x1000

    static void plic_set_priority(u32 plic, u32 gateway, u32 priority){
        write_u32(priority, plic + PLIC_PRIORITY_BASE + gateway*4);
f90002c8:	00259593          	slli	a1,a1,0x2
f90002cc:	00a585b3          	add	a1,a1,a0
        *((volatile u32*) address) = data;
f90002d0:	00c5a023          	sw	a2,0(a1)
    }
f90002d4:	00008067          	ret

f90002d8 <plic_set_enable>:
    static u32 plic_get_priority(u32 plic, u32 gateway){
        return read_u32(plic + PLIC_PRIORITY_BASE + gateway*4);
    }
    
    static void plic_set_enable(u32 plic, u32 target,u32 gateway, u32 enable){
        u32 word = plic + PLIC_ENABLE_BASE + target * PLIC_ENABLE_PER_HART + (gateway / 32 * 4);
f90002d8:	00759593          	slli	a1,a1,0x7
f90002dc:	00a58533          	add	a0,a1,a0
f90002e0:	00565593          	srli	a1,a2,0x5
f90002e4:	00259593          	slli	a1,a1,0x2
f90002e8:	00b50533          	add	a0,a0,a1
f90002ec:	000025b7          	lui	a1,0x2
f90002f0:	00b50533          	add	a0,a0,a1
        u32 mask = 1 << (gateway % 32);
f90002f4:	00100793          	li	a5,1
f90002f8:	00c797b3          	sll	a5,a5,a2
        if (enable)
f90002fc:	00068a63          	beqz	a3,f9000310 <plic_set_enable+0x38>
        return *((volatile u32*) address);
f9000300:	00052603          	lw	a2,0(a0) # f8010000 <_bss_end+0xfef8ff2c>
            write_u32(read_u32(word) | mask, word);
f9000304:	00c7e7b3          	or	a5,a5,a2
        *((volatile u32*) address) = data;
f9000308:	00f52023          	sw	a5,0(a0)
f900030c:	00008067          	ret
        return *((volatile u32*) address);
f9000310:	00052603          	lw	a2,0(a0)
        else
            write_u32(read_u32(word) & ~mask, word);
f9000314:	fff7c793          	not	a5,a5
f9000318:	00c7f7b3          	and	a5,a5,a2
        *((volatile u32*) address) = data;
f900031c:	00f52023          	sw	a5,0(a0)
    }
f9000320:	00008067          	ret

f9000324 <plic_set_threshold>:
    
    static void plic_set_threshold(u32 plic, u32 target, u32 threshold){
        write_u32(threshold, plic + PLIC_THRESHOLD_BASE + target*PLIC_CONTEXT_PER_HART);
f9000324:	00c59593          	slli	a1,a1,0xc
f9000328:	00a585b3          	add	a1,a1,a0
f900032c:	00200537          	lui	a0,0x200
f9000330:	00a585b3          	add	a1,a1,a0
f9000334:	00c5a023          	sw	a2,0(a1) # 2000 <CUSTOM1+0x1fd5>
    }
f9000338:	00008067          	ret

f900033c <plic_claim>:
    static u32 plic_get_threshold(u32 plic, u32 target){
        return read_u32(plic + PLIC_THRESHOLD_BASE + target*PLIC_CONTEXT_PER_HART);
    }
    
    static u32 plic_claim(u32 plic, u32 target){
        return read_u32(plic + PLIC_CLAIM_BASE + target*PLIC_CONTEXT_PER_HART);
f900033c:	00c59593          	slli	a1,a1,0xc
f9000340:	00a585b3          	add	a1,a1,a0
f9000344:	00200537          	lui	a0,0x200
f9000348:	00450513          	addi	a0,a0,4 # 200004 <CUSTOM1+0x1fffd9>
f900034c:	00a585b3          	add	a1,a1,a0
        return *((volatile u32*) address);
f9000350:	0005a503          	lw	a0,0(a1)
    }
f9000354:	00008067          	ret

f9000358 <plic_release>:
    
    static void plic_release(u32 plic, u32 target, u32 gateway){
        write_u32(gateway,plic + PLIC_CLAIM_BASE + target*PLIC_CONTEXT_PER_HART);
f9000358:	00c59593          	slli	a1,a1,0xc
f900035c:	00a585b3          	add	a1,a1,a0
f9000360:	00200537          	lui	a0,0x200
f9000364:	00450513          	addi	a0,a0,4 # 200004 <CUSTOM1+0x1fffd9>
f9000368:	00a585b3          	add	a1,a1,a0
        *((volatile u32*) address) = data;
f900036c:	00c5a023          	sw	a2,0(a1)
    }
f9000370:	00008067          	ret

f9000374 <bsp_printf>:

    static void bsp_printf(const char *format, ...)
    {
f9000374:	fc010113          	addi	sp,sp,-64
f9000378:	00112e23          	sw	ra,28(sp)
f900037c:	00812c23          	sw	s0,24(sp)
f9000380:	00912a23          	sw	s1,20(sp)
f9000384:	00050493          	mv	s1,a0
f9000388:	02b12223          	sw	a1,36(sp)
f900038c:	02c12423          	sw	a2,40(sp)
f9000390:	02d12623          	sw	a3,44(sp)
f9000394:	02e12823          	sw	a4,48(sp)
f9000398:	02f12a23          	sw	a5,52(sp)
f900039c:	03012c23          	sw	a6,56(sp)
f90003a0:	03112e23          	sw	a7,60(sp)
        int i;
        va_list ap;
    
        va_start(ap, format);
f90003a4:	02410793          	addi	a5,sp,36
f90003a8:	00f12623          	sw	a5,12(sp)
    
        for (i = 0; format[i]; i++)
f90003ac:	00000413          	li	s0,0
f90003b0:	01c0006f          	j	f90003cc <bsp_printf+0x58>
            if (format[i] == '%') {
                while (format[++i]) {
                    if (format[i] == 'c') {
                        bsp_printf_c(va_arg(ap,int));
f90003b4:	00c12783          	lw	a5,12(sp)
f90003b8:	00478713          	addi	a4,a5,4
f90003bc:	00e12623          	sw	a4,12(sp)
f90003c0:	0007a503          	lw	a0,0(a5)
f90003c4:	dadff0ef          	jal	ra,f9000170 <bsp_printf_c>
        for (i = 0; format[i]; i++)
f90003c8:	00140413          	addi	s0,s0,1
f90003cc:	008487b3          	add	a5,s1,s0
f90003d0:	0007c503          	lbu	a0,0(a5)
f90003d4:	0c050263          	beqz	a0,f9000498 <bsp_printf+0x124>
            if (format[i] == '%') {
f90003d8:	02500793          	li	a5,37
f90003dc:	06f50663          	beq	a0,a5,f9000448 <bsp_printf+0xd4>
                        break;
                    }
#endif //#if (ENABLE_FLOATING_POINT_SUPPORT)
                }
            } else
                bsp_printf_c(format[i]);
f90003e0:	d91ff0ef          	jal	ra,f9000170 <bsp_printf_c>
f90003e4:	fe5ff06f          	j	f90003c8 <bsp_printf+0x54>
                        bsp_printf_s(va_arg(ap,char*));
f90003e8:	00c12783          	lw	a5,12(sp)
f90003ec:	00478713          	addi	a4,a5,4
f90003f0:	00e12623          	sw	a4,12(sp)
f90003f4:	0007a503          	lw	a0,0(a5)
f90003f8:	d99ff0ef          	jal	ra,f9000190 <bsp_printf_s>
                        break;
f90003fc:	fcdff06f          	j	f90003c8 <bsp_printf+0x54>
                        bsp_printf_d(va_arg(ap,int));
f9000400:	00c12783          	lw	a5,12(sp)
f9000404:	00478713          	addi	a4,a5,4
f9000408:	00e12623          	sw	a4,12(sp)
f900040c:	0007a503          	lw	a0,0(a5)
f9000410:	db9ff0ef          	jal	ra,f90001c8 <bsp_printf_d>
                        break;
f9000414:	fb5ff06f          	j	f90003c8 <bsp_printf+0x54>
                        bsp_printf_X(va_arg(ap,int));
f9000418:	00c12783          	lw	a5,12(sp)
f900041c:	00478713          	addi	a4,a5,4
f9000420:	00e12623          	sw	a4,12(sp)
f9000424:	0007a503          	lw	a0,0(a5)
f9000428:	e61ff0ef          	jal	ra,f9000288 <bsp_printf_X>
                        break;
f900042c:	f9dff06f          	j	f90003c8 <bsp_printf+0x54>
                        bsp_printf_x(va_arg(ap,int));
f9000430:	00c12783          	lw	a5,12(sp)
f9000434:	00478713          	addi	a4,a5,4
f9000438:	00e12623          	sw	a4,12(sp)
f900043c:	0007a503          	lw	a0,0(a5)
f9000440:	e09ff0ef          	jal	ra,f9000248 <bsp_printf_x>
                        break;
f9000444:	f85ff06f          	j	f90003c8 <bsp_printf+0x54>
                while (format[++i]) {
f9000448:	00140413          	addi	s0,s0,1
f900044c:	008487b3          	add	a5,s1,s0
f9000450:	0007c783          	lbu	a5,0(a5)
f9000454:	f6078ae3          	beqz	a5,f90003c8 <bsp_printf+0x54>
                    if (format[i] == 'c') {
f9000458:	06300713          	li	a4,99
f900045c:	f4e78ce3          	beq	a5,a4,f90003b4 <bsp_printf+0x40>
                    else if (format[i] == 's') {
f9000460:	07300713          	li	a4,115
f9000464:	f8e782e3          	beq	a5,a4,f90003e8 <bsp_printf+0x74>
                    else if (format[i] == 'd') {
f9000468:	06400713          	li	a4,100
f900046c:	f8e78ae3          	beq	a5,a4,f9000400 <bsp_printf+0x8c>
                    else if (format[i] == 'X') {
f9000470:	05800713          	li	a4,88
f9000474:	fae782e3          	beq	a5,a4,f9000418 <bsp_printf+0xa4>
                    else if (format[i] == 'x') {
f9000478:	07800713          	li	a4,120
f900047c:	fae78ae3          	beq	a5,a4,f9000430 <bsp_printf+0xbc>
                    else if (format[i] == 'f') {
f9000480:	06600713          	li	a4,102
f9000484:	fce792e3          	bne	a5,a4,f9000448 <bsp_printf+0xd4>
                        bsp_printf_s("<Floating point printing not enable. Please Enable it at bsp.h first...>");
f9000488:	f9080537          	lui	a0,0xf9080
f900048c:	02850513          	addi	a0,a0,40 # f9080028 <_bss_end+0xffffff54>
f9000490:	d01ff0ef          	jal	ra,f9000190 <bsp_printf_s>
                        break;
f9000494:	f35ff06f          	j	f90003c8 <bsp_printf+0x54>
    
        va_end(ap);
    }
f9000498:	01c12083          	lw	ra,28(sp)
f900049c:	01812403          	lw	s0,24(sp)
f90004a0:	01412483          	lw	s1,20(sp)
f90004a4:	04010113          	addi	sp,sp,64
f90004a8:	00008067          	ret

f90004ac <init>:
void trap();
void crash();
void trap_entry();
void externalInterrupt();

void init(){
f90004ac:	ff010113          	addi	sp,sp,-16
f90004b0:	00112623          	sw	ra,12(sp)
    //configure PLIC
    //cpu 0 accept all interrupts with priority above 0
    plic_set_threshold(BSP_PLIC, BSP_PLIC_CPU_0, 0); 
f90004b4:	00000613          	li	a2,0
f90004b8:	00000593          	li	a1,0
f90004bc:	f8c00537          	lui	a0,0xf8c00
f90004c0:	e65ff0ef          	jal	ra,f9000324 <plic_set_threshold>
    plic_set_enable(BSP_PLIC, BSP_PLIC_CPU_0, SYSTEM_PLIC_SYSTEM_GPIO_0_IO_INTERRUPTS_0, 1);
f90004c4:	00100693          	li	a3,1
f90004c8:	00c00613          	li	a2,12
f90004cc:	00000593          	li	a1,0
f90004d0:	f8c00537          	lui	a0,0xf8c00
f90004d4:	e05ff0ef          	jal	ra,f90002d8 <plic_set_enable>
    plic_set_priority(BSP_PLIC, SYSTEM_PLIC_SYSTEM_GPIO_0_IO_INTERRUPTS_0, 1);
f90004d8:	00100613          	li	a2,1
f90004dc:	00c00593          	li	a1,12
f90004e0:	f8c00537          	lui	a0,0xf8c00
f90004e4:	de5ff0ef          	jal	ra,f90002c8 <plic_set_priority>
f90004e8:	f80167b7          	lui	a5,0xf8016
f90004ec:	00100713          	li	a4,1
f90004f0:	02e7a023          	sw	a4,32(a5) # f8016020 <_bss_end+0xfef95f4c>
    //Enable rising edge interrupts
    gpio_setInterruptRiseEnable(GPIO0, 1); 
    //enable interrupts
    //Set the machine trap vector (../common/trap.S)
    csr_write(mtvec, trap_entry); 
f90004f4:	f90007b7          	lui	a5,0xf9000
f90004f8:	64478793          	addi	a5,a5,1604 # f9000644 <_bss_end+0xfff80570>
f90004fc:	30579073          	csrw	mtvec,a5
    //Enable external interrupts
    csr_set(mie, MIE_MEIE); 
f9000500:	000017b7          	lui	a5,0x1
f9000504:	80078793          	addi	a5,a5,-2048 # 800 <CUSTOM1+0x7d5>
f9000508:	3047a073          	csrs	mie,a5
    csr_write(mstatus, MSTATUS_MPP | MSTATUS_MIE);
f900050c:	000027b7          	lui	a5,0x2
f9000510:	80878793          	addi	a5,a5,-2040 # 1808 <CUSTOM1+0x17dd>
f9000514:	30079073          	csrw	mstatus,a5
}
f9000518:	00c12083          	lw	ra,12(sp)
f900051c:	01010113          	addi	sp,sp,16
f9000520:	00008067          	ret

f9000524 <crash>:
        plic_release(BSP_PLIC, BSP_PLIC_CPU_0, claim); 
    }
}

//Used on unexpected trap/interrupt codes
void crash(){
f9000524:	ff010113          	addi	sp,sp,-16
f9000528:	00112623          	sw	ra,12(sp)
    bsp_printf("\r\n*** CRASH ***\r\n");
f900052c:	f9080537          	lui	a0,0xf9080
f9000530:	07450513          	addi	a0,a0,116 # f9080074 <_bss_end+0xffffffa0>
f9000534:	e41ff0ef          	jal	ra,f9000374 <bsp_printf>
    while(1);
f9000538:	0000006f          	j	f9000538 <crash+0x14>

f900053c <externalInterrupt>:
void externalInterrupt(){
f900053c:	ff010113          	addi	sp,sp,-16
f9000540:	00112623          	sw	ra,12(sp)
f9000544:	00812423          	sw	s0,8(sp)
    while(claim = plic_claim(BSP_PLIC, BSP_PLIC_CPU_0)){
f9000548:	00000593          	li	a1,0
f900054c:	f8c00537          	lui	a0,0xf8c00
f9000550:	dedff0ef          	jal	ra,f900033c <plic_claim>
f9000554:	00050413          	mv	s0,a0
f9000558:	02050863          	beqz	a0,f9000588 <externalInterrupt+0x4c>
        switch(claim){
f900055c:	00c00793          	li	a5,12
f9000560:	02f41263          	bne	s0,a5,f9000584 <externalInterrupt+0x48>
        case SYSTEM_PLIC_SYSTEM_GPIO_0_IO_INTERRUPTS_0: bsp_printf("gpio 0 interrupt routine \r\n"); break;
f9000564:	f9080537          	lui	a0,0xf9080
f9000568:	08850513          	addi	a0,a0,136 # f9080088 <_bss_end+0xffffffb4>
f900056c:	e09ff0ef          	jal	ra,f9000374 <bsp_printf>
        plic_release(BSP_PLIC, BSP_PLIC_CPU_0, claim); 
f9000570:	00040613          	mv	a2,s0
f9000574:	00000593          	li	a1,0
f9000578:	f8c00537          	lui	a0,0xf8c00
f900057c:	dddff0ef          	jal	ra,f9000358 <plic_release>
f9000580:	fc9ff06f          	j	f9000548 <externalInterrupt+0xc>
        default: crash(); break;
f9000584:	fa1ff0ef          	jal	ra,f9000524 <crash>
}
f9000588:	00c12083          	lw	ra,12(sp)
f900058c:	00812403          	lw	s0,8(sp)
f9000590:	01010113          	addi	sp,sp,16
f9000594:	00008067          	ret

f9000598 <trap>:
void trap(){
f9000598:	ff010113          	addi	sp,sp,-16
f900059c:	00112623          	sw	ra,12(sp)
    int32_t mcause = csr_read(mcause);
f90005a0:	342027f3          	csrr	a5,mcause
    if(interrupt){
f90005a4:	0207d263          	bgez	a5,f90005c8 <trap+0x30>
f90005a8:	00f7f713          	andi	a4,a5,15
        switch(cause){
f90005ac:	00b00793          	li	a5,11
f90005b0:	00f71a63          	bne	a4,a5,f90005c4 <trap+0x2c>
        case CAUSE_MACHINE_EXTERNAL: externalInterrupt(); break;
f90005b4:	f89ff0ef          	jal	ra,f900053c <externalInterrupt>
}
f90005b8:	00c12083          	lw	ra,12(sp)
f90005bc:	01010113          	addi	sp,sp,16
f90005c0:	00008067          	ret
        default: crash(); break;
f90005c4:	f61ff0ef          	jal	ra,f9000524 <crash>
        crash();
f90005c8:	f5dff0ef          	jal	ra,f9000524 <crash>

f90005cc <main>:
}

void main() {
f90005cc:	ff010113          	addi	sp,sp,-16
f90005d0:	00112623          	sw	ra,12(sp)
f90005d4:	00812423          	sw	s0,8(sp)
    bsp_init();
    bsp_printf("gpio 0 demo ! \r\n");
f90005d8:	f9080537          	lui	a0,0xf9080
f90005dc:	0a450513          	addi	a0,a0,164 # f90800a4 <_bss_end+0xffffffd0>
f90005e0:	d95ff0ef          	jal	ra,f9000374 <bsp_printf>
    bsp_printf("onboard LEDs blinking \r\n");
f90005e4:	f9080537          	lui	a0,0xf9080
f90005e8:	0b850513          	addi	a0,a0,184 # f90800b8 <_bss_end+0xffffffe4>
f90005ec:	d89ff0ef          	jal	ra,f9000374 <bsp_printf>
f90005f0:	f80167b7          	lui	a5,0xf8016
f90005f4:	00e00713          	li	a4,14
f90005f8:	00e7a423          	sw	a4,8(a5) # f8016008 <_bss_end+0xfef95f34>
f90005fc:	0007a223          	sw	zero,4(a5)
    //configure 4 bits gpio 0
    gpio_setOutputEnable(GPIO0, 0xe);
    gpio_setOutput(GPIO0, 0x0);
    for (int i=0; i<1000000; i=i+1) {
f9000600:	00000413          	li	s0,0
f9000604:	0300006f          	j	f9000634 <main+0x68>
        return *((volatile u32*) address);
f9000608:	f8016737          	lui	a4,0xf8016
f900060c:	00472783          	lw	a5,4(a4) # f8016004 <_bss_end+0xfef95f30>
        gpio_setOutput(GPIO0, gpio_getOutput(GPIO0) ^ 0xe);
f9000610:	00e7c793          	xori	a5,a5,14
        *((volatile u32*) address) = data;
f9000614:	00f72223          	sw	a5,4(a4)
        bsp_uDelay(LOOP_UDELAY);
f9000618:	f8b00637          	lui	a2,0xf8b00
f900061c:	017d85b7          	lui	a1,0x17d8
f9000620:	84058593          	addi	a1,a1,-1984 # 17d7840 <CUSTOM1+0x17d7815>
f9000624:	00018537          	lui	a0,0x18
f9000628:	6a050513          	addi	a0,a0,1696 # 186a0 <CUSTOM1+0x18675>
f900062c:	a61ff0ef          	jal	ra,f900008c <clint_uDelay>
    for (int i=0; i<1000000; i=i+1) {
f9000630:	00140413          	addi	s0,s0,1
f9000634:	000f47b7          	lui	a5,0xf4
f9000638:	23f78793          	addi	a5,a5,575 # f423f <CUSTOM1+0xf4214>
f900063c:	fc87d6e3          	bge	a5,s0,f9000608 <main+0x3c>
    bsp_printf("Ti180 press and release onboard button sw4 \r\n");
    bsp_printf("Ti60 press and release onboard button sw6 \r\n");
    bsp_printf("T120 press and release onboard button sw7 \r\n");
    init();
    */
    while(1); 
f9000640:	0000006f          	j	f9000640 <main+0x74>

f9000644 <trap_entry>:
.global  trap_entry
.align(2) //mtvec require 32 bits allignement
trap_entry:
  addi sp,sp, -16*4
f9000644:	fc010113          	addi	sp,sp,-64
  sw x1,   0*4(sp)
f9000648:	00112023          	sw	ra,0(sp)
  sw x5,   1*4(sp)
f900064c:	00512223          	sw	t0,4(sp)
  sw x6,   2*4(sp)
f9000650:	00612423          	sw	t1,8(sp)
  sw x7,   3*4(sp)
f9000654:	00712623          	sw	t2,12(sp)
  sw x10,  4*4(sp)
f9000658:	00a12823          	sw	a0,16(sp)
  sw x11,  5*4(sp)
f900065c:	00b12a23          	sw	a1,20(sp)
  sw x12,  6*4(sp)
f9000660:	00c12c23          	sw	a2,24(sp)
  sw x13,  7*4(sp)
f9000664:	00d12e23          	sw	a3,28(sp)
  sw x14,  8*4(sp)
f9000668:	02e12023          	sw	a4,32(sp)
  sw x15,  9*4(sp)
f900066c:	02f12223          	sw	a5,36(sp)
  sw x16, 10*4(sp)
f9000670:	03012423          	sw	a6,40(sp)
  sw x17, 11*4(sp)
f9000674:	03112623          	sw	a7,44(sp)
  sw x28, 12*4(sp)
f9000678:	03c12823          	sw	t3,48(sp)
  sw x29, 13*4(sp)
f900067c:	03d12a23          	sw	t4,52(sp)
  sw x30, 14*4(sp)
f9000680:	03e12c23          	sw	t5,56(sp)
  sw x31, 15*4(sp)
f9000684:	03f12e23          	sw	t6,60(sp)
  call trap
f9000688:	f11ff0ef          	jal	ra,f9000598 <trap>
  lw x1 ,  0*4(sp)
f900068c:	00012083          	lw	ra,0(sp)
  lw x5,   1*4(sp)
f9000690:	00412283          	lw	t0,4(sp)
  lw x6,   2*4(sp)
f9000694:	00812303          	lw	t1,8(sp)
  lw x7,   3*4(sp)
f9000698:	00c12383          	lw	t2,12(sp)
  lw x10,  4*4(sp)
f900069c:	01012503          	lw	a0,16(sp)
  lw x11,  5*4(sp)
f90006a0:	01412583          	lw	a1,20(sp)
  lw x12,  6*4(sp)
f90006a4:	01812603          	lw	a2,24(sp)
  lw x13,  7*4(sp)
f90006a8:	01c12683          	lw	a3,28(sp)
  lw x14,  8*4(sp)
f90006ac:	02012703          	lw	a4,32(sp)
  lw x15,  9*4(sp)
f90006b0:	02412783          	lw	a5,36(sp)
  lw x16, 10*4(sp)
f90006b4:	02812803          	lw	a6,40(sp)
  lw x17, 11*4(sp)
f90006b8:	02c12883          	lw	a7,44(sp)
  lw x28, 12*4(sp)
f90006bc:	03012e03          	lw	t3,48(sp)
  lw x29, 13*4(sp)
f90006c0:	03412e83          	lw	t4,52(sp)
  lw x30, 14*4(sp)
f90006c4:	03812f03          	lw	t5,56(sp)
  lw x31, 15*4(sp)
f90006c8:	03c12f83          	lw	t6,60(sp)
  addi sp,sp, 16*4
f90006cc:	04010113          	addi	sp,sp,64
  mret
f90006d0:	30200073          	mret

Disassembly of section .text.init:

f9000000 <_start>:
    .section .text.init
    .align 6
    .globl _start
    .globl _bss_end
_start:
    j reset_vector
f9000000:	0040006f          	j	f9000004 <other_exception>

f9000004 <other_exception>:
other_exception:
#    <<<他のハンドラの内容>>>
reset_vector:
#    <<<初期化内容>>>
#    li sp, 4096     # スタックポインタのアドレス
    la sp, STACK_TOP # スタックポインタのアドレス
f9000004:	00080117          	auipc	sp,0x80
f9000008:	4d010113          	addi	sp,sp,1232 # f90804d4 <_bss_end+0x400>

    auipc t0,0x0    # PCをレジスタに退避
f900000c:	00000297          	auipc	t0,0x0
    addi  t0,t0,16  # mretのアドレス
f9000010:	01028293          	addi	t0,t0,16 # f900001c <other_exception+0x18>
    csrw  mepc,t0   # MEPCにアドレスをセット
f9000014:	34129073          	csrw	mepc,t0

    li    t0,0x4    # 0x4をセット
f9000018:	00400293          	li	t0,4
    csrw  mtvec,t0  # MTVECにアドレスをセット
f900001c:	30529073          	csrw	mtvec,t0

    li    t0,0x800  # 割り込みセット
f9000020:	000012b7          	lui	t0,0x1
f9000024:	80028293          	addi	t0,t0,-2048 # 800 <CUSTOM1+0x7d5>
    csrw  mie,t0    # mieに割り込みイネーブルをセット
f9000028:	30429073          	csrw	mie,t0

    li    t0,0x8    # 割り込みセット
f900002c:	00800293          	li	t0,8
    csrw  mstatus,t0 # mieに割り込みイネーブルをセット
f9000030:	30029073          	csrw	mstatus,t0

    call  main      # mainへジャンプ
f9000034:	598000ef          	jal	ra,f90005cc <main>

    mret            # MEPCへ飛んでいく
f9000038:	30200073          	mret
f900003c:	0000                	unimp
	...
