/* PicoC implementation of endian.h */

#include "../../interpreter.h"
#include <sys/__endian.h>

/* Definitions for byte order */
static const int __DARWIN_LITTLE_ENDIANValue = __DARWIN_LITTLE_ENDIAN;
static const int __DARWIN_BIG_ENDIANValue = __DARWIN_BIG_ENDIAN;
static const int __DARWIN_PDP_ENDIANValue = __DARWIN_PDP_ENDIAN;

/* Setup function for endian.h */
void SysEndianSetupFunc(Picoc *pc)
{
    /* Define byte order constants */
    VariableDefinePlatformVar(pc, NULL, "__DARWIN_LITTLE_ENDIAN", &pc->IntType,
        (union AnyValue*)&__DARWIN_LITTLE_ENDIANValue, false);
    VariableDefinePlatformVar(pc, NULL, "__DARWIN_BIG_ENDIAN", &pc->IntType,
        (union AnyValue*)&__DARWIN_BIG_ENDIANValue, false);
    VariableDefinePlatformVar(pc, NULL, "__DARWIN_PDP_ENDIAN", &pc->IntType,
        (union AnyValue*)&__DARWIN_PDP_ENDIANValue, false);
}
