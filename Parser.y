/*
    ||| In the name of Allah |||
    ----------------------------
    Seyed mahdi mahdavi mortazavi
    Student number: 40030490
    ----------------------------
    Principles of compilers design
    >>> Final project
    ----------------------------
    File: Parser.y
    Description: parser (syntax analysis) file to check grammer of expressoins ...
    >>> Associativities are observed in grammars by %left and %right (grammar is ambiguous).
    >>> including Three address code generator functions and methods ...
*/

%{
#include "common.h"
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Globol variable
int temp_index = 0;
int final_result = 0;
char lvalue[10] = "";       // an array for left-hand side variable
int temp_results[121];      // array of value of each temporary variable

// Functions and methods
void yyerror(const char* s);
int reverse_number(int number);
void get_lvalue(char* assignment);
void generate_code(const char* op, int result, Factor arg1, Factor arg2);
void calculate_result(const char* op, int result, int argu1, int argu2, int mode);
%}

// Tokens ----------------------------------------------------------------
%union {
    int num;
    char* str;
    Factor val;
}

%token <str> ID
%token <num> NUMBER
%token PLUS MINUS MULT DIV LPAREN RPAREN ASSIGN SEMICOLON

%left MULT DIV
%right PLUS MINUS

%start stmt
%type <str> stmt
%type <val> expr

// Grammar ---------------------------------------------------------------
%%
stmt: ID ASSIGN expr SEMICOLON {          // S -> ID = E;
        get_lvalue($1);
        printf("%s = t%d;\n\n", lvalue, $3.value);
        printf("----------- Final results -----------\n");
        printf("Assignment: %s\n", $1);
        printf("Temporary variable of result: t%d\n", $3.value);
        printf("The Final Result: %d\n", final_result);
    };

expr: expr PLUS expr {                    // E -> E + E 
        $$ = (Factor){1, ++temp_index}; 
        generate_code("+", $$.value, $1, $3);
    }
    | expr MINUS expr {                   // E -> E - E 
        $$ = (Factor){1, ++temp_index};
        generate_code("-", $$.value, $1, $3);
    }
    | expr MULT expr {                    // E -> E * E
        $$ = (Factor){1, ++temp_index};
        generate_code("*", $$.value, $1, $3);
    }
    | expr DIV expr {                     // E -> E / E
        $$ = (Factor){1, ++temp_index};
        generate_code("/", $$.value, $1, $3);
    }
    | LPAREN expr RPAREN {                // E -> (E) 
        $$ = $2;
    }
    | NUMBER {                            // NUMBER
        $$ = (Factor){0, $1};              // Here, $$ is a constant number (from Factor type) ...
    };
%%

// Three address code generators -----------------------------------------
void get_lvalue(char* assignment) {
    strcpy(lvalue, ""); 
    
    int index = 0;
    while (assignment[index] != '=' && assignment[index] != '\0') {
        char temp_assign_char[2] = {assignment[index], '\0'};
        strcat(lvalue, temp_assign_char);
        index++;
    }
}

void generate_code(const char* op, int result, Factor arg1, Factor arg2) {
    int cal_mode = 0;

    if (arg1.is_temp && arg2.is_temp) {
        printf("t%d = t%d %s t%d;\n", result, arg1.value, op, arg2.value);
        cal_mode = 1;

    } else if (arg1.is_temp) {
        arg2.value = reverse_number(arg2.value);
        printf("t%d = t%d %s %d;\n", result, arg1.value, op, arg2.value);
        cal_mode = 2;

    } else if (arg2.is_temp) {
        arg1.value = reverse_number(arg1.value);
        printf("t%d = %d %s t%d;\n", result, arg1.value, op, arg2.value);
        cal_mode = 3;

    } else {
        arg1.value = reverse_number(arg1.value);
        arg2.value = reverse_number(arg2.value);
        printf("t%d = %d %s %d;\n", result, arg1.value, op, arg2.value);
        cal_mode = 4;
    }

    calculate_result(op, result, arg1.value, arg2.value, cal_mode);
}

int reverse_number(int number) {
    int reverse = 0, remainder, original = number;

    if (number % 10 == 0 || (number < 10 && number > -10))
        return number;
    else {
        while (number != 0) {
            remainder = number % 10;
            reverse = reverse * 10 + remainder;
            number /= 10;
        }
        return reverse;
    }
}

void calculate_result(const char* op, int result, int argu1, int argu2, int mode) {
    if (strcmp(op, "+") == 0) {
        switch (mode) {
        case 1: final_result = temp_results[argu1] + temp_results[argu2]; break;
        case 2: final_result = temp_results[argu1] + argu2; break;
        case 3: final_result = argu1 + temp_results[argu2]; break;  
        case 4: final_result = argu1 + argu2; break;
        }
    } 
    else if (strcmp(op, "-") == 0) {
        switch (mode) {
        case 1: final_result = temp_results[argu1] - temp_results[argu2]; break;
        case 2: final_result = temp_results[argu1] - argu2; break;
        case 3: final_result = argu1 - temp_results[argu2]; break;  
        case 4: final_result = argu1 - argu2; break;
        }
    } 
    else if (strcmp(op, "*") == 0) {
        switch (mode) {
        case 1: final_result = temp_results[argu1] * temp_results[argu2]; break;
        case 2: final_result = temp_results[argu1] * argu2; break;
        case 3: final_result = argu1 * temp_results[argu2]; break;  
        case 4: final_result = argu1 * argu2; break;
        }
    } 
    else if (strcmp(op, "/") == 0) {
        if ((mode == 1 && temp_results[argu2] == 0) || 
            (mode == 2 && argu2 == 0) || 
            (mode == 3 && temp_results[argu2] == 0) || 
            (mode == 4 && argu2 == 0)) {
            printf("Error: Division by zero!\n");
            exit(1);
        }
        switch (mode) {
        case 1: final_result = temp_results[argu1] / temp_results[argu2]; break;
        case 2: final_result = temp_results[argu1] / argu2; break;
        case 3: final_result = argu1 / temp_results[argu2]; break;  
        case 4: final_result = argu1 / argu2; break;
        }
    }
    
    final_result = reverse_number(final_result);
    temp_results[result] = final_result;
}

// Parsing and main Functions --------------------------------------------
void yyerror(const char* s) {
    fprintf(stderr, "Syntax error: %s\n", s);
    exit(1);
}

int main() {
    printf("---------- Compiler output ----------\n");
    yyparse();
    return 0;
}