#include<stdio.h>
#include<stdlib.h>
extern void yyerror(); 
extern int  yylex();
#define YYDEBUG 1
#include "y.tab.c"
#include "lex.yy.c"
extern FILE *yyin;

int main(int argc, char *argv[])
{
	init_symtable();
	char str[100];
	 FILE *fp;
	 int i;
	 if(argc>1)
	 { 
	 	fp = fopen(argv[1],"r");
	 }
	 if(!fp)
	 {
		printf("\n File not found");  
		exit(0);
	 }
	 yyin = fp;
	yyparse();
	return 0;
}
