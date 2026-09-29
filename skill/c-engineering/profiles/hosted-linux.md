# Hosted Linux profile

Use the repository's C dialect and build. Check GCC and Clang where practical, then project tests, cppcheck/Clang analysis if present, and ASan+UBSan for memory-sensitive changes. Use TSan for shared-state changes in a separate build. Check POSIX APIs against the supported feature level; test nonblocking and partial I/O paths. Linux-specific interfaces such as epoll must remain behind an explicit platform boundary.
