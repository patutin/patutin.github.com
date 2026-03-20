# Domain 1: Agentic Architecture & Orchestration

## agentic-loop-lifecycle
**Knowledge:** The agentic loop lifecycle: sending requests to Claude, inspecting `stop_reason` (`"tool_use"` vs `"end_turn"`), executing requested tools, and returning results for the next iteration
**Source:** [Handling Stop Reasons](https://platform.claude.com/docs/en/build-with-claude/handling-stop-reasons) | [Tool Use Overview](https://platform.claude.com/docs/en/agents-and-tools/tool-use/overview)

The agentic loop is the fundamental execution pattern for autonomous Claude agents. It follows a predictable cycle:

1. **Send a request** to Claude with the current conversation history and available tools.
2. **Inspect `stop_reason`** on the response to determine what happened:
   - `"tool_use"` — Claude wants to call a tool. The loop continues.
   - `"end_turn"` — Claude has finished reasoning and produced a final answer. The loop terminates.
3. **Execute the requested tool(s)** and collect results.
4. **Append tool results** to the conversation history so Claude can reason about them in the next iteration.
5. **Repeat** from step 1.

The critical insight is that **Claude drives the decision-making**. The model decides which tool to call next based on context, not the developer.

All `stop_reason` values:

| Value | Meaning | Loop Action |
|-------|---------|-------------|
| `"end_turn"` | Claude finished reasoning | **Exit loop** — extract final text |
| `"tool_use"` | Claude wants to call tool(s) | **Continue loop** — execute tools, append results |
| `"max_tokens"` | Response truncated | Handle truncation (retry with higher limit) |
| `"stop_sequence"` | Hit a custom stop sequence | Handle per application logic |
| `"pause_turn"` | Server-side sampling loop reached its iteration limit (default 10) while executing server tools | Append response as-is and continue conversation |
| `"refusal"` | Model refused the request | Handle refusal gracefully |
| `"model_context_window_exceeded"` | Claude reached the model's context window limit | Handle like `max_tokens`; available by default in Sonnet 4.5+ |

**Caveat — Empty responses with `end_turn`:** Claude may return an empty response (2-3 tokens, no content) with `stop_reason: "end_turn"` if text blocks are added immediately after tool results in conversation history. To prevent this, never add text blocks immediately after tool results, and do not retry empty responses without modification.

---

## tool-results-in-conversation-history
**Knowledge:** How tool results are appended to conversation history so the model can reason about the next action
**Source:** [How to Implement Tool Use](https://platform.claude.com/docs/en/agents-and-tools/tool-use/implement-tool-use)

Tool results must be appended to the conversation as proper `tool_result` content blocks. This allows Claude to see what data was returned, reason about whether the data is sufficient, and synthesize results from multiple tool calls.

Each tool-use iteration adds exactly **+2 messages** (one assistant, one user with tool results). Critical API rules:

1. Tool result blocks must immediately follow their corresponding tool use blocks — no messages can be inserted between.
2. Each `tool_result` must reference a `tool_use_id` matching the `id` from the corresponding `tool_use` block.
3. The assistant's entire response (text + tool_use blocks) must be appended as a single message with `"role": "assistant"`.
4. Claude may request multiple tools in a single response — all must be executed and returned in the same `tool_result` user message.
5. Within the user message containing tool results, `tool_result` blocks must come **FIRST** in the content array. Any text must come **AFTER** all tool results.

**Tool runner (beta):** The Python, TypeScript, and Ruby SDKs now provide a tool runner that automatically handles tool execution, result formatting, and conversation management. For most tool use implementations, this eliminates the need for manual handling described above.

---

## model-driven-vs-preconfigured
**Knowledge:** The distinction between model-driven decision-making (Claude reasons about which tool to call next based on context) and pre-configured decision trees or tool sequences
**Source:** [Building Effective Agents](https://www.anthropic.com/engineering/building-effective-agents)

| Aspect | Model-Driven (Correct) | Pre-Configured (Anti-Pattern) |
|--------|----------------------|------------------------------|
| Who decides next tool? | Claude, based on context | Developer, via if/else logic |
| Adaptability | High — handles novel situations | Low — only follows predefined paths |
| When to use | Default for agentic loops | Only for strict compliance gates |

Hardcoding "always call tool A, then tool B, then tool C" defeats the purpose of an agentic loop. Let Claude decide based on context (except for true compliance gates that require programmatic enforcement).

---

## agentic-loop-anti-patterns
**Knowledge:** Anti-patterns for agentic loop termination: parsing natural language signals to determine loop termination, setting arbitrary iteration caps as the primary stopping mechanism, or checking for assistant text content as a completion indicator
**Source:** [Tool Use Overview](https://platform.claude.com/docs/en/agents-and-tools/tool-use/overview)

Three critical anti-patterns:

1. **Parsing natural language to determine loop termination**: Do NOT scan Claude's text output for phrases like "I'm done" or "task complete." Always use `stop_reason`.
2. **Arbitrary iteration caps as the primary stopping mechanism**: Setting `max_iterations = 5` as your main way to stop the loop is wrong. Caps are acceptable only as safety nets, not primary control flow.
3. **Checking for assistant text content as a completion indicator**: Claude may produce text alongside tool calls — the presence of text does not mean the task is done.

---

## hub-and-spoke-architecture
**Knowledge:** Hub-and-spoke architecture where a coordinator agent manages all inter-subagent communication, error handling, and information routing
**Source:** [How We Built Our Multi-Agent Research System](https://www.anthropic.com/engineering/multi-agent-research-system) | [Building Effective Agents](https://www.anthropic.com/engineering/building-effective-agents)

Multi-agent systems in the Claude Agent SDK follow a hub-and-spoke (coordinator-subagent) pattern:

- A **coordinator agent** sits at the center and manages all communication.
- **Subagents** are spokes — they receive tasks from the coordinator and return results to it.
- Subagents **never communicate directly** with each other. All information flows through the coordinator.

The coordinator's responsibilities:
1. **Task decomposition**: Breaking a complex request into subtasks.
2. **Delegation**: Selecting which subagents to invoke based on query complexity.
3. **Result aggregation**: Collecting and synthesizing outputs from subagents.
4. **Error handling**: Managing failures, retries, and fallback strategies.
5. **Information routing**: Passing relevant context from one subagent's output to another's input.

A well-designed coordinator **dynamically selects** which subagents to invoke based on query requirements, not always routing through the full pipeline.

---

## subagent-context-isolation
**Knowledge:** Subagents operate with isolated context—they do not inherit the coordinator's conversation history, and context must be explicitly provided in the prompt
**Source:** [Agent SDK Overview](https://platform.claude.com/docs/en/agent-sdk/overview)

**Subagents do NOT automatically inherit parent context.** When a coordinator spawns a subagent:

- The subagent starts with a blank slate.
- It only knows what the coordinator **explicitly includes in the prompt**.
- It cannot access the coordinator's conversation history.
- It cannot access other subagents' outputs unless the coordinator passes them.
- There is **no shared memory** between separate invocations (each new spawn starts fresh).
- However, subagents **can be resumed** — the coordinator can use `SendMessage` with the agent's ID to continue a stopped subagent. Resumed subagents retain their full conversation history, including all previous tool calls and reasoning.
- Subagents also receive basic environment details (e.g., working directory) alongside the prompt, but not the full parent system prompt.

| Direction | What Flows | What Doesn't |
|-----------|-----------|--------------|
| **Parent → Subagent** | Agent tool's `prompt` string + basic environment details (e.g., cwd) | Parent conversation history, full system prompt, tool results |
| **Subagent → Parent** | Subagent's final message (verbatim) | Intermediate tool calls, reasoning, full transcript |

Include any file paths, error messages, or decisions the subagent needs **directly in the Agent tool prompt**, since that's the only data channel.

---

## coordinator-responsibilities
**Knowledge:** The role of the coordinator in task decomposition, delegation, result aggregation, and deciding which subagents to invoke based on query complexity
**Source:** [Agent SDK Overview](https://platform.claude.com/docs/en/agent-sdk/overview)

The coordinator performs four key functions: task decomposition (breaking complex requests into subtasks appropriate for individual subagents), delegation (selecting which subagents to invoke based on query complexity and requirements), result aggregation (collecting outputs from subagents and synthesizing them), and information routing (passing relevant context from one subagent's output to another's input).

A critical design point: the coordinator should **dynamically select** which subagents to invoke. A simple factual query might only need one search subagent; a complex research question might need search, analysis, and synthesis subagents.

---

## narrow-decomposition-risk
**Knowledge:** Risks of overly narrow task decomposition by the coordinator, leading to incomplete coverage of broad research topics
**Source:** [How We Built Our Multi-Agent Research System](https://www.anthropic.com/engineering/multi-agent-research-system)

A coordinator can decompose tasks **too narrowly**, causing incomplete coverage. Example: asked about "AI impact on creative industries," the coordinator decomposes into only "AI in digital art," "AI in graphic design," and "AI in photography" — missing music, writing, film, and other creative domains entirely.

The subagents did their jobs correctly — they thoroughly covered the topics they were assigned. The failure is upstream: the coordinator's decomposition only captured visual arts subcategories. The fix is to ensure decomposition covers the full breadth of the topic.

---

## task-tool-spawning
**Knowledge:** The `Task` tool as the mechanism for spawning subagents, and the requirement that `allowedTools` must include `"Task"` for a coordinator to invoke subagents
**Source:** [Agent SDK Overview](https://platform.claude.com/docs/en/agent-sdk/overview)

The `Task` tool (renamed to `Agent` in Claude Code v2.1.63) is the mechanism for spawning subagents. Key requirements:

- The coordinator's `allowedTools` must include `"Agent"` (or legacy `"Task"`) for it to be able to invoke subagents.
- Fine-grained control: use `Agent(worker, researcher)` syntax in the `tools` field to restrict which specific subagent types can be spawned (allowlist). Omitting parentheses (`Agent`) allows spawning any subagent.
- Each `Task` call creates a new subagent with its own isolated context.
- The coordinator can emit **multiple `Task` tool calls in a single response** to spawn parallel subagents.
- **Subagents cannot spawn their own subagents** — do not include `"Agent"` in a subagent's tools array.
- Subagents can be **resumed** via `SendMessage` with the agent ID, retaining full conversation history.

Agent tool input parameters:

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `agent_name` / `agent_type` | `string` | Yes | Key from agents dict or built-in type |
| `prompt` | `string` | Yes | The full instruction/context — the **only data channel** |
| `description` | `string` | No | Short description for logging/UI |

---

## agent-definition-configuration
**Knowledge:** The `AgentDefinition` configuration including descriptions, system prompts, and tool restrictions for each subagent type
**Source:** [Agent SDK – Python](https://platform.claude.com/docs/en/agent-sdk/python)

Each subagent type is configured via an `AgentDefinition`:

**SDK `AgentDefinition` (programmatic, Python/TypeScript):**

```python
class AgentDefinition:
    description: str          # Required — when to use this agent
    prompt: str               # Required — subagent's system prompt
    tools: list[str] | None = None   # Optional — allowed tools (None = inherit all)
    model: str | None = None         # Optional — model override (None = use parent's)
```

**File-based subagent definition (`.claude/agents/*.md` frontmatter and CLI `--agents` flag)** supports additional fields beyond the SDK type: `name`, `disallowedTools`, `permissionMode`, `maxTurns`, `skills`, `mcpServers`, `hooks`, `memory` (`user`/`project`/`local`), `background`, `effort`, `isolation` (`worktree`).

| Field | Default | Notes |
|-------|---------|-------|
| `tools` | `None` (inherit all) | Do **not** include `"Agent"` — subagents cannot spawn sub-subagents |
| `model` | `None` (use parent's) | Accepts aliases (`"sonnet"`, `"opus"`, `"haiku"`), full model IDs (e.g., `claude-opus-4-6`), or `"inherit"` |

Common tool configurations:

| Use Case | Tools |
|----------|-------|
| Read-only analysis | `["Read", "Grep", "Glob"]` |
| Test execution | `["Bash", "Read", "Grep"]` |
| Code modification | `["Read", "Edit", "Write", "Grep", "Glob"]` |

---

## fork-based-session-management
**Knowledge:** Fork-based session management (`fork_session`) for creating independent branches from a shared analysis baseline to explore divergent approaches
**Source:** [Claude Code Subagents](https://code.claude.com/docs/en/sub-agents) | [Agent SDK Sessions](https://platform.claude.com/docs/en/agent-sdk/sessions) | [Claude Code Common Workflows](https://code.claude.com/docs/en/common-workflows)

`fork_session` creates an independent branch from a shared analysis baseline:

- Both branches start from the same point (e.g., after initial codebase analysis).
- Each branch can explore a different approach independently.
- Branches are fully independent — changes in one do not affect the other.

CLI usage: `claude --resume <session-id> --fork-session`

Key constraint: `--fork-session` **must** be combined with `--resume` or `--continue` — it does not work standalone.

### Scenarios Where Forking Outperforms Resume-with-Summary

**Scenario 1 — Exploring Divergent Architecture Approaches**
After a shared codebase-analysis session (e.g., mapping auth module dependencies), you want to compare *JWT-based auth* vs *OAuth2-based auth*. Fork the session twice from the analysis baseline; each fork already has full context of module layouts, dependencies, and constraints. Resume-with-summary would force you to re-explain the entire analysis or risk losing nuance.

**Scenario 2 — Running Parallel Refactoring Experiments**
You have a monolith extraction session that identified 5 candidate services. Fork once per candidate strategy (e.g., "extract UserService first" vs "extract PaymentService first"). Each fork retains the full dependency map. Combine with `--worktree` or `isolation: worktree` on subagents so file-system changes don't collide. Resume-with-summary cannot preserve the rich intermediate reasoning (tool outputs, dependency graphs) that each fork inherits.

**Scenario 3 — A/B Testing Prompt Approaches from the Same Baseline**
During a debugging session, you've narrowed the issue to a race condition. Fork once to try a lock-based fix, fork again to try an event-driven fix. Both forks share the same diagnostic context (stack traces, repro steps, file reads). With resume-with-summary, you'd need to re-run diagnostics or trust a lossy summary.

### Fork vs Resume-with-Summary — Comparison Table

| Dimension | Fork (`--fork-session`) | Resume-with-Summary (new session + summary) |
|---|---|---|
| **Context fidelity** | Full transcript copied — all tool outputs, reasoning, file reads | Lossy — summary captures conclusions but drops intermediate detail |
| **Stale data risk** | Inherits stale tool results (API responses, search results) | Clean slate — no stale data if you craft the summary carefully |
| **Setup cost** | Zero — one CLI flag | Manual — you must write/generate the summary |
| **Parallelism** | Excellent — fork N times from one baseline for N experiments | Poor — each new session needs its own summary, hard to keep consistent |
| **Context window usage** | Starts with parent's full token count | Starts lean — only summary tokens |
| **Best when** | Exploring divergent approaches from a *recent, still-valid* baseline | Returning after significant codebase changes or long time gaps |
| **Filesystem isolation** | ⚠️ Both sessions share the working directory (use worktrees) | Each session is independent by default |
| **Session ID** | New ID auto-generated; parent unchanged | Entirely new session |

### Decision Criteria — When to Fork vs When to Resume vs When to Start Fresh

1. **Fork** when: the parent session is recent, tool results are still valid, and you want to explore ≥2 alternative approaches from the same baseline.
2. **Resume** (`--resume`) when: you want to continue a single line of work, context is still valid, and no branching is needed.
3. **Start fresh with summary** when: significant time has passed, codebase has changed materially, or tool results (API data, search results, test outputs) are stale.
4. **Fork + Worktree** (`--fork-session` + `--worktree`) when: forked sessions will make file changes that could conflict. Each worktree gets an isolated copy of the repository.

### SDK Pattern — Parallel Forking

```python
import asyncio
from claude_agent_sdk import query, ClaudeAgentOptions

async def explore_branch(base_id: str, prompt: str):
    opts = ClaudeAgentOptions(resume=base_id, fork_session=True)
    async for msg in query(prompt=prompt, options=opts):
        if hasattr(msg, "session_id"):
            return msg.session_id

async def main():
    # Phase 1: shared analysis
    base_session = None
    async for msg in query(prompt="Analyze the auth module"):
        if hasattr(msg, "session_id"):
            base_session = msg.session_id

    # Phase 2: parallel divergent exploration
    results = await asyncio.gather(
        explore_branch(base_session, "Refactor auth to use OAuth2"),
        explore_branch(base_session, "Refactor auth to use JWT + refresh tokens"),
        explore_branch(base_session, "Refactor auth to use session cookies"),
    )
    # results = [fork_id_1, fork_id_2, fork_id_3]
```

---

## partitioning-research-scope
**Knowledge:** Partitioning research scope across subagents to minimize duplication (e.g., assigning distinct subtopics or source types to each agent)
**Source:** [How We Built Our Multi-Agent Research System](https://www.anthropic.com/engineering/multi-agent-research-system)

Assign distinct subtopics or source types to each subagent to minimize duplication of effort. This partitioning must be done carefully to ensure full coverage without gaps. The coordinator should verify that the union of all subagent assignments covers the full scope of the research question.

### Scope Assignment Strategies

**Strategy 1 — By Subtopic (Facet Decomposition):**
The coordinator decomposes the query into non-overlapping conceptual facets. Each subagent owns one facet exclusively.

Example — "Research React Server Components":
- Subagent A → *Architecture & mental model*: What RSCs are, server/client boundary, rendering lifecycle
- Subagent B → *Performance & data fetching*: Bundle-size impact, streaming SSR, caching strategies
- Subagent C → *Ecosystem & adoption*: Framework support (Next.js App Router, Remix), migration patterns, limitations

The coordinator's decomposition prompt explicitly states: *"Each subtopic must be independent. Do NOT overlap with the other subagents' scopes."*

**Strategy 2 — By Source Type:**
Instead of splitting by topic, assign each subagent a different class of sources:
- Subagent A → Academic papers and official documentation
- Subagent B → Blog posts, conference talks, and community discussions
- Subagent C → GitHub repositories, changelogs, and code examples

This works well when the topic is narrow but benefits from diverse evidence types.

**Strategy 3 — By Depth Level:**
Useful for exploratory queries where breadth must precede depth:
- **Phase 1 (breadth):** 3–5 subagents each perform short, broad searches. They return high-level summaries.
- **Phase 2 (depth):** The coordinator reads Phase 1 results, identifies the 2–3 most promising leads, and spawns new subagents to investigate those in depth.

### Overlap Detection and Resolution

1. **Explicit boundary prompting** — The coordinator tells each subagent what the *other* subagents are covering:
   ```
   You are researching [Topic X]. Another agent is handling [Topic Y]
   and a third is handling [Topic Z]. Do NOT investigate those areas.
   ```

2. **Post-hoc deduplication at synthesis** — The coordinator compares returned findings. When two subagents return the same fact, the coordinator keeps the richer version and discards the duplicate.

3. **Iterative re-delegation** — After the first round, the coordinator checks for gaps and overlaps. If two subagents both covered caching but neither covered streaming, the coordinator spawns a new subagent for the gap.

---

## iterative-refinement-loops
**Knowledge:** Iterative refinement loops where the coordinator evaluates synthesis output for gaps, re-delegates to search and analysis subagents with targeted queries, and re-invokes synthesis until coverage is sufficient
**Source:** [How We Built Our Multi-Agent Research System](https://www.anthropic.com/engineering/multi-agent-research-system)

The coordinator can implement refinement loops:

1. Delegate initial work to subagents (search, analysis).
2. Invoke a synthesis subagent to produce output.
3. **Evaluate** the synthesis output for gaps or quality issues.
4. If gaps exist, **re-delegate** to search and analysis subagents with targeted queries addressing the specific gaps.
5. **Re-invoke** synthesis until coverage is sufficient.

This prevents one-shot failures where the first decomposition misses important areas.

---

## structured-data-context-passing
**Knowledge:** Using structured data formats to separate content from metadata (source URLs, document names, page numbers) when passing context between agents to preserve attribution
**Source:** [How We Built Our Multi-Agent Research System](https://www.anthropic.com/engineering/multi-agent-research-system)

When passing context between agents, use **structured data formats** that separate content from metadata:

```json
{
  "content": "The research findings...",
  "metadata": {
    "source_url": "https://example.com/article",
    "document_name": "AI Impact Report 2024",
    "page_number": 42,
    "retrieved_at": "2024-01-15T10:30:00Z"
  }
}
```

This separation preserves **attribution** — the downstream agent knows where information came from, which is critical for citation, verification, and trust. Passing unstructured context blobs makes it impossible for downstream agents to attribute sources.

---

## parallel-subagent-spawning
**Knowledge:** Spawning parallel subagents by emitting multiple `Task` tool calls in a single coordinator response rather than across separate turns
**Source:** [Agent SDK Overview](https://platform.claude.com/docs/en/agent-sdk/overview)

Claude can emit **multiple `ToolUseBlock`s with `name="Agent"`** in a single response for concurrent execution. This is the correct way to achieve parallelism — not sequential spawning across separate turns.

Anti-pattern: Spawning subagents one at a time across separate turns when they could run in parallel wastes time.

---

## goal-oriented-coordinator-prompts
**Knowledge:** Designing coordinator prompts that specify research goals and quality criteria rather than step-by-step procedural instructions, to enable subagent adaptability
**Source:** [How We Built Our Multi-Agent Research System](https://www.anthropic.com/engineering/multi-agent-research-system)

Coordinator prompts should specify **research goals and quality criteria** rather than step-by-step procedural instructions:

- **Good**: "Research the environmental impact of data centers. Ensure coverage of energy consumption, water usage, and e-waste. Output should include quantified data with sources."
- **Bad**: "Step 1: Search for 'data center energy consumption'. Step 2: Search for 'data center water usage'. Step 3: Combine results."

The goal-oriented approach lets the subagent adapt its strategy based on what it finds, while the procedural approach is brittle and may miss important angles.

---

## programmatic-vs-prompt-enforcement
**Knowledge:** The difference between programmatic enforcement (hooks, prerequisite gates) for deterministic guarantees and prompt-based guidance for probabilistic compliance; prompt instructions alone have a non-zero failure rate when deterministic compliance is required
**Source:** [Agent SDK Hooks](https://platform.claude.com/docs/en/agent-sdk/hooks)

Two ways to enforce workflow ordering:

- **Prompt-based guidance**: Instructions in the system prompt. This is *probabilistic* — Claude will usually follow the instructions, but has a **non-zero failure rate** for critical sequences.
- **Programmatic enforcement**: Code-level prerequisites that physically block downstream tool calls until prior steps complete. This is *deterministic*.

**Rule of thumb**: When deterministic compliance is required (identity verification before financial operations, authorization before data access), you must use programmatic enforcement. Prompt instructions alone are insufficient for critical business logic.

---

## structured-handoff-protocols
**Knowledge:** Structured handoff protocols for mid-process escalation that include customer details, root cause analysis, and recommended actions
**Source:** [Agent SDK Overview](https://platform.claude.com/docs/en/agent-sdk/overview)

When an agent escalates to a human, the handoff must include structured context because the human agent lacks access to the conversation transcript. A proper handoff summary includes:

- Customer ID (verified)
- Root cause analysis
- Refund amount or action details
- Recommended action
- Summary of what was already attempted

---

## multi-concern-decomposition
**Knowledge:** Decomposing multi-concern customer requests into distinct items, then investigating each in parallel using shared context before synthesizing a unified resolution
**Source:** [Building Effective Agents](https://www.anthropic.com/engineering/building-effective-agents) | [How We Built Our Multi-Agent Research System](https://www.anthropic.com/engineering/multi-agent-research-system)

When a customer message contains multiple issues, the coordinator should decompose it into distinct concern items, investigate each in parallel via subagents, then synthesize a unified resolution. This is the **parallelization → sectioning** pattern from Anthropic's "Building Effective Agents" guide, applied to customer support.

### Why Parallel Decomposition?

Single-pass handling of multi-issue messages causes **attention dilution** — the model loses focus and under-investigates later concerns. Decomposition into parallel subagents ensures each concern gets dedicated context and focused tool access. Anthropic's multi-agent research system showed a **90.2% performance improvement** over single-agent approaches on breadth-first tasks (internal eval).

### Worked Example: Multi-Issue Customer Message

**Customer message:**
> "I was double-charged $49.99 on order #8842, my blender from order #8840 arrived with a cracked lid, and I need to change my shipping address to 742 Evergreen Terrace for my next subscription box."

**Step 1 — Coordinator Decomposes into 3 Concerns**

The coordinator analyzes the message, identifies three independent concerns, and spawns three parallel subagents via multiple `Agent` tool calls in a single response:

| Concern | Subagent | Assigned Tools |
|---------|----------|----------------|
| Double-charge on #8842 | `billing-investigator` | `lookup_order`, `lookup_payments`, `issue_refund` |
| Damaged item on #8840 | `fulfillment-investigator` | `lookup_order`, `lookup_shipment`, `create_return_label` |
| Address change for subscription | `account-investigator` | `lookup_customer`, `update_address`, `lookup_subscription` |

**Step 2 — Shared Context Each Subagent Receives**

Each subagent receives a **focused prompt** from the coordinator containing only what it needs. Because subagents have **isolated context** (they do NOT inherit parent conversation history), the coordinator must include all relevant details in the prompt:

```
── billing-investigator prompt ──────────────────────────────
Customer ID: C-9031
Concern: Customer reports double-charge of $49.99 on order #8842.
Instructions: Look up order #8842 and its payment records.
Verify whether a duplicate charge exists. If confirmed, issue a
refund for the duplicate amount. Report: charge details, whether
duplicate confirmed, and action taken.

── fulfillment-investigator prompt ──────────────────────────
Customer ID: C-9031
Concern: Customer reports blender from order #8840 arrived with
a cracked lid.
Instructions: Look up order #8840 and its shipment tracking.
Create a prepaid return label for the damaged item and initiate
a replacement. Report: item details, return label number, and
replacement ETA.

── account-investigator prompt ──────────────────────────────
Customer ID: C-9031
Concern: Customer wants to change shipping address to
"742 Evergreen Terrace" for future subscription deliveries.
Instructions: Look up the customer's subscription. Update the
shipping address. Confirm the change and report when it takes
effect (next billing cycle or immediately).
```

**Key shared context elements across all prompts:**
- **Customer ID** (C-9031) — enables each subagent to access the same account
- **Specific order/reference numbers** — scopes each investigation precisely
- **Clear output format instructions** — ensures the coordinator can synthesize results

**Step 3 — Parallel Investigation (Subagents Execute Concurrently)**

All three subagents run simultaneously, each with its own context window:

```
billing-investigator:        fulfillment-investigator:     account-investigator:
  → lookup_order(#8842)        → lookup_order(#8840)        → lookup_customer(C-9031)
  → lookup_payments(#8842)     → lookup_shipment(#8840)     → lookup_subscription(C-9031)
  → [confirms duplicate]       → create_return_label(...)   → update_address(...)
  → issue_refund($49.99)       → [replacement initiated]    → [address updated]
  → returns findings           → returns findings           → returns findings
```

**Step 4 — Coordinator Synthesizes Unified Response**

The coordinator receives all three subagent results as `tool_result` blocks and composes a single, cohesive reply:

> "Hi! I've looked into all three of your concerns:
>
> **Double Charge (Order #8842):** Confirmed — you were charged $49.99 twice on June 12. I've issued a refund of $49.99 to your Visa ending in 4421. It should appear within 3–5 business days.
>
> **Damaged Blender (Order #8840):** I'm sorry about the cracked lid. I've created a prepaid return label (RMA-29481) — check your email. A replacement blender will ship within 2 business days once we receive the return.
>
> **Shipping Address Update:** Your subscription shipping address has been updated to 742 Evergreen Terrace. This will apply starting with your next subscription box on July 1.
>
> Is there anything else I can help with?"

### Architecture Pattern: Why This Works

```
                        ┌─────────────────────┐
                        │    Coordinator       │
                        │  (receives message,  │
                        │   decomposes, then   │
                        │   synthesizes)       │
                        └──┬──────┬──────┬─────┘
                  prompt │  │prompt│      │ prompt
                  ┌──────┘  │     │      └──────┐
                  ▼         ▼     │              ▼
          ┌──────────┐ ┌──────────┐       ┌──────────┐
          │ Billing  │ │Fulfillmt │       │ Account  │
          │ Subagent │ │ Subagent │       │ Subagent │
          └────┬─────┘ └────┬─────┘       └────┬─────┘
               │            │                   │
          result│       result│              result│
               └────────┬───┘                   │
                        ▼                       │
                  ┌─────────────────────┐       │
                  │   Coordinator       │◄──────┘
                  │  (synthesizes all   │
                  │   results into one  │
                  │   unified reply)    │
                  └─────────────────────┘
```

**Critical design principles:**
1. **Hub-and-spoke only** — subagents never communicate directly. All results flow back through the coordinator.
2. **Context is explicit** — the coordinator passes Customer ID, order numbers, and specific instructions in each prompt. Subagents have no other data channel.
3. **Scoped tools** — each subagent gets only the tools relevant to its concern (billing tools, fulfillment tools, account tools). This prevents cross-concern mistakes and enforces least-privilege.
4. **Parallel execution** — the coordinator emits all three `Agent` tool calls in a single response, enabling concurrent execution. This cuts total resolution time by ~60-70% vs sequential.
5. **Unified synthesis** — the customer receives one coherent response, not three fragmented answers.

---

## post-tool-use-hooks
**Knowledge:** Hook patterns (e.g., `PostToolUse`) that intercept tool results for transformation before the model processes them
**Source:** [Agent SDK Hooks](https://platform.claude.com/docs/en/agent-sdk/hooks) | [Claude Code Hooks](https://code.claude.com/docs/en/hooks)

PostToolUse hooks intercept tool results *after* execution but *before* Claude processes them. Used for data normalization (converting timestamps, status codes, etc. into consistent formats).

The `additionalContext` field appends text alongside the tool result that Claude sees, instructing it to prefer the normalized data.

Hook callback signature:
```python
async def my_hook(
    input_data: HookInput,
    tool_use_id: str | None,
    context: HookContext,
) -> HookJSONOutput:
    ...
```

---

## pre-tool-use-hooks
**Knowledge:** Hook patterns that intercept outgoing tool calls to enforce compliance rules (e.g., blocking refunds above a threshold)
**Source:** [Agent SDK Hooks](https://platform.claude.com/docs/en/agent-sdk/hooks)

Pre-tool-call hooks intercept outgoing tool calls *before* execution. Used for policy enforcement (blocking refunds above a threshold, requiring authorization).

The hook returns a `permissionDecision`: `"deny"` blocks the action, `"allow"` lets it proceed (possibly with `updatedInput`), and `"ask"` prompts the user. Priority rules: **deny > ask > allow** when multiple hooks apply.

---

## data-normalization-hooks
**Knowledge:** Using `PostToolUse` hooks to normalize heterogeneous data formats (Unix timestamps, ISO 8601, numeric status codes) from different MCP tools
**Source:** [Agent SDK Hooks](https://platform.claude.com/docs/en/agent-sdk/hooks)

PostToolUse hooks can normalize tool output — converting Unix timestamps to ISO 8601 and numeric status codes to human-readable strings — *before* Claude processes the results. This ensures consistent data formats regardless of which MCP tool produced the result.

The key mechanism: The `additionalContext` field injects normalized data alongside the raw tool result, with instructions to prefer the normalized values.

---

## pipelines-vs-adaptive-decomposition
**Knowledge:** When to use fixed sequential pipelines (prompt chaining) versus dynamic adaptive decomposition based on intermediate findings
**Source:** [Building Effective Agents](https://www.anthropic.com/engineering/building-effective-agents)

| Approach | Best For | Advantage | Limitation |
|----------|----------|-----------|------------|
| **Fixed Sequential Pipelines** | Structured reviews, multi-aspect analysis with known aspects | Predictable, debuggable, consistent | Cannot adapt to unexpected findings |
| **Dynamic Adaptive Decomposition** | Open-ended investigation, research, legacy codebase exploration | Handles unknowns, adapts to findings | Less predictable, harder to debug |

Example of fixed pipeline: Code review → analyze each file individually → run a cross-file integration pass.

Example of adaptive: "Add comprehensive tests" → first map the codebase structure → identify high-impact areas → create a prioritized plan that adapts as dependencies are discovered.

---

## prompt-chaining-patterns
**Knowledge:** Prompt chaining patterns that break reviews into sequential steps (e.g., analyze each file individually, then run a cross-file integration pass) to avoid attention dilution
**Source:** [Building Effective Agents](https://www.anthropic.com/engineering/building-effective-agents) | [Cookbook: Agentic Patterns](https://github.com/anthropics/claude-cookbooks/tree/main/patterns/agents)

When reviewing large artifacts (e.g., a 14-file PR), processing everything in a single pass leads to **attention dilution**. The solution is to split into focused passes:

1. **Per-file local analysis**: Analyze each file individually for local issues (bugs, style, logic errors).
2. **Cross-file integration pass**: A separate pass focused on data flow between files, API contract consistency, and integration issues.

This two-pass approach is more reliable than a single monolithic review.

---

## adaptive-investigation-plans
**Knowledge:** The value of adaptive investigation plans that generate subtasks based on what is discovered at each step
**Source:** [How We Built Our Multi-Agent Research System](https://www.anthropic.com/engineering/multi-agent-research-system)

Dynamic adaptive decomposition generates subtasks **based on what is discovered** at each step. Best for open-ended investigation, research, and legacy codebase exploration.

The advantage is handling unknowns and adapting to findings. The limitation is less predictability and harder debugging.

---

## open-ended-task-decomposition
**Knowledge:** Decomposing open-ended tasks by first mapping structure, identifying high-impact areas, then creating a prioritized plan that adapts as dependencies are discovered
**Source:** [How We Built Our Multi-Agent Research System](https://www.anthropic.com/engineering/multi-agent-research-system)

For open-ended tasks like "Add comprehensive tests":

1. First **map the codebase structure** to understand what exists.
2. **Identify high-impact areas** that need testing most.
3. **Create a prioritized plan** that adapts as dependencies are discovered during implementation.

This approach avoids the trap of generating a rigid plan upfront that becomes obsolete as you learn more about the codebase.

---

## named-session-resumption
**Knowledge:** Named session resumption using `--resume <session-name>` to continue a specific prior conversation
**Source:** [Claude Code Common Workflows](https://code.claude.com/docs/en/common-workflows)

Named sessions allow continuing prior conversations:

```bash
claude --resume auth-refactor          # Resume by name
claude -r 550e8400-e29b-41d4-...       # Resume by session UUID
claude -c                              # Continue most recent session
```

Use case: Multi-day investigations, ongoing code review, iterative development tasks. The agent picks up with all prior conversation context intact.

---

## informing-resumed-sessions
**Knowledge:** The importance of informing the agent about changes to previously analyzed files when resuming sessions after code modifications
**Source:** [Claude Code Common Workflows](https://code.claude.com/docs/en/common-workflows)

When resuming sessions after code modifications, you must **inform the agent about changes** to previously analyzed files. The agent's prior analysis may be stale, and it won't automatically detect that files have changed. Without this, the agent will reason based on incorrect information.

---

## fresh-session-vs-stale-resume
**Knowledge:** Why starting a new session with a structured summary is more reliable than resuming with stale tool results
**Source:** [Claude Code Best Practices](https://code.claude.com/docs/en/best-practices)

| Situation | Recommendation |
|-----------|---------------|
| Prior context mostly valid, minor updates | Resume with `--resume` and inform about changes |
| Significant code changes since last session | Start fresh with a structured summary injected |
| Tool results are stale (API data, search results) | Start fresh — stale tool results can mislead |
| Need to explore divergent approaches | Use `fork_session` from a shared baseline |

Starting a new session with a structured summary of prior findings is **more reliable** than resuming with stale tool results. The summary captures important conclusions while avoiding stale data.
