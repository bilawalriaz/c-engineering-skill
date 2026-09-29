# Repository guidance

- Keep `skill/c-engineering/SKILL.md` concise; put detailed C guidance in the focused references.
- Prefer deterministic checks and repository-native build/test commands over longer prompts.
- Preserve portability. Scripts target POSIX `sh`; explain platform or tool limitations rather than claiming checks ran.
- Do not add secrets, credentials, personal paths, or unrelated files.
- For script changes, run `sh -n` and `tests/test-scripts.sh`; exercise GCC and Clang when installed.
- Major behavioral changes should update eval cases and expected detection guidance.
- Review `git diff --check` and inspect the complete diff before committing.
