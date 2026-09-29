# Embedded C

Read the MCU/reference manual, compiler ABI docs, linker script, startup code, and project coding rules. Verify actual memory map, address width, available libc, stack/heap budget, interrupt model, and timing requirements.

`volatile` is commonly needed for implementation-defined MMIO access semantics, but does not guarantee atomicity, ordering across all buses, or thread/ISR synchronization. Follow vendor rules for barriers and register access widths. Never apply ordinary read-modify-write blindly to write-one-to-clear or side-effect registers.

For DMA, verify alignment, cache coherency, ownership handoff, and lifetime. For ISR/main-loop sharing, use target-supported atomics or short critical sections and document which operations are permitted in the ISR. Prefer fixed buffers and bounded work when allocation or latency is constrained; measure stack use and interrupt latency.
