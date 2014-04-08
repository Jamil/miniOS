#define SD_ADDR 0x00800000

typedef struct inode {
  void* block_ptr[8];         // Max file size = 8 * 512 = 4kb
} inode;

typedef struct file {
  char file_name[20];         
  char file_extension[3];    
  inode node;
} File;

typedef struct freelist {
  void* block_ptr[128];
} freelist;

typedef struct directory {
  File* files[128];
} Directory;

int c_strcmp(char* a, char* b) {
  while (1) {
    if (*a != *b)
      return (int)(*a - *b);
    else if (*a == '\0')
      return 0;
    a++;
    b++;
  }
}

int main() {
  return 0;
}

void c_strcpy(char* dest, const char* original) {
  while (*original != '\0') {
    *dest = *original;
    *original++;
    *dest++;
  }
  *dest = '\0';
}

/** filesystem_init
  * Should be called to initialize the filesystem from scratch
  * Calling this function essentially erases all usable information about the filesystem
 **/
void filesystem_init() {
  // Initialize freelist
  freelist* fl = (freelist*)0x000A0000;
  for (int i = 0; i < 128; i++) {
    fl->block_ptr[i] = (void*)(512 * i + 0x10400);
  }
  storeSDBlock(SD_ADDR, 0x10200, &fl);
}

/** file_seek
  * Pass this the address of a directory *loaded locally in memory*, and the name of a file. Will return a pointer to the file structure
 **/
File* seekFile(struct directory* dir, char* filename) {
  for (int i = 0; i < 128; i++) {
    if (!c_strcmp(dir->files[i]->file_name, filename))
      return dir->files[i];
  }
  return (File*)0;
}

void loadFile(File* file, void* loc) {
  int done = 0;
  for (int i = 0; i < 8; i++) {
    if (file->node.block_ptr[i] == 0)
      break;
    loadSDBlock(SD_ADDR, file->node.block_ptr[i], loc + (i * 512));
  }
}

void storeFile(File* file, void* loc) {
  int done = 0;
  for (int i = 0; i < 8; i++) {
    if (file->node.block_ptr[i] == 0)
      break;
    storeSDBlock(SD_ADDR, file->node.block_ptr[i], loc + (i * 512));
  }
}

void initFile(char* name, char* ext, void* loc, int bytes) {
  int blocks = bytes/512 + 1;
  File* file = (File*)0x000B0000;
  c_strcpy(file->file_name, name);
  
  for (int i = 0; i < 3; i++)
    file->file_extension[i] = ext[i];
  
  // Load free list and look for free blocks
  // Initialize freelist
  int inserted = 0;
  freelist* fl = (freelist*)0x000A0000;
  for (int i = 0; i < 128 && inserted < blocks; i++) {
    if (fl->block_ptr[i]) {
      file->node.block_ptr[inserted] = fl->block_ptr[i];
      storeSDBlock(SD_ADDR, fl->block_ptr[i], loc + inserted * 512);
      fl->block_ptr[i] = (void*)0;
      inserted++;
    }
  }
}
