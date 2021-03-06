# Generate machine code memory image from MIPS assembly

# Get PROGRAM and *MEMDUMP from project settings
PROGRAM := lw_sw

# Memory image(s) to create from the assembly program
TEXTMEMDUMP := $(PROGRAM).text.hex
DATAMEMDUMP := $(PROGRAM).data.hex

## Verilog settings

# Top-level module/filename (minus .v/.t.v extension)
TOPLEVEL := cpu

# All circuits included by the toplevel $(TOPLEVEL).t.v
CIRCUITS := $(TOPLEVEL).v

ALLMEM := $(TEXTMEMDUMP) $(DATAMEMDUMP)

# MARS is pre-installed (/usr/local/bin/mars) on VM. Non-VM users should use
#MARS_PATH := java -jar /usr/local/share/mars/Mars4_5.jar
MARS_PATH := java -jar /usr/local/share/mars/Mars4_5.jar
MARS_OPTS := a  mc CompactTextAtZero
MARS      := $(MARS_PATH) $(MARS_OPTS)


# Pattern rule for generating .text memory dump from MIPS assembly
%.text.hex: %.asm
	$(MARS) dump .text HexText $@  $<

# Pattern rule for generating .data memory dump from MIPS assembly
%.data.hex: %.asm
	$(MARS) dump .data HexText $@  $<


# Shortcut (phony) targets for convenience
assemble: $(ALLMEM)

clean:
	-rm -f $(ALLMEM)


.PHONY: assemble clean
