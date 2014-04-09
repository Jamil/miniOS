#define SD_ADD		0x00800000
#define DIR_LOCATION 	0x000B0000
#define FREE_LIST 	0x000A0000
#define file_location 	0x000C0000	
#define BLOCK_START   	0x00010A00

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


typedef struct inode {
  void* block_ptr[8];         // Max file size = 8 * 512 = 4kb
} inode;

typedef struct file {
  int signature;         //if 0x0000BB33
  void* sub_dir;
  char file_name[20];         
  char file_extension[4];    
  inode node;
} File;

typedef struct freelist {
  void* block_ptr[128];
} freelist;

typedef struct directory  {
  int signature;         //0x0000BB33
  void* parent_dir;
  char file_name[12];         
  char file_extension[4];    
  File* files[8]; 
}  Directory;

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
  freelist* fl = (freelist*)FREE_LIST;
  int i = 0;
  for (i = 0; i < 128; i++) {
    fl->block_ptr[i] = (void*)(512 * i + BLOCK_START);
  }
  storeSDBlock(SD_ADDR, 0x10800, FREE_LIST);
  
  // Initialize dir
  
  char* all_dir = (char*)DIR_LOCATION;
  for(i=0;i<512*4;i++)
    all_dir[i]='\0';
  
  
  struct directory* dir = (struct directory*)DIR_LOCATION;
 
 for( i=0;i<8;i++)
    dir->files[i]=0;
	
  c_strcpy(dir->file_name, "dir");
  dir->sub_dir=dir;
  dir->signature=0xbb33;
  
  storeSDBlock(SD_ADDR, 0x00010000, DIR_LOCATION);
  storeSDBlock(SD_ADDR, 0x00010000, DIR_LOCATION+0x200);
  storeSDBlock(SD_ADDR, 0x00010000, DIR_LOCATION+0x400);
  storeSDBlock(SD_ADDR, 0x00010000, DIR_LOCATION+0x600);

   
}

void load_metadata() {
  // Initialize freelist

  loadSDBlock(SD_ADDR, 0x10800, FREE_LIST);
  
  loadSDBlock(SD_ADDR, 0x00010000, DIR_LOCATION);
  loadSDBlock(SD_ADDR, 0x00010000, DIR_LOCATION+0x200);
  loadSDBlock(SD_ADDR, 0x00010000, DIR_LOCATION+0x400);
  loadSDBlock(SD_ADDR, 0x00010000, DIR_LOCATION+0x600);

   
}

/** file_seek
  * Pass this the address of a directory *loaded locally in memory*, and the name of a file. Will return a pointer to the file structure
 **/
File* seekFile(struct directory* dir, char* filename) {
   int i;
  for ( i = 0; i < 8; i++) {
    if (!c_strcmp(dir->files[i]->file_name, filename))
      return dir->files[i];
  }
  return (File*)DIR_LOCATION;
}

void loadFile_name(struct directory* dir, char* filename,void* loc) {
    
	loadFile(seekFile(dir, filename),loc);
}

void loadFile(File* file, void* loc) {
  int done = 0;
  int i;
  for (i = 0; i < 8; i++) {
    if (file->node.block_ptr[i] == 0)
      break;
    loadSDBlock(SD_ADDR, file->node.block_ptr[i], loc + (i * 512));
  }
}

void storeFile(File* file,void* loc){
  int done = 0;
  int i;
  for (i = 0; i < 8; i++) {
    if (file->node.block_ptr[i] == 0)
      break;
    storeSDBlock(SD_ADDR, file->node.block_ptr[i], loc + (i * 512));
  }
}
void storeFile_name(struct directory* dir, char* filename, void* loc) {
    
	storeFile(seekFile(dir, filename),loc);
}



void initFile(char* name, char* ext,  int bytes, void* loc, struct directory* dir) {
  
  int blocks = bytes/512 + 1;
  
  int k;
  for(k=0;dir->files[k]!=0;k++){
  
  }
  
  void* all_dir = (struct all_dir*)DIR_LOCATION;
  int j;
  for(j=0;((struct file*)(all_dir+j*64))->signature==0xbb33;j++){
  }
  
  dir->files[k]=(all_dir+j*64);
  
  File* file = (File*)(struct file*)(all_dir+j*64);
  c_strcpy(file->file_name, name);
  
  int i;
  for ( i = 0; i < 3; i++)
    file->file_extension[i] = ext[i];
	
  file->file_extension[3]='\0';
  if(c_strcmp(file->file_extension,"dir")==0)
      blocks=0;
	
  file->sub_dir=DIR_LOCATION;
  file->signature=0xbb33;
	
	
  storeSDBlock(SD_ADDR, 0x00010000, DIR_LOCATION);
  storeSDBlock(SD_ADDR, 0x00010000, DIR_LOCATION+0x200);
  storeSDBlock(SD_ADDR, 0x00010000, DIR_LOCATION+0x400);
  storeSDBlock(SD_ADDR, 0x00010000, DIR_LOCATION+0x600);


  
  
  // Load free list and look for free blocks
  // Initialize freelist
  int inserted = 0;
  freelist* fl = (freelist*)0x000A0000;
  
  for ( i = 0; i < 128 && inserted < blocks; i++) {
    if (fl->block_ptr[i]) {
      file->node.block_ptr[inserted] = fl->block_ptr[i];
      storeSDBlock(SD_ADDR, fl->block_ptr[i], loc + inserted * 512);
      fl->block_ptr[i] = (void*)0;
      inserted++;
    }
  }
  storeSDBlock(SD_ADDR, 0x10800, FREE_LIST);
}
