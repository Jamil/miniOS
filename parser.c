void parser(char* command);
void newLine(char*);
char* split_line(char* command);
int str_cp(char* str1,char* str2);
void pwd_function(char* arg);
void concatinate(char* str1,char* str2);
void ls_function(char* arg);
void cd_function(char* arg);
void execute_function(char* arg);


int newLine asm("newLine") = 0x02000;


void parser(char* command){
  int a=1;

  if(*command=='\0'){
    newLine(">>");
    return;
  }
  
  char* args;
  args=split_line(command);
  
  if(str_cp(command,"pwd")==1)
    pwd_function(args);
	
  if(str_cp(command,"execute")==1)
    execute_function(args);
	
 if(str_cp(command,"ls")==1)
    ls_function(args);
	
  if(str_cp(command,"cd")==1)
   cd_function(args);

  newLine(">>");
  return;
}


