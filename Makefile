SOURCE_DIR = src
BOOTLOADER = $(SOURCE_DIR)/bootloader.asm
TARGET     = dsacle.bin
TARGET_IMG = dsaclelive.img

# Assembler settings
LDFLAGS    = -f bin
NASM       = nasm

build: $(BOOTLOADER)
	$(NASM) $(LDFLAGS) $(BOOTLOADER) -o $(TARGET)

img:
	dd if=$(TARGET) of=$(TARGET_IMG) bs=512 count=1

burn: $(BIN)
	@echo "Burning $(BIN) into $(DRIVE)..."
	@sudo dd if=$(BIN) of=$(USB_DEV) bs=512 count=1 conv=notrunc status=progress
	@sync
	@echo "Completed!"
