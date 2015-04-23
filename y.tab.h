#define IDENTIFIER 257
#define I_CONSTANT 258
#define F_CONSTANT 259
#define STRING_LITERAL 260
#define FUNC_NAME 261
#define SIZEOF 262
#define PTR_OP 263
#define INC_OP 264
#define DEC_OP 265
#define LEFT_OP 266
#define RIGHT_OP 267
#define LE_OP 268
#define GE_OP 269
#define EQ_OP 270
#define NE_OP 271
#define AND_OP 272
#define OR_OP 273
#define MUL_ASSIGN 274
#define DIV_ASSIGN 275
#define MOD_ASSIGN 276
#define ADD_ASSIGN 277
#define SUB_ASSIGN 278
#define LEFT_ASSIGN 279
#define RIGHT_ASSIGN 280
#define AND_ASSIGN 281
#define XOR_ASSIGN 282
#define OR_ASSIGN 283
#define TYPEDEF_NAME 284
#define ENUMERATION_CONSTANT 285
#define TYPEDEF 286
#define EXTERN 287
#define STATIC 288
#define AUTO 289
#define REGISTER 290
#define INLINE 291
#define CONST 292
#define RESTRICT 293
#define VOLATILE 294
#define BOOL 295
#define CHAR 296
#define SHORT 297
#define INT 298
#define LONG 299
#define SIGNED 300
#define UNSIGNED 301
#define FLOAT 302
#define DOUBLE 303
#define VOID 304
#define COMPLEX 305
#define IMAGINARY 306
#define STRUCT 307
#define UNION 308
#define ENUM 309
#define ELLIPSIS 310
#define CASE 311
#define DEFAULT 312
#define IF 313
#define ELSE 314
#define SWITCH 315
#define WHILE 316
#define DO 317
#define FOR 318
#define GOTO 319
#define CONTINUE 320
#define BREAK 321
#define RETURN 322
#define ALIGNAS 323
#define ALIGNOF 324
#define ATOMIC 325
#define GENERIC 326
#define NORETURN 327
#define STATIC_ASSERT 328
#define THREAD_LOCAL 329
#ifdef YYSTYPE
#undef  YYSTYPE_IS_DECLARED
#define YYSTYPE_IS_DECLARED 1
#endif
#ifndef YYSTYPE_IS_DECLARED
#define YYSTYPE_IS_DECLARED 1
typedef union 	{
	int iVal;
	float fVal;
	char *sVal;
	BINARY_TREE tVal;
} YYSTYPE;
#endif /* !YYSTYPE_IS_DECLARED */
extern YYSTYPE yylval;
