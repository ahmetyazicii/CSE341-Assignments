%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define MAXSYMBOL 20
#define MAXSYMBOLLEN 20
#define MAXFUNCPARAMETERS 10
void yyerror(char *s);
int yylex();

struct sT{
	char id[MAXSYMBOLLEN];
	int val;
}; typedef struct sT symbolTable;

struct fT{
	char id[MAXSYMBOLLEN];
	symbolTable parameters[MAXFUNCPARAMETERS];
	int val;
	int paramIndex;
	
}; typedef struct fT functionTable;

char tempParamSymbols[MAXFUNCPARAMETERS][MAXSYMBOLLEN];
int tempParamSymbolsIndex = 0;
symbolTable symbols[MAXSYMBOL];
functionTable functions[MAXSYMBOL];

int symbolValue(char *symbol);
void updateSymbolValue(char *symbol, int val);
int findSymbolIndex(char *symbol,int flag);
int addNewSymbol(char *symbol);
int symbolIndex = 0;

int funcValue(char *symbol);
void updateFuncValue(char *symbol, int val);
int findFuncIndex(char *symbol);
int addNewFunc(char *symbol);
void updateFuncParam(char *fsymbol,char *psymbol);
int funcIndex = 0;

%}

%union {int ival; char id[20]; char bval;}
%start START
%token KW_AND;
%token KW_OR;
%token KW_NOT;
%token KW_EQUAL;
%token KW_LESS;
%token KW_NIL;
%token KW_LIST;
%token KW_APPEND;
%token KW_CONCAT;
%token KW_SET;
%token KW_DEFFUN;
%token KW_FOR;
%token KW_IF;
%token KW_EXIT;
%token KW_LOAD;
%token KW_DISP;
%token <bval> KW_TRUE;
%token <bval> KW_FALSE;
%token KW_DEFVAR;
%token OP_PLUS;
%token OP_MINUS;
%token OP_DIV;
%token OP_MULT;
%token OP_OP;
%token OP_CP;
%token OP_DBLMULT;
%token OP_OC;
%token OP_CC;
%token OP_COMMA;
%token COMMENT;
%token <id> IDENTIFIER
%token <ival> VALUE;
%type <ival> INPUT 
%type <ival> EXPI 
%type <bval> EXPB 
%type <id> IDLIST
%type <bval> BINARY_VALUE
/*
%type <ival> EXPLISTI 
%type <ival> VALUES
%type <ival> LISTVALUE
*/
%%

START		: INPUT START  												{printf("Syntax OK.\n");}
			| OP_OP KW_EXIT OP_CP										{exit(EXIT_SUCCESS);}
			;

INPUT		: EXPI 														{printf("Syntax OK.\n");printf("Result:%d\n",$1);}
			//| EXPLISTI
			| EXPB 														{printf("Syntax OK.\n");if($1 == 'F') printf("false\n"); else printf("true\n");}
			| COMMENT													{printf("Syntax OK.\n");}

			;

EXPI		: OP_OP OP_PLUS EXPI EXPI OP_CP 							{$$ = $3 + $4;}
			| OP_OP OP_MINUS EXPI EXPI OP_CP 							{$$ = $3 - $4;}
			| OP_OP OP_DIV EXPI EXPI OP_CP 								{$$ = $3 / $4;}
			| OP_OP OP_MULT EXPI EXPI OP_CP 							{$$ = $3 * $4;}
			| OP_OP OP_DBLMULT EXPI  OP_CP 								{$$ = $3 * $3;}
			| OP_OP KW_DISP EXPI OP_CP									{printf("Syntax OK.\n");printf("Printing : %d\n",$3);}
			| VALUE 													{$$ = $1;}
			| IDENTIFIER 												{$$ = symbolValue($1);}
			| OP_OP KW_SET IDENTIFIER EXPI OP_CP						{updateSymbolValue($3,$4); $$ = symbolValue($3); }
			| OP_OP KW_DEFVAR IDENTIFIER EXPI OP_CP						{updateSymbolValue($3,$4); $$ = symbolValue($3); }
			| OP_OP KW_DEFFUN IDENTIFIER OP_OP IDLIST OP_CP EXPI OP_CP	{
																			updateFuncValue($3,0); 
																			$$ = funcValue($3); 
																			int i;
																			for(i=0;i<tempParamSymbolsIndex;i++)
																				updateFuncParam($3,tempParamSymbols[i]);													
																			tempParamSymbolsIndex = 0;
																		}
			| OP_OP IDENTIFIER EXPI OP_CP								{printf("Syntax OK.\n");}
			| OP_OP KW_IF EXPB EXPI OP_CP								{if($3 == 'T') $$ = $4; else $$ = 0;}
			| OP_OP KW_IF EXPB EXPI EXPI OP_CP							{if($3 == 'T') $$ = $4; else $$ = $5;}
			| OP_OP KW_FOR OP_OP IDENTIFIER EXPI EXPI OP_CP EXPI OP_CP	{printf("Syntax OK.\n");}
			;  
		
EXPB		: OP_OP KW_AND EXPB EXPB OP_CP 								{$$ = ($3 && $4);}
			| OP_OP KW_OR EXPB EXPB OP_CP 								{$$ = ($3 || $4);}
			| OP_OP KW_NOT EXPB OP_CP 									{$$ = !$3;}
			| OP_OP KW_EQUAL EXPB EXPB OP_CP 							{$$ = $3 == $4;}
			| OP_OP KW_EQUAL EXPI EXPI OP_CP 							{$$ = ($3 == $4) ? 'T' : 'F';}
			| OP_OP KW_LESS EXPI EXPI OP_CP 							{$$ = ($3 < $4) ? 'T' : 'F';}
			| BINARY_VALUE 												{$$ = $1;}
			;  
		
BINARY_VALUE: KW_TRUE 													{$$ = $1;}
			| KW_FALSE													{$$ = $1;}
			;	
			 
IDLIST		: IDLIST IDENTIFIER 										{strncpy(tempParamSymbols[tempParamSymbolsIndex++],$2,MAXSYMBOLLEN);}
			| IDENTIFIER												{strncpy(tempParamSymbols[tempParamSymbolsIndex++],$1,MAXSYMBOLLEN);}
			;

/*		
EXPLISTI: OP_OP KW_CONCAT EXPLISTI EXPLISTI OP_CP	{;}
		| OP_OP KW_APPEND EXPI EXPLISTI OP_CP		{;}	
		| LISTVALUE								{;}
		| KW_NIL									{$$ = 0;}
		;
*/

/*
LISTVALUE: OP_OC OP_OP VALUES OP_CP					{;}
		 | OP_OC OP_OP OP_CP						{;}
		 | KW_NIL									{;}
		 ;


VALUES	: VALUES VALUE								{$1 = $2;}
		| VALUE										{$$ = $1;}
		;
*/

%%

int main(void){

	return yyparse();

}


int symbolValue(char *symbol){

	int index = findSymbolIndex(symbol,0);
	if(index !=-1)
		return symbols[index].val;
	else{
		printf("SYNTAX_ERROR UNDEFINED IDENTIFIER\n");
		exit(EXIT_SUCCESS);
	}

}
void updateSymbolValue(char *symbol, int val){

	int index = findSymbolIndex(symbol,1);
	if(index !=-1)
		symbols[index].val = val;
	else{
	printf("SYNTAX_ERROR UNDEFINED IDENTIFIER\n");
		exit(EXIT_SUCCESS);
	}
}

int findSymbolIndex(char *symbol,int flag){
	int i;
	for(i=0;i<symbolIndex;i++){
		if( strcmp(symbol,symbols[i].id) == 0)
			return i;
	}
	if(symbolIndex != MAXSYMBOL && flag == 1)
		return addNewSymbol(symbol);
	
	return -1;
}
int addNewSymbol(char *symbol){
	strncpy(symbols[symbolIndex].id,symbol,MAXSYMBOLLEN);
	symbols[symbolIndex].val = 0;
	return symbolIndex++;
}

int funcValue(char *symbol){
	int index = findFuncIndex(symbol);
	if(index !=-1)
		return functions[index].val;
	else{
		printf("SYNTAX_ERROR UNDEFINED FUNCTION\n");
		exit(EXIT_SUCCESS);
	}
}
void updateFuncValue(char *symbol, int val){

	int index = findFuncIndex(symbol);
	if(index !=-1)
		functions[index].val = val;
	else{
		printf("SYNTAX_ERROR UNDEFINED FUNCTION\n");
		exit(EXIT_SUCCESS);
	}
}
int findFuncIndex(char *symbol){
	int i;
	for(i=0;i<funcIndex;i++){
		if( strcmp(symbol,functions[i].id) == 0)
			return i;
	}
	if(funcIndex != MAXSYMBOL)		
		return addNewFunc(symbol);
		
	return -1;
}
int addNewFunc(char *symbol){
	strncpy(functions[funcIndex].id,symbol,MAXSYMBOLLEN);
	functions[funcIndex].val = 0;
	functions[funcIndex].paramIndex = 0;
	
	return funcIndex++;
}

void updateFuncParam(char *fsymbol,char *psymbol){
		int index = findFuncIndex(fsymbol);	
		strncpy(functions[index].parameters[functions[index].paramIndex].id,psymbol,MAXSYMBOLLEN);
		functions[index].paramIndex++;
}



void yyerror(char *s){fprintf (stderr, "SYNTAX_ERROR\n");}
