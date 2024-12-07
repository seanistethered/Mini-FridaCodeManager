/* dirent.h implementation for PicoC */

#include "../interpreter.h"
#include <dirent.h>
#include <sys/_types/_ino_t.h>

/* Define constants for dirent.h */
static const int DT_BLKValue = DT_BLK;
static const int DT_CHRValue = DT_CHR;
static const int DT_DIRValue = DT_DIR;
static const int DT_FIFOValue = DT_FIFO;
static const int DT_LNKValue = DT_LNK;
static const int DT_REGValue = DT_REG;
static const int DT_SOCKValue = DT_SOCK;
static const int DT_UNKNOWNValue = DT_UNKNOWN;

/* Directory functions */
void StdOpendir(struct ParseState *Parser, struct Value *ReturnValue,
    struct Value **Param, int NumArgs)
{
    ReturnValue->Val->Pointer = opendir(Param[0]->Val->Pointer);
}

void StdReaddir(struct ParseState *Parser, struct Value *ReturnValue,
    struct Value **Param, int NumArgs)
{
    ReturnValue->Val->Pointer = readdir((DIR *)Param[0]->Val->Pointer);
}

void StdClosedir(struct ParseState *Parser, struct Value *ReturnValue,
    struct Value **Param, int NumArgs)
{
    ReturnValue->Val->Integer = closedir((DIR *)Param[0]->Val->Pointer);
}

/* Definitions for dirent.h */
const char StdDirentDefs[] = "\
typedef struct { \
    void *handle; \
} DIR; \
typedef    __darwin_ino_t        ino_t; \
struct dirent { \
    ino_t d_ino; \
    off_t d_off; \
    unsigned short d_reclen; \
    unsigned char d_type; \
    char d_name[256]; \
}; \
";

/* Function list for dirent.h */
struct LibraryFunction StdDirentFunctions[] =
{
    {StdOpendir, "DIR *opendir(char *);"},
    {StdReaddir, "struct dirent *readdir(DIR *);"},
    {StdClosedir, "int closedir(DIR *);"},
    {NULL, NULL}
};

/* Setup function for dirent.h */
void StdDirentSetupFunc(Picoc *pc)
{
    /* Define constants */
    VariableDefinePlatformVar(pc, NULL, "DT_BLK", &pc->IntType,
        (union AnyValue*)&DT_BLKValue, false);
    VariableDefinePlatformVar(pc, NULL, "DT_CHR", &pc->IntType,
        (union AnyValue*)&DT_CHRValue, false);
    VariableDefinePlatformVar(pc, NULL, "DT_DIR", &pc->IntType,
        (union AnyValue*)&DT_DIRValue, false);
    VariableDefinePlatformVar(pc, NULL, "DT_FIFO", &pc->IntType,
        (union AnyValue*)&DT_FIFOValue, false);
    VariableDefinePlatformVar(pc, NULL, "DT_LNK", &pc->IntType,
        (union AnyValue*)&DT_LNKValue, false);
    VariableDefinePlatformVar(pc, NULL, "DT_REG", &pc->IntType,
        (union AnyValue*)&DT_REGValue, false);
    VariableDefinePlatformVar(pc, NULL, "DT_SOCK", &pc->IntType,
        (union AnyValue*)&DT_SOCKValue, false);
    VariableDefinePlatformVar(pc, NULL, "DT_UNKNOWN", &pc->IntType,
        (union AnyValue*)&DT_UNKNOWNValue, false);
}
