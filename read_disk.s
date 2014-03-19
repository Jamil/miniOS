# Read from SRAM

.equ BLOCK_SIZE 512

.global loadBlock
.global storeBlock

# loadBlock
# Function Prototype
#   r4: Disk Address
#   r5: Target address (on disk)
#   r6: Destination address (in Main Memory)

loadBlock:
    mov r8, r4          
    add r8, r8, r5          # Add target to offset to get final target address (absolute address)
    movi r9, 0              # Iterator
    mov r10, BLOCK_SIZE 
    
load_bytes:
    bge r9, r10, finish_load    # while (iterator < BLOCK_SIZE)
    add r11, r8, r9             # target address
    ldbio r12, (r11)            # load from disk        
    add r11, r6, r9             # destination address
    stb r12, (r11)              # store to Main Memory
    
finish_load:
    ret
    
# storeBlock
# Function Prototype
#   r4: Disk Address
#   r5: Destination address (on disk)
#   r6: Target address (in Main Memory)

storeBlock:
    mov r8, r4          
    add r8, r8, r5          # Add target to offset to get final target address (absolute address)
    movi r9, 0              # Iterator
    mov r10, BLOCK_SIZE 
    
store_bytes:
    bge r9, r10, finish_store
    add r11, r6, r9             # target address
    ldb r12, (r11)              # load from main memory
    add r11, r8, r9             # destination address
    stbio r12, (r11)            # store to disk
    
finish_store:
    ret
    