#include <stdio.h>
#include <string.h>
#include "gpp_tokens.h"

/* 	
	Externing function from the c ile which is created by lex.
	This function returns a value indicating the type of token that has been obtained.
*/	
extern int yylex();
/* 	
	Externing string from the c ile which is created by lex.
	This string is a the token that has been obtained.
*/	
extern char* yytext;


/* This function prints the obtained token */
void print_corresponding(int token_number);

int main(){

	int new_token;
	int temp_token;
	char temp_token_text[50];
	int temp_token2;
	
	new_token = yylex();	/* getting next token  */
	
	while(new_token){

		if(new_token == -1){	/* if the token is a '.' that means exit from program. */
			printf("'.'_FOUND_PROGRAM_TERMINATED\n");
			return 1;
		}
		if(new_token == NOT_IDENTIFIER){	/* if the identifier starting with digit. */
			printf("SYNTAX_ERROR %s cannot be tokenized.Identifiers cannot start with digits\n",yytext);
			return 1;
		}
		
		print_corresponding(new_token);

		/* 
			If the token is '(', then check the next token. 
			If it is a keyword of language, it is okay.
			If it is a identifier, the next token of identifier must be ')' or '('. Otherwise print syntax error.
			Example: 
			(list 1 2) is okay.
			(liste 1 2) is not okay (print error message here).
			(liste) is okay.
			(liste(+ x 1)) is okay.
		*/
		if(new_token == OP_OP){
			temp_token = yylex();
			strcpy(temp_token_text,yytext);
				
				if(temp_token == IDENTIFIER){
					temp_token2 = yylex();
					if(temp_token2 != OP_CP && temp_token2 != OP_OP ){
						printf("SYNTAX_ERROR %s cannot be tokenized\n",temp_token_text);
						return 1;
					}
					else{
						print_corresponding(temp_token);
						print_corresponding(temp_token2);
					}

				}
				else
					print_corresponding(temp_token);
		
		}
		new_token = yylex();
	}
	return 0;
}


/* Printing the tokens corresponding to the given token number which is obtained from lexer. */
void print_corresponding(int token_number){

	switch(token_number){
		case KW_AND:		printf("KW_AND\n"); 		break;
		case KW_OR:			printf("KW_OR\n"); 			break;
		case KW_NOT:		printf("KW_NOT\n"); 		break;
		case KW_EQUAL:		printf("KW_EQUAL\n"); 		break;
		case KW_LESS:		printf("KW_LESS\n"); 		break;
		case KW_NIL:		printf("KW_NIL\n"); 		break;
		case KW_LIST:		printf("KW_LIST\n"); 		break;
		case KW_APPEND:		printf("KW_APPEND\n"); 		break;
		case KW_CONCAT:		printf("KW_CONCAT\n"); 		break;
		case KW_SET:		printf("KW_SET\n"); 		break;
		case KW_DEFFUN:		printf("KW_DEFFUN\n"); 		break;
		case KW_FOR:		printf("KW_FOR\n"); 		break;
		case KW_IF:			printf("KW_IF\n"); 			break;
		case KW_EXIT:		printf("KW_EXIT\n"); 		break;
		case KW_LOAD:		printf("KW_LOAD\n"); 		break;
		case KW_DISP:		printf("KW_DISP\n"); 		break;
		case KW_TRUE:		printf("KW_TRUE\n"); 		break;
		case KW_FALSE:		printf("KW_FALSE\n"); 		break;
		case OP_PLUS:		printf("OP_PLUS\n"); 		break;
		case OP_MINUS:		printf("OP_MINUS\n"); 		break;
		case OP_DIV:		printf("OP_DIV\n"); 		break;
		case OP_DIV2:		printf("OP_DIV2\n"); 		break;
		case OP_MULT:		printf("OP_MULT\n"); 		break;
		case OP_OP:			printf("OP_OP\n"); 			break;
		case OP_CP:			printf("OP_CP\n"); 			break;
		case OP_DBLMULT:	printf("OP_DBLMULT\n"); 	break;
		case OP_OC:			printf("OP_OC\n"); 			break;
		case OP_CC:			printf("OP_CC\n"); 			break;
		case OP_COMMA:		printf("OP_COMMA\n"); 		break;
		case COMMENT:		printf("COMMENT\n"); 		break;
		case VALUE:			printf("VALUE\n"); 			break;
		case IDENTIFIER:	printf("IDENTIFIER\n"); 	break;
		case ZERO:			printf("ZERO\n"); 			break;
		default: 			printf("SYNTAX_ERROR\n"); 	break;
		
	}
}

