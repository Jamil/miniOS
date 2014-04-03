void newLine(char*);
char* split_line(char* command);
int str_cp(char* str1,char* str2);
void pwd_function(char* arg);


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

  newLine(">>");
  return;
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
 
 
  char *temp_response="you are home";
  pwd_current=temp_response;
  
  
  newLine(pwd_current);
  return;
  
}



