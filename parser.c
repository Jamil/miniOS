void parser(char* command);
void newLine(char*);
char* split_line(char* command);
int str_cp(char* str1,char* str2);
void pwd_function(char* arg);
void concatinate(char* str1,char* str2);
void ls_function(char* arg);
void cd_function(char* arg);
void execute_function(char* arg);
void store_function(char* arg);
void mkdir_function(char* arg);
void mkfile_function(char* arg);
void format_function(char* arg);
void call_program(int i);
int c_strcmp(char* a, char* b);



typedef struct inode {
  void* block_ptr[8];         // Max file size = 8 * 512 = 4kb
} inode;

typedef struct file {
  int signature;         //if 0x0000BB33
  void* parent_dir;
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
} Directory;


void c_strcpy(char* dest, const char* original);
void filesystem_init();

void load_metadata();
File* seekFile(struct directory* dir, char* filename);

void loadFile_name(struct directory* dir, char* filename,void* loc) ;

void loadFile(File* file, void* loc);
void storeFile(File* file,void* loc);

void storeFile_name(struct directory* dir, char* filename, void* loc);

void initFile(char* name, char* ext,  int bytes, void* loc, struct directory* dir);
void pwd(struct directory* dir);
void cd(char* dirName, Directory* dir);
void ls(Directory* dir) ;



#define PWD             0x001FFFF0




//int foobar asm("newLine") = 0x02000;


void parser(char* command){
  int a=1;

  if(*command=='\0'){
    newLine(">>");
    return;
  }
  
  char* args;
  args=split_line(command);
  
  if(c_strcmp(command,"pwd")==0)
    pwd_function(args);
  else if(c_strcmp(command,"execute")==0)
    execute_function(args);
	
  else if(c_strcmp(command,"ls")==0)
    ls_function(args);
	
  else if(c_strcmp(command,"cd")==0)
   cd_function(args);
   
  else if(c_strcmp(command,"mkdir")==0)
   mkdir_function(args);
   
  else if(c_strcmp(command,"load")==0)
   store_function(args);
   
   else if (c_strcmp(command,"store")==0)
    load_function();
   
  else if(c_strcmp(command,"mkfile")==0)
   mkfile_function(args);
  
  else if(c_strcmp(command,"format")==0)
   format_function(args);
   
  else if(c_strcmp(command,"update")==0)
   update_function(args);
  
  else if (c_strcmp(command,"ex")==0)
    ex_function();
   
  else
   no_fun(args);
   
  newLine(">>");
  return;
}





char* split_line(char* command){



  //declaration
  char* temp;
  temp=command;
  //whilellop
  while((*temp)!=0&&(*temp)!=' '){
    temp++;
  }
  //end of while loop
  if((*temp)==0)
    return 0;
  *temp='\0';
  return temp+1;
   
}


void concatinate(char* str1,char* str2){

  //declaration
  

  //whilellop
  char *temp=str1;
  
  while((*temp)!='\0'){
    temp++;
  }
  while((*str2)!='\0'){
    *temp=*str2;
	temp++;
	str2++;
  }
  *temp='\0';
  //end of while loop
  return;
   
}

void pwd_function(char* arg){
  Directory** dirptr = *(Directory***)PWD;
  
  pwd(dirptr);
  return;
}

void ls_function(char* arg){
  Directory** dirptr = *(Directory***)PWD;
  ls(dirptr);
  return;
}


void cd_function(char* arg){
  if (!arg) {
    newLine("No directory specified.");
    return;
  }
  
  Directory** dirptr = *(Directory***)PWD;
  cd(arg, dirptr);
  return;
}

void mkdir_function(char* arg){

  char* name=arg;
   char* pwd_current;
  char* flags=split_line(name);
 
 
 
  Directory** dirptr = *(Directory***)PWD;

  
  
  initFile(name,"dir",0, 0,dirptr);
 
  char *temp_response[100];

  *temp_response='\0';
 
  concatinate(temp_response,">> Creating directory: ");
  concatinate(temp_response,arg);
  
  pwd_current=temp_response;
  
  
  newLine(pwd_current);
  return;
}

void mkfile_function(char* arg){

  char* name=arg;
  char* pwd_current;
 
  char* exe=split_line(name);
  
  char* size_str=split_line(exe);
  
  char* loc_str=split_line(size_str);
  
  split_line(loc_str);
  
  int size=atoh(size_str);
  int loc=atoh(loc_str);
  
    Directory** dirptr = *(Directory***)PWD;

  
  initFile(name,exe,size,loc,dirptr);
 
  char *temp_response[100];

  *temp_response='\0';
  
  concatinate(temp_response,">> Creating file:");
  concatinate(temp_response,name);
  concatinate(temp_response," , at location: ");
  concatinate(temp_response,loc_str);
  
  pwd_current=temp_response;
  
  newLine(pwd_current);
  return;
}

void store_function(char* arg){

  char* name=arg;
  char* pwd_current;
  char* loc_str=split_line(name);

  split_line(loc_str);
  
  int loc=atoh(loc_str);
  
  
  Directory** dirptr = *(Directory***)PWD;

  loadFile_name(dirptr,name, loc);
 
  char *temp_response[100];

  *temp_response='\0';
  
  concatinate(temp_response,">> Storing file :");
  concatinate(temp_response,name);
  concatinate(temp_response,"m at location :");
  concatinate(temp_response,loc_str);
  
  pwd_current=temp_response;
  
  newLine(pwd_current);
  return;
}

void load_function(char* arg){

  char* name=arg;
  char* pwd_current;
  char* loc_str=split_line(name);

  split_line(loc_str);
  
  int loc=atoh(loc_str);
  
  
  Directory** dirptr = *(Directory***)PWD;

  storeFile_name(dirptr,name, loc);
 
  char *temp_response[100];

  *temp_response='\0';
  
  concatinate(temp_response,">> Storing file :");
  concatinate(temp_response,name);
  concatinate(temp_response,"m at location :");
  concatinate(temp_response,loc_str);
  
  pwd_current=temp_response;
  
  newLine(pwd_current);
  return;
}


void execute_function(char* arg){

  char* name=arg;
  char* pwd_current;
  char* loc_str=split_line(name);

  Directory** dirptr = *(Directory***)PWD;

  loadFile_name(dirptr,name, 0x00130000);
 
  char *temp_response[100];

  *temp_response='\0';
  
  concatinate(temp_response,">> Executing program:");
  concatinate(temp_response,name);

  
  pwd_current=temp_response;
  
  newLine(pwd_current);
  
  ex_function(); 
  
  return;
}


void call_program(int i){
  
  asm("addi sp,sp,-4"::);
  asm("stw ra,(sp)"::);
    
 //asm("callr r4"::);
  
  asm("stw ra,(sp)"::);
  asm("addi sp,sp,4"::);

  return;
};



void format_function(char* arg){

   char* pwd_current;
  filesystem_init();
 
  char *temp_response[100];

  *temp_response='\0';
  
  concatinate(temp_response,">> Formatted SD card.");
  
  pwd_current=temp_response;
  
  newLine(pwd_current);
  

  
  return;
}


void update_function(char* arg){

  int* loc = PWD;
  (*loc)=(int)(0x0000B0000);
  
   char* pwd_current;
  load_metadata();
 
  char *temp_response[100];

  *temp_response='\0';
  
  concatinate(temp_response,">> System updated");
  
  pwd_current=temp_response;
  
  newLine(pwd_current);
  
// call_program(0x00130000);

  return;
}

void no_fun(char* arg){


  
   char* pwd_current;

 
  char *temp_response[100];

  *temp_response='\0';
  
  concatinate(temp_response,">> Error: Not a valid command.");
  
  pwd_current=temp_response;
  
  newLine(pwd_current);
  
  //	call_program(0x00130000);

  return;
}


int atoh(char *str){
  
  
  int hex=0;
  int hex_c=0;
  while(*str!='\0'){
    if(*str>='0'&&*str<='9')
	    hex_c=*str-0x30;
	else if(*str>='a'&&*str<='z')
		hex_c=*str-0x41;
	else if(*str>='A'&&*str<='Z')
		hex_c=*str-0x61;
	else
	 	hex_c=0;
    hex=hex*16+hex_c;
	
    str++;
    }

	return hex;
}

void ex_function() {
  asm("movia r18, 0x00130000"::);
  asm("subi sp, sp, 4"::);
  asm("stw ra, (sp)"::);
  asm("callr r18"::); 
  asm("ldw ra, (sp)"::);
  asm("addi sp, sp, 4"::);
}
