%{
#include "parse.tab.h"
%}

%%
"<!DOCTYPE html>"    { return DOCTYPE; }
"<html>"             { return HTML_BODY_OPEN; }
"</html>"            { return HTML_BODY_CLOSE; }
"<head>"             { return HEAD_OPEN; }
"</head>"            { return HEAD_CLOSE; }
"<title>"            { return TITLE_OPEN; }
"</title>"           { return TITLE_CLOSE; }
"<body>"             { return BODY_OPEN; }
"</body>"            { return BODY_CLOSED; }
"<meta"              { return META; }
">"                  { return CB; }
"<"([a-zA-Z][a-zA-Z0-9_]*)">"   { return OPEN_TAG; }
"</"([a-zA-Z][a-zA-Z0-9_]*)">"  { return CLOSE_TAG; }
[ \t\n]              ; // ignore whitespaces
[a-zA-Z][a-zA-Z0-9_ .]*   { return TEXT; }
[0-9]+               { return DIGIT; }
"="                  { return EQUAL; }
\"[^\"]         { return QUOTED_STRING; }
[^ \t\n]+            { return UNQUOTED_STRING; }


%%

int yywrap() {
    return 1;
}