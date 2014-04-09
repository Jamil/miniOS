void parser(char* command);
char* split_line(char* command);
int str_cp(char* str1,char* str2);
void pwd_function(char* arg);
void concatinate(char* str1,char* str2);
void ls_function(char* arg);
void cd_function(char* arg);
void execute_function(char* arg);
char* get_str( int i);


void os_main(){
   
   
   newLine_load(get_str(0));
   newLine_load(get_str(1));
   
   while(1){
   
   }
   
}
	

void newLine_load(char* s){
  asm("addi sp,sp,-4"::);
  asm("stw ra,0(sp)"::);
  
  asm("call 0x1704"::);//must change to newline addres in main
  
  asm("ldw ra,0(sp)"::);
  asm("addi sp,sp,4"::);
  
  return;
}

char* get_str( int i){

  
  asm("addi r8,r0,0x110"::);
  asm("slli r8,r8,8"::);
  
  asm("muli r4,r4,4"::);
  asm("add r4,r4,r8"::);
  asm("ldw r2,(r4)"::);
 
  asm("ret"::);
}


void parser(char* command){
  int a=1;

  if(*command=='\0'){
    newLine_load(get_str(2));
    return;
  }
  
  char* args;
  args=split_line(command);
  
  if(str_cp(command,get_str(3))==1)
    pwd_function(args);
	
  if(str_cp(command,get_str(4))==1)
    execute_function(args);
	
 if(str_cp(command,get_str(5))==1)
    ls_function(args);
	
  if(str_cp(command,get_str(6))==1)
   cd_function(args);

  newLine_load(get_str(2));
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





int str_cp(char* str1,char* str2){
  int count=0;
  
  while(str1[count]==str2[count]&&str1[count]!='\0'&&str2[count]!='\0'){
      count++;
  
  }
  if(str1[count]!=str2[count])
   return 0;
  return 1;

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

  char* pwd_current;
 
 
  char *temp_response=get_str(7);
  pwd_current=temp_response;
  
  
  newLine_load(pwd_current);
  return;
  
}


void execute_function(char* arg){


  char* flags=split_line(arg);

  

  char* pwd_current;
  
  char *temp_response[100];

  *temp_response='\0';
  
  concatinate(temp_response,get_str(8));
  concatinate(temp_response,arg);
  
  
  
  pwd_current=temp_response;
  
  
  newLine_load(pwd_current);
  return;
  
}

void ls_function(char* arg){

  char* pwd_current;
 
 
  char *temp_response=get_str(9);
  pwd_current=temp_response;
  
  
  newLine_load(pwd_current);
  return;
  
}


void cd_function(char* arg){

  char* pwd_current;
 
  char* flags=split_line(arg);
 
  char *temp_response[100];

  *temp_response='\0';
  
  concatinate(temp_response,get_str(10));
  concatinate(temp_response,arg);
  
  pwd_current=temp_response;
  
  
  newLine_load(pwd_current);
  return;
  
}

