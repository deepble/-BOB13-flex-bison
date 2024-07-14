/* calculator with AST */
%{
# include <stdio.h>
# include <stdlib.h>
# include <stdarg.h> /* 추가: va_start와 va_end를 사용하기 위해 필요 */
# include "fb3-1.h"
%}

%union {
    struct ast *a;
    double d;
}

/* declare tokens */
%token <d> NUMBER
%token EOL
%type <a> exp factor term

%%
calclist:
      /* nothing */
    | calclist exp EOL {
        printf("= %4.4g\n", eval($2)); /* evaluate and print the AST */
        treefree($2); /* free up the AST */
        printf("> ");
    }
    | calclist EOL { printf("> "); } /* blank line or a comment */
    ;

exp:
      factor
    | exp '+' factor { $$ = newast('+', $1, $3); }
    | exp '-' factor { $$ = newast('-', $1, $3); }
    ;

factor:
      term
    | factor '*' term { $$ = newast('*', $1, $3); }
    | factor '/' term { $$ = newast('/', $1, $3); }
    ;

term:
      NUMBER { $$ = newnum($1); }
    | '|' term { $$ = newast('|', $2, NULL); }
    | '(' exp ')' { $$ = $2; }
    | '-' term { $$ = newast('M', $2, NULL); }
    ;

%%

void yyerror(char *s, ...) {
    va_list ap;
    va_start(ap, s);
    fprintf(stderr, "%d: error: ", yylineno);
    vfprintf(stderr, s, ap);
    fprintf(stderr, "\n");
    va_end(ap); /* 추가: va_end 호출 */
}

int main(void) {
    printf("> ");
    return yyparse();
}


