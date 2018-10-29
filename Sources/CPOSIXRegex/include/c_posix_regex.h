#ifndef C_POSIX_REGEX_H
#define C_POSIX_REGEX_H

#include <regex.h>

#ifndef REG_OK
#define REG_OK 0
#endif

typedef struct {
    int value;
} PosixRegexCode;

typedef struct {
    regex_t *pointer;
} PosixRegexPointer;

typedef struct {
    regmatch_t *match_pointer;
    int size;
} PosixRegexMatch;

typedef struct {
    regoff_t value;
} PosixRegexRegmatchIndex;

PosixRegexCode MakePosixRegexCode(int value);

PosixRegexPointer NewPosixRegexPointer();

PosixRegexMatch NewPosixRegexMatch(int size);

PosixRegexRegmatchIndex MakePosixRegmatchIndex(regoff_t index);

PosixRegexCode regex_compile(regex_t *regex_pointer, const char *pattern);

PosixRegexCode regex_exec(const regex_t *regex_pointer, const char *target_string, regmatch_t *regmatch, int expected_size);

PosixRegexRegmatchIndex regmatch_start_index(const regmatch_t *regmatch, int index);

PosixRegexRegmatchIndex regmatch_end_index(const regmatch_t *regmatch, int index);

void regex_free(PosixRegexPointer *regex_pointer);

void regmatch_free(PosixRegexMatch *regex_match);

#endif
