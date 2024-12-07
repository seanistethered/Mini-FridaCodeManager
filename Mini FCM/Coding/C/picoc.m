#import "../../bridge.h"

/* picoc main program - this varies depending on your operating system and
 * how you're using picoc */
/* platform-dependent code for running programs is in this file */
#if defined(UNIX_HOST) || defined(WIN32)
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#endif

/* include only picoc.h here - should be able to use it with only the
    external interfaces, no internals from interpreter.h */
#include "picoc.h"


#if defined(UNIX_HOST) || defined(WIN32)
#include "LICENSE.h"

/* Override via STACKSIZE environment variable */
#define PICOC_STACK_SIZE (128000*4)

int c_interpret(NSString *files, NSString *proot)
{
    chdir([proot UTF8String]);
    
    int ParamCount = 1;
    int StackSize = getenv("STACKSIZE") ? atoi(getenv("STACKSIZE")) : PICOC_STACK_SIZE;
    Picoc pc;

    PicocInitialize(&pc, StackSize);

    if (PicocPlatformSetExitPoint(&pc)) {
        PicocCleanup(&pc);
        return pc.PicocExitValue;
    }
    
    NSArray *splitPaths = [files componentsSeparatedByString:@" "];
    for (NSString *path in splitPaths) {
        if (path.length > 0) {
            PicocPlatformScanFile(&pc, [path UTF8String]);
        }
    }
    
    char *argv[] = { "picoc", NULL };
    PicocCallMain(&pc, 0, &argv[ParamCount]);

    PicocCleanup(&pc);
    return pc.PicocExitValue;
}
#endif

