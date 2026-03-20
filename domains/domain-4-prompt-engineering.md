---
layout: default
title: Domain 4: Prompt Engineering & Structured Output
---

# Domain 4: Prompt Engineering & Structured Output

## explicit-criteria-over-vague
**Knowledge:** The importance of explicit criteria over vague instructions (e.g., "flag comments only when claimed behavior contradicts actual code behavior" vs "check that comments are accurate")
**Source:** [Prompting Best Practices](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/claude-prompting-best-practices)

The single most important principle: **replace vague instructions with specific categorical criteria**.

Instructions like "be conservative," "only report high-confidence findings," or "check that comments are accurate" give the model no actionable framework. The model cannot reliably calibrate its own confidence.

What works: Define **which categories** of issues to report and which to skip. Use precise behavioral descriptions: "Flag comments only when the claimed behavior contradicts actual code behavior" is far more effective than "check that comments are accurate."

---

## general-instructions-fail
**Knowledge:** How general instructions like "be conservative" or "only report high-confidence findings" fail to improve precision compared to specific categorical criteria
**Source:** [Prompt Engineering Overview](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/overview)

General instructions produce inconsistent results because the model interprets them differently each time. Telling the model to "only report high-confidence findings" does not meaningfully change what it reports — the model cannot reliably calibrate its own confidence.

The fix is category-based filtering: enumerate specific issue types to look for (bugs, security vulnerabilities, data races) and explicitly exclude categories you don't want (minor style, local naming conventions).

---

## false-positive-trust-erosion
**Knowledge:** The impact of false positive rates on developer trust: high false positive categories undermine confidence in accurate categories
**Source:** [Prompt Engineering Overview](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/overview)

High false positive rates in one category **undermine developer confidence across all categories**, including accurate ones. If your code review tool produces many false positives for "style" issues, developers start ignoring all findings — including legitimate bug reports.

The solution: temporarily disable high false-positive categories entirely while you improve the prompts. Re-enable only once their false positive rate is acceptable.

---

## specific-review-criteria
**Knowledge:** Writing specific review criteria that define which issues to report (bugs, security) versus skip (minor style, local patterns) rather than relying on confidence-based filtering
**Source:** [Prompt Engineering Overview](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/overview)

Define which categories to report vs skip:
- **Report**: Bugs, security vulnerabilities, logic errors, data races
- **Skip**: Minor style issues, local naming conventions, team-specific patterns

Avoid confidence-based filtering entirely — use category-based filtering instead.

---

## disabling-false-positive-categories
**Knowledge:** Temporarily disabling high false-positive categories to restore developer trust while improving prompts for those categories
**Source:** [Prompt Engineering Overview](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/overview)

Monitor false positive rates per category. When a category's false positive rate erodes trust, disable it entirely rather than trying to lower confidence thresholds. Improve the prompt for that category offline, then re-enable once precision is acceptable. This preserves trust in the remaining categories.

---

## severity-criteria-with-examples
**Knowledge:** Defining explicit severity criteria with concrete code examples for each severity level to achieve consistent classification
**Source:** [Prompting Best Practices](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/claude-prompting-best-practices)

Create explicit severity criteria with **concrete code examples** for each level:
- **Critical:** SQL injection, auth bypass — show actual code snippets
- **High:** Race condition, resource leak — show actual code snippets
- **Medium:** N+1 query, swallowed exception — show actual code snippets
- **Low:** Inconsistent naming, missing docstring — show actual code snippets

Boundary rules: Promote Medium → High when code is on a hot path or involves financial logic. Promote Low → Medium when style has security implications (e.g., string concatenation for SQL).

---

## few-shot-examples-primary-tool
**Knowledge:** Few-shot examples as the most effective technique for achieving consistently formatted, actionable output when detailed instructions alone produce inconsistent results
**Source:** [Prompting Best Practices](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/claude-prompting-best-practices)

Few-shot examples are **the most effective technique** for consistent output. They demonstrate the exact output format, show how to handle ambiguous cases, and enable the model to generalize judgment to novel patterns.

Use **3–5 targeted examples** covering distinct ambiguous scenarios. Each should show reasoning for why one action was chosen over alternatives. Include examples of acceptable patterns that should NOT be flagged.

Formatting options:
- XML `<example>` tags in system prompt — best for classification/extraction
- User/assistant turn pairs — best for conversational tasks

Note: Prefilled responses on the last assistant turn are no longer supported starting with Claude 4.6 models. Use explicit instructions or examples to lock output format instead.

---

## few-shot-ambiguous-case-handling
**Knowledge:** The role of few-shot examples in demonstrating ambiguous-case handling (e.g., tool selection for ambiguous requests, branch-level test coverage gaps)
**Source:** [Prompting Best Practices](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/claude-prompting-best-practices)

Few-shot examples show how to decide between plausible alternatives. Example for tool selection:
1. "What's **our** return policy?" → `knowledge_base` (not `web_search`). Signal word "our" indicates internal docs.
2. "Calculate expenses... and show a **breakdown chart**" → `code_executor` (not `calculator`). The chart requirement drives the choice.

Each example explicitly states *why* the chosen action is preferred, not just *what* action to take.

---

## few-shot-generalization
**Knowledge:** How few-shot examples enable the model to generalize judgment to novel patterns rather than matching only pre-specified cases
**Source:** [Prompting Best Practices](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/claude-prompting-best-practices)

Few-shot examples don't just teach the model to handle the exact cases shown. They teach the *decision boundary* — how to reason about novel cases by analogy. The model learns the reasoning pattern, not just the specific examples. This is why 2-3 well-chosen examples are sufficient.

---

## few-shot-hallucination-reduction
**Knowledge:** The effectiveness of few-shot examples for reducing hallucination in extraction tasks (e.g., handling informal measurements, varied document structures)
**Source:** [Prompt Engineering Interactive Tutorial](https://github.com/anthropics/prompt-eng-interactive-tutorial)

Few-shot examples reduce hallucination in extraction tasks by showing what correct extraction looks like from real documents with different formats (tables, prose, mixed). They demonstrate consistent schema adherence across wildly different source formats, currency detection from context, and handling of ambiguous or missing data.

---

## tool-use-structured-output
**Knowledge:** Tool use (`tool_use`) with JSON schemas as the most reliable approach for guaranteed schema-compliant structured output, eliminating JSON syntax errors
**Source:** [Structured Outputs](https://platform.claude.com/docs/en/build-with-claude/structured-outputs)

There are now **two complementary approaches** for guaranteed schema-compliant structured output:

1. **JSON outputs** (`output_config.format` with `type: "json_schema"`): Controls Claude's response format directly, returning valid JSON in `response.content[0].text`.
2. **Strict tool use** (`strict: true` on tool definitions): Guarantees schema validation on tool names and inputs, ensuring `tool_use` blocks always match your `input_schema`.

Both approaches use constrained decoding to eliminate JSON syntax errors (malformed JSON, missing brackets, unquoted strings). They can be used independently or together.

Critical distinction:
- ✅ **Eliminated by structured outputs:** JSON syntax errors, missing required fields, wrong field types, invalid enum values, schema violations
- ❌ **NOT eliminated:** Semantic errors (line items don't sum, wrong field placement, hallucinated values)

---

## tool-choice-auto-vs-any-vs-forced
**Knowledge:** The distinction between `tool_choice: "auto"` (model may return text instead of calling a tool), `"any"` (model must call a tool but can choose which), and forced tool selection (model must call a specific named tool)
**Source:** [Tool Use Overview](https://platform.claude.com/docs/en/agents-and-tools/tool-use/overview)

| Setting | Behavior | Use When |
|---|---|---|
| `"auto"` | May return plain text | You want model judgment about whether structured output is needed |
| `"any"` | Must call a tool, can choose which | Multiple schemas, unknown doc type |
| `{"type": "tool", "name": "..."}` | Must call the specific named tool | Need guaranteed specific extraction |

`"auto"` gives no guarantee of structured output. `"any"` guarantees structured output but allows tool selection. Forced selection guarantees both.

---

## semantic-vs-schema-errors
**Knowledge:** Strict JSON schemas via tool use eliminate syntax errors but do not prevent semantic errors (e.g., line items that don't sum to total, values in wrong fields)
**Source:** [Structured Outputs](https://platform.claude.com/docs/en/build-with-claude/structured-outputs)

Schema compliance (guaranteed by tool_use) is different from semantic correctness (requires validation logic). Tool use ensures valid JSON with correct types but cannot catch:
- Line items that don't sum to the stated total
- A field placed in the wrong category
- Hallucinated values for fields where the source document lacks information

These require programmatic validation and retry-with-error-feedback.

---

## schema-design-patterns
**Knowledge:** Schema design considerations: required vs optional fields, enum fields with "other" + detail string patterns for extensible categories
**Source:** [Structured Outputs](https://platform.claude.com/docs/en/build-with-claude/structured-outputs)

Key patterns:
- **Nullable fields**: Use `"type": ["string", "null"]` with `required` when source may lack info — prevents hallucination
- **Enum with "other"**: `["bug", "security", "performance", "other"]` with a sibling `category_detail` string field
- **"unclear" enum values**: Gives the model an honest escape valve for ambiguous cases
- **Schema complexity awareness**: Structured outputs enforce limits — max 24 optional parameters and max 16 union-type parameters (including nullable fields) across all strict schemas. Each optional parameter roughly doubles grammar state space.
- **Required over optional when possible**: Making parameters required reduces compilation complexity. Use nullable (`"type": ["string", "null"]` + `required`) rather than truly optional fields when you need "absent" semantics.
- **Calculated vs stated totals**: Extract both to flag discrepancies

---

## nullable-fields-prevent-hallucination
**Knowledge:** Designing optional (nullable) schema fields when source documents may not contain the information, preventing the model from fabricating values to satisfy required fields
**Source:** [Structured Outputs](https://platform.claude.com/docs/en/build-with-claude/structured-outputs)

When source documents may not contain certain information, make those fields **nullable**. If a field is required, the model is forced to produce a value — and will **fabricate one** if the information isn't in the source. Rule: any field that might legitimately be absent should be nullable.

Use `"type": ["string", "null"]` + `required` — forces Claude to make an explicit decision. Output: `null` (not found) vs actual value (found).

---

## format-normalization-rules
**Knowledge:** Including format normalization rules in prompts alongside strict output schemas to handle inconsistent source formatting
**Source:** [Prompting Best Practices](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/claude-prompting-best-practices)

Include format normalization rules in the **prompt** (not the schema) to handle inconsistent source formatting. The schema enforces structure; the prompt instructs *how* to transform messy real-world values into that structure.

### Format Normalization — Before/After Examples

**Example 1: Date Normalization**
- Before: `"March 15, 2024"`, `"03/15/24"`, `"15 Mar 2024"`, `"2024-03-15"`
- Prompt rule: *"Normalize ALL dates to ISO 8601 (YYYY-MM-DD). Assume MM/DD/YY for US documents."*
- Schema: `{ "type": ["string", "null"], "description": "ISO 8601 date" }`
- After: All become `"2024-03-15"`

**Example 2: Currency Normalization**
- Before: `"$1,234.56"`, `"1234.56 USD"`, `"1.234,56 €"`
- Prompt rule: *"Separate amount (number) from currency (ISO 4217 code). Strip symbols and thousand separators."*
- Schema: `{ "amount": { "type": "number" }, "currency": { "type": "string" } }`
- After: `{ "amount": 1234.56, "currency": "USD" }` or `{ "amount": 1234.56, "currency": "EUR" }`

**Example 3: Phone Number Normalization**
- Before: `"(415) 555-2671"`, `"415.555.2671"`, `"+1-415-555-2671"`
- Prompt rule: *"Normalize to E.164. Assume US (+1) unless international prefix present."*
- After: All become `"+14155552671"`

### Three-Layer Enforcement Model

| Layer | Responsibility | Mechanism |
|-------|---------------|-----------|
| **Prompt** | Teaches *how* to normalize (transformation rules, examples) | XML-tagged `<normalization_rules>` with few-shot examples |
| **Schema** | Enforces *what* output looks like (types, required fields) | `input_schema` on tool with `strict: true` |
| **Validation** | Catches semantic errors (future dates, invalid codes) | Programmatic check in retry loop |

---

## retry-with-error-feedback
**Knowledge:** Retry-with-error-feedback: appending specific validation errors to the prompt on retry to guide the model toward correction
**Source:** [Prompt Engineering Overview](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/overview) | [Building Effective Agents](https://www.anthropic.com/engineering/building-effective-agents)

Core pattern for semantic errors:
1. Extract structured data using tool_use
2. Validate programmatically (field relationships, totals)
3. If validation fails, send follow-up with: original document + failed extraction + **specific validation error messages**
4. Model uses error feedback to correct output

Use `tool_result` with `is_error: true` to signal Claude to self-correct. Include expected vs actual values in error messages.

---

## retry-limits
**Knowledge:** The limits of retry: retries are ineffective when the required information is simply absent from the source document (vs format or structural errors)
**Source:** [Structured Outputs](https://platform.claude.com/docs/en/build-with-claude/structured-outputs)

Retries work when the information exists but was misformatted. Retries are **ineffective** when the information simply isn't in the source document — no amount of retrying will conjure information that doesn't exist. Detect missing-source failures and handle differently (flag for human review).

| Scenario | Action |
|---|---|
| Arithmetic errors | Retry — almost always self-corrects |
| Date format issues | Retry — simple format fix |
| Empty required fields | Retry once, then flag — source may lack the data |
| Hallucinated data | Flag for review — retrying won't fix |

---

## feedback-loop-detected-pattern
**Knowledge:** Feedback loop design: tracking which code constructs trigger findings (`detected_pattern` field) to enable systematic analysis of dismissal patterns
**Source:** [Prompt Engineering Overview](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/overview)

Add a `detected_pattern` field to structured findings that records which code construct triggered each finding. This enables systematic analysis of dismissal patterns — if developers consistently dismiss findings from a certain pattern, that pattern is a false positive source.

### End-to-End Feedback Loop Example

**Step 1 — Produce findings with `detected_pattern`:**
```json
{
  "id": "f-001", "file": "src/api/users.ts", "line": 42,
  "detected_pattern": "unused-import",
  "severity": "Low", "confidence": 0.92,
  "message": "Import 'lodash' is declared but never used."
}
```
Key: `detected_pattern` is an **enum-like string** (not free-form) enabling exact-match aggregation.

**Step 2 — Collect developer responses** (accepted/dismissed) over one week.

**Step 3 — Analyze dismissal rates by pattern:**
```sql
SELECT detected_pattern, COUNT(*) AS total,
  ROUND(100.0 * SUM(CASE WHEN status = 'dismissed' THEN 1 ELSE 0 END) / COUNT(*), 1) AS dismissal_pct
FROM code_review_findings WHERE created_at >= DATE('now', '-7 days')
GROUP BY detected_pattern ORDER BY dismissal_pct DESC;
```
| Pattern | Total | Dismissed | Rate |
|---|---|---|---|
| style-naming | 50 | 40 | **80%** |
| unused-import | 80 | 12 | 15% |
| missing-null-check | 40 | 2 | **5%** |

**Step 4 — Improve the prompt:**
- Before: `"Flag naming convention violations."`
- After: `"Do NOT flag naming issues unless they violate the project's .eslintrc rules."`

**Step 5 — Re-measure:** `style-naming` dismissal drops from 80% → 20%.

### Connections
- **`false-positive-trust-erosion`**: The data quantifies which categories to fix
- **`disabling-false-positive-categories`**: Temporarily disable `style-naming` while refining
- **`explicit-criteria-over-vague`**: The fix replaces vague with specific criteria

---

## semantic-vs-syntax-validation
**Knowledge:** The difference between semantic validation errors (values don't sum, wrong field placement) and schema syntax errors (eliminated by tool use)
**Source:** [Structured Outputs](https://platform.claude.com/docs/en/build-with-claude/structured-outputs)

Schema syntax errors (malformed JSON, wrong types) are eliminated by tool use. Semantic validation errors require your own validation logic:
- Values that don't sum correctly
- Fields placed in wrong categories
- Cross-field inconsistencies

---

## self-correction-validation
**Knowledge:** Self-correction validation flows: extracting "calculated_total" alongside "stated_total" to flag discrepancies, adding "conflict_detected" booleans for inconsistent source data
**Source:** [Structured Outputs](https://platform.claude.com/docs/en/build-with-claude/structured-outputs)

For numerical data, extract both `calculated_total` (model's sum of line items) and `stated_total` (what the document claims). Flag discrepancies automatically — this catches both document errors and extraction errors. Include `totals_match: boolean` to route discrepancies to human review.

---

## batch-api-characteristics
**Knowledge:** The Message Batches API: 50% cost savings, up to 24-hour processing window, no guaranteed latency SLA
**Source:** [Batch Processing](https://platform.claude.com/docs/en/build-with-claude/batch-processing)

Core characteristics:
- **50% cost savings** compared to synchronous API calls
- **Most batches complete in less than 1 hour**, with a maximum processing window of 24 hours (batches expire after 24 hours if not complete)
- A batch is limited to **100,000 requests or 256 MB**, whichever is reached first
- Batch results are available for **29 days** after creation
- Each request includes a **`custom_id` field** for correlating request/response pairs

---

## batch-appropriate-workloads
**Knowledge:** Batch processing is appropriate for non-blocking, latency-tolerant workloads (overnight reports, weekly audits, nightly test generation) and inappropriate for blocking workflows (pre-merge checks)
**Source:** [Batch Processing](https://platform.claude.com/docs/en/build-with-claude/batch-processing)

**Appropriate:** Overnight technical debt reports, weekly code audits, nightly test generation, bulk document extraction — any analysis where results are consumed hours or days later.

**Inappropriate:** Pre-merge CI checks, real-time code review, interactive workflows — any process where a human is waiting.

The key test: If someone is **waiting** for the result before proceeding, use the synchronous API.

---

## batch-no-multi-turn
**Knowledge:** The batch API does not support multi-turn tool calling within a single request
**Source:** [Batch Processing](https://platform.claude.com/docs/en/build-with-claude/batch-processing)

The batch API supports tool use and multi-turn conversations within individual requests. However, for **client-side tools**, each batch request is processed independently — you cannot do iterative tool-calling loops (send request → receive tool_use → send tool_result → get final response) within a single batch request. Workflows requiring multiple client-side tool round-trips must use the synchronous API.

Note: **Server tools** (like web search) execute on Anthropic's servers and may complete multi-step tool execution within a single batch request via the server-side sampling loop.

---

## batch-custom-id
**Knowledge:** `custom_id` fields for correlating batch request/response pairs
**Source:** [Batch Processing API Reference](https://platform.claude.com/docs/en/api/messages/batches)

`custom_id` (1–64 chars, unique per batch) is the only way to correlate batch responses back to original inputs. Results arrive in **any order**. Essential for failure handling — identifies which documents need reprocessing.

---

## batch-sla-calculation
**Knowledge:** Calculating batch submission frequency based on SLA constraints (e.g., 4-hour windows to guarantee 30-hour SLA with 24-hour batch processing)
**Source:** [Batch Processing](https://platform.claude.com/docs/en/build-with-claude/batch-processing)

Formula: `submission_interval = target_SLA - batch_processing_window`

Example (worst-case planning): 30-hour SLA − 24-hour max processing = 6-hour max interval. Submit every 4–6 hours for headroom. Worst case: event arrives just after submission, waits for next batch, then takes 24 hours.

In practice, most batches complete within 1 hour, so effective SLA is typically much shorter. However, use the 24-hour maximum for planning guarantees since there is no latency SLA.

---

## batch-failure-handling
**Knowledge:** Handling batch failures: resubmitting only failed documents (identified by `custom_id`) with appropriate modifications (e.g., chunking documents that exceeded context limits)
**Source:** [Batch Processing](https://platform.claude.com/docs/en/build-with-claude/batch-processing)

Use `custom_id` to identify failed requests. Analyze whether failures are systematic (prompt issue) or isolated (document issues). Resubmit **only failed documents** — never the entire batch.

Result types: `succeeded` (billed), `errored` (not billed), `canceled` (not billed), `expired` (not billed).

---

## prompt-refinement-before-batch
**Knowledge:** Using prompt refinement on a sample set before batch-processing large volumes to maximize first-pass success rates
**Source:** [Batch Processing](https://platform.claude.com/docs/en/build-with-claude/batch-processing)

Before submitting large volumes, refine on a small sample (10–20 documents covering edge cases):
1. Run synchronously with the planned prompt
2. Evaluate results, identify failure patterns
3. Refine the prompt
4. Repeat until acceptable quality
5. Submit the full batch

This maximizes first-pass success rate and avoids wasting batch API credits.

---

## self-review-limitations
**Knowledge:** Self-review limitations: a model retains reasoning context from generation, making it less likely to question its own decisions in the same session
**Source:** [Prompt Engineering Overview](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/overview)

When a model reviews its own output, it retains reasoning context from generation, making it biased toward confirming its prior decisions. The same blind spots that caused an error persist during review. Self-review is fundamentally limited.

---

## independent-review-instances
**Knowledge:** Independent review instances (without prior reasoning context) are more effective at catching subtle issues than self-review instructions or extended thinking
**Source:** [Prompt Engineering Overview](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/overview)

A second, independent Claude instance (without the generator's reasoning context) is significantly more effective at catching subtle issues. The reviewer sees only the code/output, not the rationale — evaluating the artifact on its own merits.

---

## multi-pass-review
**Knowledge:** Multi-pass review: splitting large reviews into per-file local analysis passes plus cross-file integration passes to avoid attention dilution and contradictory findings
**Source:** [Cookbook: Agentic Patterns](https://github.com/anthropics/claude-cookbooks/tree/main/patterns/agents)

For large codebases:
- **Pass 1 — Per-file local analysis:** Review each file independently for local issues
- **Pass 2 — Cross-file integration analysis:** Review relationships between files (data flow, API contracts, shared state)

This is necessary because a single pass on a large codebase produces shallow or inconsistent analysis.

---

## confidence-self-reporting
**Knowledge:** Running verification passes where the model self-reports confidence alongside each finding to enable calibrated review routing
**Source:** [Prompt Engineering Overview](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/overview)

Run verification passes where the model reports confidence alongside each finding. Useful for **triaging review output** — not for filtering (confidence filtering is unreliable for precision), but for prioritizing human review effort. Note: confidence scores are heuristic, not calibrated probabilities.

### Worked Example: Confidence Calibration and Routing

**Scenario:** Agent processes 100 document extractions with self-reported confidence (0.0–1.0).

#### Bucket Analysis

| Confidence Bucket | Items | Correct | Actual Accuracy |
|---|---|---|---|
| 0.9–1.0 | 40 | 38 | **95%** |
| 0.7–0.9 | 35 | 28 | **80%** |
| 0.5–0.7 | 15 | 8 | **53%** |
| < 0.5 | 10 | 3 | **30%** |

#### Expected Calibration Error (ECE)
ECE = Σ (n/N) × |actual_accuracy − avg_confidence| = **0.024 (2.4%)** — well-calibrated (< 5% threshold).

#### Routing Rules Derived

| Confidence | Action | Rationale |
|---|---|---|
| ≥ 0.9 | Auto-approve | 95% accuracy; review cost > residual error |
| 0.7–0.9 | Spot-check (20% sample) | 80% accuracy; sampling catches drift |
| < 0.7 | Mandatory human review | ≤ 53% accuracy |

#### Prompt for Confidence Scores
```xml
For each extracted field, before assigning confidence:
1. State evidence from source text
2. Note ambiguity or competing interpretations
3. Assign 0.0–1.0: 0.95+ = verbatim, 0.80–0.94 = clearly implied,
   0.60–0.79 = moderate inference, 0.30–0.59 = significant uncertainty
```

#### Calibration Drift Monitoring
- **Weekly:** Compute ECE on trailing 7 days; alert if > 5%
- **Monthly:** Full re-calibration with ≥ 200 labelled items
- **On model upgrade:** Mandatory re-calibration
- **Method:** Platt scaling if ECE exceeds target
