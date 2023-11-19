%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
%}

%union {
    char* str;
}

%token <str> SL OB CB EQ ID STRING TEXT

%%

document: html_element { printf("Parsing successful!\n"); };

html_element: open_tag A;

open_tag: OB tag_name attribute_list CB;

A: content close_tag
  | close_tag;

close_tag: OB SL tag_name CB;

tag_name: ID;

attribute_list: attribute EQ text attribute_list
              | 
              ;

attribute: ID '=' STRING;

content: text content_prime;

content_prime: html_element content_prime
             | text content_prime
             |
             ;

text: TEXT { free($$); };

%%

int yyerror(char * msg)
{
	printf("Invalid decision statement!\n");
	return 1;
}
int main()
{
	printf("Enter decision statement:\n");
	yyparse();
}
