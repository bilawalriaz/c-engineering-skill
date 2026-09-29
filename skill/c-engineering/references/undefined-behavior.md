# Undefined behavior

UB means the standard places no requirements on the program once the condition occurs. Optimizers may therefore remove or transform code based on the assumption that UB does not happen. A test passing under one optimization level does not validate the operation.

Frequent sources: signed integer overflow; shifting by a negative count or at least the promoted type width; dereferencing null, misaligned, indeterminate, or expired pointers; out-of-bounds pointer formation/dereference; invalid format arguments; incompatible effective type access; unsequenced conflicting side effects; division by zero; and data races in C11's memory model.

Check arithmetic before performing it, keep pointer arithmetic within an array object (including one-past only for comparison/subtraction rules), and use sanitizers where available. Sanitizers observe executed paths and do not prove absence of UB. C permits some implementation-defined and unspecified behavior; label those accurately rather than calling every surprising result UB.
