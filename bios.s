.include "nios_macros.h"

.section .data

.section .text

# BIOS Operations
#   1. Ensure SD Card is inserted and can be read
#   2. Check for boot signature 0xaa55
#   3. Load Master Boot Record (MBR) from disk into memory
#   4. Jump to location where MBR is loaded
#   If none found, display an error on VGA

# STEP 1
# Ensuring SD Card is Inserted


