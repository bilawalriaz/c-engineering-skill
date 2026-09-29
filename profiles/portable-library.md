# Portable library profile

Treat public headers, symbols, ABI, and ownership contracts as product interfaces. Preserve the oldest supported C dialect and platform. Build the compiler/OS matrix with strict warnings; avoid relying on POSIX unless exposed as an optional backend. Test install/export consumers and shared/static variants when relevant. Keep representation and wire formats independent of host struct layout.
