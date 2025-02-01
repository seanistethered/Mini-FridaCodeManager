//
//  arbcall.h
//  FridaPret
//
//  Created by FridaDEV on 09.12.24.
//

#ifndef arbcall_h
#define arbcall_h

#include <stdio.h>

// function to be called
void arbCall(const char *symbol, uint64_t arguments[UINT8_MAX], uint64_t *result);
void arbCallHigh(const char *symbol, uint64_t *result, uint8_t count, ...);

#endif /* arbcall_h */
