%{
int yylex();
void yyerror(const char *s);
char *id[100];
char *type[100];
#include "hashing.c"
#include<stdio.h>
#include<stdlib.h>
#define SYMTABSIZE	997
#define IDLENGTH	15
#define NOTHING		struct value temp;temp.use="none";
#define INDENTOFFSET	2

enum ParseTreeNodeType {UNARY_OPERATOR,UNARY_EXPRESSION,TYPE_SPECIFIER,TYPE_QUALIFIER_LIST,TYPE_QUALIFIER,TYPE_NAME,TRANSLATION_UNIT,STRUCT_DECLARATOR,STRUCT_DECLARATOR_LIST,SPECIFIER_QUALIFIER_LIST,STRUCT_DECLARATION,STRUCT_DECLARATION_LIST,STRUCT_OR_UNION,STRUCT_OR_UNION_SPECIFIER,STORAGE_CLASS_SPECIFIER,STATEMENT,STATIC_ASSERT_DECLARATION,SHIFT_EXPRESSION,STRING,SELECTION_STATEMENT,RELATIONAL_EXPRESSION,PROGRAM,PRIMARY_EXPRESSION,POSTFIX_EXPRESSION,POINTER,PARAMETER_DECLARATION,PARAMETER_LIST,PARAMETER_TYPE_LIST,MULTIPLICATIVE_EXPRESSION,LOGICAL_OR_EXPRESSION,LOGICAL_AND_EXPRESSION,LABELED_STATEMENT,JUMP_STATEMENT,ITERATION_STATEMENT,INITIALIZER_LIST,INITIALIZER,INIT_DECLARATOR,INIT_DECLARATOR_LIST,INCLUSIVE_OR_EXPRESSION,IDENTIFIER_LIST,GENERIC_ASSOCIATION,GENERIC_ASSOC_LIST,GENERIC_SELECTION,FUNCTION_SPECIFIER,FUNCTION_DEFINITION,EXTERNAL_DECLARATION,EXPRESSION_STATEMENT,EXPRESSION,EXCLUSIVE_OR_EXPRESSION,EQUALITY_EXPRESSION,ENUMERATOR,ENUMERATOR_LIST,ENUM_SPECIFIER,DIRECT_ABSTRACT_DECLARATOR,DIRECT_DECLARATOR,DESIGNATOR,DESIGNATOR_LIST,DESIGNATION,DECLARATION_LIST,DECLARATOR,DECLARATION_SPECIFIERS,DECLARATION,CONSTANT_EXPRESSION,CONSTANT,CONDITIONAL_EXPRESSION,COMPOUND_STATEMENT,CAST_EXPRESSION,BLOCK_ITEM,BLOCK_ITEM_LIST,ASSIGNMENT_OPERATOR,ASSIGNMENT_EXPRESSION,ARGUMENT_EXPRESSION_LIST,AND_EXPRESSION,ALIGNMENT_SPECIFIER,ADDITIVE_EXPRESSION,ABSTRACT_DECLARATOR};

const char* labels[] = {"UNARY_OPERATOR","UNARY_EXPRESSION","TYPE_SPECIFIER","TYPE_QUALIFIER_LIST","TYPE_QUALIFIER","TYPE_NAME","TRANSLATION_UNIT","STRUCT_DECLARATOR","STRUCT_DECLARATOR_LIST","SPECIFIER_QUALIFIER_LIST","STRUCT_DECLARATION","STRUCT_DECLARATION_LIST","STRUCT_OR_UNION","STRUCT_OR_UNION_SPECIFIER","STORAGE_CLASS_SPECIFIER","STATEMENT","STATIC_ASSERT_DECLARATION","SHIFT_EXPRESSION","STRING","SELECTION_STATEMENT","RELATIONAL_EXPRESSION","PROGRAM","PRIMARY_EXPRESSION","POSTFIX_EXPRESSION","POINTER","PARAMETER_DECLARATION","PARAMETER_LIST","PARAMETER_TYPE_LIST","MULTIPLICATIVE_EXPRESSION","LOGICAL_OR_EXPRESSION","LOGICAL_AND_EXPRESSION","LABELED_STATEMENT","JUMP_STATEMENT","ITERATION_STATEMENT","INITIALIZER_LIST","INITIALIZER","INIT_DECLARATOR","INIT_DECLARATOR_LIST","INCLUSIVE_OR_EXPRESSION","IDENTIFIER_LIST","GENERIC_ASSOCIATION","GENERIC_ASSOC_LIST","GENERIC_SELECTION","FUNCTION_SPECIFIER","FUNCTION_DEFINITION","EXTERNAL_DECLARATION","EXPRESSION_STATEMENT","EXPRESSION","EXCLUSIVE_OR_EXPRESSION","EQUALITY_EXPRESSION","ENUMERATOR","ENUMERATOR_LIST","ENUM_SPECIFIER","DIRECT_ABSTRACT_DECLARATOR","DIRECT_DECLARATOR","DESIGNATOR","DESIGNATOR_LIST","DESIGNATION","DECLARATION_LIST","DECLARATOR","DECLARATION_SPECIFIERS","DECLARATION","CONSTANT_EXPRESSION","CONSTANT","CONDITIONAL_EXPRESSION","COMPOUND_STATEMENT","CAST_EXPRESSION","BLOCK_ITEM","BLOCK_ITEM_LIST","ASSIGNMENT_OPERATOR","ASSIGNMENT_EXPRESSION","ARGUMENT_EXPRESSION_LIST","AND_EXPRESSION","ALIGNMENT_SPECIFIER","ADDITIVE_EXPRESSION","ABSTRACT_DECLARATOR"};
#ifndef TRUE
#define TRUE 1
#endif

#ifndef FALSE
#define FALSE 0
#endif

#ifndef NULL
#define NULL 0
#endif
/*-------------Parse tree------------*/
/*struct value{
	union {
		int i;
		int f;
		char *s;
	} v;
	char *use;
};*/
struct treeNode {
	struct value{
		union {
			int i;
			float f;
			char *s;
		} v;
		char *use;
	} val;
	int nodeIdentifier;
	struct treeNode *first;
	struct treeNode *second;
	struct treeNode *third;
	struct treeNode *fourth;
};
typedef struct treeNode TREE_NODE;
typedef TREE_NODE *BINARY_TREE;
BINARY_TREE create_node(struct value,int,BINARY_TREE,BINARY_TREE,BINARY_TREE,BINARY_TREE);

/*-------------Symbol Table----------*/
struct symTabNode {
	char identifier[IDLENGTH];
	char type[100];
};
typedef struct symTabNode SYMTABNODE;
typedef SYMTABNODE *SYMTABNODEPTR;

SYMTABNODEPTR symTab[SYMTABSIZE];

int currentSymTabSize=0;
void PrintTree(BINARY_TREE);
%}
%union 	{
	int iVal;
	float fVal;
	char *sVal;
	BINARY_TREE tVal;
}

%type <tVal> unary_operator unary_expression type_specifier type_qualifier_list type_qualifier type_name translation_unit struct_declarator struct_declarator_list specifier_qualifier_list struct_declaration struct_declaration_list struct_or_union struct_or_union_specifier storage_class_specifier statement static_assert_declaration shift_expression string selection_statement relational_expression program primary_expression postfix_expression pointer parameter_declaration parameter_list parameter_type_list multiplicative_expression logical_or_expression logical_and_expression labeled_statement jump_statement iteration_statement initializer_list initializer init_declarator init_declarator_list inclusive_or_expression identifier_list generic_association generic_assoc_list generic_selection function_specifier function_definition external_declaration expression_statement expression exclusive_or_expression equality_expression enumeration_constant enumerator enumerator_list enum_specifier direct_abstract_declarator direct_declarator designator designator_list designation declaration_list declarator declaration_specifiers declaration constant_expression constant conditional_expression compound_statement cast_expression block_item block_item_list assignment_operator assignment_expression argument_expression_list and_expression alignment_specifier additive_expression abstract_declarator

%token	IDENTIFIER I_CONSTANT F_CONSTANT STRING_LITERAL FUNC_NAME SIZEOF
%type <iVal> I_CONSTANT
%type <fVal> F_CONSTANT
%type <sVal> IDENTIFIER STRING_LITERAL
%token	PTR_OP INC_OP DEC_OP LEFT_OP RIGHT_OP LE_OP GE_OP EQ_OP NE_OP
%token	AND_OP OR_OP MUL_ASSIGN DIV_ASSIGN MOD_ASSIGN ADD_ASSIGN
%token	SUB_ASSIGN LEFT_ASSIGN RIGHT_ASSIGN AND_ASSIGN
%token	XOR_ASSIGN OR_ASSIGN
%token	TYPEDEF_NAME ENUMERATION_CONSTANT

%token	TYPEDEF EXTERN STATIC AUTO REGISTER INLINE
%token	CONST RESTRICT VOLATILE
%token	BOOL CHAR SHORT INT LONG SIGNED UNSIGNED FLOAT DOUBLE VOID
%token	COMPLEX IMAGINARY 
%token	STRUCT UNION ENUM ELLIPSIS

%token	CASE DEFAULT IF ELSE SWITCH WHILE DO FOR GOTO CONTINUE BREAK RETURN

%token	ALIGNAS ALIGNOF ATOMIC GENERIC NORETURN STATIC_ASSERT THREAD_LOCAL

%start program
%%

abstract_declarator
	: pointer direct_abstract_declarator
	{NOTHING
		$$ = create_node(temp,ABSTRACT_DECLARATOR,$1,$2,NULL,NULL);
	}
	| pointer
	{NOTHING
		$$ = create_node(temp,ABSTRACT_DECLARATOR,$1,NULL,NULL,NULL);
	}
	| direct_abstract_declarator
	{NOTHING
		$$ = create_node(temp,ABSTRACT_DECLARATOR,$1,NULL,NULL,NULL);
	}
	;

additive_expression
	: multiplicative_expression
	{NOTHING
		$$ = create_node(temp,ADDITIVE_EXPRESSION,$1,NULL,NULL,NULL);
	}
	| additive_expression '+' multiplicative_expression 
	{NOTHING
		$$ = create_node(temp,ADDITIVE_EXPRESSION,$1,$3,NULL,NULL);
	}
	| additive_expression '-' multiplicative_expression
	{NOTHING
		$$ = create_node(temp,ADDITIVE_EXPRESSION,$1,$3,NULL,NULL);
	}
	;


alignment_specifier
	: ALIGNAS '(' type_name ')'
	{	struct value temp;
		temp.v.s = "=";
		temp.use = "alignas";
		$$ = create_node(temp,ALIGNMENT_SPECIFIER,$3,NULL,NULL,NULL);
	}
	| ALIGNAS '(' constant_expression ')'
	{	struct value temp;
		temp.v.s = "alignas";
		temp.use = "string";
		$$ = create_node(temp,ALIGNMENT_SPECIFIER,$3,NULL,NULL,NULL);
	}
	;


and_expression
	: equality_expression
	{NOTHING
		$$ = create_node(temp,AND_EXPRESSION,$1,NULL,NULL,NULL);
	}
	| and_expression '&' equality_expression
	{NOTHING
		$$ = create_node(temp,AND_EXPRESSION,$1,$3,NULL,NULL);
	}
	;

argument_expression_list
	: assignment_expression
	{NOTHING
		$$ = create_node(temp,ARGUMENT_EXPRESSION_LIST,$1,NULL,NULL,NULL);
	}
	| argument_expression_list ',' assignment_expression
	{NOTHING
		$$ = create_node(temp,ARGUMENT_EXPRESSION_LIST,$1,$3,NULL,NULL);
	}
	;

assignment_expression
	: conditional_expression
	{NOTHING
		$$ = create_node(temp,ASSIGNMENT_EXPRESSION,$1,NULL,NULL,NULL);
	}
	| unary_expression assignment_operator assignment_expression
	{NOTHING
		$$ = create_node(temp,ASSIGNMENT_EXPRESSION,$1,$2,$3,NULL);
	}
	;

assignment_operator
	: "="
	{
		struct value temp;
		temp.v.s = "=";
		temp.use = "string";
		$$ = create_node(temp,ASSIGNMENT_OPERATOR,NULL,NULL,NULL,NULL);;
	}
	| MUL_ASSIGN
	{
		struct value temp;
		temp.v.s = "*=";
		temp.use = "string";
		$$ = create_node(temp,ASSIGNMENT_OPERATOR,NULL,NULL,NULL,NULL);;
	}
	| DIV_ASSIGN
	{
		struct value temp;
		temp.v.s = "/=";
		temp.use = "string";
		$$ = create_node(temp,ASSIGNMENT_OPERATOR,NULL,NULL,NULL,NULL);;
	}
	| MOD_ASSIGN
	{
		struct value temp;
		temp.v.s = "%=";
		temp.use = "string";
		$$ = create_node(temp,ASSIGNMENT_OPERATOR,NULL,NULL,NULL,NULL);;
	}
	| ADD_ASSIGN
	{
		struct value temp;
		temp.v.s = "+=";
		temp.use = "string";
		$$ = create_node(temp,ASSIGNMENT_OPERATOR,NULL,NULL,NULL,NULL);;
	}
	| SUB_ASSIGN
	{
		struct value temp;
		temp.v.s = "-=";
		temp.use = "string";
		$$ = create_node(temp,ASSIGNMENT_OPERATOR,NULL,NULL,NULL,NULL);;
	}
	| LEFT_ASSIGN
	{
		struct value temp;
		temp.v.s = "<<=";
		temp.use = "string";
		$$ = create_node(temp,ASSIGNMENT_OPERATOR,NULL,NULL,NULL,NULL);;
	}
	| RIGHT_ASSIGN
	{
		struct value temp;
		temp.v.s = ">>=";
		temp.use = "string";
		$$ = create_node(temp,ASSIGNMENT_OPERATOR,NULL,NULL,NULL,NULL);;
	}
	| AND_ASSIGN
	{
		struct value temp;
		temp.v.s = "&=";
		temp.use = "string";
		$$ = create_node(temp,ASSIGNMENT_OPERATOR,NULL,NULL,NULL,NULL);;
	}
	| XOR_ASSIGN
	{
		struct value temp;
		temp.v.s = "^=";
		temp.use = "string";
		$$ = create_node(temp,ASSIGNMENT_OPERATOR,NULL,NULL,NULL,NULL);;
	}
	| OR_ASSIGN
	{
		struct value temp;
		temp.v.s = "|=";
		temp.use = "string";
		$$ = create_node(temp,ASSIGNMENT_OPERATOR,NULL,NULL,NULL,NULL);;
	}
	;



block_item_list
	: block_item
	{
		struct value temp;
		temp.use="none";
		$$ = create_node(temp,BLOCK_ITEM_LIST,$1,NULL,NULL,NULL);
	}
	| block_item_list block_item
	{
		struct value temp;
		temp.use="none";
		$$ = create_node(temp,BLOCK_ITEM_LIST,$1,$2,NULL,NULL);
	}
	;

block_item
	: declaration
	{NOTHING
		$$ = create_node(temp,BLOCK_ITEM,$1,NULL,NULL,NULL);
	}
	| statement
	{NOTHING
		$$ = create_node(temp,BLOCK_ITEM,$1,NULL,NULL,NULL);
	}
	;
cast_expression
	: unary_expression
	{NOTHING
		$$ = create_node(temp,CAST_EXPRESSION,$1,NULL,NULL,NULL);
	}
	| '(' type_name ')' cast_expression
	{NOTHING
		$$ = create_node(temp,CAST_EXPRESSION,$2,$4,NULL,NULL);
	}
	;

compound_statement
	: '{' '}'{}
	| '{'  block_item_list '}'{}
	{
		struct value temp;
		temp.use="none";
		$$ = create_node(temp,COMPOUND_STATEMENT,$2,NULL,NULL,NULL);
	}
	;

conditional_expression
	: logical_or_expression
	{NOTHING
		$$ = create_node(temp,CONDITIONAL_EXPRESSION,$1,NULL,NULL,NULL);
	}
	| logical_or_expression '?' expression ':' conditional_expression
	{NOTHING
		$$ = create_node(temp,CONDITIONAL_EXPRESSION,$1,$3,$5,NULL);
	}
	;


constant
	: I_CONSTANT		/* includes character_constant */
	{
		struct value temp;
		temp.v.i = yylval.iVal;
		temp.use = "integer";
		//printf("%s\n",temp.use);
		$$ = create_node(temp,CONSTANT,NULL,NULL,NULL,NULL);
	}
	| F_CONSTANT
	{
		struct value temp;
		temp.v.f = yylval.fVal;
		temp.use = "float";
		$$ = create_node(temp,CONSTANT,NULL,NULL,NULL,NULL);
	}
	| ENUMERATION_CONSTANT	/* after it has been defined as such */
	{NOTHING
		$$ = create_node(temp,CONSTANT,NULL,NULL,NULL,NULL);
	}
	;

constant_expression
	: conditional_expression	/* with constraints */
	{NOTHING
		$$ = create_node(temp,CONSTANT_EXPRESSION,$1,NULL,NULL,NULL);
	}
	;



declaration
	: declaration_specifiers ';'
	{NOTHING
		$$ = create_node(temp,DECLARATION,$1,NULL,NULL,NULL);
	}
	| declaration_specifiers init_declarator_list ';'
	{NOTHING
		$$ = create_node(temp,DECLARATION,$1,$2,NULL,NULL);
		int i,j,ti=0,ii=0;
		for(i=0;i<100;i++) {
			id[i] = (char *)malloc(IDLENGTH*sizeof(char));
			strcpy(id[i],"NIL");
			type[i] = (char *)malloc(10*sizeof(char));
			strcpy(type[i],"NIL");
		}
		ti=find_usage($1,type,ti,"string");
		ii=find_usage($2,id,ii,"identifier");
		for(i=0;i<ii;i++) {
			for(j=1;j<ti;j++) {
				if(strcmp(type[j],"NIL")!=0) {
					strcat(type[0]," ");
					strcat(type[0],type[j]);
				}
			}
			hash_insert(id[i],type[0]);
		}
	}
	| static_assert_declaration
	{NOTHING
		$$ = create_node(temp,DECLARATION,$1,NULL,NULL,NULL);
	}
	;

declaration_specifiers
	: storage_class_specifier declaration_specifiers
	{NOTHING
		$$ = create_node(temp,DECLARATION_SPECIFIERS,$1,$2,NULL,NULL);
	}
	| storage_class_specifier
	{NOTHING
		$$ = create_node(temp,DECLARATION_SPECIFIERS,$1,NULL,NULL,NULL);
	}
	| type_specifier declaration_specifiers
	{NOTHING
		$$ = create_node(temp,DECLARATION_SPECIFIERS,$1,$2,NULL,NULL);
	}
	| type_specifier
	{NOTHING
		$$ = create_node(temp,DECLARATION_SPECIFIERS,$1,NULL,NULL,NULL);
	}
	| type_qualifier declaration_specifiers
	{NOTHING
		$$ = create_node(temp,DECLARATION_SPECIFIERS,$1,$2,NULL,NULL);
	}
	| type_qualifier
	{NOTHING
		$$ = create_node(temp,DECLARATION_SPECIFIERS,$1,NULL,NULL,NULL);
	}
	| function_specifier declaration_specifiers
	{NOTHING
		$$ = create_node(temp,DECLARATION_SPECIFIERS,$1,$2,NULL,NULL);
	}
	| function_specifier
	{NOTHING
		$$ = create_node(temp,DECLARATION_SPECIFIERS,$1,NULL,NULL,NULL);
	}
	| alignment_specifier declaration_specifiers
	{NOTHING
		$$ = create_node(temp,DECLARATION_SPECIFIERS,$1,$2,NULL,NULL);
	}
	| alignment_specifier
	{NOTHING
		$$ = create_node(temp,DECLARATION_SPECIFIERS,$1,NULL,NULL,NULL);
	}
	;
declarator
	: pointer direct_declarator
	{NOTHING
		$$ = create_node(temp,DECLARATOR,$1,$2,NULL,NULL);
	}
	| direct_declarator
	{NOTHING
		$$ = create_node(temp,DECLARATOR,$1,NULL,NULL,NULL);
	}
	;

declaration_list
	: declaration
	{NOTHING
		$$ = create_node(temp,DECLARATION_LIST,$1,NULL,NULL,NULL);
	}
	| declaration_list declaration
	{NOTHING
		$$ = create_node(temp,DECLARATION_LIST,$1,$2,NULL,NULL);
	}
	;
designation
	: designator_list '='
	{NOTHING
		$$ = create_node(temp,DESIGNATION,$1,NULL,NULL,NULL);
	}
	;

designator_list
	: designator
	{NOTHING
		$$ = create_node(temp,DESIGNATOR_LIST,$1,NULL,NULL,NULL);
	}
	| designator_list designator
	{NOTHING
		$$ = create_node(temp,DESIGNATOR_LIST,$1,$2,NULL,NULL);
	}
	;

designator
	: '[' constant_expression ']'
	{NOTHING
		$$ = create_node(temp,DESIGNATOR,$2,NULL,NULL,NULL);
	}
	| '.' IDENTIFIER
	{
		struct value temp;
		temp.v.s = yylval.sVal;
		temp.use = "identifier";
		$$ = create_node(temp,CONSTANT,NULL,NULL,NULL,NULL);
	}
	;
direct_declarator
	: IDENTIFIER
	{
		struct value temp;
		temp.v.s = yylval.sVal;
		temp.use = "identifier";
		$$ = create_node(temp,DIRECT_DECLARATOR,NULL,NULL,NULL,NULL);
	}
	| '(' declarator ')'
	{NOTHING
		$$ = create_node(temp,DIRECT_DECLARATOR,$2,NULL,NULL,NULL);
	}
	| direct_declarator '[' ']'
	{NOTHING
		$$ = create_node(temp,DIRECT_DECLARATOR,$1,NULL,NULL,NULL);
	}
	| direct_declarator '[' '*' ']'
	{NOTHING
		$$ = create_node(temp,DIRECT_DECLARATOR,$1,NULL,NULL,NULL);
	}
	| direct_declarator '[' STATIC type_qualifier_list assignment_expression ']'
	{NOTHING
		$$ = create_node(temp,DIRECT_DECLARATOR,$1,$4,$5,NULL);
	}
	| direct_declarator '[' STATIC assignment_expression ']'
	{NOTHING
		$$ = create_node(temp,DIRECT_DECLARATOR,$1,$4,NULL,NULL);
	}
	| direct_declarator '[' type_qualifier_list '*' ']'
	{NOTHING
		$$ = create_node(temp,DIRECT_DECLARATOR,$1,$3,NULL,NULL);
	}
	| direct_declarator '[' type_qualifier_list STATIC assignment_expression ']'
	{NOTHING
		$$ = create_node(temp,DIRECT_DECLARATOR,$1,$3,$5,NULL);
	}
	| direct_declarator '[' type_qualifier_list assignment_expression ']'
	{NOTHING
		$$ = create_node(temp,DIRECT_DECLARATOR,$1,$3,$4,NULL);
	}
	| direct_declarator '[' type_qualifier_list ']'
	{NOTHING
		$$ = create_node(temp,DIRECT_DECLARATOR,$1,$3,NULL,NULL);
	}
	| direct_declarator '[' assignment_expression ']'
	{NOTHING
		$$ = create_node(temp,DIRECT_DECLARATOR,$1,$3,NULL,NULL);
	}
	| direct_declarator '(' parameter_type_list ')'
	{NOTHING
		$$ = create_node(temp,DIRECT_DECLARATOR,$1,$3,NULL,NULL);
	}
	| direct_declarator '(' ')'
	{NOTHING
		$$ = create_node(temp,DIRECT_DECLARATOR,$1,NULL,NULL,NULL);
	}
	| direct_declarator '(' identifier_list ')'
	{NOTHING
		$$ = create_node(temp,DIRECT_DECLARATOR,$1,$3,NULL,NULL);
	}
	;


direct_abstract_declarator
	: '(' abstract_declarator ')'
	{NOTHING
		$$ = create_node(temp,DIRECT_ABSTRACT_DECLARATOR,$2,NULL,NULL,NULL);
	}
	| '[' ']'{}
	| '[' '*' ']'{}
	| '[' STATIC type_qualifier_list assignment_expression ']'
	{NOTHING
		$$ = create_node(temp,DIRECT_ABSTRACT_DECLARATOR,$3,$4,NULL,NULL);
	}
	| '[' STATIC assignment_expression ']'
	{NOTHING
		$$ = create_node(temp,DIRECT_ABSTRACT_DECLARATOR,$3,NULL,NULL,NULL);
	}
	| '[' type_qualifier_list STATIC assignment_expression ']'
	{NOTHING
		$$ = create_node(temp,DIRECT_ABSTRACT_DECLARATOR,$2,$4,NULL,NULL);
	}
	| '[' type_qualifier_list assignment_expression ']'
	{NOTHING
		$$ = create_node(temp,DIRECT_ABSTRACT_DECLARATOR,$2,$3,NULL,NULL);
	}
	| '[' type_qualifier_list ']'
	{NOTHING
		$$ = create_node(temp,DIRECT_ABSTRACT_DECLARATOR,$2,NULL,NULL,NULL);
	}
	| '[' assignment_expression ']'
	{NOTHING
		$$ = create_node(temp,DIRECT_ABSTRACT_DECLARATOR,$2,NULL,NULL,NULL);
	}
	| direct_abstract_declarator '[' ']'
	{NOTHING
		$$ = create_node(temp,DIRECT_ABSTRACT_DECLARATOR,$1,NULL,NULL,NULL);
	}
	| direct_abstract_declarator '[' '*' ']'
	{NOTHING
		$$ = create_node(temp,DIRECT_ABSTRACT_DECLARATOR,$1,NULL,NULL,NULL);
	}
	| direct_abstract_declarator '[' STATIC type_qualifier_list assignment_expression ']'
	{NOTHING
		$$ = create_node(temp,DIRECT_ABSTRACT_DECLARATOR,$1,$4,$5,NULL);
	}
	| direct_abstract_declarator '[' STATIC assignment_expression ']'
	{NOTHING
		$$ = create_node(temp,DIRECT_ABSTRACT_DECLARATOR,$1,$4,NULL,NULL);
	}
	| direct_abstract_declarator '[' type_qualifier_list assignment_expression ']'
	{NOTHING
		$$ = create_node(temp,DIRECT_ABSTRACT_DECLARATOR,$1,$3,NULL,NULL);
	}
	| direct_abstract_declarator '[' type_qualifier_list STATIC assignment_expression ']'
	{NOTHING
		$$ = create_node(temp,DIRECT_ABSTRACT_DECLARATOR,$1,$3,$5,NULL);
	}
	| direct_abstract_declarator '[' type_qualifier_list ']'
	{NOTHING
		$$ = create_node(temp,DIRECT_ABSTRACT_DECLARATOR,$1,$3,NULL,NULL);
	}
	| direct_abstract_declarator '[' assignment_expression ']'
	{NOTHING
		$$ = create_node(temp,DIRECT_ABSTRACT_DECLARATOR,$1,$3,NULL,NULL);
	}
	| '(' ')'{}
	| '(' parameter_type_list ')'{}
	{NOTHING
		$$ = create_node(temp,DIRECT_ABSTRACT_DECLARATOR,$2,NULL,NULL,NULL);
	}
	| direct_abstract_declarator '(' ')'
	{NOTHING
		$$ = create_node(temp,DIRECT_ABSTRACT_DECLARATOR,$1,NULL,NULL,NULL);
	}
	| direct_abstract_declarator '(' parameter_type_list ')'
	{NOTHING
		$$ = create_node(temp,DIRECT_ABSTRACT_DECLARATOR,$1,$3,NULL,NULL);
	}
	;


enum_specifier
	: ENUM '{' enumerator_list '}'
	{NOTHING
		$$ = create_node(temp,ENUM_SPECIFIER,$3,NULL,NULL,NULL);
	}
	| ENUM '{' enumerator_list ',' '}'
	{NOTHING
		$$ = create_node(temp,ENUM_SPECIFIER,$3,NULL,NULL,NULL);
	}
	| ENUM IDENTIFIER '{' enumerator_list '}'
	{
		struct value temp;
		temp.v.s = yylval.sVal;
		temp.use = "identifier";
		$$ = create_node(temp,ENUM_SPECIFIER,NULL,NULL,NULL,NULL);
	}
	| ENUM IDENTIFIER '{' enumerator_list ',' '}'
	{
		struct value temp;
		temp.v.s = yylval.sVal;
		temp.use = "identifier";
		$$ = create_node(temp,ENUM_SPECIFIER,NULL,NULL,NULL,NULL);
	}
	| ENUM IDENTIFIER
	{
		struct value temp;
		temp.v.s = yylval.sVal;
		temp.use = "identifier";
		$$ = create_node(temp,ENUM_SPECIFIER,NULL,NULL,NULL,NULL);
	}
	;

enumerator_list
	: enumerator
	{NOTHING
		$$ = create_node(temp,ENUMERATOR_LIST,$1,NULL,NULL,NULL);
	}
	| enumerator_list ',' enumerator
	{NOTHING
		$$ = create_node(temp,ENUMERATOR_LIST,$1,$3,NULL,NULL);
	}
	;

enumerator	/* identifiers must be flagged as ENUMERATION_CONSTANT */
	: enumeration_constant '=' constant_expression
	{NOTHING
		$$ = create_node(temp,ENUMERATOR,$1,$3,NULL,NULL);
	}
	| enumeration_constant
	{NOTHING
		$$ = create_node(temp,ENUMERATOR,$1,NULL,NULL,NULL);
	}
	;

enumeration_constant		/* before it has been defined as such */
	: IDENTIFIER
	{
		struct value temp;
		temp.v.s = yylval.sVal;
		temp.use = "identifier";
		$$ = create_node(temp,ENUMERATION_CONSTANT,NULL,NULL,NULL,NULL);
	}
	;

equality_expression
	: relational_expression
	{NOTHING
		$$ = create_node(temp,EQUALITY_EXPRESSION,$1,NULL,NULL,NULL);
	}
	| equality_expression EQ_OP relational_expression
	{NOTHING
		$$ = create_node(temp,EQUALITY_EXPRESSION,$1,$3,NULL,NULL);
	}

	| equality_expression NE_OP relational_expression
	{NOTHING
		$$ = create_node(temp,EQUALITY_EXPRESSION,$1,$3,NULL,NULL);
	}
	;

exclusive_or_expression
	: and_expression
	{NOTHING
		$$ = create_node(temp,EXCLUSIVE_OR_EXPRESSION,$1,NULL,NULL,NULL);
	}
	| exclusive_or_expression '^' and_expression
	{NOTHING
		$$ = create_node(temp,EXCLUSIVE_OR_EXPRESSION,$1,$3,NULL,NULL);
	}
	;


expression
	: assignment_expression
	{NOTHING
		$$ = create_node(temp,EXPRESSION,$1,NULL,NULL,NULL);
	}
	| expression ',' assignment_expression
	{NOTHING
		$$ = create_node(temp,EXPRESSION,$1,$3,NULL,NULL);
	}
	;


expression_statement
	: ';'{}
	| expression ';'
	{NOTHING
		$$ = create_node(temp,EXPRESSION_STATEMENT,$1,NULL,NULL,NULL);
	}	
	;

external_declaration
	: function_definition
	{NOTHING
		$$ = create_node(temp,EXTERNAL_DECLARATION,$1,NULL,NULL,NULL);
	}
	| declaration
	{NOTHING
		$$ = create_node(temp,EXTERNAL_DECLARATION,$1,NULL,NULL,NULL);
	}
	;


function_definition
	: declaration_specifiers declarator declaration_list compound_statement
	{NOTHING
		$$ = create_node(temp,FUNCTION_DEFINITION,$1,$2,$3,$4);
	}
	| declaration_specifiers declarator compound_statement
	{NOTHING
		$$ = create_node(temp,FUNCTION_DEFINITION,$1,$2,$3,NULL);
	}
	;

function_specifier
	: INLINE
	{	struct value temp;
		temp.v.s = "inline";
		temp.use = "string";
		$$ = create_node(temp,FUNCTION_SPECIFIER,NULL,NULL,NULL,NULL);
	}
	| NORETURN
	{	struct value temp;
		temp.v.s = "noreturn";
		temp.use = "string";
		$$ = create_node(temp,FUNCTION_SPECIFIER,NULL,NULL,NULL,NULL);
	}
	;


generic_selection
	: GENERIC '(' assignment_expression ',' generic_assoc_list ')'
	{NOTHING
		$$ = create_node(temp,GENERIC_SELECTION,$3,$5,NULL,NULL);
	}
	;

generic_assoc_list
	: generic_association
	{NOTHING
		$$ = create_node(temp,GENERIC_ASSOC_LIST,$1,NULL,NULL,NULL);
	}
	| generic_assoc_list ',' generic_association
	{NOTHING
		$$ = create_node(temp,GENERIC_ASSOC_LIST,$1,$3,NULL,NULL);
	}
	;

generic_association
	: type_name ':' assignment_expression
	{NOTHING
		$$ = create_node(temp,GENERIC_ASSOCIATION,$1,$3,NULL,NULL);
	}
	| DEFAULT ':' assignment_expression
	{NOTHING
		$$ = create_node(temp,GENERIC_ASSOCIATION,$3,NULL,NULL,NULL);
	}
	;



identifier_list
	: IDENTIFIER
	{
		struct value temp;
		temp.v.s = yylval.sVal;
		temp.use = "identifier";
		$$ = create_node(temp,IDENTIFIER_LIST,NULL,NULL,NULL,NULL);
	}
	| identifier_list ',' IDENTIFIER
	{
		struct value temp;
		temp.v.s = yylval.sVal;
		temp.use = "identifier";
		$$ = create_node(temp,IDENTIFIER_LIST,$1,NULL,NULL,NULL);
	}
	;

inclusive_or_expression
	: exclusive_or_expression
	{NOTHING
		$$ = create_node(temp,INCLUSIVE_OR_EXPRESSION,$1,NULL,NULL,NULL);
	}
	| inclusive_or_expression '|' exclusive_or_expression
	{NOTHING
		$$ = create_node(temp,INCLUSIVE_OR_EXPRESSION,$1,$3,NULL,NULL);
	}
	;

init_declarator_list
	: init_declarator
	{NOTHING
		$$ = create_node(temp,INIT_DECLARATOR_LIST,$1,NULL,NULL,NULL);
	}
	| init_declarator_list ',' init_declarator
	{NOTHING
		$$ = create_node(temp,INIT_DECLARATOR_LIST,$1,$3,NULL,NULL);
	}
	;

init_declarator
	: declarator '=' initializer
	{
		struct value temp;
		temp.v.s = "=";
		temp.use = "string";
		$$ = create_node(temp,INIT_DECLARATOR,$1,$3,NULL,NULL);
	}
	| declarator
	{NOTHING
		$$ = create_node(temp,INIT_DECLARATOR,$1,NULL,NULL,NULL);
	}
	;

initializer
	: '{' initializer_list '}'
	{NOTHING
		$$ = create_node(temp,INITIALIZER,$2,NULL,NULL,NULL);
	}
	| '{' initializer_list ',' '}'
	{NOTHING
		$$ = create_node(temp,INITIALIZER,$2,NULL,NULL,NULL);
	}
	| assignment_expression
	{NOTHING
		$$ = create_node(temp,INITIALIZER,$1,NULL,NULL,NULL);
	}
	;

initializer_list
	: designation initializer
	{NOTHING
		$$ = create_node(temp,INITIALIZER_LIST,$1,NULL,NULL,NULL);
	}
	| initializer
	{NOTHING
		$$ = create_node(temp,INITIALIZER_LIST,$1,NULL,NULL,NULL);
	}
	| initializer_list ',' designation initializer
	{NOTHING
		$$ = create_node(temp,INITIALIZER_LIST,$1,$3,NULL,NULL);
	}
	| initializer_list ',' initializer
	{NOTHING
		$$ = create_node(temp,INITIALIZER_LIST,$1,$3,NULL,NULL);
	}
	;
iteration_statement
	: WHILE '(' expression ')' statement
	{NOTHING
		$$ = create_node(temp,ITERATION_STATEMENT,$3,$5,NULL,NULL);
	}
	| DO statement WHILE '(' expression ')' ';'
	{NOTHING
		$$ = create_node(temp,ITERATION_STATEMENT,$2,$5,NULL,NULL);
	}
	| FOR '(' expression_statement expression_statement ')' statement
	{NOTHING
		$$ = create_node(temp,ITERATION_STATEMENT,$3,$4,$6,NULL);
	}
	| FOR '(' expression_statement expression_statement expression ')' statement
	{NOTHING
		$$ = create_node(temp,ITERATION_STATEMENT,$3,$4,$5,$7);
	}
	| FOR '(' declaration expression_statement ')' statement
	{NOTHING
		$$ = create_node(temp,ITERATION_STATEMENT,$3,$4,$6,NULL);
	}
	| FOR '(' declaration expression_statement expression ')' statement
	{NOTHING
		$$ = create_node(temp,ITERATION_STATEMENT,$3,$4,$5,$7);
	}
	;

jump_statement
	: GOTO IDENTIFIER ';'
	{
		struct value temp;
		temp.v.s = yylval.sVal;
		temp.use = "identifier";
		$$ = create_node(temp,JUMP_STATEMENT,NULL,NULL,NULL,NULL);
	}
	| CONTINUE ';'
	{NOTHING
		$$ = create_node(temp,JUMP_STATEMENT,NULL,NULL,NULL,NULL);
	}	
	| BREAK ';'
	{NOTHING
		$$ = create_node(temp,JUMP_STATEMENT,NULL,NULL,NULL,NULL);
	}	
	| RETURN ';'
	{NOTHING
		$$ = create_node(temp,JUMP_STATEMENT,NULL,NULL,NULL,NULL);
	}	
	| RETURN expression ';'
	{NOTHING
		$$ = create_node(temp,JUMP_STATEMENT,$2,NULL,NULL,NULL);
	}	
	;

labeled_statement
	: IDENTIFIER ':' statement
	{
		struct value temp;
		temp.v.s = yylval.sVal;
		temp.use = "identifier";
		$$ = create_node(temp,LABELED_STATEMENT,$3,NULL,NULL,NULL);
	}	
	| CASE constant_expression ':' statement
	{NOTHING
		$$ = create_node(temp,LABELED_STATEMENT,$2,$4,NULL,NULL);
	}
	| DEFAULT ':' statement
	{NOTHING
		$$ = create_node(temp,LABELED_STATEMENT,$3,NULL,NULL,NULL);
	}
	;

logical_and_expression
	: inclusive_or_expression
	{NOTHING
		$$ = create_node(temp,LOGICAL_AND_EXPRESSION,$1,NULL,NULL,NULL);
	}
	| logical_and_expression AND_OP inclusive_or_expression
	{NOTHING
		$$ = create_node(temp,LOGICAL_AND_EXPRESSION,$1,$3,NULL,NULL);
	}
	;

logical_or_expression
	: logical_and_expression
	{NOTHING
		$$ = create_node(temp,LOGICAL_OR_EXPRESSION,$1,NULL,NULL,NULL);
	}
	| logical_or_expression OR_OP logical_and_expression
	{NOTHING
		$$ = create_node(temp,LOGICAL_OR_EXPRESSION,$1,$3,NULL,NULL);
	}
	;

multiplicative_expression
	: cast_expression
	{NOTHING
		$$ = create_node(temp,MULTIPLICATIVE_EXPRESSION,$1,NULL,NULL,NULL);
	}
	| multiplicative_expression '*' cast_expression
	{NOTHING
		$$ = create_node(temp,MULTIPLICATIVE_EXPRESSION,$1,$3,NULL,NULL);
	}
	| multiplicative_expression '/' cast_expression
	{NOTHING
		$$ = create_node(temp,MULTIPLICATIVE_EXPRESSION,$1,$3,NULL,NULL);
	}
	| multiplicative_expression '%' cast_expression
	{NOTHING
		$$ = create_node(temp,MULTIPLICATIVE_EXPRESSION,$1,$3,NULL,NULL);
	}
	;


parameter_type_list
	: parameter_list ',' ELLIPSIS
	{NOTHING
		$$ = create_node(temp,PARAMETER_TYPE_LIST,$1,NULL,NULL,NULL);
	}
	| parameter_list
	{NOTHING
		$$ = create_node(temp,PARAMETER_TYPE_LIST,$1,NULL,NULL,NULL);
	}
	;

parameter_list
	: parameter_declaration
	{NOTHING
		$$ = create_node(temp,PARAMETER_LIST,$1,NULL,NULL,NULL);
	}
	| parameter_list ',' parameter_declaration
	{NOTHING
		$$ = create_node(temp,PARAMETER_LIST,$1,$3,NULL,NULL);
	}
	;

parameter_declaration
	: declaration_specifiers declarator
	{NOTHING
		$$ = create_node(temp,PARAMETER_DECLARATION,$1,$2,NULL,NULL);
		int i,j,ti=0,ii=0;
		for(i=0;i<100;i++) {
			id[i] = (char *)malloc(IDLENGTH*sizeof(char));
			strcpy(id[i],"NIL");
			type[i] = (char *)malloc(10*sizeof(char));
			strcpy(type[i],"NIL");
		}
		ti=find_usage($1,type,ti,"string");
		ii=find_usage($2,id,ii,"identifier");
		for(i=0;i<ii;i++) {
			for(j=1;j<ti;j++) {
				if(strcmp(type[j],"NIL")!=0) {
					strcat(type[0]," ");
					strcat(type[0],type[j]);
				}
			}
			hash_insert(id[i],type[0]);
		}
	}
	| declaration_specifiers abstract_declarator
	{NOTHING
		$$ = create_node(temp,PARAMETER_DECLARATION,$1,$2,NULL,NULL);
	}
	| declaration_specifiers
	{NOTHING
		$$ = create_node(temp,PARAMETER_DECLARATION,$1,NULL,NULL,NULL);
	}
	;

pointer
	: '*' type_qualifier_list pointer
	{NOTHING
		$$ = create_node(temp,POINTER,$2,$3,NULL,NULL);
	}
	| '*' type_qualifier_list
	{NOTHING
		$$ = create_node(temp,POINTER,$2,NULL,NULL,NULL);
	}
	| '*' pointer
	{NOTHING
		$$ = create_node(temp,POINTER,$2,NULL,NULL,NULL);
	}
	| '*' {}
	;


postfix_expression
	: primary_expression
	{NOTHING
		$$ = create_node(temp,POSTFIX_EXPRESSION,$1,NULL,NULL,NULL);
	}
	| postfix_expression '[' expression ']'
	{NOTHING
		$$ = create_node(temp,POSTFIX_EXPRESSION,$1,$3,NULL,NULL);
	}
	| postfix_expression '(' ')'

	{NOTHING
		$$ = create_node(temp,POSTFIX_EXPRESSION,$1,NULL,NULL,NULL);
	}
	| postfix_expression '(' argument_expression_list ')'

	{NOTHING
		$$ = create_node(temp,POSTFIX_EXPRESSION,$1,$3,NULL,NULL);
	}
	| postfix_expression '.' IDENTIFIER

	{
		struct value temp;
		temp.v.s = yylval.sVal;
		temp.use = "identifier";
		$$ = create_node(temp,POSTFIX_EXPRESSION,$1,NULL,NULL,NULL);
	}
	| postfix_expression PTR_OP IDENTIFIER

	{
		struct value temp;
		temp.v.s = yylval.sVal;
		temp.use = "identifier";
		$$ = create_node(temp,POSTFIX_EXPRESSION,$1,NULL,NULL,NULL);
	}
	| postfix_expression INC_OP

	{NOTHING
		$$ = create_node(temp,POSTFIX_EXPRESSION,$1,NULL,NULL,NULL);
	}
	| postfix_expression DEC_OP

	{NOTHING
		$$ = create_node(temp,POSTFIX_EXPRESSION,$1,NULL,NULL,NULL);
	}
	| '(' type_name ')' '{' initializer_list '}'

	{NOTHING
		$$ = create_node(temp,POSTFIX_EXPRESSION,$2,$5,NULL,NULL);
	}
	| '(' type_name ')' '{' initializer_list ',' '}'
	{NOTHING
		$$ = create_node(temp,POSTFIX_EXPRESSION,$2,$5,NULL,NULL);
	}
	;

primary_expression
	: IDENTIFIER
	{
		struct value temp;
		temp.v.s = yylval.sVal;
		temp.use = "identifier";
		$$ = create_node(temp,PRIMARY_EXPRESSION,NULL,NULL,NULL,NULL);
	}
	| constant
	{NOTHING
		$$ = create_node(temp,PRIMARY_EXPRESSION,$1,NULL,NULL,NULL);
	}
	| string
	{NOTHING
		$$ = create_node(temp,PRIMARY_EXPRESSION,$1,NULL,NULL,NULL);
	}
	| '(' expression ')'
	{NOTHING
		$$ = create_node(temp,PRIMARY_EXPRESSION,$2,NULL,NULL,NULL);
	}
	| generic_selection
	{NOTHING
		$$ = create_node(temp,PRIMARY_EXPRESSION,$1,NULL,NULL,NULL);
	}
	;
program 
	: translation_unit
	{ 	BINARY_TREE ParseTree;
		struct value temp;
		temp.use="none";
		ParseTree = create_node(temp,PROGRAM,$1,NULL,NULL,NULL);
		PrintTree(ParseTree);
		print_table();
	}
	;

relational_expression
	: shift_expression
	{NOTHING
		$$ = create_node(temp,RELATIONAL_EXPRESSION,$1,NULL,NULL,NULL);
	}
	| relational_expression '<' shift_expression
	{NOTHING
		$$ = create_node(temp,RELATIONAL_EXPRESSION,$1,$3,NULL,NULL);
	}
	| relational_expression '>' shift_expression
	{NOTHING
		$$ = create_node(temp,RELATIONAL_EXPRESSION,$1,$3,NULL,NULL);
	}
	| relational_expression LE_OP shift_expression
	{NOTHING
		$$ = create_node(temp,RELATIONAL_EXPRESSION,$1,$3,NULL,NULL);
	}
	| relational_expression GE_OP shift_expression
	{NOTHING
		$$ = create_node(temp,RELATIONAL_EXPRESSION,$1,$3,NULL,NULL);
	}
	;


selection_statement
	: IF '(' expression ')' statement ELSE statement
	{NOTHING
		$$ = create_node(temp,SELECTION_STATEMENT,$3,$5,$7,NULL);
	}
	| IF '(' expression ')' statement

	{NOTHING
		$$ = create_node(temp,SELECTION_STATEMENT,$3,$5,NULL,NULL);
	}
	| SWITCH '(' expression ')' statement

	{NOTHING
		$$ = create_node(temp,SELECTION_STATEMENT,$3,$5,NULL,NULL);
	}
	;

string
	: STRING_LITERAL
	{NOTHING
		$$ = create_node(temp,STRING,NULL,NULL,NULL,NULL);
	}
	| FUNC_NAME
	{NOTHING
		$$ = create_node(temp,STRING,NULL,NULL,NULL,NULL);
	}
	;

shift_expression
	: additive_expression
	{NOTHING
		$$ = create_node(temp,SHIFT_EXPRESSION,$1,NULL,NULL,NULL);
	}
	| shift_expression LEFT_OP additive_expression
	{NOTHING
		$$ = create_node(temp,SHIFT_EXPRESSION,$1,$3,NULL,NULL);
	}
	| shift_expression RIGHT_OP additive_expression
	{NOTHING
		$$ = create_node(temp,SHIFT_EXPRESSION,$1,$3,NULL,NULL);
	}
	;

static_assert_declaration
	: STATIC_ASSERT '(' constant_expression ',' STRING_LITERAL ')' ';'
	{NOTHING
		$$ = create_node(temp,STATIC_ASSERT_DECLARATION,NULL,$3,NULL,NULL);
	}
	;

statement
	: labeled_statement
	{NOTHING
		$$ = create_node(temp,STATEMENT,$1,NULL,NULL,NULL);
	}
	| compound_statement
	{NOTHING
		$$ = create_node(temp,STATEMENT,$1,NULL,NULL,NULL);
	}
	| expression_statement
	{NOTHING
		$$ = create_node(temp,STATEMENT,$1,NULL,NULL,NULL);
	}
	| selection_statement
	{NOTHING
		$$ = create_node(temp,STATEMENT,$1,NULL,NULL,NULL);
	}
	| iteration_statement
	{NOTHING
		$$ = create_node(temp,STATEMENT,$1,NULL,NULL,NULL);
	}
	| jump_statement
	{NOTHING
		$$ = create_node(temp,STATEMENT,$1,NULL,NULL,NULL);
	}
	;

storage_class_specifier
	: TYPEDEF	/* identifiers must be flagged as TYPEDEF_NAME */
	{	struct value temp;
		temp.v.s = "typedef";
		temp.use = "string";
		$$ = create_node(temp,STORAGE_CLASS_SPECIFIER,NULL,NULL,NULL,NULL);
	}
	| EXTERN
	{	struct value temp;
		temp.v.s = "extern";
		temp.use = "string";
		$$ = create_node(temp,STORAGE_CLASS_SPECIFIER,NULL,NULL,NULL,NULL);
	}
	| STATIC
	{	struct value temp;
		temp.v.s = "static";
		temp.use = "string";
		$$ = create_node(temp,STORAGE_CLASS_SPECIFIER,NULL,NULL,NULL,NULL);
	}
	| THREAD_LOCAL
	{	struct value temp;
		temp.v.s = "thread_local";
		temp.use = "string";
		$$ = create_node(temp,STORAGE_CLASS_SPECIFIER,NULL,NULL,NULL,NULL);
	}
	| AUTO
	{	struct value temp;
		temp.v.s = "auto";
		temp.use = "string";
		$$ = create_node(temp,STORAGE_CLASS_SPECIFIER,NULL,NULL,NULL,NULL);
	}
	| REGISTER
	{	struct value temp;
		temp.v.s = "register";
		temp.use = "string";
		$$ = create_node(temp,STORAGE_CLASS_SPECIFIER,NULL,NULL,NULL,NULL);
	}
	;


struct_or_union_specifier
	: struct_or_union '{' struct_declaration_list '}'
	{NOTHING
		$$ = create_node(temp,STRUCT_OR_UNION_SPECIFIER,$1,$3,NULL,NULL);
	}
	| struct_or_union IDENTIFIER '{' struct_declaration_list '}'
	{
		struct value temp;
		temp.v.s = yylval.sVal;
		temp.use = "identifier";
		$$ = create_node(temp,STRUCT_OR_UNION_SPECIFIER,$1,$4,NULL,NULL);
	}
	| struct_or_union IDENTIFIER
	{
		struct value temp;
		temp.v.s = yylval.sVal;
		temp.use = "identifier";
		$$ = create_node(temp,STRUCT_OR_UNION_SPECIFIER,$1,NULL,NULL,NULL);
	}
	;

struct_or_union
	: STRUCT
	{	struct value temp;
		temp.v.s = "struct";
		temp.use = "string";
		$$ = create_node(temp,STRUCT_OR_UNION,NULL,NULL,NULL,NULL);
	}
	| UNION
	{	struct value temp;
		temp.v.s = "union";
		temp.use = "string";
		$$ = create_node(temp,STRUCT_OR_UNION,NULL,NULL,NULL,NULL);
	}
	;

struct_declaration_list
	: struct_declaration
	{NOTHING
		$$ = create_node(temp,STRUCT_DECLARATION_LIST,$1,NULL,NULL,NULL);
	}
	| struct_declaration_list struct_declaration
	{NOTHING
		$$ = create_node(temp,STRUCT_DECLARATION_LIST,$1,$2,NULL,NULL);
	}
	;

struct_declaration
	: specifier_qualifier_list ';'	/* for anonymous struct/union */
	{NOTHING
		$$ = create_node(temp,STRUCT_DECLARATION,$1,NULL,NULL,NULL);
	}
	| specifier_qualifier_list struct_declarator_list ';'
	{NOTHING
		$$ = create_node(temp,STRUCT_DECLARATION,$1,$2,NULL,NULL);
	}
	| static_assert_declaration
	{NOTHING
		$$ = create_node(temp,STRUCT_DECLARATION,$1,NULL,NULL,NULL);
	}
	;

specifier_qualifier_list
	: type_specifier specifier_qualifier_list
	{NOTHING
		$$ = create_node(temp,SPECIFIER_QUALIFIER_LIST,$1,$2,NULL,NULL);
	}
	| type_specifier
	{NOTHING
		$$ = create_node(temp,SPECIFIER_QUALIFIER_LIST,$1,NULL,NULL,NULL);
	}
	| type_qualifier specifier_qualifier_list
	{NOTHING
		$$ = create_node(temp,SPECIFIER_QUALIFIER_LIST,$1,$2,NULL,NULL);
	}
	| type_qualifier
	{NOTHING
		$$ = create_node(temp,SPECIFIER_QUALIFIER_LIST,$1,NULL,NULL,NULL);
	}
	;

struct_declarator_list
	: struct_declarator
	{NOTHING
		$$ = create_node(temp,STRUCT_DECLARATOR_LIST,$1,NULL,NULL,NULL);
	}
	| struct_declarator_list ',' struct_declarator
	{NOTHING
		$$ = create_node(temp,STRUCT_DECLARATOR_LIST,$1,$3,NULL,NULL);
	}
	;

struct_declarator
	: ':' constant_expression
	{NOTHING
		$$ = create_node(temp,STRUCT_DECLARATOR,$2,NULL,NULL,NULL);
	}
	| declarator ':' constant_expression
	{NOTHING
		$$ = create_node(temp,STRUCT_DECLARATOR,$1,$3,NULL,NULL);
	}
	| declarator
	{NOTHING
		$$ = create_node(temp,STRUCT_DECLARATOR,$1,NULL,NULL,NULL);
	}
	;


translation_unit
	: external_declaration
	{NOTHING
		$$ = create_node(temp,TRANSLATION_UNIT,$1,NULL,NULL,NULL);
	}	
	| translation_unit external_declaration
	{NOTHING 	
		$$ = create_node(temp,TRANSLATION_UNIT,$1,$2,NULL,NULL);
	}
	;

type_name
	: specifier_qualifier_list abstract_declarator
	{NOTHING
		$$ = create_node(temp,TYPE_NAME,$1,$2,NULL,NULL);
	}
	| specifier_qualifier_list
	{NOTHING
		$$ = create_node(temp,TYPE_NAME,$1,NULL,NULL,NULL);
	}
	;

type_qualifier
	: CONST
	{	struct value temp;
		temp.v.s = "const";
		temp.use = "string";
		$$ = create_node(temp,TYPE_QUALIFIER,NULL,NULL,NULL,NULL);
	}
	| RESTRICT
	{	struct value temp;
		temp.v.s = "restrict";
		temp.use = "string";
		$$ = create_node(temp,TYPE_QUALIFIER,NULL,NULL,NULL,NULL);
	}
	| VOLATILE
	{	struct value temp;
		temp.v.s = "volatile";
		temp.use = "string";
		$$ = create_node(temp,TYPE_QUALIFIER,NULL,NULL,NULL,NULL);
	}
	;

type_qualifier_list
	: type_qualifier
	{NOTHING
		$$ = create_node(temp,TYPE_QUALIFIER_LIST,$1,NULL,NULL,NULL);
	}
	| type_qualifier_list type_qualifier
	{NOTHING
		$$ = create_node(temp,TYPE_QUALIFIER_LIST,$1,$2,NULL,NULL);
	}
	;


type_specifier
	: VOID
	{	struct value temp;
		temp.v.s = "void";
		temp.use = "string";
		$$ = create_node(temp,TYPE_SPECIFIER,NULL,NULL,NULL,NULL);
	}
	| CHAR
	{	struct value temp;
		temp.v.s = "char";
		temp.use = "string";
		$$ = create_node(temp,TYPE_SPECIFIER,NULL,NULL,NULL,NULL);
	}
	| SHORT
	{	struct value temp;
		temp.v.s = "short";
		temp.use = "string";
		$$ = create_node(temp,TYPE_SPECIFIER,NULL,NULL,NULL,NULL);
	}
	| INT
	{	struct value temp;
		temp.v.s = "int";
		temp.use = "string";
		$$ = create_node(temp,TYPE_SPECIFIER,NULL,NULL,NULL,NULL);
	}
	| LONG
	{	struct value temp;
		temp.v.s = "long";
		temp.use = "string";
		$$ = create_node(temp,TYPE_SPECIFIER,NULL,NULL,NULL,NULL);
	}
	| FLOAT
	{	struct value temp;
		temp.v.s = "float";
		temp.use = "string";
		$$ = create_node(temp,TYPE_SPECIFIER,NULL,NULL,NULL,NULL);
	}
	| DOUBLE
	{	struct value temp;
		temp.v.s = "double";
		temp.use = "string";
		$$ = create_node(temp,TYPE_SPECIFIER,NULL,NULL,NULL,NULL);
	}
	| SIGNED
	{	struct value temp;
		temp.v.s = "signed";
		temp.use = "string";
		$$ = create_node(temp,TYPE_SPECIFIER,NULL,NULL,NULL,NULL);
	}
	| UNSIGNED
	{	struct value temp;
		temp.v.s = "unsigned";
		temp.use = "string";
		$$ = create_node(temp,TYPE_SPECIFIER,NULL,NULL,NULL,NULL);
	}
	| BOOL
	{	struct value temp;
		temp.v.s = "bool";
		temp.use = "string";
		$$ = create_node(temp,TYPE_SPECIFIER,NULL,NULL,NULL,NULL);
	}
	| COMPLEX
	{	struct value temp;
		temp.v.s = "complex";
		temp.use = "string";
		$$ = create_node(temp,TYPE_SPECIFIER,NULL,NULL,NULL,NULL);
	}
	| IMAGINARY	  	/* non-mandated extension */
	{	struct value temp;
		temp.v.s = "imaginary";
		temp.use = "string";
		$$ = create_node(temp,TYPE_SPECIFIER,NULL,NULL,NULL,NULL);
	}
	| struct_or_union_specifier
	{NOTHING
		$$ = create_node(temp,TYPE_SPECIFIER,$1,NULL,NULL,NULL);
	}
	| enum_specifier
	{	struct value temp;
		temp.v.s = "enum";
		temp.use = "string";
		$$ = create_node(temp,TYPE_SPECIFIER,$1,NULL,NULL,NULL);
	}
	| TYPEDEF_NAME		/* after it has been defined as such */
	{	struct value temp;
		temp.v.s = "typedef_name";
		temp.use = "string";
		$$ = create_node(temp,TYPE_SPECIFIER,NULL,NULL,NULL,NULL);
	}
	;

unary_expression
	: postfix_expression
	{	struct value temp;
		temp.use="none";
		$$ = create_node(temp,UNARY_EXPRESSION,$1,NULL,NULL,NULL);
	}
	| INC_OP unary_expression
	{	struct value temp;
		temp.use="none";
		$$ = create_node(temp,UNARY_EXPRESSION,$2,NULL,NULL,NULL);
	}
	| DEC_OP unary_expression
	{	struct value temp;
		temp.use="none";
		$$ = create_node(temp,UNARY_EXPRESSION,$2,NULL,NULL,NULL);
	}
	| unary_operator cast_expression
	{	struct value temp;
		temp.use="none";
		$$ = create_node(temp,UNARY_EXPRESSION,$1,$2,NULL,NULL);
	}
	| SIZEOF unary_expression
	{	struct value temp;
		temp.use="none";
		$$ = create_node(temp,UNARY_EXPRESSION,$2,NULL,NULL,NULL);
	}
	| SIZEOF '(' type_name ')'
	{	struct value temp;
		temp.use="none";
		$$ = create_node(temp,UNARY_EXPRESSION,$3,NULL,NULL,NULL);
	}
	| ALIGNOF '(' type_name ')'
	{	struct value temp;
		temp.use="none";
		$$ = create_node(temp,UNARY_EXPRESSION,$3,NULL,NULL,NULL);
	}
	;

unary_operator
	: '&'{}
	| '*'{}
	| '+'{}
	| '-'{}
	| '~'{}
	| '!'{}
	;


%%
#include <stdio.h>

void yyerror(const char *s)
{
	fflush(stdout);
	fprintf(stderr, "*** %s\n", s);
}
BINARY_TREE create_node(struct value val,int case_identifier,BINARY_TREE p1,BINARY_TREE p2,BINARY_TREE p3,BINARY_TREE p4) {
	BINARY_TREE t;
	t= (BINARY_TREE)malloc(sizeof(TREE_NODE));
	t->val = val;
	t->nodeIdentifier = case_identifier;
	t->first = p1;
	t->second = p2;
	t->third = p3;
	t->fourth = p4;
	return (t);
}
void PrintTree(BINARY_TREE t) {
	if(t==NULL)
		return; 
	if(strcmp(t->val.use,"string")==0)
		printf("Value: %s ",t->val.v.s);
	if(strcmp(t->val.use,"identifier")==0)
		printf("Value: %s ",t->val.v.s);
	else if(strcmp(t->val.use,"float")==0)
		printf("Value: %f ",t->val.v.f);
	else if(strcmp(t->val.use,"integer")==0)
		printf("Value: %d ",t->val.v.i);
	else 
		printf("Value: ");

	printf("Label: %s\n",labels[(t->nodeIdentifier)]);
	//if(t->first!=NULL) printf("Going from %s to %s\n",labels[t->nodeIdentifier],labels[t->first->nodeIdentifier]);
	PrintTree(t->first);
	//if(t->second!=NULL) printf("Going from %s to %s\n",labels[t->nodeIdentifier],labels[t->second->nodeIdentifier]);
	PrintTree(t->second);
	//if(t->third!=NULL) printf("Going from %s to %s\n",labels[t->nodeIdentifier],labels[t->third->nodeIdentifier]);
	PrintTree(t->third);
	//if(t->fourth!=NULL) printf("Going from %s to %s\n",labels[t->nodeIdentifier],labels[t->fourth->nodeIdentifier]);
	PrintTree(t->fourth);
}
int find_usage(BINARY_TREE p,char *type[100],int i,char *u) {
if(p==NULL)
	return i;
if(strcmp(p->val.use,u)==0) {
	strcpy(type[i],p->val.v.s);
	i++;
}
i=find_usage(p->first,type,i,u);
i=find_usage(p->second,type,i,u);
i=find_usage(p->third,type,i,u);
i=find_usage(p->fourth,type,i,u);
return i;
}

