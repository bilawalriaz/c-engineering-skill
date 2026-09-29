#include <errno.h>
#include <stddef.h>
#include <unistd.h>

int send_all(int fd, const void *data, size_t length);

int send_all(int fd, const void *data, size_t length)
{
    const unsigned char *bytes = data;
    size_t sent = 0;
    while (sent < length) {
        ssize_t result = write(fd, bytes + sent, length - sent);
        if (result > 0) {
            sent += (size_t)result;
        } else if (result < 0 && errno == EINTR) {
            continue;
        } else {
            return -1;
        }
    }
    return 0;
}
