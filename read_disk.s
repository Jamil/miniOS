# Read from SRAM

.equ BLOCK_SIZE, 512

.global loadSRAMBlock
.global storeSRAMBlock
.global loadSDBlock
.global storeSDBlock

# Function Prototype for Load, Store functions
#   r4: Disk Address
#   r5: Target address (on disk)
#   r6: Destination address (in Main Memory)

##
## Loads
##

loadSDBlock:
  mov r8, r4              # Disk address => r4
  stwio r5, 556(r4)       # Write target address to Command Argument Register
  movi r9, 0x11           # READ_BLOCK command
  sthio r9, 560(r4)       # Write to Command Register
  
load_poll_SD:
  ldwio r9, 564(r4)       # Read Auxiliary Status Register
  andi r9, r9, 0b10       # Check if bit 2 (in progress) on
  bne r9, r0, load_poll_SD 

prepare_for_load:
  mov r8, r0
  mov r9, r0
  movi r10, BLOCK_SIZE
  br load_bytes

loadSRAMBlock:
  mov r8, r4          
  add r8, r8, r5          # Add target to offset to get final target address (absolute address)
  movi r9, 0              # Iterator
  movia r10, BLOCK_SIZE 
  br load_bytes

# r8 = Starting point in memory
# r9 = Iterator
# r10 - BLOCK_SIZE
load_bytes:
  bge r9, r10, finish_load    # while (iterator < BLOCK_SIZE)
  add r11, r8, r9             # target address
  ldwio r12, (r11)            # load from disk        
  add r11, r6, r9             # destination address
  stw r12, (r11)              # store to Main Memory
  addi r9, r9, 4
  br load_bytes
    
finish_load:
  ret
  
##
## Loads
##

# Function Prototype for Load, Store functions
#   r4: Disk Address
#   r5: Destination address (on disk)
#   r6: Target address (in Main Memory)

storeSDBlock:
  movi r9, 0
  movia r10, BLOCK_SIZE

store_SD_bytes:
  bge r9, r10, prepare_for_store    
  add r11, r6, r9                   # address in main memory (to move)
  ldb r12, (r11)                    # load from main memory
  stbio r12, (r4)                   # store to SD disk buffer

prepare_for_store:                  # Set control bits to store to SD Card
  stwio r5, 556(r4)                 # Set command register to target address
  movi r9, 0x18                     # Tell command register to write bytes to SD Card
  sthio r9, 560(r4)

poll_SD_until_stored:
  ldwio r9, 560(r4)
  andi r9, r9, 0b10
  bne r9, r0, poll_SD_until_stored
  br finish_store

storeSRAMBlock:
  mov r8, r4          
  add r8, r8, r5          # Add target to offset to get final target address (absolute address)
  movi r9, 0              # Iterator
  movia r10, BLOCK_SIZE 
    
store_bytes:
  bge r9, r10, finish_store
  add r11, r6, r9             # target address
  ldb r12, (r11)              # load from main memory
  add r11, r8, r9             # destination address
  stbio r12, (r11)            # store to disk
    
finish_store:
  ret
    
