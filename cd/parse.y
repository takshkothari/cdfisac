%{
#include <stdio.h>
#include <stdlib.h>
int yylex();
int yyerror(char* msg);
extern FILE* yyin;
%}

%token DOCTYPE HTML_BODY HEAD TITLE META BODY OPEN_TAG CLOSE_TAG TEXT
%token ELEMENT ATTRIBUTES ATTRIBUTE TAG_NAME ATTR_NAME ATTR_VALUE
%token QUOTED_STRING UNQUOTED_STRING EQUAL

%%

html_doc: DOCTYPE html_body { printf("HTML Document recognized!\n"); }
        ;

html_body: HTML_BODY_OPEN HEAD body HTML_BODY_CLOSE { printf("HTML Body recognized!\n"); }
        ;

HEAD: HEAD_OPEN TITLE meta HEAD_CLOSE { printf("Head recognized!\n"); }
        | /* ε */ { printf("Empty Head recognized!\n"); }
        ;

TITLE: TITLE_OPEN TEXT TITLE_CLOSE { printf("Title recognized!\n"); }
        ;

meta: META attributes CLOSE_TAG { printf("Meta recognized!\n"); }
        ;

body: BODY_OPEN content BODY_CLOSED { printf("Body recognized!\n"); }
        ;

content: element content { printf("Element content recognized!\n"); }
        | TEXT content { printf("Text content recognized!\n"); }
        | /* ε */ { printf("Empty content recognized!\n"); }
        ;

element: OPEN_TAG content CLOSE_TAG { printf("Element recognized!\n"); }
        ;

open_tag: OPEN_TAG TAG_NAME attributes '>' { printf("Open tag recognized!\n"); }
        ;

close_tag: CLOSE_TAG TAG_NAME '>' { printf("Close tag recognized!\n"); }
        ;

TAG_NAME: LETTER (LETTER | DIGIT | '_')* { printf("Tag name: %s\n", yytext); }
        ;

attributes: attribute attributes { printf("Attributes recognized!\n"); }
        | /* ε */ { printf("Empty attributes recognized!\n"); }
        ;

attribute: ATTR_NAME EQUAL ATTR_VALUE { printf("Attribute recognized!\n"); }
        ;

ATTR_NAME: LETTER (LETTER | DIGIT | '_')* { printf("Attribute name: %s\n", yytext); }
        ;

ATTR_VALUE: QUOTED_STRING { printf("Quoted attribute value: %s\n", yytext); }
          | UNQUOTED_STRING { printf("Unquoted attribute value: %s\n", yytext); }
        ;

QUOTED_STRING: '\'' TEXT '\'' { printf("Quoted string: %s\n", yytext); }
        ;

UNQUOTED_STRING: TEXT { printf("Unquoted string: %s\n", yytext); }
        ;

TEXT: (LETTER | DIGIT)* { printf("Text: %s\n", yytext); }
        ;

LETTER: [a-zA-Z] { printf("Letter: %s\n", yytext); }
        ;

DIGIT: [0-9] { printf("Digit: %s\n", yytext); }
        ;

EQUAL: '=' { printf("Equal sign recognized!\n"); }
        ;

%%

int yyerror(char* msg)
{
    printf("Error: %s\n", msg);
    return 1;
}

int main(int argc, char** argv)
{
    yyin = fopen(argv[1], "r");
    if (!yyin)
    {
        yyerror("File Error\n");
        return 1;
    }

    yyparse();

    fclose(yyin);
    return 0;
}
