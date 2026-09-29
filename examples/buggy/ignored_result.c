#include <stdio.h>

int write_line(FILE *stream, const char *text)
{
    fputs(text, stream);
    return 0;
}
