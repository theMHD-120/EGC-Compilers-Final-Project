#ifndef COMMON_H
#define COMMON_H

typedef struct {
    int is_temp;  // if $$ is a temporary variable (t)
    int value;    // if $$ is a constant number
} Factor;

#endif