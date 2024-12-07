/* stdint.h implementation for PicoC */

#include "../interpreter.h"

/* Standard integer types and their size definitions */
typedef signed char int8_t;
typedef short int int16_t;
typedef int int32_t;
typedef long long int int64_t;

typedef unsigned char uint8_t;
typedef unsigned short int uint16_t;
typedef unsigned int uint32_t;
typedef unsigned long long int uint64_t;

/* Limits of integer types */
static const int8_t INT8_MINValue = -128;
static const int8_t INT8_MAXValue = 127;
static const uint8_t UINT8_MAXValue = 255;

static const int16_t INT16_MINValue = -32768;
static const int16_t INT16_MAXValue = 32767;
static const uint16_t UINT16_MAXValue = 65535;

static const int32_t INT32_MINValue = -2147483648;
static const int32_t INT32_MAXValue = 2147483647;
static const uint32_t UINT32_MAXValue = 4294967295U;

static const int64_t INT64_MINValue = -9223372036854775807LL - 1;
static const int64_t INT64_MAXValue = 9223372036854775807LL;
static const uint64_t UINT64_MAXValue = 18446744073709551615ULL;

/* Structure definitions for StdInt */
const char StdIntDefs[] = "\
typedef signed char int8_t; \
typedef unsigned char uint8_t; \
typedef signed short int16_t; \
typedef unsigned short uint16_t; \
typedef signed int32_t; \
typedef unsigned uint32_t; \
typedef signed long int64_t; \
typedef unsigned long uint64_t; \
typedef unsigned long uintptr_t; \
";

/* Variable definitions for integer limits */
void StdIntSetupFunc(Picoc *pc)
{
    VariableDefinePlatformVar(pc, NULL, "INT8_MIN", &pc->IntType,
        (union AnyValue*)&INT8_MINValue, false);
    VariableDefinePlatformVar(pc, NULL, "INT8_MAX", &pc->IntType,
        (union AnyValue*)&INT8_MAXValue, false);
    VariableDefinePlatformVar(pc, NULL, "UINT8_MAX", &pc->IntType,
        (union AnyValue*)&UINT8_MAXValue, false);

    VariableDefinePlatformVar(pc, NULL, "INT16_MIN", &pc->IntType,
        (union AnyValue*)&INT16_MINValue, false);
    VariableDefinePlatformVar(pc, NULL, "INT16_MAX", &pc->IntType,
        (union AnyValue*)&INT16_MAXValue, false);
    VariableDefinePlatformVar(pc, NULL, "UINT16_MAX", &pc->IntType,
        (union AnyValue*)&UINT16_MAXValue, false);

    VariableDefinePlatformVar(pc, NULL, "INT32_MIN", &pc->IntType,
        (union AnyValue*)&INT32_MINValue, false);
    VariableDefinePlatformVar(pc, NULL, "INT32_MAX", &pc->IntType,
        (union AnyValue*)&INT32_MAXValue, false);
    VariableDefinePlatformVar(pc, NULL, "UINT32_MAX", &pc->IntType,
        (union AnyValue*)&UINT32_MAXValue, false);

    VariableDefinePlatformVar(pc, NULL, "INT64_MIN", &pc->LongType,
        (union AnyValue*)&INT64_MINValue, false);
    VariableDefinePlatformVar(pc, NULL, "INT64_MAX", &pc->LongType,
        (union AnyValue*)&INT64_MAXValue, false);
    VariableDefinePlatformVar(pc, NULL, "UINT64_MAX", &pc->UnsignedLongType,
        (union AnyValue*)&UINT64_MAXValue, false);
}
