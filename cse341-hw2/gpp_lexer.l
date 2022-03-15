%{
#include "y.tab.h"
#include <string.h>
%}

%%

"and"					return KW_AND;
"or"					return KW_OR;
"not" 					return KW_NOT;
"equal"					return KW_EQUAL;
"less"					return KW_LESS;
"nil"					return KW_NIL;
"list"					return KW_LIST;
"append"				return KW_APPEND;
"concat"				return KW_CONCAT;
"set"					return KW_SET;
"deffun"				return KW_DEFFUN;
"for"					return KW_FOR;
"if"					return KW_IF;
"exit"					return KW_EXIT;
"load"					return KW_LOAD;
"disp"					return KW_DISP;
"true"					{yylval.bval = yytext[0]; return KW_TRUE;}
"false"					{yylval.bval = yytext[0]; return KW_FALSE;}
"defvar"				return KW_DEFVAR;
[+]						return OP_PLUS;
[-]						return OP_MINUS;
[/]						return OP_DIV;
[*]						return OP_MULT;
[(]						return OP_OP;
[)]						return OP_CP;
[*][*]					return OP_DBLMULT;
[']						return OP_OC;
[\"]					return OP_CC;
[,]						return OP_COMMA;
[;;].*					return COMMENT;
[0]						{yylval.ival = atoi(yytext); return VALUE;}
[ \t\n]					;
[1-9][0-9]*[.]?[0-9]*	{yylval.ival = atoi(yytext); return VALUE;}
[a-zA-Z][a-zA-Z0-9-]* 	{strncpy(yylval.id,yytext,20); return IDENTIFIER;}


%%

int yywrap(void){
	return 1;
}
