# In SDRAM

| Component                                  | Start Address  | End Address     |
| ------------------------------------------ | :------------: | :-------------: |
|   Exception Vector                         | 0x00000020     |                 |
|   BIOS                                     | 0x00001000     |                 |
|   Bootloader                               | 0x00007C00     |                 |
|   Free                                     | 0x00100000     |                 |
|   - I/O Temporary                          | 0x00110000     | 0x001FFFFF      |
|   -- VGA Temporary                         | 0x00110000     | 0x0011FFFF      |
|   --keyboard Temporary                     | 0x00120000     | 0x0012FFFF      |


# Memory Map

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
