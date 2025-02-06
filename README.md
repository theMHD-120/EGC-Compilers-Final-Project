# EGC-Compilers-Final-Project
>>> Pirnciples of Compilers Design - Windter 2025

Eqbal G Mansoori Compilers; a simple version of a compiler including mathematical expressions with specified rules and instructions. 

In this compiler, we have this <code>+</code>, <code>-</code>, <code>*</code>, <code>/</code>, <code>(</code>, <code>)</code> and <code>=</code> operators and white spaces; oppsite of real expressions, in this compiler, PLUS and MINUS operators have higher priority than MULT and DIV operators; also PLUS and MINUS operators, have Right Associativity (left in reality :); consider these specifications and read documentation files in Guidance folder ...

To determine the mentioned speciafications of PLUS and MINUS, i used an ambiguous grammar and these two lines (in <code>Parser.y</code> file):
<code>
%left MULT, DIV;
%right PLUS, MINUS;
</code>


## Main files
<code>Scanner.l</code>: Lexical analysis phase (to extract tokens and deliver them to Syntax analysis phase) ...

<code>Parser.y</code>: Syntax analysis phase (to check syntax of input expression, generate intermediate representation (three-address code) and calculate the final result of input expression;
