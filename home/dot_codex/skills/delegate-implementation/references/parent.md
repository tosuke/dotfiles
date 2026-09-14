# Parent workflow

Only the root agent coordinating the user's task follows this workflow. The parent owns design, task decomposition, the Markdown task file, assignment, integration, and final review.

## Establish an agreed design

Before decomposing implementation, inspect relevant code and existing user decisions. If material design choices remain, use [design-alignment](../../design-alignment/SKILL.md) to align scope and design depth with the user. If that skill is unavailable, perform the alignment in the main agent using concrete alternatives and wait for the user's decision. Do not delegate unresolved design to implementing subagents.

Reuse an existing agreement for continuation work and skip comparisons for mechanical changes or fixes determined by established requirements and structure. A small change can still require alignment. Record required behavior, exclusions, boundaries, and acceptance criteria so implementation and review preserve the chosen depth.

## Build the task list

Before assigning implementation, create or update a persistent Markdown task file. Follow the user's location or repository convention; otherwise use `tasks/<short-task-name>.md` in the project. Reuse the same file for continuation work and share its path with the user. Conversation-only lists and internal planning tools do not replace this file. Include the agreed design or a durable reference to it. For each task, identify:

- Stable task ID, status, and assigned agent (or unassigned).
- Deliverable and acceptance criteria.
- Decided behavior, inputs and outputs, and responsibility boundaries.
- Bounded write scope, including relevant files or modules.
- Prerequisites and dependencies expressed using task IDs.
- Unresolved design questions, if any.

Resolve design questions in the main agent before assigning the affected work. A label such as "implement API" is not a sufficient brief. Define shared contracts before assigning their consumers and producers in parallel.

Choose parallel assignments only when prerequisites are satisfied, contracts are settled, and write scopes do not conflict. Different files alone do not establish independence. Sequence coupled tasks; do not invent work merely to fill agent slots. Record which tasks can run in parallel and which must wait, with the relevant dependency or shared-write constraint.

Leave mechanical implementation details to subagents within the agreed design and repository conventions. The task list does not require user approval by itself; ask the user only when new intent or material scope decisions are needed.

## Maintain the Markdown task file

The main agent owns updates to the task file; subagents report progress rather than editing the shared list concurrently.

- Use explicit statuses: `pending`, `in_progress`, `blocked`, `in_review`, and `done`. Record a blocker and the next action for blocked tasks.
- Update the file when assigning or reassigning work, receiving a blocker or implementation result, making a design decision, changing scope or dependencies, and finishing review. Keep it current throughout the work rather than reconstructing it at the end.
- A subagent's completion report moves a task to `in_review`. Mark it `done` only after the main agent reviews the actual changes and required verification passes. Record concise verification evidence and any remaining issues.
- Include integration and combined verification as explicit tasks when needed. On resumption, read the file and reconcile it with actual workspace and agent state before assigning more work.
- Preserve task IDs when revising the plan. Explicitly note removed or superseded tasks and why; do not silently drop unfinished work. Link the task file in the final handoff and accurately represent any outstanding work.

## Delegate

- Always set `fork_turns: "none"` when spawning a subagent so the parent thread history is not inherited. Supply the necessary context explicitly in the task brief.
- Default to `model: "gpt-5.6-luna"` and `reasoning_effort: "high"`, unless the user specifies otherwise. Check tool support; if unavailable, explain the limitation and ask for a fallback rather than silently substituting a model.
- Give each subagent its task ID and Markdown task-file path, the relevant repository instructions, approved design including explicit exclusions, bounded write scope, task dependencies, acceptance criteria, and verification expectations. Assign disjoint write scopes for parallel tasks.
- Have subagents edit their assigned files and report changed paths, verification results, and unresolved issues.
- Explicitly identify the recipient as a child implementation agent, provide the absolute path to `references/child.md`, and require it to read that file. Include the no-further-delegation rule and decision protocol in the brief itself; do not assume this skill or parent history is inherited.

## Decision protocol

Subagents must ask the main agent about unresolved design choices before implementing the affected work. Questions should include relevant evidence, options, and consequences. Recommendations are welcome, but are not authorization. Independent work may continue while awaiting an answer.

- Escalate choices about behavior, APIs, data structures, state ownership, dependencies, error handling, compatibility, or scope. Mechanical choices following the approved design and consistent repository conventions need no question.
- If parent messaging is unavailable, return a blocked handoff with the question so the main agent can answer and resume the work. Do not ask the user directly or delegate further.
- The main agent sends an explicit decision and any revised acceptance criteria. Resolve questions within the existing agreement without asking the user again. When new evidence changes agreed scope, constraints, or implementation and maintenance burden, reopen only the affected choice with the user before the affected implementation proceeds.

## Monitor

- Prefer notifications. Space routine active checks of the same running work at least approximately 60 seconds apart, including log reads and progress requests.
- When blocked on results, use `wait_agent` with `timeout_ms: 60000` where supported, grouping outstanding agents. A timeout alone does not justify restarting an agent.
- Handle questions, completion, failures, and user direction promptly; the interval does not delay responses to events. Do useful non-overlapping work between checks and keep user-facing updates separate from polling.

## Review

- The main agent must inspect every subagent's actual diff and relevant surrounding code for design compliance, defects, scope drift, and adequate verification. Check both that required behavior is present and that excluded mechanisms or unagreed complexity have not been added. Summaries and passing tests do not replace this review.
- Return concrete corrections and review the resulting changes again. Resolve new design questions before further implementation.
- Integrate using the actual workspace mechanism and verify the combined result in proportion to risk. Address material findings before reporting completion.
