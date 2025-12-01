ENTRY(_start)

SECTIONS {
	. = 0x80200000;
	
	.text : ALIGN(16) {
		*(.text.start)
		*(.text .text.*)
	}

  .data : ALIGN(16) {
		*(.rodata)
		*(.rodata.*)
		*(.data)
		*(.data.*)
	}

	.bss : ALIGN(16) {
		*(.bss .bss.*)
		*(COMMON)
	}

	. = ALIGN(16);
	__stack_bottom = .;
	. = . + 0x10000;
	__stack_top = .;
}
