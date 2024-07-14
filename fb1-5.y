/* simplest version of calculator */
%{
#include <stdio.h>

int yylex(void);           /* yylex 함수 선언 추가 */
void yyerror(char *s);     /* yyerror 함수 선언 추가 */
%}
/* declare tokens */
%token NUMBER
%token ADD SUB MUL DIV ABS
%token EOL
%%
calclist: /* nothing */                       
    /* matches at beginning of input */
  | calclist exp EOL { printf("= %d\n", $2); } /* EOL is end of an expression */
  ;
exp: factor           /* default $$ = $1 */
  | exp ADD factor { $$ = $1 + $3; }
  | exp SUB factor { $$ = $1 - $3; }
  ;
factor: term           /* default $$ = $1 */
  | factor MUL term { $$ = $1 * $3; }
  | factor DIV term { $$ = $1 / $3; }
  ;
term: NUMBER           /* default $$ = $1 */
  | ABS term { $$ = $2 >= 0 ? $2 : -$2; }
  ;
%%
int main(int argc, char **argv)  /* 반환 타입 명시 */
{
  yyparse();
  return 0;  /* main 함수는 int 타입을 반환해야 하므로 return 추가 */
}

void yyerror(char *s)  /* 반환 타입 명시 */
{
  fprintf(stderr, "error: %s\n", s);
}

