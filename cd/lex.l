%{
#include <stdio.h>
#include "parse.tab.h"
%}

%%
"<!DOCTYPE html>"    { return DOCTYPE; }
"<html>"             { return HTML_BODY; }
"</html>"            { return HTML_BODY; }
"<head>"             { return HEAD; }
"</head>"            { return HEAD; }
"<title>"            { return TITLE; }
"</title>"           { return TITLE; }
"<body>"             { return BODY; }
"</body>"            { return BODY; }
"<meta"              { return META; }
"<"([a-zA-Z][a-zA-Z0-9_]*)">"   { return OPEN_TAG; }
"</"([a-zA-Z][a-zA-Z0-9_]*)">"  { return CLOSE_TAG; }
[a-zA-Z][a-zA-Z0-9_]*   { return TEXT; }
[0-9]+               { return DIGIT; }
"="                  { return EQUAL; }
\"[^\"]         { return QUOTED_STRING; }
[^ \t\n]+            { return UNQUOTED_STRING; }
[ \t\n]              ; // ignore whitespaces

%%

int yywrap() {
    return 1;
}

int main() {
    yylex();
    return 0;
}