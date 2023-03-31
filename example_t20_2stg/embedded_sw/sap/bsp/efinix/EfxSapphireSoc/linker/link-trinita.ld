MEMORY {
    ROM (rx)  : ORIGIN = 0xF9000000, LENGTH = 0x8000
    RAM (rwx) : ORIGIN = 0xF9080000, LENGTH = 0x8000
}
SECTIONS
{
  . = 0xF9000000;
  .text.init : {} > ROM
  . = 0x00000040;
  .text : {} > ROM
  . = 0xF9080000;
  . = ALIGN(4);
  .rodata : {} > RAM
  . = ALIGN(4);
  .data : {} > RAM
  . = ALIGN(4);
  _bss_start = .
;  .bss : {} > RAM
  . = ALIGN(4);
  _bss_end = .;
  . = ALIGN(4);
  end = .;
  _end = .;
}