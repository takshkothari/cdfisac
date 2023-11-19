%{
#include <stdio.h>
#include <stdlib.h>
int yylex();
int yyerror(char* msg);
extern FILE* yyin;
%}

%token OPEN_TAG CB CLOSE_TAG TEXT DIGIT EQUAL QUOTED_STRING UNQUOTED_STRING CB

%%

element: open_tag content close_tag { printf("Element recognized: %s\n", yylex); }
        ;

open_tag: OPEN_TAG attributes CB { printf("Open tag recognized!\n"); }
        ;

content: element content { printf("Element content recognized!\n"); }
        | TEXT content { printf("Text content recognized!\n"); }
        | /* ε */ { printf("Empty content recognized!\n"); }
        ;

close_tag: CLOSE_TAG { printf("Close tag recognized!\n"); }
        ;

attributes: attribute attributes { printf("Attributes recognized!\n"); }
        | /* ε */ { printf("Empty attributes recognized!\n"); }
        ;

attribute: attr_name EQUAL attr_value { printf("Attribute recognized!\n"); }
        ;

attr_name: TEXT { printf("Attribute name: %s\n", yylex); }
        ;

attr_value: QUOTED_STRING { printf("Quoted attribute value: %s\n", yylex); }
          | UNQUOTED_STRING { printf("Unquoted attribute value: %s\n", yylex); }
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
