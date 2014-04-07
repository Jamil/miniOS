void parser(char* command);
void newLine(char*);
char* split_line(char* command);
int str_cp(char* str1,char* str2);
void pwd_function(char* arg);
void concatinate(char* str1,char* str2);
void ls_function(char* arg);
void cd_function(char* arg);
void execute_function(char* arg);


//int foobar asm("newLine") = 0x02000;


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
 
 
  char *temp_response="you are home";
  pwd_current=temp_response;
  
  
  newLine(pwd_current);
  return;
  
}


void execute_function(char* arg){


  char* flags=split_line(arg);

  

  char* pwd_current;
  
  char *temp_response[100];

  *temp_response='\0';
  
  concatinate(temp_response,"executing program ");
  concatinate(temp_response,arg);
  
  
  
  pwd_current=temp_response;
  
  
  newLine(pwd_current);
  

  return;
  
}

void ls_function(char* arg){

  char* pwd_current;
 
 
  char *temp_response="There is nothing here";
  pwd_current=temp_response;
  
  
  newLine(pwd_current);
  return;
  
}


void cd_function(char* arg){

  char* pwd_current;
 
  char* flags=split_line(arg);
 
  char *temp_response[100];

  *temp_response='\0';
  
  concatinate(temp_response,"goin to: ");
  concatinate(temp_response,arg);
  
  pwd_current=temp_response;
  
  
  newLine(pwd_current);
  return;
  
}

