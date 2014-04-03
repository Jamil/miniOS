void newLine(char*);

void parser(char* command){

  if(*command=='\0'){
    newLine(">>");
    return;
  }
  
  char* args;
  split_line(command,&args);
  
  if(str_cp(command,"pwd")==1)
    pwd_function(args);

  newLine(">>");
  return;
}


void split_line(char* command,char** args_pt){

  char* temp;
  temp=command;
  while((*temp)!='\0'||(*temp)!=' '){
    temp++;
  }
  if((*temp)=='\0')
    *args_pt='\0';
  *temp='\0';
  *args_pt=temp+1;

}

int str_cp(char* str1,char* str2){
  int count;
  
  while(str1[count]==str2[count]&&str1[count]!='\0'&&str2[count]!='\0'){
      count++;
  
  }
  if(str1[count]!=str2[count])
   return 0;
  return 1;

}


void pwd_function(char* arg){

  char* pwd_current;
 
 
  char temp_response="you are home";
  pwd_current=temp_response;
  
  
  newLine(pwd_current);
  return;
  
}
