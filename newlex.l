%{
#include "parse.tab.h"
%}

%%
"<"([a-zA-Z][a-zA-Z0-9_]*)   { return OPEN_TAG; }
">"                      { return CB; }
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