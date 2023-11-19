%{
#include <stdio.h>
#include <stdlib.h>
int yylex();
int yyerror(char* msg);
extern FILE* yyin;
%}

%token DOCTYPE HTML_BODY_OPEN HTML_BODY_CLOSE
%token HEAD_OPEN HEAD_CLOSE TITLE_OPEN TITLE_CLOSE META
%token BODY_OPEN BODY_CLOSED OPEN_TAG CLOSE_TAG TEXT
%token DIGIT EQUAL QUOTED_STRING UNQUOTED_STRING EQUAL

%%

html_doc: DOCTYPE html_body { printf("HTML Document recognized!\n"); }
        ;

html_body: HTML_BODY_OPEN head body HTML_BODY_CLOSE { printf("HTML Body recognized!\n"); }
        ;

head: HEAD_OPEN title meta HEAD_CLOSE { printf("Head recognized!\n"); }
        | /* ε */ { printf("Empty Head recognized!\n"); }
        ;

title: TITLE_OPEN TEXT TITLE_CLOSE { printf("Title recognized!\n"); }
        ;

meta: META attributes CLOSE_TAG { printf("Meta recognized!\n"); }
        ;

body: BODY_OPEN content BODY_CLOSED { printf("Body recognized!\n"); }
        ;

content: element content { printf("Element content recognized!\n"); }
        | TEXT content { printf("Text content recognized!\n"); }
        | /* ε */ { printf("Empty content recognized!\n"); }
        ;

element: open_tag content close_tag { printf("Element recognized!\n"); }
        ;

open_tag: OPEN_TAG { printf("Open tag recognized!\n"); }
        ;

close_tag: CLOSE_TAG { printf("Close tag recognized!\n"); }
        ;

tag_name: LETTER (LETTER | DIGIT | '_')* { printf("Tag name: %s\n", yytext); }
        ;

attributes: attribute attributes { printf("Attributes recognized!\n"); }
        | /* ε */ { printf("Empty attributes recognized!\n"); }
        ;

attribute: attr_name EQUAL attr_value { printf("Attribute recognized!\n"); }
        ;

attr_name: LETTER (LETTER | DIGIT | '_')* { printf("Attribute name: %s\n", yytext); }
        ;

attr_value: QUOTED_STRING { printf("Quoted attribute value: %s\n", yytext); }
          | UNQUOTED_STRING { printf("Unquoted attribute value: %s\n", yytext); }
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
