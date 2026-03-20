# Domain 2: Tool Design & MCP Integration

## tool-descriptions-as-selection-mechanism
**Knowledge:** Tool descriptions as the primary mechanism LLMs use for tool selection; minimal descriptions lead to unreliable selection among similar tools
**Source:** [Tool Use Overview](https://platform.claude.com/docs/en/agents-and-tools/tool-use/overview) | [Writing Tools for Agents](https://www.anthropic.com/engineering/writing-tools-for-agents)

LLMs choose which tool to call based almost entirely on the tool's description. When descriptions are minimal (e.g., just a name and one-line summary), the model cannot reliably distinguish between similar tools. This is the **#1 root cause** of tool misrouting in production.

A good tool description must include:
- **Purpose**: What the tool does and when to use it
- **Expected inputs**: Format, types, constraints, and examples
- **Expected outputs**: What the response looks like
- **Edge cases and boundaries**: What the tool does NOT do and when to use a different tool instead
- **Example queries**: Concrete usage examples that disambiguate from similar tools

---

## tool-description-detail-requirements
**Knowledge:** The importance of including input formats, example queries, edge cases, and boundary explanations in tool descriptions
**Source:** [Writing Tools for Agents](https://www.anthropic.com/engineering/writing-tools-for-agents) | [How to Implement Tool Use](https://platform.claude.com/docs/en/agents-and-tools/tool-use/implement-tool-use)

Descriptions must include input formats, example queries, edge cases, and boundary explanations. Without these, the model has no basis for choosing correctly between similar tools. Each tool description should make clear what makes it different from every other tool.

Best practices:
- Be specific: "Get current weather including temperature, humidity, and conditions" not "Get weather"
- Explain when to use: "Use when the user asks about weather forecasts or current conditions"
- Describe inputs in context: "The location can be a city name, zip code, or coordinates"
- Note limitations: "Makes an external API call and may be rate-limited"

---

## ambiguous-tool-descriptions-misrouting
**Knowledge:** How ambiguous or overlapping tool descriptions cause misrouting (e.g., `analyze_content` vs `analyze_document` with near-identical descriptions)
**Source:** [Writing Tools for Agents](https://www.anthropic.com/engineering/writing-tools-for-agents)

When two tools have near-identical descriptions, the LLM essentially guesses between them. Classic example: `analyze_content` vs `analyze_document` — if both say "analyzes content and returns results," the model has no basis for choosing correctly.

**Fix pattern**: Make descriptions mutually exclusive. Each tool description should make clear what makes it different from every other tool.

---

## system-prompt-tool-selection-impact
**Knowledge:** The impact of system prompt wording on tool selection: keyword-sensitive instructions can create unintended tool associations
**Source:** [Writing Tools for Agents](https://www.anthropic.com/engineering/writing-tools-for-agents) | [Prompting Best Practices](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/claude-prompting-best-practices) | [Effective Context Engineering](https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents) | [Advanced Tool Use](https://www.anthropic.com/engineering/advanced-tool-use)

Keywords in system prompts can create unintended tool associations that **override** well-written tool descriptions. The model treats the system prompt as high-authority instructions, so directive language containing words that overlap with tool names or descriptions creates implicit bias toward those tools — even when the user's query would be better served by a different tool.

### Concrete Misrouting Examples

**Example 1 — "Always search" triggers web search over local database**

Available tools: `web_search`, `query_customer_db`. System prompt says: *"Always search for the latest data before answering."*

- **What goes wrong:** User asks "What is customer #4521's subscription tier?" The word "search" plus the directive "always" causes the model to call `web_search` instead of `query_customer_db`, because the system prompt's keyword "search" creates a strong association with the identically-named tool.
- **Fixed wording:** *"Use the most appropriate data source for each query. Prefer internal database tools for customer-specific lookups; use web search only for publicly available or real-time external information."*

**Example 2 — "Verify all claims" triggers fact-checking for simple lookups**

Available tools: `verify_claim`, `get_document`, `summarize_text`. System prompt says: *"Verify all claims and statements before responding to the user."*

- **What goes wrong:** User asks "Summarize the Q3 report." The model calls `verify_claim` on each paragraph before summarizing, because "verify all claims" creates a blanket association with the `verify_claim` tool. This wastes tokens, adds latency, and may produce confusing intermediate outputs.
- **Fixed wording:** *"When the user makes a factual assertion that contradicts your information, use `verify_claim` to check it. For retrieval and summarization requests, proceed directly with the appropriate tool."*

**Example 3 — Keyword collision between system prompt language and tool names**

Available tools: `book_meeting`, `search_library`. System prompt says: *"You are a helpful assistant. When users want to book something or look up a book, help them."*

- **What goes wrong:** User asks "Can you find me a book on Python?" The word "book" in the prompt context collides with `book_meeting`. The model may call `book_meeting` instead of `search_library`, because the system prompt reinforced "book" as a key action verb associated with the `book_` prefixed tool.
- **Fixed wording:** *"You are a helpful assistant. Use `book_meeting` only for scheduling calendar events. Use `search_library` for finding publications, papers, or reading material."*

### Guidelines for Avoiding Keyword-Sensitive Instructions

1. **Audit system prompts for tool-name echoes.** Search your system prompt for words that appear in any tool name or description. Each match is a potential misrouting trigger.
2. **Replace directive verbs with intent-based language.** Instead of "always search," write "use the most specific data source." Instead of "verify all," write "check disputed claims."
3. **Use explicit tool routing in the system prompt when needed.** State *which* tool to use *when*, rather than using generic verbs: "Use `query_customer_db` for account-level questions; use `web_search` for public information."
4. **Add negative guidance.** Tell the model what each tool is NOT for: "Do NOT use `web_search` for internal customer data."
5. **Test with ambiguous queries.** After writing your system prompt, test edge-case queries where keywords overlap (e.g., "search the database," "book a book") and observe which tool the model selects.
6. **Prefer tool descriptions over system prompt directives for routing.** Tool descriptions are the primary selection mechanism. System prompt directives should set policy, not duplicate or contradict tool descriptions.

### Real-World Case Study: Anthropic's Web Search Tool

When Anthropic launched Claude's web search tool, evaluation revealed that Claude was appending "2025" to search queries, biasing results. The fix was not a system prompt change but a refinement to the **tool description** itself — demonstrating that small wording changes in tool-facing text can dramatically affect behavior (source: [Writing Tools for Agents](https://www.anthropic.com/engineering/writing-tools-for-agents)).

---

## tool-renaming-overlap-elimination
**Knowledge:** Renaming tools and updating descriptions to eliminate functional overlap
**Source:** [Writing Tools for Agents](https://www.anthropic.com/engineering/writing-tools-for-agents)

When two tools overlap, rename and rewrite descriptions to eliminate ambiguity. Namespacing (grouping related tools under common prefixes) can help delineate boundaries; MCP clients sometimes do this by default. For example, namespace tools by service (e.g., `asana_search`, `jira_search`) and by resource (e.g., `asana_projects_search`, `asana_users_search`).

Another approach is renaming for clarity:
- `analyze_content` → `extract_web_results` with a web-specific description
- `analyze_document` → `summarize_uploaded_document` with a file-specific description

After renaming, verify: can you imagine a user query where the model would be confused between these two tools? If yes, refine further. Note that the choice between prefix-based and suffix-based namespacing can have non-trivial effects on evaluation performance and varies by LLM.

---

## splitting-generic-tools
**Knowledge:** Right-sizing tools: splitting ambiguous multi-mode tools into purpose-specific tools, and consolidating multi-step workflows into single tools
**Source:** [Writing Tools for Agents](https://www.anthropic.com/engineering/writing-tools-for-agents)

Make sure each tool has a clear, distinct purpose. This works in **two directions**:

**Splitting**: When a generic tool uses a mode parameter to do unrelated things, split it. Example: splitting `analyze_document(doc, analysis_type)` into:
- `extract_data_points` — extracts structured data
- `summarize_content` — produces summaries
- `verify_claim_against_source` — checks claims against documents

Each tool gets distinct descriptions with clear input/output contracts, eliminating ambiguity about when to use each.

**Consolidating**: When multiple low-level tools force agents through multi-step workflows, consolidate them. Examples from the source:
- Instead of `list_users` + `list_events` + `create_event` → implement `schedule_event` (finds availability and schedules)
- Instead of `read_logs` → implement `search_logs` (returns only relevant lines with context)
- Instead of `get_customer_by_id` + `list_transactions` + `list_notes` → implement `get_customer_context` (compiles all relevant info at once)

Tools can handle multiple discrete operations (or API calls) under the hood, reducing the agent's decision complexity and context consumption from intermediate outputs.

---

## mcp-iserror-flag
**Knowledge:** The MCP `isError` flag pattern for communicating tool failures back to the agent
**Source:** [MCP Specification – Tools](https://modelcontextprotocol.io/specification/2025-06-18/server/tools) | [Writing Tools for Agents](https://www.anthropic.com/engineering/writing-tools-for-agents)

MCP provides `isError` on `CallToolResult` to signal failure. When set to `true`, the agent knows the operation failed. Without `isError`, the agent may interpret error messages as valid data.

Critical distinction: Tool execution errors use `isError: true` inside a *successful* JSON-RPC response (the LLM **sees** the error and can self-correct). Protocol-level errors use the JSON-RPC `error` envelope (the LLM **may not see** details).

Both TypeScript and Python SDKs automatically catch unhandled exceptions and wrap them as `isError: true`.

---

## error-categories
**Knowledge:** The distinction between transient errors (timeouts, service unavailability), validation errors (invalid input), business errors (policy violations), and permission errors
**Source:** [Writing Tools for Agents](https://www.anthropic.com/engineering/writing-tools-for-agents) | [MCP Specification – Tools](https://modelcontextprotocol.io/specification/2025-06-18/server/tools) (synthesized from recommended practices)

| Category | Description | Retryable? | Recovery |
|----------|-------------|-----------|----------|
| **Transient** | Temporary infrastructure failures | Yes | Retry with backoff |
| **Validation** | Invalid input from the caller | No | Fix input and retry |
| **Business** | Policy/rule violations | No | Inform user, suggest alternatives |
| **Permission** | Authorization failures | No | Escalate or request different credentials |

---

## uniform-error-responses-harmful
**Knowledge:** Why uniform error responses (generic "Operation failed") prevent the agent from making appropriate recovery decisions
**Source:** [Writing Tools for Agents](https://www.anthropic.com/engineering/writing-tools-for-agents)

A generic response like `{"error": "Operation failed"}` gives the agent no information to work with — should it retry? Fix the input? Tell the user? **Structured metadata enables intelligent recovery. Generic errors force the agent to guess.**

---

## structured-error-metadata
**Knowledge:** The difference between retryable and non-retryable errors, and how returning structured metadata (including `errorCategory`, `isRetryable`, and human-readable descriptions) prevents wasted retry attempts
**Source:** [Writing Tools for Agents](https://www.anthropic.com/engineering/writing-tools-for-agents)

Return structured error information:
- **`errorCategory`**: `transient` | `validation` | `permission` | `business`
- **`isRetryable`**: `true` | `false` — prevents wasted retry attempts
- **`description`**: Human-readable explanation
- **`suggestedAction`**: Guidance for the LLM on what to do next

---

## access-failures-vs-empty-results
**Knowledge:** The distinction between access failures (needing retry decisions) and valid empty results (representing successful queries with no matches)
**Source:** [Writing Tools for Agents](https://www.anthropic.com/engineering/writing-tools-for-agents)

| Situation | What Happened | Correct Response |
|-----------|---------------|------------------|
| **Access failure** | Could not reach the data source | `isError: true` with error details |
| **Valid empty result** | Successfully queried, no matches | `isError: false` with empty results |

Anti-pattern: Returning empty results `[]` for both cases. The agent cannot distinguish "no matching records exist" from "the database was down."

---

## local-error-recovery
**Knowledge:** Local error recovery within subagents for transient failures, propagating to the coordinator only errors that cannot be resolved locally along with partial results and what was attempted
**Source:** [How We Built Our Multi-Agent Research System](https://www.anthropic.com/engineering/multi-agent-research-system)

Subagents should handle transient failures locally before propagating:

1. Subagent detects transient error (timeout, rate limit)
2. Subagent retries locally (with exponential backoff)
3. If local recovery succeeds: return results normally
4. If local recovery fails: propagate structured error to coordinator with full context (failure type, attempted query, partial results, alternative approaches)

Only propagate errors the subagent cannot resolve.

---

## agent-tool-overload
**Knowledge:** The principle that giving an agent access to too many tools (e.g., 18 instead of 4-5) degrades tool selection reliability by increasing decision complexity
**Source:** [Advanced Tool Use](https://www.anthropic.com/engineering/advanced-tool-use) | [Writing Tools for Agents](https://www.anthropic.com/engineering/writing-tools-for-agents)

Loading too many tool definitions into context degrades tool selection reliability. In Anthropic's testing, a five-server setup with 58 tools consumed ~55K tokens before the conversation started, and the most common failures were wrong tool selection and incorrect parameters. Too many tools or overlapping tools distract agents from efficient strategies.

**Mitigation: Tool Search Tool** — Instead of loading all tools upfront, Claude can discover tools on-demand using the Tool Search Tool. This reduced context consumption by ~85% while improving accuracy (Opus 4: 49% → 74%; Opus 4.5: 79.5% → 88.1%). Each agent should still have access to only the tools relevant to its specific role, with 3–5 most-used tools always loaded and the rest deferred via `defer_loading: true`.

---

## out-of-scope-tool-misuse
**Knowledge:** Why agents with tools outside their specialization tend to misuse them
**Source:** [Advanced Tool Use](https://www.anthropic.com/engineering/advanced-tool-use)

A synthesis agent with access to web search tools will sometimes attempt web searches instead of synthesizing results — it uses what's available, not what's appropriate. Agents tend to misuse out-of-scope tools simply because they can see them.

---

## scoped-tool-access
**Knowledge:** Scoped tool access: giving agents only the tools needed for their role, with limited cross-role tools for specific high-frequency needs
**Source:** [Advanced Tool Use](https://www.anthropic.com/engineering/advanced-tool-use)

Give agents only the tools needed for their role. Keep 3–5 most-used tools always loaded and defer the rest via Tool Search Tool. Example: A synthesis agent primarily needs formatting/compilation tools, but may also benefit from a scoped `verify_fact` tool for quick checks. The Tool Search Tool enables this pattern by marking infrequently-used tools with `defer_loading: true`.

---

## constrained-tool-alternatives
**Knowledge:** Replacing generic tools with constrained alternatives (e.g., replacing `fetch_url` with `load_document` that validates document URLs)
**Source:** [Advanced Tool Use](https://www.anthropic.com/engineering/advanced-tool-use)

Replace generic tools with constrained alternatives to prevent misuse. Example: replacing `fetch_url` (can fetch anything) with `load_document` that validates only document URLs. The constrained tool makes it impossible to misuse for unintended purposes.

---

## tool-choice-configuration
**Knowledge:** `tool_choice` configuration options: `"auto"`, `"any"`, and forced tool selection (`{"type": "tool", "name": "..."}`)
**Source:** [Tool Use Overview](https://platform.claude.com/docs/en/agents-and-tools/tool-use/overview)

| Setting | Behavior | Use When |
|---------|----------|----------|
| `{"type": "auto"}` | Model decides whether to call a tool | Default; model uses judgment |
| `{"type": "any"}` | Must call a tool, can choose which | Multiple schemas, unknown doc type |
| `{"type": "tool", "name": "..."}` | Must call the specific named tool | Need guaranteed specific extraction |
| `{"type": "none"}` | Cannot use any tools | Text-only response needed |

With `any` or `tool`, Claude does NOT emit text before the `tool_use` block. Extended thinking only supports `auto` and `none`.

---

## mcp-server-scoping
**Knowledge:** MCP server scoping: local scope (default, personal per-project), project scope (`.mcp.json` for shared team tooling), and user scope (`~/.claude.json` for cross-project personal servers)
**Source:** [Claude Code MCP Configuration](https://code.claude.com/docs/en/mcp)

| Scope | File | Purpose | Visibility |
|-------|------|---------|------------|
| **Local** (default) | `~/.claude.json` (under project path) | Personal servers, experimental configs, or sensitive credentials specific to one project | Only you, only this project |
| **Project** | `.mcp.json` (project root) | Team-shared servers — committed to version control | Everyone on the team |
| **User** | `~/.claude.json` (home directory) | Personal utilities needed across multiple projects | Only you, all projects |

Scope precedence (highest wins): Local → Project → User. Servers from different scopes are merged; when servers with the same name exist at multiple scopes, the higher-precedence scope wins. Additionally, organizations can deploy a `managed-mcp.json` for exclusive enterprise control that overrides all other scopes.

---

## env-var-expansion-mcp
**Knowledge:** Environment variable expansion in `.mcp.json` (e.g., `${GITHUB_TOKEN}`) for credential management without committing secrets
**Source:** [Claude Code MCP Configuration](https://code.claude.com/docs/en/mcp)

The `${VARIABLE_NAME}` syntax resolves to environment variable values at runtime. Never commit secrets into `.mcp.json` — use `${TOKEN_NAME}` expansion. Supports `${VAR:-default}` fallback syntax. Expansion works in `command`, `args`, `env`, `url`, and `headers` fields.

---

## simultaneous-mcp-server-access
**Knowledge:** Tools from all configured MCP servers are discovered at connection time and available simultaneously to the agent
**Source:** [Claude Code MCP Configuration](https://code.claude.com/docs/en/mcp)

All MCP servers configured across both scopes are discovered at connection time and available simultaneously. Tools from `.mcp.json` and `~/.claude.json` are both available in the same session. No additional configuration is needed to "enable" servers.

---

## mcp-resources-content-catalogs
**Knowledge:** MCP resources as a mechanism for exposing content catalogs (e.g., issue summaries, documentation hierarchies, database schemas) to reduce exploratory tool calls
**Source:** [MCP Resources Specification](https://modelcontextprotocol.io/specification/2025-06-18/server/resources) | [MCP Concepts — Resources](https://modelcontextprotocol.info/docs/concepts/resources/)

MCP resources expose **content catalogs** so the agent knows what data exists before making tool calls:
- **Issue summaries**: Agent sees all open issues upfront
- **Documentation hierarchies**: Agent navigates to the right doc directly
- **Database schemas**: Agent writes correct queries on the first attempt

Without resources, agents make exploratory tool calls to discover what data is available, wasting tokens and adding latency.

Core distinction: Resources are **application-controlled, read-only** data (like GET endpoints). Tools are **model-controlled actions** (like POST endpoints). The host application decides when to surface resources to the model; the model decides when to invoke tools.

### End-to-End Example: Documentation Site MCP Server

Consider an MCP server that exposes an internal documentation site with ~50 articles across 6 categories. The agent's task: answer a user question about "authentication rate limits."

**Step 1 — Agent reads the catalog via `resources/list`:**

```json
// Request
{ "jsonrpc": "2.0", "id": 1, "method": "resources/list" }

// Response — the server returns the full documentation catalog
{
  "jsonrpc": "2.0", "id": 1,
  "result": {
    "resources": [
      { "uri": "docs://auth/overview",       "name": "Authentication Overview",      "description": "OAuth2, API keys, session management" },
      { "uri": "docs://auth/rate-limits",    "name": "Auth Rate Limits",             "description": "Rate limiting policies for login, token refresh, API keys" },
      { "uri": "docs://auth/sso-setup",      "name": "SSO Configuration",            "description": "SAML and OIDC setup guides" },
      { "uri": "docs://api/pagination",      "name": "API Pagination",               "description": "Cursor and offset pagination patterns" },
      { "uri": "docs://api/errors",          "name": "API Error Codes",              "description": "Standard error responses and retry guidance" },
      { "uri": "docs://deploy/scaling",      "name": "Scaling Guide",                "description": "Horizontal scaling, load balancing, caching" }
    ],
    "nextCursor": "page2"
  }
}
```

The agent now sees that `docs://auth/rate-limits` directly matches the user's question. It also identifies `docs://auth/overview` as useful background context.

**Step 2 — Agent reads targeted documents via `resources/read`:**

```json
// Request — fetch the specific rate-limits doc
{ "jsonrpc": "2.0", "id": 2, "method": "resources/read",
  "params": { "uri": "docs://auth/rate-limits" } }

// Response
{
  "jsonrpc": "2.0", "id": 2,
  "result": {
    "contents": [{
      "uri": "docs://auth/rate-limits",
      "mimeType": "text/markdown",
      "text": "# Auth Rate Limits\n\n## Login Endpoint\n- 5 attempts per minute per IP...\n## Token Refresh\n- 30 requests per minute per user..."
    }]
  }
}
```

**Step 3 — Agent answers** using the content from 2 targeted reads.

### Resource Approach vs Tool-Only Approach

| Step | Resource Approach | Tool-Only Approach |
|------|------------------|--------------------|
| 1 | `resources/list` → see 50 docs with names/descriptions | `search_docs("authentication")` → 12 results (too broad) |
| 2 | `resources/read("docs://auth/rate-limits")` — exact match | `search_docs("rate limits")` → 8 results (still broad) |
| 3 | `resources/read("docs://auth/overview")` — supporting context | `get_doc(id=7)` → wrong doc, was about API rate limits |
| 4 | ✅ Answer with 3 total calls | `get_doc(id=3)` → partial match, mentions rate limits |
| 5 | | `search_docs("authentication rate limits policy")` → 4 results |
| 6 | | `get_doc(id=15)` → correct doc found |
| 7 | | `get_doc(id=1)` → fetch overview for context |
| 8 | | ✅ Answer with 8+ total calls |

**Quantified reduction: 3 targeted reads vs 8+ exploratory tool calls** — a 60%+ reduction in calls, with lower token usage and latency, and zero wasted "wrong document" fetches.

### Why This Works

1. **Catalog provides metadata upfront**: Names and descriptions let the agent identify the right resource without guessing
2. **URI-based addressing**: Once the agent knows the URI, it reads exactly what it needs — no search-and-filter cycle
3. **No side effects**: `resources/list` and `resources/read` are safe to call without user confirmation, unlike tools which may require approval
4. **Cacheable**: Clients can cache the resource list and only refresh on `notifications/resources/list_changed`

---

## enhancing-mcp-tool-descriptions
**Knowledge:** Enhancing MCP tool descriptions to explain capabilities and outputs in detail, preventing the agent from preferring built-in tools over more capable MCP tools
**Source:** [Writing Tools for Agents](https://www.anthropic.com/engineering/writing-tools-for-agents)

When MCP tools have vague descriptions, agents prefer familiar built-in tools. Fix by explaining:
- What the tool does in detail
- Capabilities beyond basic fetching (authentication, pagination, filtering)
- Output format
- When to prefer this tool over built-in alternatives

Example: "Queries Jira issues using JQL syntax. Handles authentication automatically. Returns structured JSON. Use this instead of fetch_url for any Jira data."

---

## community-vs-custom-mcp-servers
**Knowledge:** Choosing existing community MCP servers over custom implementations for standard integrations, reserving custom servers for team-specific workflows
**Source:** [MCP Servers Repository](https://github.com/modelcontextprotocol/servers) | [MCP Registry](https://registry.modelcontextprotocol.io/)

**Prefer existing MCP servers** for standard integrations. The primary discovery mechanism is now the **[MCP Registry](https://registry.modelcontextprotocol.io/)**, which lists published servers. The GitHub `modelcontextprotocol/servers` repo is now limited to reference implementations (not production-ready) and many previously-hosted servers (GitHub, Slack, PostgreSQL, Sentry) have been archived or transferred to third-party maintainers.

**Build custom** only for team-specific workflows, proprietary internal systems, or custom business logic. MCP SDKs are available in 10 languages (TypeScript, Python, Go, Java, Kotlin, Rust, C#, PHP, Ruby, Swift).

Decision rule: Search the MCP Registry for an existing server first. Only build custom if nothing exists or existing servers don't meet requirements.

---

## grep-content-search
**Knowledge:** Grep for content search (searching file contents for patterns like function names, error messages, or import statements)
**Source:** [Claude Code Tools Reference](https://code.claude.com/docs/en/tools-reference)

Grep searches file *contents* for patterns. Use when looking for code patterns, function calls, string matches across a codebase. Start with Grep to find entry points (e.g., search for `main(`, `app.listen`, `export default`).

---

## glob-path-matching
**Knowledge:** Glob for file path pattern matching (finding files by name or extension patterns)
**Source:** [Claude Code Tools Reference](https://code.claude.com/docs/en/tools-reference)

Glob matches file *paths* by pattern. Use when finding files by name or extension (e.g., `*.py`, `src/**/*.test.js`).

---

## read-write-edit-tools
**Knowledge:** Read/Write for full file operations; Edit for targeted modifications using unique text matching
**Source:** [Claude Code Tools Reference](https://code.claude.com/docs/en/tools-reference)

| Tool | Purpose | Use When |
|------|---------|----------|
| **Read** | Load full file contents | Need the entire file content |
| **Write** | Write full file contents | Creating new files or fully replacing content |
| **Edit** | Targeted modification using unique text matching | Changing a specific section without rewriting |

---

## edit-fallback-pattern
**Knowledge:** When Edit fails due to non-unique text matches, using Read + Write as a fallback for reliable file modifications
**Source:** Derived from [Claude Code Tools Reference](https://code.claude.com/docs/en/tools-reference) (best practice pattern based on tool capabilities)

Edit requires a unique text anchor. If the text appears multiple times, Edit cannot determine which occurrence to change. **Fallback**: Use Read to load the full file, modify in memory, then Write the complete file back.

---

## incremental-codebase-understanding
**Knowledge:** Building codebase understanding incrementally: starting with Grep to find entry points, then using Read to follow imports and trace flows, rather than reading all files upfront
**Source:** Derived from [Claude Code Tools Reference](https://code.claude.com/docs/en/tools-reference) (best practice pattern based on tool capabilities)

1. Start with **Grep** to find entry points (e.g., search for `main(`, `app.listen`, `export default`)
2. Use **Read** to examine those files and follow imports
3. Trace function usage across wrapper modules by first identifying all exported names, then searching for each with Grep

Anti-pattern: Starting with Read on unknown codebases — use Grep/Glob first to find relevant files.

**Note:** Claude Code also provides an **LSP tool** for code intelligence, which supports jumping to definitions, finding references, getting type info, listing symbols, finding implementations, and tracing call hierarchies. When available (requires a code intelligence plugin and language server binary), LSP provides more precise navigation than Grep-based approaches.

---

## tracing-function-usage
**Knowledge:** Tracing function usage across wrapper modules by first identifying all exported names, then searching for each name across the codebase — with awareness that barrel files create indirection making naive grep insufficient
**Source:** [Claude Code Tools Reference](https://code.claude.com/docs/en/tools-reference) | [How Claude Code Works](https://code.claude.com/docs/en/how-claude-code-works)

To trace function usage across wrapper modules: first identify all exported names from the module, then search for each name across the codebase using Grep. This reveals all consumers and helps understand the full impact of changes.

### Why Barrel Files Make Simple Grep Insufficient

In TypeScript/JavaScript codebases, **barrel files** (`index.ts`) re-export symbols from sibling modules. Consumers import from `src/utils`, not from `src/utils/format`. A naive `grep "from.*format"` misses every consumer that imports through the barrel. The same pattern appears in Python (`__init__.py`), Rust (`mod.rs` + `pub use`), and Go.

### Worked Example: Tracing `formatCurrency`

**Step 1 — Find the definition** (Grep for the function name):
```
Grep: "export.*formatCurrency" → src/utils/format.ts:14
```

**Step 2 — Check for re-exports** (Glob for barrel file):
```
Glob: src/utils/index.ts → exists
Read: export { formatCurrency, formatDate } from './format';
```

**Step 3 — Search for ALL import paths** (Grep for the *symbol name*):
```
Grep: "formatCurrency" across **/*.ts (excluding definition + barrel)
→ src/components/PriceDisplay.tsx:3  import { formatCurrency } from '../utils';
→ src/api/invoice.ts:5              import { formatCurrency } from '../utils/index';
→ src/tests/format.test.ts:2        import { formatCurrency } from '../utils/format';
```

**Step 4 — Read consumers** to understand usage context.

### Key Principle: Search by Symbol Name, Not File Path

The critical technique is **Step 3**: grep for `formatCurrency` (the symbol) across the entire codebase, rather than `format` (the file). This catches all import styles — barrel, explicit index, and direct.

### Agent Decision Pattern

1. **Grep** for symbol → find definition
2. **Glob** for `index.ts`/`__init__.py`/`mod.rs` in same directory → detect barrel
3. **Read** barrel → confirm re-export
4. **Grep** for symbol across codebase → find all consumers
5. **Read** consumers → understand context
