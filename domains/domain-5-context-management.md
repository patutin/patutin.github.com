# Domain 5: Context Management & Reliability

## progressive-summarization-risks
**Knowledge:** Progressive summarization risks: condensing numerical values, percentages, dates, and customer-stated expectations into vague summaries
**Source:** [Context Windows](https://platform.claude.com/docs/en/build-with-claude/context-windows)

When conversations grow long, compaction (server-side summarization) condenses earlier turns. Combined with "context rot"—the phenomenon where accuracy and recall degrade as token count grows—this creates a dangerous failure mode: numerical values, percentages, dates, and customer-stated expectations get condensed into vague summaries. Example: "customer was charged $147.32 on 2024-03-15 for order #8829" becomes "customer had a billing issue." The specific facts needed for resolution are lost. As the effective context engineering guide notes, "overly aggressive compaction can result in the loss of subtle but critical context whose importance only becomes apparent later."

**Mitigation:** Extract transactional facts into a persistent "case facts" block that lives outside summarized history and is included verbatim in each prompt.

---

## lost-in-the-middle
**Knowledge:** The "lost in the middle" effect: models reliably process information at the beginning and end of long inputs but may omit findings from middle sections
**Source:** [Prompting Long Context](https://www.anthropic.com/news/prompting-long-context)

Research on long-context recall found that performance degrades with distance from the end of the prompt. For some models, there is also a dip in the middle (the "lost in the middle" effect). Current documentation frames this more broadly as **"context rot"**: as the number of tokens in context increases, the model's ability to accurately recall information decreases. The prompting best practices guide recommends putting longform data at the top and queries at the end, which can improve response quality by up to 30%.

**Mitigation:** Place key findings summaries at the beginning of aggregated inputs. Use explicit section headers to organize detailed results so the model navigates structurally rather than relying on positional attention.

---

## tool-result-accumulation
**Knowledge:** How tool results accumulate in context and consume tokens disproportionately to their relevance
**Source:** [Effective Context Engineering for AI Agents](https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents)

A single order lookup might return 40+ fields when only 5 are relevant. Over a multi-turn conversation, these verbose results accumulate and crowd out actual conversation context.

**Mitigation:** Trim verbose tool outputs to only relevant fields *before* they enter the conversation history.

---

## complete-conversation-history
**Knowledge:** The importance of passing complete conversation history in subsequent API requests to maintain conversational coherence
**Source:** [Messages API Reference](https://platform.claude.com/docs/en/api/messages/create)

The model has no memory between API calls — if you drop earlier turns, the model loses awareness of what was discussed. Complete conversation history must be passed in subsequent requests. This creates tension with context limits that trimming, case facts extraction, and summarization address.

---

## case-facts-extraction
**Knowledge:** Extracting transactional facts (amounts, dates, order numbers, statuses) into a persistent "case facts" block included in each prompt, outside summarized history
**Source:** [Effective Context Engineering for AI Agents](https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents)

Pull transactional facts (amounts, dates, order numbers, statuses) into a persistent "case facts" block that is included verbatim in each prompt, separate from summarized history. This ensures critical data survives progressive summarization.

---

## trimming-verbose-outputs
**Knowledge:** Trimming verbose tool outputs to only relevant fields before they accumulate in context
**Source:** [Effective Context Engineering for AI Agents](https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents)

Remove irrelevant fields from tool results before they accumulate in context. Design upstream agents/tools to return structured data (key facts, citations, relevance scores) instead of verbose raw output when downstream consumers have limited context budgets.

---

## position-aware-organization
**Knowledge:** Placing key findings summaries at the beginning of aggregated inputs and organizing detailed results with explicit section headers to mitigate position effects
**Source:** [Prompting Long Context](https://www.anthropic.com/news/prompting-long-context)

Place key findings summaries at the beginning of aggregated inputs. Use explicit section headers to organize detailed results. This mitigates the "lost in the middle" effect by ensuring critical information is in positions where the model attends most reliably.

---

## subagent-metadata-requirements
**Knowledge:** Requiring subagents to include metadata (dates, source locations, methodological context) in structured outputs to support accurate downstream synthesis
**Source:** [How We Built Our Multi-Agent Research System](https://www.anthropic.com/engineering/multi-agent-research-system)

Require subagents to include metadata (dates, source locations, methodological context) in structured outputs. Without this metadata, the synthesis agent cannot attribute sources, verify claims, or distinguish temporal differences from contradictions.

---

## upstream-agent-structured-data
**Knowledge:** Modifying upstream agents to return structured data (key facts, citations, relevance scores) instead of verbose content and reasoning chains when downstream agents have limited context budgets
**Source:** [Effective Context Engineering for AI Agents](https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents)

When downstream agents have limited context budgets, modify upstream agents to return structured data (key facts, citations, relevance scores) instead of verbose content and reasoning chains. This prevents context budget overflow while preserving the essential information.

---

## escalation-triggers
**Knowledge:** Appropriate escalation triggers: customer requests for a human, policy exceptions/gaps (not just complex cases), and inability to make meaningful progress
**Source:** Applied best practice (not explicitly documented in current Anthropic documentation; the cited prompting best practices page does not contain escalation-specific guidance)

Three categories that should trigger escalation:

1. **Customer requests for a human** — must be honored immediately
2. **Policy exceptions or gaps** — when the request falls outside documented policy
3. **Inability to make meaningful progress** — exhausted available tools and approaches

**Important:** Complex cases alone are NOT an escalation trigger. A case can be complex but still within the agent's capability. The trigger is policy gaps, not difficulty.

---

## immediate-vs-deferred-escalation
**Knowledge:** The distinction between escalating immediately when a customer explicitly demands it versus offering to resolve when the issue is straightforward
**Source:** Applied best practice (not explicitly documented in current Anthropic documentation)

- **Customer explicitly demands a human** → Escalate immediately. Do not attempt investigation first.
- **Customer is frustrated but issue is straightforward** → Acknowledge frustration, offer to resolve. Escalate only if they reiterate preference for a human.

Attempting to resolve when explicitly asked for a human *decreases* satisfaction. But reflexively escalating every frustrated customer wastes human agent capacity.

---

## unreliable-escalation-proxies
**Knowledge:** Why sentiment-based escalation and self-reported confidence scores are unreliable proxies for actual case complexity
**Source:** Applied best practice (not explicitly documented in current Anthropic documentation)

Two unreliable signals:

1. **Sentiment-based escalation** — Customer sentiment doesn't correlate with case complexity. A furious customer may have a simple issue; a calm customer may have a complex policy edge case.
2. **Self-reported confidence scores** — Models report high confidence even when wrong. Confidence doesn't reliably predict whether the case needs human intervention.

---

## multiple-customer-matches
**Knowledge:** How multiple customer matches require clarification (requesting additional identifiers) rather than heuristic selection
**Source:** Applied best practice (not explicitly documented in current Anthropic documentation)

When a lookup returns multiple matching customers (e.g., two accounts with the same name), **ask for additional identifiers** (email, phone, order number) rather than selecting based on heuristics (most recent order, highest value). Heuristic selection risks acting on the wrong customer's account.

---

## explicit-escalation-criteria
**Knowledge:** Adding explicit escalation criteria with few-shot examples to the system prompt demonstrating when to escalate versus resolve autonomously
**Source:** Applied best practice; few-shot example technique from [Prompting Best Practices](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/claude-prompting-best-practices), escalation-specific application not in source

Add clear escalation rules with few-shot examples:
- "Customer sends photo of damaged item, requests replacement → Resolve: process standard replacement"
- "Customer requests competitor price match, policy only covers own-site → Escalate: policy gap"

This is the highest-impact intervention for agents that escalate too much or too little.

---

## structured-error-context
**Knowledge:** Structured error context (failure type, attempted query, partial results, alternative approaches) as enabling intelligent coordinator recovery decisions
**Source:** Applied best practice for multi-agent systems; the `is_error` field is documented in the [Messages API](https://platform.claude.com/docs/en/api/messages/create) ToolResultBlockParam, but structured error context patterns are not explicitly in current Anthropic documentation

When a subagent fails, provide the coordinator with:
- **Failure type**: What category of error occurred
- **Attempted query**: What the subagent was trying to do
- **Partial results**: Any data successfully retrieved before failure
- **Alternative approaches**: Suggestions (e.g., "Try a different search engine", "Use cached results")

This enables intelligent recovery decisions rather than forcing the coordinator to guess.

---

## access-failures-vs-empty-results-propagation
**Knowledge:** The distinction between access failures (timeouts needing retry decisions) and valid empty results (successful queries with no matches)
**Source:** Applied best practice; `is_error` field documented in [Messages API ToolResultBlockParam](https://platform.claude.com/docs/en/api/messages/create)

Access failures (timeouts, auth errors) need `isError: true` with error details — the coordinator decides whether to retry. Valid empty results (query succeeded, no matches) get `isError: false` with empty results — this is a correct answer.

Never conflate these: "Database was down" and "no matching records" require fundamentally different responses.

---

## generic-error-statuses-harmful
**Knowledge:** Why generic error statuses hide valuable context from the coordinator
**Source:** Applied best practice for multi-agent error handling (not explicitly in current Anthropic documentation)

A generic "search unavailable" hides whether it was a timeout, auth failure, or rate limit — each needs different recovery. Structured error context enables intelligent coordinator decisions; generic statuses force guessing.

---

## error-suppression-anti-patterns
**Knowledge:** Why silently suppressing errors (returning empty results as success) or terminating entire workflows on single failures are both anti-patterns
**Source:** [How We Built Our Multi-Agent Research System](https://www.anthropic.com/engineering/multi-agent-research-system)

Two anti-patterns:
- **Silent suppression**: Returning empty results as success hides failures, producing silently incomplete answers
- **Full termination**: One subagent failing should not crash the whole pipeline — other subagents' results are still valuable

---

## local-recovery-propagation
**Knowledge:** Local recovery for transient failures within subagents, propagating only unresolvable errors with what was attempted and partial results
**Source:** [How We Built Our Multi-Agent Research System](https://www.anthropic.com/engineering/multi-agent-research-system)

Subagents retry transient failures locally (exponential backoff). If recovery succeeds, return results normally. If it fails, propagate structured error to coordinator with full context. Only propagate errors the subagent cannot resolve.

---

## coverage-annotations
**Knowledge:** Structuring synthesis output with coverage annotations indicating which findings are well-supported versus which topic areas have gaps due to unavailable sources
**Source:** [How We Built Our Multi-Agent Research System](https://www.anthropic.com/engineering/multi-agent-research-system)

Annotate synthesis output with coverage status per data source:

```json
{
  "coverage": {
    "web_search": {"status": "complete", "confidence": "high"},
    "database_query": {"status": "partial", "note": "Timeout after 3 of 5 queries"},
    "document_analysis": {"status": "failed", "note": "Server unreachable"}
  }
}
```

This lets users understand the reliability of the output.

---

## context-degradation
**Knowledge:** Context degradation in extended sessions: models start giving inconsistent answers and referencing "typical patterns" rather than specific classes discovered earlier
**Source:** [Context Windows](https://platform.claude.com/docs/en/build-with-claude/context-windows)

In long exploration sessions, models start giving inconsistent answers and referencing "typical patterns" rather than specific classes found earlier. Earlier discoveries get summarized away or pushed out of context. Key indicator: model says "this likely follows the repository pattern" instead of naming the specific class it found 20 messages ago.

---

## scratchpad-files
**Knowledge:** The role of scratchpad files for persisting key findings across context boundaries
**Source:** [Effective Context Engineering for AI Agents](https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents)

Scratchpad files externalize agent state to disk, surviving context compaction, session restarts, and `/clear` commands. The filesystem is the only reliable memory that survives every form of context loss.

The source article calls this technique **"structured note-taking"** or **"agentic memory"**: "the agent regularly writes notes persisted to memory outside of the context window." Canonical structure (from practical usage, e.g., Claude Code): Current Objective, Plan (with status markers), Current Status, Key Decisions, Discovered Context, Problems Encountered, Next Steps.

---

## subagent-delegation-exploration
**Knowledge:** Subagent delegation for isolating verbose exploration output while the main agent coordinates high-level understanding
**Source:** [Claude Code Subagents](https://code.claude.com/docs/en/sub-agents)

Spawning subagents isolates verbose exploration output from the main agent's context. The main agent coordinates high-level understanding while subagents investigate specific questions and return concise, structured findings. This prevents the main agent's context from filling with raw exploration data.

---

## structured-state-persistence
**Knowledge:** Structured state persistence for crash recovery: each agent exports state to a known location, and the coordinator loads a manifest on resume
**Source:** [Effective Context Engineering for AI Agents](https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents)

Each agent exports its state to a known location (a manifest file). On crash or session restart, the coordinator loads the manifest to resume from the last known state. Critical for long-running multi-agent workflows.

The manifest includes: agent identity, task status, progress (completed/pending steps), findings, files examined/modified, and checkpoint metadata.

### Full Crash-Recovery-Resume Cycle Example

**Scenario:** Agent migrates 10 files from v1 API to v2 API.

**Phase 1 — Normal operation (files 1–3 complete).** Agent writes checkpoint after each file:
```json
{
  "task": { "task_id": "migrate-to-v2-api", "status": "in_progress" },
  "progress": {
    "completion_percentage": 30,
    "completed": [
      {"file": "src/auth.ts", "result": "jwt.verify → authClient.verify"},
      {"file": "src/users.ts", "result": "userApi.fetch → usersClient.list"},
      {"file": "src/api/routes.ts", "result": "12 handlers updated, legacy wrapper kept"}
    ],
    "pending": ["src/billing.ts", "src/notifications.ts", "src/dashboard.ts",
                "src/settings.ts", "src/reports.ts", "src/admin.ts", "src/webhooks.ts"]
  },
  "decisions_made": [
    {"file": "src/auth.ts", "decision": "use authClient.verify", "reason": "v2 removed jwt.verify"},
    {"file": "src/users.ts", "decision": "batch fetching", "reason": "60% fewer API calls"},
    {"file": "src/api/routes.ts", "decision": "keep /legacy wrapper", "reason": "partner dependency until Q3"}
  ],
  "checkpoint": { "checkpoint_id": "ckpt-003", "created_at": "2024-03-15T14:30:00Z" }
}
```

**Phase 2 — Crash.** Context fills mid-way through file 4. Manifest on disk reflects checkpoint 3 (last successful). Partial work on `billing.ts` is NOT persisted — by design (write-ahead pattern commits only completed steps).

**Phase 3 — Recovery.** New session loads the manifest and injects a resume prompt:
```
You are resuming from a crash. Last checkpoint: 3/10 files complete.
Completed: auth.ts, users.ts, routes.ts
Key decisions: authClient.verify for auth, batch fetching for users, /legacy wrapper preserved
Next: src/billing.ts — do NOT redo completed work.
```
The agent spot-checks completed work, then resumes from file 4 with full decision context.

### What Must Be Persisted vs. Re-derived

| Must Persist (irreplaceable) | Can Re-derive (cheap) |
|---|---|
| Decisions + rationale | File listings (re-glob) |
| Completed steps + results | Linter output, git diffs |
| In-flight operation state | Test suite results |
| Checkpoint metadata | Environment info |

**Rule of thumb:** Persist anything that required *judgment*. Skip anything a single tool call can reproduce.

---

## phase-summarization
**Knowledge:** Summarizing key findings from one exploration phase before spawning sub-agents for the next phase, injecting summaries into initial context
**Source:** [Effective Context Engineering for AI Agents](https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents)

Summarize key findings from one phase before spawning sub-agents for the next. Inject summaries into the sub-agents' initial context. This ensures knowledge transfers between phases without carrying over verbose raw data.

### Good vs Bad Phase Summary — Worked Comparison

**Scenario:** Agent completed Phase 1 (auth module analysis). Must hand off to Phase 2 sub-agents.

**❌ BAD summary:**
> "Analyzed the codebase and found several issues with the authentication module. The API needs refactoring and there are some dependency problems."

**Why this fails:** No file paths, no specifics, no decisions, no versions, no scope boundaries.

**✅ GOOD summary:**
> **Phase 1 Complete — Auth Module Migration:**
> - `auth.ts:45-67`: `jwt.verify()` uses deprecated RS256, must migrate to ES256
> - 3 endpoints affected: `/login` (auth.ts:23), `/refresh` (auth.ts:89), `/verify` (middleware.ts:12)
> - Breaking change: `UserSession` type needs new `algorithm` field (types/auth.ts:8)
> - Dependency: `jsonwebtoken@8.5.1` → `@9.0.0` (ES256 added in v9)
> - `bcrypt` and `express-session` unaffected — no cascading changes
> - **Decision:** Single PR to avoid mixed-algorithm state
> - **Decision:** `algorithm` field required (not optional) to force compile-time errors
> - **Next:** Start `auth.ts` → `middleware.ts` → update 47 tests in `__tests__/auth.test.ts`

### 7 Properties of Effective Phase Summaries

| Property | Example |
|----------|---------|
| **Locationality** | `auth.ts:45-67`, `middleware.ts:12` |
| **Decisions preserved** | "Single PR to avoid mixed-algorithm state" |
| **Scope boundaries** | "bcrypt and express-session unaffected" |
| **Dependency specificity** | `jsonwebtoken@8.5.1 → @9.0.0` |
| **Actionable next steps** | "Start auth.ts, then middleware.ts, then tests" |
| **Quantified scope** | "3 endpoints", "47 existing test cases" |
| **Breaking change flags** | "UserSession type needs new field" |

### Guidelines
1. Structure over prose — use sections, not paragraphs
2. Include negative findings — "X is NOT affected" prevents re-investigation
3. Anchor decisions to rationale — prevents re-litigation
4. Preserve exact values — never paraphrase numbers
5. Bound the scope — define what next phase should and should NOT touch

---

## compact-command
**Knowledge:** Using `/compact` to reduce context usage during extended exploration sessions when context fills with verbose discovery output
**Source:** [Claude Code Best Practices](https://code.claude.com/docs/en/best-practices)

`/compact` frees context by summarizing conversation history, preserving code patterns, file states, and key decisions. CLAUDE.md files survive (re-loaded from disk). You can provide custom focus: `/compact Focus on the API changes`. For partial compaction, use `/rewind` and choose "Summarize from here."

Best practice: Use `/clear` frequently between unrelated tasks. Compact at logical task breakpoints. Use the Explore–Compact–Execute pattern: explore broadly → `/compact preserve findings` → execute with clean context.

Auto-compact triggers automatically when approaching context limits. For quick questions that don't need to stay in context, use `/btw` — the answer appears in a dismissible overlay and never enters conversation history.

---

## aggregate-accuracy-masking
**Knowledge:** The risk that aggregate accuracy metrics (e.g., 97% overall) may mask poor performance on specific document types or fields
**Source:** Applied best practice for AI data extraction systems (not explicitly documented in current Anthropic documentation; the cited page is a brief redirect with no relevant content)

A system reporting 97% overall accuracy may be 99% on invoices but only 82% on handwritten receipts. **Aggregate metrics hide disparities.** Before automating, validate accuracy broken down by document type, field, and combinations.

---

## stratified-sampling
**Knowledge:** Stratified random sampling for measuring error rates in high-confidence extractions and detecting novel error patterns
**Source:** Applied best practice for AI evaluation systems (not explicitly documented in current Anthropic documentation)

Stratify by document type, field, and confidence level — don't just randomly sample uniformly. Sample from high-confidence extractions specifically — these are where undetected errors hide. Measure error rates per stratum. Use statistical process control (CUSUM, EWMA) to detect shifts.

---

## field-level-confidence
**Knowledge:** Field-level confidence scores calibrated using labeled validation sets for routing review attention
**Source:** Applied best practice for AI data extraction systems (not explicitly documented in current Anthropic documentation; the cited page covers JSON schema constraints, not confidence scoring)

Output confidence scores per field, not just per document. Calibrate using a labeled validation set — raw model confidence is often overconfident.

Calibration process:
1. Run model on labeled validation set
2. For each threshold, measure actual accuracy
3. Find threshold where accuracy meets requirements
4. Set auto-accept threshold accordingly

Three-tier routing: confidence ≥ T_high → auto-approve, T_low ≤ conf < T_high → human review, < T_low → reject/re-extract.

---

## accuracy-validation-before-automation
**Knowledge:** The importance of validating accuracy by document type and field segment before automating high-confidence extractions
**Source:** Applied best practice for AI data extraction systems (not explicitly documented in current Anthropic documentation)

Before automating, confirm consistent performance across all segments (document type × field). A field that's 99% accurate on invoices may be 85% on handwritten receipts. Automating based on aggregate accuracy produces systematic errors on weak segments.

---

## routing-to-human-review
**Knowledge:** Routing extractions with low model confidence or ambiguous/contradictory source documents to human review, prioritizing limited reviewer capacity
**Source:** Applied best practice for AI data extraction systems (not explicitly documented in current Anthropic documentation)

Route to human review: low model confidence, ambiguous/contradictory sources, novel document types, and segments with historically high error rates. This is a prioritization problem: given limited reviewer time, maximize errors caught.

---

## source-attribution-loss
**Knowledge:** How source attribution is lost during summarization steps when findings are compressed without preserving claim-source mappings
**Source:** [How We Built Our Multi-Agent Research System](https://www.anthropic.com/engineering/multi-agent-research-system)

When subagents summarize findings, source attribution is the first casualty. "Revenue grew 12% (Company 10-K, 2024)" becomes "Revenue grew 12%." The synthesis agent then cannot verify, reconcile, or cite the claim.

Solution: Require subagents to output **structured claim-source mappings** — not prose summaries.

---

## claim-source-mappings
**Knowledge:** The importance of structured claim-source mappings that the synthesis agent must preserve and merge when combining findings
**Source:** [How We Built Our Multi-Agent Research System](https://www.anthropic.com/engineering/multi-agent-research-system)

Each finding should include: claim, source (document name, URL), excerpt, methodological context, and date. The synthesis agent must preserve and merge these mappings when combining findings from multiple subagents — never summarize them away.

---

## conflicting-statistics-handling
**Knowledge:** How to handle conflicting statistics from credible sources: annotating conflicts with source attribution rather than arbitrarily selecting one value
**Source:** [How We Built Our Multi-Agent Research System](https://www.anthropic.com/engineering/multi-agent-research-system)

When credible sources report different values:
- **Wrong:** Silently choosing one value
- **Wrong:** Averaging away the conflict
- **Right:** "Market size estimates vary: $4.2B (Source A, survey methodology) vs. $3.8B (Source B, revenue-based). The difference may reflect differing methodologies."

Complete the analysis with conflicting values included and explicitly annotated.

---

## temporal-data-requirements
**Knowledge:** Temporal data: requiring publication/collection dates in structured outputs to prevent temporal differences from being misinterpreted as contradictions
**Source:** Applied best practice; related concepts in [Effective Context Engineering](https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents) (timestamps as relevance proxy) and [Multi-Agent Research System](https://www.anthropic.com/engineering/multi-agent-research-system) (source quality evaluation)

Without dates, "Company X has 5,000 employees" (2022) and "Company X has 8,000 employees" (2024) look contradictory. With dates, they show growth. Require publication or collection dates in all structured outputs.

---

## established-vs-contested-findings
**Knowledge:** Structuring reports with explicit sections distinguishing well-established findings from contested ones, preserving original source characterizations and methodological context
**Source:** [How We Built Our Multi-Agent Research System](https://www.anthropic.com/engineering/multi-agent-research-system)

Structure reports with explicit sections:
- **Well-established findings** — supported by multiple credible sources with consistent data
- **Contested findings** — sources disagree, with disagreement documented
- **Gaps** — no credible source data found

This preserves original source characterizations and lets readers assess reliability.

---

## content-type-appropriate-rendering
**Knowledge:** Rendering different content types appropriately in synthesis outputs—financial data as tables, news as prose, technical findings as structured lists—rather than converting everything to a uniform format
**Source:** Applied best practice for synthesis output design (the cited multi-agent research article does not explicitly discuss content-type rendering formats)

Match rendering format to content type:
- **Financial data** → Tables (comparing across years, companies, or metrics)
- **News and narrative** → Prose paragraphs with inline citations
- **Technical findings** → Structured lists with specifications and parameters
- **Statistical comparisons** → Formatted tables or charts
- **Action items** → Priority-ordered lists (P1/P2/P3)
- **Metadata / key-value pairs** → Compact definition lists or key-value blocks

Anti-pattern: Converting everything to uniform prose — a table of quarterly revenue is more useful as a table than as a paragraph. Similarly, forcing action items into flowing prose obscures priorities and makes them harder to act on.

### Why Different Content Types Need Different Rendering

Each content type has an **information shape** that a specific format serves best:

| Content Type | Best Format | Why |
|---|---|---|
| Financial data | Tables | Enables row-by-row comparison; aligned columns reveal patterns |
| Narrative context | Prose paragraphs | Captures causality, nuance, and temporal flow |
| Action items | Priority-ordered lists | Scannable; status can be tracked per item |
| Entity metadata | Key-value pairs | Compact; no wasted words on connective tissue |
| Statistical comparisons | Tables or charts | Side-by-side layout makes differences immediately visible |

**Key insight:** The reader's task determines the optimal format. Someone scanning for "what do I do next?" needs a list. Someone understanding "why did this happen?" needs prose. Someone comparing Q1 vs Q2 needs a table. A single synthesis report often serves all three reader-tasks simultaneously.

### Prompt Pattern for Mixed-Format Synthesis Output

To instruct Claude to produce content-type-appropriate rendering within a single report, use **explicit section templates with per-section format directives**:

```
You are a customer account analyst. Given the following account data and interaction
history, produce a Customer Account Review report.

Structure the report EXACTLY as follows:

## Account Metadata
Render as key-value pairs (one per line, "Key: Value" format).
Include: Account ID, Customer Name, Tier, Tenure, Lifetime Value, Risk Score.

## Executive Summary
Write 1-2 paragraphs of prose. Explain the customer's current situation, recent
trends, and overall health of the relationship. Use a narrative tone.

## Transaction History
Render as a markdown table with columns: Date | Description | Amount | Status.
Include the 6 most recent transactions. Right-align the Amount column values.

## Action Items
Render as a priority-ordered list. Format each item as:
- **[P1/P2/P3]** Action description — Owner: [team/person]
Order by priority (P1 first).

IMPORTANT: Use the format specified for EACH section. Do NOT convert tables to
prose or lists to paragraphs. Each content type must keep its native format.
```

### Complete Synthesis Output Example — Customer Account Review

Below is the expected output from the prompt above, demonstrating all four content types rendered appropriately in a single report:

---

**Account Metadata**

```
Account ID:     ACC-2024-78432
Customer Name:  Meridian Healthcare Systems
Tier:           Enterprise Gold
Tenure:         4 years, 7 months (since Jan 2020)
Lifetime Value: $1,247,500
Risk Score:     Medium-High (72/100)
```

**Executive Summary**

Meridian Healthcare Systems has been a consistent Enterprise Gold customer since January 2020, contributing over $1.2M in lifetime value. However, the past quarter reveals concerning signals. Usage of the analytics module dropped 34% between Q3 and Q4 2024, coinciding with the departure of their internal champion (VP of Data, Sarah Chen) in October. Two support escalations in December — both related to API integration failures during their EMR migration — remain unresolved, and the customer's NPS response fell from 8 to 5.

Despite these headwinds, Meridian recently expanded their user license count from 150 to 200 seats, suggesting continued organizational commitment. The upcoming contract renewal in March 2025 is at risk if the open support issues and champion loss are not addressed proactively. The account requires immediate executive engagement and a dedicated technical resource for the EMR migration.

**Transaction History**

```
| Date       | Description                      |   Amount | Status    |
|------------|----------------------------------|----------|-----------|
| 2024-12-15 | API integration support (esc.)   |       $0 | Escalated |
| 2024-12-01 | License expansion (50 seats)     | $125,000 | Completed |
| 2024-11-15 | Analytics module renewal         |  $85,000 | Completed |
| 2024-10-01 | Professional services — EMR      |  $45,000 | In Progress|
| 2024-09-15 | Quarterly platform subscription  |  $62,500 | Completed |
| 2024-08-20 | Training workshop (onsite)       |  $12,000 | Completed |
```

**Action Items**

```
- **[P1]** Resolve open API integration escalations (tickets #4521, #4523)
       — Owner: Engineering Support Lead
- **[P1]** Schedule executive sponsor call before Jan 31
       — Owner: VP Customer Success
- **[P2]** Identify and enable new internal champion post-Chen departure
       — Owner: Account Manager
- **[P2]** Assign dedicated SE for EMR migration through March
       — Owner: Solutions Engineering
- **[P3]** Prepare renewal proposal with loyalty incentive pricing
       — Owner: Account Manager + Finance
```

---

### Anti-Pattern: Uniform Format Rendering

**❌ Everything as prose (destroys scannability):**

> "Account ACC-2024-78432 belongs to Meridian Healthcare Systems, which is an Enterprise Gold customer with 4 years and 7 months of tenure and a lifetime value of $1,247,500. Their risk score is Medium-High at 72 out of 100. On December 15 they had an API integration support escalation costing $0, on December 1 they completed a license expansion of 50 seats for $125,000, on November 15 they renewed their analytics module for $85,000..."

This buries comparisons in sentences, makes metadata hard to extract, and forces the reader to parse narrative to find specific values.

**❌ Everything as tables (destroys narrative flow):**

| Section | Content |
|---|---|
| Situation | Usage dropped 34% between Q3 and Q4... |
| Cause | VP of Data departed in October... |
| Risk | Contract renewal in March 2025 at risk... |

This strips causality and nuance from the executive summary, reducing a coherent narrative to disconnected fragments.

**❌ Everything as bullet lists (destroys both comparison and narrative):**

- Usage dropped 34% Q3→Q4
- VP of Data (Sarah Chen) departed October
- Two unresolved support escalations
- NPS dropped from 8 to 5
- License count expanded 150→200
- Renewal in March 2025

This loses the *connections* between events (the champion departure *caused* the usage drop, which *threatens* the renewal) — the very insight that makes the executive summary valuable.

### Implementation Guidance for Architects

When designing multi-agent synthesis systems:

1. **System prompt directive:** Include a standing instruction that Claude must match format to content type. Without this, models default to uniform prose.
2. **Per-section format tags:** Use XML tags or explicit headings with format instructions (`<financial_table>`, `<narrative>`, `<action_list>`) so each section's format is unambiguous.
3. **Prefilling for format anchoring:** In API calls, prefill the assistant response with the first section header and format to anchor Claude into the expected structure.
4. **Validation in pipelines:** If building agentic pipelines, validate that the synthesis output contains the expected mix of formats (e.g., regex check for markdown table delimiters, list markers, and paragraph-length prose blocks).
