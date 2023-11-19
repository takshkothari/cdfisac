%{
#include "parser.tab.h"
%}

%option noyywrap

ID [a-zA-Z][a-zA-Z0-9]*
STRING \"([^\"]*\")
TEXT .+

%%
"/" { return SL; }
"<" { return OB; }
">" { return CB; }
"=" { return EQ; }
{ID} { yylval.str = strdup(yytext); return ID; }
{STRING} { yylval.str = strdup(yytext); return STRING; }
{TEXT} { yylval.str = strdup(yytext); return TEXT; }
. { /* Ignore any other characters */ }

%%

int yywrap() {
    return 1;
}

int main() {
    yylex();
    return 0;
}