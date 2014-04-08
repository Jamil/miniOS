## SDRAM

| Component                                  | Start Address  | End Address     |
| ------------------------------------------ | :------------: | :-------------: |
|   Exception Vector                         | 0x00000020     |                 |
|   BIOS                                     | 0x00001000     |                 |
|   Bootloader                               | 0x00005000     |                 |
|   Operating System Base                    | 0x00010000     | 0x00018FFF      |
|   Local Fat Directory                      | 0x00080000     | 0x0009FFFF      |
|   Freelist                                 | 0x000A0000     | 0x000FFFFF      |
|   Free                                     | 0x00100000     |                 |
|   - I/O Temporary                          | 0x00110000     | 0x001FFFFF      |
|   -- VGA Temporary                         | 0x00110000     | 0x0011FFFF      |
|   -- Keyboard Temporary                    | 0x00120000     | 0x0012FFFF      |
|   Active Program                           | 0x00130000     | 0x001FFFFF      |
|   Stack Pointer                            | 0x00200000     |                 |

## SD Card

| Component                                  | Start Address  | End Address     |
| ------------------------------------------ | :------------: | :-------------: |
|   Master Boot Record (+ Bootloader)        | 0x00000000     | 0x000001FF      |
|   Kernel                                   | 0x00000200     | 0x0000FFFF      |
|   Root Directory                           | 0x00010000     | 0x000101FF      |
|   Free List                                | 0x00010200     | 0x000103FF      |
|   Blocks                                   | 0x00010400     | 0x007FFFFF      |

## Memory Map

| Component                                  | Start Address  |
| ------------------------------------------ | :------------: |
| **CPU**                                    | 0x0a000000     | 
| **JTAG_UART**                              | 0x10001000     | 
| **Interval_Timer**                         | 0x10002000     | 
| **sysid**                                  | 0x10002020     | 
| **SDRAM**                                  | 0x00000000     | 
| **END**                                    | 0x007FFFFF     | 
| **Red_LEDs**                               | 0x10000000     | 
| **Green_LEDs**                             | 0x10000010     | 
| **HEX3_HEX0** | 0x10000020     | 
| **HEX7_HEX4** | 0x10000030     | 
| **Slider_Switches** | 0x10000040     | 
| **Pushbuttons** | 0x10000050     | 
| **Expansion_JP1** | 0x10000060     | 
| **Expansion_JP2** | 0x10000070     | 
| **Serial_Port** | 0x10001010     | 
| **AV_Config** | 0x10003000     | 
| **Audio** | 0x10003040     | 
| **Char_LCD_16x2** | 0x10003050     | 
| **PS2_Port** | 0x10000100     | 
| **SRAM** | 0x08000000     | 
| **VGA_Pixel_Buffer** | 0x10003020     | 
| **VGA_Char_Buffer** | 0x10003030     | 
| **alon_char_control_slave** | 0x09000000     | 
| **External_Clocks** | 0x10002030     | 
| **Altera_UP_SD_Card_Avalon_Interface_** | 0x00800000     | 
| **Altera_UP_Flash_Memory_IP_Core_Avalon**  | 0x01000000     | 



