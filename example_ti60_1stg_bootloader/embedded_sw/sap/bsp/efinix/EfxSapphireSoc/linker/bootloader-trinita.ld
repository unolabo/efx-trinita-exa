MEMORY {
    ROM (rx)  : ORIGIN = 0xF9007800, LENGTH = 2048
    RAM (rwx) : ORIGIN = 0xF9087800, LENGTH = 2048
}
SECTIONS
{
  . = 0xF9007800;
  .text.init : {} > ROM
  . = 0x00000040;
  .text : {} > ROM
  . = 0xF9087800;
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