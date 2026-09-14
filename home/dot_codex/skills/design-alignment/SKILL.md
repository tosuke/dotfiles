---
name: design-alignment
description: Align implementation scope and design depth with the user before unresolved design choices are implemented. Present three concrete approaches when meaningful choices remain; reuse existing agreements for continuation work. Useful with either direct or delegated implementation.
---

# Design alignment

The main agent owns design and helps the user choose how much complexity and operational coverage the work warrants.

## When to align

- Inspect relevant code, repository instructions, and existing decisions before proposing approaches.
- Present alternatives when unresolved choices materially affect behavior, scope, compatibility, architecture, or implementation and maintenance burden.
- Skip a new comparison for mechanical edits, fixes whose behavior and approach follow established requirements and structure, and work continuing an agreed design. Small diff size alone is not a reason to skip alignment.
- Preserve the user's existing decisions. Reopen only the affected choice when new evidence changes agreed scope, constraints, or burden.

## Present three concrete approaches

Use the user's language and the actual task to describe:

1. **DIY / 日曜大工:** Meet the smallest relevant use case with minimal structure. State constraints, manual workarounds, and when a redesign would become necessary.
2. **Balanced / 中間:** Cover realistic exceptions and plausible near-term changes. Identify which provisions are included now and which are deferred.
3. **Enterprise / エンプラ:** Cover explicitly named broader requirements such as multiple users, long-term operation, recovery, and compatibility. State the additional assumptions and their costs; do not claim to cover every conceivable case.

For each approach, briefly show covered and excluded cases, concrete code structure or mechanisms, implementation and maintenance burden, and the conditions under which it becomes insufficient. All approaches must work correctly within their agreed scope and receive appropriate verification; simpler does not mean careless.

Recommend an approach based on evidence, without automatically favoring the middle. Do not invent implausible extremes to steer the choice. The user may combine aspects of the approaches.

Wait for the user's selection or adjustment before implementing affected work. Continue independent investigation while waiting; elapsed time is not agreement. If meaningful alternatives do not exist, explain the determined approach instead of manufacturing three options.

## Record the agreement

Keep a concise agreement in the conversation or an existing task artifact:

- Chosen approach and any combined aspects.
- Required behavior, covered cases, and explicitly excluded mechanisms or cases.
- Key responsibility boundaries and interfaces.
- Acceptance criteria and verification expectations proportional to the agreed scope.
- Remaining questions and conditions that would require renewed alignment.

This agreement is the input to implementation and review, whether the main agent implements directly or delegates. It need not introduce a new repository document. Do not leave unresolved design choices for an implementing subagent to settle.
