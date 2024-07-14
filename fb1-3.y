%{
#include <stdio.h>
#include <stdlib.h>
%}

%token NUMBER PLUS MINUS TIMES DIVIDE ABS NEWLINE

%%
input:
    /* 비어 있음 */
    | input line
    ;

line:
    '\n'
    | exp '\n'  { printf("%d\n", $1); }
    ;

exp:
    NUMBER
    | exp PLUS exp  { $$ = $1 + $3; }
    | exp MINUS exp { $$ = $1 - $3; }
    | exp TIMES exp { $$ = $1 * $3; }
    | exp DIVIDE exp { $$ = $1 / $3; }
    | ABS exp { $$ = abs($2); }
    ;

%%
int main(void) {
    return yyparse();
}

void yyerror(const char *s) {
    fprintf(stderr, "오류: %s\n", s);
}

