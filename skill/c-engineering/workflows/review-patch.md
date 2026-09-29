# Review a C patch

Read the contract and diff first. Check ownership/lifetime, bounds/termination, integer conversions, initialization, aliasing/alignment, error cleanup, ABI/platform assumptions, and synchronization. Run build/tests plus targeted analysis. Report concrete defects with locations and impact; distinguish proven behavior from implementation-specific concerns and state untested paths.
