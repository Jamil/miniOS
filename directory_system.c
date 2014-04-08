typedef struct file {
  char file_name[8];          // 0x00   Filename (if byte 1 is 2e => is directory)
  char file_extension[3];     // 0x08   File extension
  uint8_t file_attributes;    // 0x0b	  Attributes 
  char reserved_space[10]     // 0x0c	  Reserved
  uint16_t update_time;       // 0x16   Time created or last updated
  uint16_t update_date;       // 0x18   Date created or last updated
  uint16_t starting_cluster;  // 0x1a   Starting Cluster Number for file
  uint32_t file_size;         // 0x1c   Filesize (in bytes)
} File;
