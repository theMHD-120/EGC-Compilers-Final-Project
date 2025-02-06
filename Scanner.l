/*
    ||| In the name of Allah |||
    ----------------------------
    Seyed mahdi mahdavi mortazavi
    Student number: 40030490
    ----------------------------
    Principles of compilers design
    >>> Final project
    ----------------------------
    File: Scanner.l
    Description: scanner (lexical analysis) file to extract tokens of source program ...
*/

%{
#include "common.h"
#include <stdio.h>
#include "parser.h"
%}

/* Patterns --------------------------------------------------------------*/
digit [0-9]
id [a-zA-Z_][a-zA-Z0-9_]*
ws [ \t\n]

/* Tokens ----------------------------------------------------------------*/
%%
{id}          { yylval.str = yytext; return ID; }
{digit}+      { yylval.num = atoi(yytext); return NUMBER; }
"+"           { return PLUS; }
"-"           { return MINUS; }
"*"           { return MULT; }
"/"           { return DIV; }
"("           { return LPAREN; }
")"           { return RPAREN; }
"="           { return ASSIGN; }
";"           { return SEMICOLON; }
{ws}+         ; // to ignore white-spaces ...
.             { printf("Lexical Error: Invalid character %s\n", yytext); exit(1); }
%%

// Main ------------------------------------------------------------------
int yywrap() { return 1; }