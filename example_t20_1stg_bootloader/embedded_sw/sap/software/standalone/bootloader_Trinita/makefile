PROJ_NAME=bootloader_Trinita

STANDALONE = ..

SRCS = 	$(wildcard src/*.c) \
		$(wildcard src/*.cpp) \
		$(wildcard src/*.S) \
        ${STANDALONE}/common/start.S \

LDSCRIPT ?= ${BSP_PATH}/linker/bootloader-trinita.ld

include ${STANDALONE}/common/bsp-trinita.mk
include ${STANDALONE}/common/riscv64-unknown-elf.mk
include ${STANDALONE}/common/standalone-trinita.mk

