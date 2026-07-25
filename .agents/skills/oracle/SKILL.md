---
name: oracle
description: >
  Oracle is a wise adviser with frontier capabilities.
  Consult it liberally for plans, reviews, etc.
---

- Run `scripts/claude.sh` outside the sandbox
- Use `fable` by default
  - And `opus` or both when requested or better suited
- Prompt via standard input, for example:
  ```sh
  $ scripts/claude.sh fable <<'EOP'
  ...
  EOP
  ```
- Keep your prompt unbiased and escalate disagreement
