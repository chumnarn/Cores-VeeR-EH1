/*
 NOTE NOTE NOTE NOTE NOTE NOTE NOTE NOTE NOTE NOTE NOTE NOTE NOTE NOTE NOTE NOTE
 This is an automatically generated file by  on Sun Sep 20 04:36:54 ADT 2026

 cmd:    veer -target=default_pd -ahb_lite -set=dccm_enable=0 -set=iccm_enable=0 -set=icache_enable=0 -unset=assert_on 

*/

OUTPUT_ARCH( "riscv" )
ENTRY(_start)

SECTIONS
{
  . = 0x80000000;
  .text.init .  : { *(.text.init) }
  
  .text . : { *(.text) }
  _end = .;
  . = 0xd0580000;
  .data.io .  : { *(.data.io) }
    . = 0xc0580000 ;
  .data  :  ALIGN(0x800) { *(.*data) *(.rodata*)}
  .bss :  {BSS_START = .; *(.*bss)}
  BSS_END = .;
  STACK = ALIGN(16) + 0x1000;
  
  
}

