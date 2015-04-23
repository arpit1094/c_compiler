%e  1019
%p  2807
%n  371
%k  284
%a  1213
%o  1117

O   [0-7]
D   [0-9]
NZ  [1-9]
L   [a-zA-Z_]
A   [a-zA-Z_0-9]
H   [a-fA-F0-9]
HP  (0[xX])
E   ([Ee][+-]?{D}+)
P   ([Pp][+-]?{D}+)
FS  (f|F|l|L)
IS  (((u|U)(l|L|ll|LL)?)|((l|L|ll|LL)(u|U)?))
CP  (u|U|L)
SP  (u8|u|U|L)
ES  (\\(['"\?\\abfnrtv]|[0-7]{1,3}|x[a-fA-F0-9]+))
WS  [ \t\v\n\f]

%{
#include <stdio.h>
#include "y.tab.h"

extern void yyerror(const char *);  /* prints grammar violation message */

extern int sym_type(const char *);  /* TOKs type from symbol table */

#define sym_type(identifier) IDENTIFIER /* with no symbol table, fake it */

static void comment(void);
static int check_type(void);


#include<strings.h>
extern SYMTABNODEPTR symTab[SYMTABSIZE];
extern int currentSymTabSize;

#define TOK(t) return(t);
#define TOK_I(t) {yylval.iVal = atoi(yytext);return(t);}
#define TOK_F(t) {yylval.fVal = atof(yytext);return(t);}
#define TOK_S(t) {yylval.sVal = strdup(yytext);return(t);}
#define TOK_ID(t) {yylval.sVal = strdup(yytext);return (t);}
%}

%%
"/*"                                    { comment(); }
"//".*                                    { /* consume //-comment */ }

"auto"					{ TOK(AUTO); }
"break"					{ TOK(BREAK); }
"case"					{ TOK(CASE); }
"char"					{ TOK(CHAR); }
"const"					{ TOK(CONST); }
"continue"				{ TOK(CONTINUE); }
"default"				{ TOK(DEFAULT); }
"do"					{ TOK(DO); }
"double"				{ TOK(DOUBLE); }
"else"					{ TOK(ELSE); }
"enum"					{ TOK(ENUM); }
"extern"				{ TOK(EXTERN); }
"float"					{ TOK(FLOAT); }
"for"					{ TOK(FOR); }
"goto"					{ TOK(GOTO); }
"if"					{ TOK(IF); }
"inline"				{ TOK(INLINE); }
"int"					{ TOK(INT); }
"long"					{ TOK(LONG); }
"register"				{ TOK(REGISTER); }
"restrict"				{ TOK(RESTRICT); }
"return"				{ TOK(RETURN); }
"short"					{ TOK(SHORT); }
"signed"				{ TOK(SIGNED); }
"sizeof"				{ TOK(SIZEOF); }
"static"				{ TOK(STATIC); }
"struct"				{ TOK(STRUCT); }
"switch"				{ TOK(SWITCH); }
"typedef"				{ TOK(TYPEDEF); }
"union"					{ TOK(UNION); }
"unsigned"				{ TOK(UNSIGNED); }
"void"					{ TOK(VOID); }
"volatile"				{ TOK(VOLATILE); }
"while"					{ TOK(WHILE); }
"_Alignas"                              { TOK(ALIGNAS); }
"_Alignof"                              { TOK(ALIGNOF); }
"_Atomic"                               { TOK(ATOMIC); }
"_Bool"                                 { TOK(BOOL); }
"_Complex"                              { TOK(COMPLEX); }
"_Generic"                              { TOK(GENERIC); }
"_Imaginary"                            { TOK(IMAGINARY); }
"_Noreturn"                             { TOK(NORETURN); }
"_Static_assert"                        { TOK(STATIC_ASSERT); }
"_Thread_local"                         { TOK(THREAD_LOCAL); }
"__func__"                              { TOK(FUNC_NAME); }

{L}{A}*					{ TOK(check_type()); }

{HP}{H}+{IS}?				{ TOK_I(I_CONSTANT); }
{NZ}{D}*{IS}?				{ TOK_I(I_CONSTANT); }
"0"{O}*{IS}?				{ TOK_I(I_CONSTANT); }
{CP}?"'"([^'\\\n]|{ES})+"'"		{ TOK_I(I_CONSTANT); }

{D}+{E}{FS}?				{ TOK_F(F_CONSTANT); }
{D}*"."{D}+{E}?{FS}?			{ TOK_F(F_CONSTANT); }
{D}+"."{E}?{FS}?			{ TOK_F(F_CONSTANT); }
{HP}{H}+{P}{FS}?			{ TOK_F(F_CONSTANT); }
{HP}{H}*"."{H}+{P}{FS}?			{ TOK_F(F_CONSTANT); }
{HP}{H}+"."{P}{FS}?			{ TOK_F(F_CONSTANT); }

({SP}?\"([^"\\\n]|{ES})*\"{WS}*)+	{ TOK_S(STRING_LITERAL); }

"..."					{ TOK(ELLIPSIS); }
">>="					{ TOK(RIGHT_ASSIGN); }
"<<="					{ TOK(LEFT_ASSIGN); }
"+="					{ TOK(ADD_ASSIGN); }
"-="					{ TOK(SUB_ASSIGN); }
"*="					{ TOK(MUL_ASSIGN); }
"/="					{ TOK(DIV_ASSIGN); }
"%="					{ TOK(MOD_ASSIGN); }
"&="					{ TOK(AND_ASSIGN); }
"^="					{ TOK(XOR_ASSIGN); }
"|="					{ TOK(OR_ASSIGN); }
">>"					{ TOK(RIGHT_OP); }
"<<"					{ TOK(LEFT_OP); }
"++"					{ TOK(INC_OP); }
"--"					{ TOK(DEC_OP); }
"->"					{ TOK(PTR_OP); }
"&&"					{ TOK(AND_OP); }
"||"					{ TOK(OR_OP); }
"<="					{ TOK(LE_OP); }
">="					{ TOK(GE_OP); }
"=="					{ TOK(EQ_OP); }
"!="					{ TOK(NE_OP); }
";"					{ TOK(';'); }
("{"|"<%")				{ TOK('{'); }
("}"|"%>")				{ TOK('}'); }
","					{ TOK(','); }
":"					{ TOK(':'); }
"="					{ TOK('='); }
"("					{ TOK('('); }
")"					{ TOK(')'); }
("["|"<:")				{ TOK('['); }
("]"|":>")				{ TOK(']'); }
"."					{ TOK('.'); }
"&"					{ TOK('&'); }
"!"					{ TOK('!'); }
"~"					{ TOK('~'); }
"-"					{ TOK('-'); }
"+"					{ TOK('+'); }
"*"					{ TOK('*'); }
"/"					{ TOK('/'); }
"%"					{ TOK('%'); }
"<"					{ TOK('<'); }
">"					{ TOK('>'); }
"^"					{ TOK('^'); }
"|"					{ TOK('|'); }
"?"					{ TOK('?'); }

{WS}					{ /* whitespace separates TOKs */ }
.					{ /* discard bad characters */ }

%%

int yywrap(void)        /* called at end of input */
{
    return 1;           /* terminate now */
}

static void comment(void)
{
    int c;

    while ((c = input()) != 0)
        if (c == '*')
        {
            while ((c = input()) == '*')
                ;

            if (c == '/')
                return;

            if (c == 0)
                break;
        }
    yyerror("unterminated comment");
}

static int check_type(void)
{
    switch (sym_type(yytext))
    {
    case TYPEDEF_NAME:                /* previously defined */
        return TYPEDEF_NAME;
    case ENUMERATION_CONSTANT:        /* previously defined */
        return ENUMERATION_CONSTANT;
    default:                          /* includes undefined */
        TOK_ID(IDENTIFIER);
    }
}
