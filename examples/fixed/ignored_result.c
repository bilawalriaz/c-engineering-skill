#include <stdio.h>

int write_line(FILE *stream, const char *text);

int write_line(FILE *stream, const char *text)
{
    if (stream == NULL || text == NULL) return -1;
    return fputs(text, stream) == EOF ? -1 : 0;
}
