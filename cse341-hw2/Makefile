YACCFLAG=-d

all: program
	./program

program: yacc lex
	gcc lex.yy.c y.tab.c -o program

yacc: gpp_interpreter.y
	yacc $(YACCFLAG) gpp_interpreter.y

lex: gpp_lexer.l
	lex gpp_lexer.l

