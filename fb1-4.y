%{
#include <stdio.h>
#include <stdlib.h>

void yyerror(const char *s);
int yylex(void);
%}

%union {
    int num;
}

%token <num> NUMBER
%token ADD SUB MUL DIV ABS EOL
%type <num> exp term factor

%start input

%%
input:
    /* empty */
    | input line
    ;

line:
    exp EOL { printf("Result: %d\n", $1); }
    | EOL
    ;

exp:
    term
    | exp ADD term { $$ = $1 + $3; }
    | exp SUB term { $$ = $1 - $3; }
    ;

term:
    factor
    | term MUL factor { $$ = $1 * $3; }
    | term DIV factor { $$ = $1 / $3; }
    ;

factor:
    NUMBER { $$ = $1; }
    | '|' factor { $$ = abs($2); }
    | '(' exp ')' { $$ = $2; }
    | SUB factor { $$ = -$2; }
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

int main(void) {
    printf("> ");
    return yyparse();
}




