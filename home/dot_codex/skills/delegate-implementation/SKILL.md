---
name: delegate-implementation
description: Delegate implementation of features, fixes, and refactors to subagents after the main agent establishes an agreed design and an explicitly maintained Markdown task list with dependencies. Retain design decisions, integration, and review in the main agent.
---

# Delegate implementation

Determine your role before taking action. Read only the workflow for that role.

- **Parent:** You are the root agent coordinating the user's task, not an agent spawned by another agent. Follow [the parent workflow](references/parent.md).
- **Child:** You were spawned by another agent or received an implementation assignment from a parent agent. Follow [the child workflow](references/child.md). Do not spawn agents or delegate work further.

Use runtime role information and the assignment source to determine your role. An inherited user request, this skill's description, available delegation tools, or the size of your assignment does not make a child the parent. If your role is unclear, do not delegate; resolve the ambiguity with the assigning agent when available.
