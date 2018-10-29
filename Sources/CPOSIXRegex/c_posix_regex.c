#include <c_posix_regex.h>
#include <stdlib.h>

PosixRegexCode MakePosixRegexCode(int value) {
    return (PosixRegexCode){ value };
}

PosixRegexPointer NewPosixRegexPointer() {
    regex_t *regex_ptr = malloc(sizeof(regex_t));
    return (PosixRegexPointer) { regex_ptr };
}

PosixRegexMatch NewPosixRegexMatch(int size) {
    regmatch_t *reg_match_prt = malloc(sizeof(regmatch_t) * size);
    return (PosixRegexMatch) { reg_match_prt, size };
}

PosixRegexRegmatchIndex MakePosixRegmatchIndex(regoff_t index) {
    return (PosixRegexRegmatchIndex) { index };
}

PosixRegexCode regex_compile(regex_t *regex_pointer, const char *pattern) {
    int result = regcomp(regex_pointer, pattern, REG_EXTENDED | REG_NEWLINE);
    return MakePosixRegexCode(result);
}

PosixRegexCode
regex_exec(const regex_t *regex_pointer, const char *target_string, regmatch_t *regmatch, int expected_size) {
    int result = regexec(regex_pointer, target_string, (size_t)expected_size, regmatch, 0);
    return MakePosixRegexCode(result);
}

PosixRegexRegmatchIndex regmatch_start_index(const regmatch_t *regmatch, int index) {
    regmatch_t target = regmatch[index];
    return MakePosixRegmatchIndex(target.rm_so);
}

PosixRegexRegmatchIndex regmatch_end_index(const regmatch_t *regmatch, int index) {
    regmatch_t target = regmatch[index];
    return MakePosixRegmatchIndex(target.rm_eo);
}

void regex_free(PosixRegexPointer *regex_pointer) {
    free(regex_pointer);
}

void regmatch_free(PosixRegexMatch *regex_match) {
    free(regex_match);
}
