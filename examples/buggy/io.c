#include <unistd.h>

int send_all(int fd, const void *data, size_t length)
{
    return write(fd, data, length) == (ssize_t)length ? 0 : -1;
}
