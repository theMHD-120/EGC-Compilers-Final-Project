# EGC-Compilers-Final-Project
>>> Pirnciples of Compilers Design - Windter 2025

Eqbal G Mansoori Compilers; a simple version of a compiler including mathematical expressions with specified rules and instructions. 

In this compiler, we have this <code>+</code>, <code>-</code>, <code>*</code>, <code>/</code>, <code>(</code>, <code>)</code> and <code>=</code> operators and white spaces; oppsite of real expressions, in this compiler, PLUS and MINUS operators have higher priority than MULT and DIV operators; also PLUS and MINUS operators, have Right Associativity (left in reality :); consider these specifications and read documentation files in Guidance folder ...

## Main files
1) <code>Scanner.l</code>: Lexical analysis phase (to extract tokens and deliver them to Syntax analysis phase) ...
2) <code>Parser.y</code>: Syntax analysis phase (to check syntax of input expression, generate intermediate representation (three-address code) and calculate the final result of input expression;
3) <code>common.h</code>: A common header file (between <code>.l</code> and <code>.y</code> files) that contains a Factor struct to determine type of numbers during calculations (are they Numbers or Temporary variables?) ...

## Parser.y
1) To determine Tokens:
   <code>
      %token <str> ID
      %token <num> NUMBER
      %token PLUS MINUS MULT DIV LPAREN RPAREN ASSIGN SEMICOLON
   </code>
2) To determine the mentioned speciafications of PLUS and MINUS, i used an ambiguous grammar and these two lines (in <code>Parser.y</code> file):
   <code>
      %left MULT DIV
      %right PLUS MINUS
   </code>
3) To determine start symbol and types of grammar Non-terminals:
   <code>
      %start stmt
      %type <str> stmt
      %type <val> expr
   </code>

## Guidance (Help) files
1) <code>Lex & Flex.pdf</code>: What is Lex and Flex? ...
2) <code>Yacc & Bison.pdf</code>: What is Yacc and Bison? ...
3) <code>Project Definition.pdf</code>: The problem statement and project definition.
4) <code>Project Report & Description.pdf</code>: A complete description and report of the project and used codes.

## How to run?
I have executed this files in Windows Subsystem for Linux (WSL); WSL is a feature of Windows that allows you to run a Linux environment on your Windows machine, without the need for a separate virtual machine or dual booting.

Using these lines (in order), we can execute <code>.l</code> and <code>.y</code> codes in WSl (last line is an example for input expression) ...
      bison -d -o parser.c Parser.y
      flex -o lexer.c Scanner.l
      gcc -o compiler parser.c lexer.c -lm
      echo "b = 20*(24/6)+45 -60;" | ./compiler
