%{
#include "gpp_tokens.h"
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
"true"					return KW_TRUE;
"false"					return KW_FALSE;
[+]						return OP_PLUS;
[-]						return OP_MINUS;
[/]						return OP_DIV;
[*]						return OP_MULT;
[(]						return OP_OP;
[)]						return OP_CP;
[*][*]					return OP_DBLMULT;
[']						return OP_OC;
[,]						return OP_COMMA;
[0]						return ZERO;
[.]						return -1;
[;;].*					return COMMENT;
[1-9][0-9]*[.]?[0-9]*	return VALUE;
[a-zA-Z][a-zA-Z0-9-]* 	return IDENTIFIER;
[0-9]+[a-zA-Z0-9-]* 	return NOT_IDENTIFIER;


%%

int yywrap(void){
	return 1;
}
