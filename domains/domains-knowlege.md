---
layout: default
title: Domains Knowledge
---

# Domains Knowledge

## Domain 1: Agentic Architecture & Orchestration

- [The agentic loop lifecycle: sending requests to Claude, inspecting `stop_reason` (`"tool_use"` vs `"end_turn"`), executing requested tools, and returning results for the next iteration](domain-1-agentic-architecture.md#agentic-loop-lifecycle) \| [Source](https://platform.claude.com/docs/en/build-with-claude/handling-stop-reasons)
- [How tool results are appended to conversation history so the model can reason about the next action](domain-1-agentic-architecture.md#tool-results-in-conversation-history) \| [Source](https://platform.claude.com/docs/en/agents-and-tools/tool-use/implement-tool-use)
- [The distinction between model-driven decision-making (Claude reasons about which tool to call next based on context) and pre-configured decision trees or tool sequences](domain-1-agentic-architecture.md#model-driven-vs-preconfigured) \| [Source](https://www.anthropic.com/engineering/building-effective-agents)
- [Anti-patterns for agentic loop termination: parsing natural language signals to determine loop termination, setting arbitrary iteration caps as the primary stopping mechanism, or checking for assistant text content as a completion indicator](domain-1-agentic-architecture.md#agentic-loop-anti-patterns) \| [Source](https://platform.claude.com/docs/en/agents-and-tools/tool-use/overview)
- [Hub-and-spoke architecture where a coordinator agent manages all inter-subagent communication, error handling, and information routing](domain-1-agentic-architecture.md#hub-and-spoke-architecture) \| [Source](https://www.anthropic.com/engineering/multi-agent-research-system)
- [Subagents operate with isolated context—they do not inherit the coordinator's conversation history, and context must be explicitly provided in the prompt](domain-1-agentic-architecture.md#subagent-context-isolation) \| [Source](https://platform.claude.com/docs/en/agent-sdk/overview)
- [The role of the coordinator in task decomposition, delegation, result aggregation, and deciding which subagents to invoke based on query complexity](domain-1-agentic-architecture.md#coordinator-responsibilities) \| [Source](https://platform.claude.com/docs/en/agent-sdk/overview)
- [Risks of overly narrow task decomposition by the coordinator, leading to incomplete coverage of broad research topics](domain-1-agentic-architecture.md#narrow-decomposition-risk) \| [Source](https://www.anthropic.com/engineering/multi-agent-research-system)
- [The `Task` tool as the mechanism for spawning subagents, and the requirement that `allowedTools` must include `"Task"` for a coordinator to invoke subagents](domain-1-agentic-architecture.md#task-tool-spawning) \| [Source](https://platform.claude.com/docs/en/agent-sdk/overview)
- [The `AgentDefinition` configuration including descriptions, system prompts, and tool restrictions for each subagent type](domain-1-agentic-architecture.md#agent-definition-configuration) \| [Source](https://platform.claude.com/docs/en/agent-sdk/python)
- [Fork-based session management (`fork_session`) for creating independent branches from a shared analysis baseline to explore divergent approaches](domain-1-agentic-architecture.md#fork-based-session-management) \| [Source](https://code.claude.com/docs/en/sub-agents)
- [Partitioning research scope across subagents to minimize duplication (e.g., assigning distinct subtopics or source types to each agent)](domain-1-agentic-architecture.md#partitioning-research-scope) \| [Source](https://www.anthropic.com/engineering/multi-agent-research-system)
- [Iterative refinement loops where the coordinator evaluates synthesis output for gaps, re-delegates to search and analysis subagents with targeted queries, and re-invokes synthesis until coverage is sufficient](domain-1-agentic-architecture.md#iterative-refinement-loops) \| [Source](https://www.anthropic.com/engineering/multi-agent-research-system)
- [Using structured data formats to separate content from metadata (source URLs, document names, page numbers) when passing context between agents to preserve attribution](domain-1-agentic-architecture.md#structured-data-context-passing) \| [Source](https://www.anthropic.com/engineering/multi-agent-research-system)
- [Spawning parallel subagents by emitting multiple `Task` tool calls in a single coordinator response rather than across separate turns](domain-1-agentic-architecture.md#parallel-subagent-spawning) \| [Source](https://platform.claude.com/docs/en/agent-sdk/overview)
- [Designing coordinator prompts that specify research goals and quality criteria rather than step-by-step procedural instructions, to enable subagent adaptability](domain-1-agentic-architecture.md#goal-oriented-coordinator-prompts) \| [Source](https://www.anthropic.com/engineering/multi-agent-research-system)
- [The difference between programmatic enforcement (hooks, prerequisite gates) for deterministic guarantees and prompt-based guidance for probabilistic compliance; prompt instructions alone have a non-zero failure rate when deterministic compliance is required](domain-1-agentic-architecture.md#programmatic-vs-prompt-enforcement) \| [Source](https://platform.claude.com/docs/en/agent-sdk/hooks)
- [Structured handoff protocols for mid-process escalation that include customer details, root cause analysis, and recommended actions](domain-1-agentic-architecture.md#structured-handoff-protocols) \| [Source](https://platform.claude.com/docs/en/agent-sdk/overview)
- [Decomposing multi-concern customer requests into distinct items, then investigating each in parallel using shared context before synthesizing a unified resolution](domain-1-agentic-architecture.md#multi-concern-decomposition) \| [Source](https://www.anthropic.com/engineering/building-effective-agents)
- [Hook patterns (e.g., `PostToolUse`) that intercept tool results for transformation before the model processes them](domain-1-agentic-architecture.md#post-tool-use-hooks) \| [Source](https://platform.claude.com/docs/en/agent-sdk/hooks)
- [Hook patterns that intercept outgoing tool calls to enforce compliance rules (e.g., blocking refunds above a threshold)](domain-1-agentic-architecture.md#pre-tool-use-hooks) \| [Source](https://platform.claude.com/docs/en/agent-sdk/hooks)
- [Using `PostToolUse` hooks to normalize heterogeneous data formats (Unix timestamps, ISO 8601, numeric status codes) from different MCP tools](domain-1-agentic-architecture.md#data-normalization-hooks) \| [Source](https://platform.claude.com/docs/en/agent-sdk/hooks)
- [When to use fixed sequential pipelines (prompt chaining) versus dynamic adaptive decomposition based on intermediate findings](domain-1-agentic-architecture.md#pipelines-vs-adaptive-decomposition) \| [Source](https://www.anthropic.com/engineering/building-effective-agents)
- [Prompt chaining patterns that break reviews into sequential steps (e.g., analyze each file individually, then run a cross-file integration pass) to avoid attention dilution](domain-1-agentic-architecture.md#prompt-chaining-patterns) \| [Source](https://www.anthropic.com/engineering/building-effective-agents)
- [The value of adaptive investigation plans that generate subtasks based on what is discovered at each step](domain-1-agentic-architecture.md#adaptive-investigation-plans) \| [Source](https://www.anthropic.com/engineering/multi-agent-research-system)
- [Decomposing open-ended tasks by first mapping structure, identifying high-impact areas, then creating a prioritized plan that adapts as dependencies are discovered](domain-1-agentic-architecture.md#open-ended-task-decomposition) \| [Source](https://www.anthropic.com/engineering/multi-agent-research-system)
- [Named session resumption using `--resume <session-name>` to continue a specific prior conversation](domain-1-agentic-architecture.md#named-session-resumption) \| [Source](https://code.claude.com/docs/en/common-workflows)
- [The importance of informing the agent about changes to previously analyzed files when resuming sessions after code modifications](domain-1-agentic-architecture.md#informing-resumed-sessions) \| [Source](https://code.claude.com/docs/en/common-workflows)
- [Why starting a new session with a structured summary is more reliable than resuming with stale tool results](domain-1-agentic-architecture.md#fresh-session-vs-stale-resume) \| [Source](https://code.claude.com/docs/en/best-practices)

### Cheat Sheet

#### Relevant Legends

- **L1: Deterministic > Probabilistic for Critical Operations** — When something MUST happen (financial operations, security checks, required sequences) → use programmatic enforcement (hooks, prerequisites, code-level gates). Prompt instructions, few-shot examples, system prompt rules are all probabilistic — they have non-zero failure rates. **Trap**: Options that suggest "add to system prompt" or "add few-shot examples" for critical/deterministic needs.
- **L2: Fix Root Cause, Not Symptoms** — Tool selection problems → fix tool descriptions first. Format inconsistency → fix the criteria/specification, not add more instructions. **Trap**: Options that add classifiers, routing layers, or workarounds instead of fixing the actual problem.
- **L3: Scope Appropriately — Neither Over- nor Under-Engineer** — Match the solution to the problem size. **Over-engineering traps**: separate ML classifiers, vector databases, custom wrapper services, fine-tuning. **Under-engineering traps**: doing nothing, reducing functionality. Use the simplest tool that solves the problem.
- **L4: Coordinator Owns Orchestration — Subagents Stay in Lane** — Hub-and-spoke: all communication goes through the coordinator. Subagents should NOT: direct other agents, make orchestration decisions, halt workflow for decisions outside their scope. Subagents SHOULD: complete their task, annotate conflicts/uncertainties, return structured results with context. **Trap**: Options where subagents escalate/halt/direct other agents.

#### Common Traps

| ❌ Wrong (Trap) | ✅ Right |
|---|---|
| Using prompts for critical business logic | Programmatic enforcement (hooks, interceptors) |
| Static sequential task pipelines | Dynamic decomposition based on complexity |
| Subagents communicate independently | All communication through coordinator |
| Generic error messages ("error") | Structured error context (category, retryable, partial) |
| Assuming subagents inherit parent context | Explicitly pass findings in prompt |

#### Quick Reference

- Loop control = `stop_reason` field (`tool_use` → continue, `end_turn` → stop)
- Multi-step enforcement = programmatic prerequisites (hooks/code), NOT prompts
- Multi-concern requests = decompose + parallel investigation + shared context
- Parallel tool execution = prompt Claude to batch, return all results together

#### Key Insights

1. **Agentic Loop**: Check `stop_reason`, never natural language. `tool_use`=continue, `end_turn`=stop
2. **Programmatic > Prompts**: 88% prompt compliance → 12% failure. Hooks for financial/safety
3. **Dynamic Decomposition**: Coordinator analyzes urgency, spawns subagents by priority. Not fixed pipelines
4. **Hub-and-Spoke**: All communication through coordinator. Subagents never act independently
5. **Structured Error Propagation**: error_category + is_retryable + partial_results + alternatives
6. **Explicit Context Passing**: Subagents don't inherit. Pass customer_id, findings, scope in prompt
7. **Information Provenance**: Mark coverage_gaps, confidence levels. Never hide incompleteness

## Domain 2: Tool Design & MCP Integration

- [Tool descriptions as the primary mechanism LLMs use for tool selection; minimal descriptions lead to unreliable selection among similar tools](domain-2-tool-design-mcp.md#tool-descriptions-as-selection-mechanism) \| [Source](https://platform.claude.com/docs/en/agents-and-tools/tool-use/overview)
- [The importance of including input formats, example queries, edge cases, and boundary explanations in tool descriptions](domain-2-tool-design-mcp.md#tool-description-detail-requirements) \| [Source](https://www.anthropic.com/engineering/writing-tools-for-agents)
- [How ambiguous or overlapping tool descriptions cause misrouting (e.g., `analyze_content` vs `analyze_document` with near-identical descriptions)](domain-2-tool-design-mcp.md#ambiguous-tool-descriptions-misrouting) \| [Source](https://www.anthropic.com/engineering/writing-tools-for-agents)
- [The impact of system prompt wording on tool selection: keyword-sensitive instructions can create unintended tool associations](domain-2-tool-design-mcp.md#system-prompt-tool-selection-impact) \| [Source](https://www.anthropic.com/engineering/writing-tools-for-agents)
- [Renaming tools and updating descriptions to eliminate functional overlap](domain-2-tool-design-mcp.md#tool-renaming-overlap-elimination) \| [Source](https://www.anthropic.com/engineering/writing-tools-for-agents)
- [Right-sizing tools: splitting ambiguous multi-mode tools into purpose-specific tools, and consolidating multi-step workflows into single tools (e.g., replacing `list_users` + `list_events` + `create_event` with `schedule_event`)](domain-2-tool-design-mcp.md#splitting-generic-tools) \| [Source](https://www.anthropic.com/engineering/writing-tools-for-agents)
- [The MCP `isError` flag pattern for communicating tool failures back to the agent](domain-2-tool-design-mcp.md#mcp-iserror-flag) \| [Source](https://modelcontextprotocol.io/specification/2025-06-18/server/tools)
- [The distinction between transient errors (timeouts, service unavailability), validation errors (invalid input), business errors (policy violations), and permission errors](domain-2-tool-design-mcp.md#error-categories) \| [Source](https://modelcontextprotocol.io/specification/2025-06-18/server/tools)
- [Why uniform error responses (generic "Operation failed") prevent the agent from making appropriate recovery decisions](domain-2-tool-design-mcp.md#uniform-error-responses-harmful) \| [Source](https://www.anthropic.com/engineering/writing-tools-for-agents)
- [The difference between retryable and non-retryable errors, and how returning structured metadata (including `errorCategory`, `isRetryable`, and human-readable descriptions) prevents wasted retry attempts](domain-2-tool-design-mcp.md#structured-error-metadata) \| [Source](https://www.anthropic.com/engineering/writing-tools-for-agents)
- [The distinction between access failures (needing retry decisions) and valid empty results (representing successful queries with no matches)](domain-2-tool-design-mcp.md#access-failures-vs-empty-results) \| [Source](https://www.anthropic.com/engineering/writing-tools-for-agents)
- [Local error recovery within subagents for transient failures, propagating to the coordinator only errors that cannot be resolved locally along with partial results and what was attempted](domain-2-tool-design-mcp.md#local-error-recovery) \| [Source](https://www.anthropic.com/engineering/multi-agent-research-system)
- [The principle that giving an agent access to too many tools (e.g., 18 instead of 4-5) degrades tool selection reliability by increasing decision complexity](domain-2-tool-design-mcp.md#agent-tool-overload) \| [Source](https://www.anthropic.com/engineering/advanced-tool-use)
- [Why agents with tools outside their specialization tend to misuse them](domain-2-tool-design-mcp.md#out-of-scope-tool-misuse) \| [Source](https://www.anthropic.com/engineering/advanced-tool-use)
- [Scoped tool access: giving agents only the tools needed for their role, with limited cross-role tools for specific high-frequency needs](domain-2-tool-design-mcp.md#scoped-tool-access) \| [Source](https://www.anthropic.com/engineering/advanced-tool-use)
- [Replacing generic tools with constrained alternatives (e.g., replacing `fetch_url` with `load_document` that validates document URLs)](domain-2-tool-design-mcp.md#constrained-tool-alternatives) \| [Source](https://www.anthropic.com/engineering/advanced-tool-use)
- [`tool_choice` configuration options: `"auto"`, `"any"`, and forced tool selection (`{"type": "tool", "name": "..."}`)](domain-2-tool-design-mcp.md#tool-choice-configuration) \| [Source](https://platform.claude.com/docs/en/agents-and-tools/tool-use/overview)
- [MCP server scoping: local scope (default, personal per-project), project scope (`.mcp.json` for shared team tooling), and user scope (`~/.claude.json` for cross-project personal servers)](domain-2-tool-design-mcp.md#mcp-server-scoping) \| [Source](https://code.claude.com/docs/en/mcp)
- [Environment variable expansion in `.mcp.json` (e.g., `${GITHUB_TOKEN}`) for credential management without committing secrets](domain-2-tool-design-mcp.md#env-var-expansion-mcp) \| [Source](https://code.claude.com/docs/en/mcp)
- [Tools from all configured MCP servers are discovered at connection time and available simultaneously to the agent](domain-2-tool-design-mcp.md#simultaneous-mcp-server-access) \| [Source](https://code.claude.com/docs/en/mcp)
- [MCP resources as a mechanism for exposing content catalogs (e.g., issue summaries, documentation hierarchies, database schemas) to reduce exploratory tool calls](domain-2-tool-design-mcp.md#mcp-resources-content-catalogs) \| [Source](https://modelcontextprotocol.io/specification/2025-06-18/server/resources)
- [Enhancing MCP tool descriptions to explain capabilities and outputs in detail, preventing the agent from preferring built-in tools over more capable MCP tools](domain-2-tool-design-mcp.md#enhancing-mcp-tool-descriptions) \| [Source](https://www.anthropic.com/engineering/writing-tools-for-agents)
- [Choosing existing community MCP servers over custom implementations for standard integrations, reserving custom servers for team-specific workflows](domain-2-tool-design-mcp.md#community-vs-custom-mcp-servers) \| [Source](https://github.com/modelcontextprotocol/servers)
- [Grep for content search (searching file contents for patterns like function names, error messages, or import statements)](domain-2-tool-design-mcp.md#grep-content-search) \| [Source](https://code.claude.com/docs/en/tools-reference)
- [Glob for file path pattern matching (finding files by name or extension patterns)](domain-2-tool-design-mcp.md#glob-path-matching) \| [Source](https://code.claude.com/docs/en/tools-reference)
- [Read/Write for full file operations; Edit for targeted modifications using unique text matching](domain-2-tool-design-mcp.md#read-write-edit-tools) \| [Source](https://code.claude.com/docs/en/tools-reference)
- [When Edit fails due to non-unique text matches, using Read + Write as a fallback for reliable file modifications](domain-2-tool-design-mcp.md#edit-fallback-pattern) \| [Source](https://code.claude.com/docs/en/tools-reference)
- [Building codebase understanding incrementally: starting with Grep to find entry points, then using Read to follow imports and trace flows, rather than reading all files upfront](domain-2-tool-design-mcp.md#incremental-codebase-understanding) \| [Source](https://code.claude.com/docs/en/tools-reference)
- [Tracing function usage across wrapper modules by first identifying all exported names, then searching for each name across the codebase](domain-2-tool-design-mcp.md#tracing-function-usage) \| [Source](https://code.claude.com/docs/en/tools-reference)

### Cheat Sheet

#### Relevant Legends

- **L2: Fix Root Cause, Not Symptoms** — Tool selection problems → fix DESCRIPTIONS first (they are the primary selection mechanism). Keyword-triggered misrouting → fix SYSTEM PROMPT wording. **Trap**: Options that add classifiers, routing layers, or workarounds instead of fixing the actual problem.
- **L3: Scope Appropriately — Neither Over- nor Under-Engineer** — Match the solution to the problem size. Use tool descriptions for selection issues, hooks for deterministic enforcement, constrained tools for scope issues. **Trap**: If the option adds a NEW SYSTEM COMPONENT (separate model, database, queue, classifier) → likely a trap.

#### Common Traps

| ❌ Wrong (Trap) | ✅ Right |
|---|---|
| Minimal tool descriptions ("Analyzes content") | Detailed with inputs, outputs, when-to-use |
| Giving 18 tools to every agent | Scope to 4–5 per role |
| Full verbose tool output in context | PostToolUse hooks trim to relevant fields |
| MCP config in ~/.claude.json for team | .mcp.json in project root for shared |
| Confusing Glob and Grep | Glob = files by path, Grep = content search |

#### Quick Reference

- Wrong tool selection → fix DESCRIPTIONS first (primary selection mechanism)
- Keyword-triggered misrouting → fix SYSTEM PROMPT wording
- Tool overlap → RENAME tools to eliminate semantic overlap
- Too many tools → scope to role; consider Tool Search Tool
- Out-of-scope tool use → CONSTRAIN tool (e.g., replace `fetch_url` with `load_document`)

#### Key Insights

8. **Tool Descriptions Drive Selection**: Include input/output formats, edge cases, "use INSTEAD OF"
9. **4-5 Tools Per Agent**: 18 tools → degraded selection. Scope per role
10. **Two Hook Types**: PostToolUse (transform results), Tool Call Interceptor (block/redirect calls)
11. **MCP Server Scoping**: .mcp.json (team, git) vs ~/.claude.json (personal)
12. **Built-in Tools**: Glob=files by path, Grep=content, Read=load, Edit=targeted, Write=overwrite
13. **tool_choice Config**: "auto" (model decides), "any" (must call tool), forced (specific tool)

## Domain 3: Claude Code Configuration & Workflows

- [The CLAUDE.md configuration hierarchy: managed policy (system-level), project-level (`.claude/CLAUDE.md` or root `CLAUDE.md`), user-level (`~/.claude/CLAUDE.md`), and directory-level (subdirectory `CLAUDE.md` files)](domain-3-claude-code-configuration.md#claude-md-hierarchy) \| [Source](https://code.claude.com/docs/en/memory)
- [User-level settings apply only to that user—instructions in `~/.claude/CLAUDE.md` are not shared with teammates via version control](domain-3-claude-code-configuration.md#user-level-not-shared) \| [Source](https://code.claude.com/docs/en/memory)
- [The `@import` syntax for referencing external files to keep CLAUDE.md modular](domain-3-claude-code-configuration.md#import-syntax) \| [Source](https://code.claude.com/docs/en/memory)
- [`.claude/rules/` directory for organizing topic-specific rule files as an alternative to a monolithic CLAUDE.md](domain-3-claude-code-configuration.md#claude-rules-directory) \| [Source](https://code.claude.com/docs/en/settings)
- [Using the `/memory` command to verify which memory files are loaded and diagnose inconsistent behavior across sessions](domain-3-claude-code-configuration.md#memory-command-verification) \| [Source](https://code.claude.com/docs/en/memory)
- [Project-scoped skills in `.claude/skills/` (shared via version control) vs user-scoped skills in `~/.claude/skills/` (personal), with enterprise skills at highest priority](domain-3-claude-code-configuration.md#project-vs-user-commands) \| [Source](https://code.claude.com/docs/en/skills)
- [Skills in `.claude/skills/` with `SKILL.md` files that support frontmatter configuration including `context: fork`, `allowed-tools`, `argument-hint`, `model`, `agent`, and `hooks`](domain-3-claude-code-configuration.md#skills-with-frontmatter) \| [Source](https://code.claude.com/docs/en/skills)
- [The `context: fork` frontmatter option for running skills in an isolated sub-agent context, preventing skill outputs from polluting the main conversation](domain-3-claude-code-configuration.md#context-fork-isolation) \| [Source](https://code.claude.com/docs/en/skills)
- [Personal skill customization: creating personal variants in `~/.claude/skills/` with different names to avoid affecting teammates](domain-3-claude-code-configuration.md#personal-skill-customization) \| [Source](https://code.claude.com/docs/en/skills)
- [Choosing between skills (on-demand invocation for task-specific workflows) and CLAUDE.md (always-loaded universal standards)](domain-3-claude-code-configuration.md#skills-vs-claude-md) \| [Source](https://code.claude.com/docs/en/skills)
- [`.claude/rules/` files with YAML frontmatter `paths` fields containing glob patterns for conditional rule activation](domain-3-claude-code-configuration.md#path-scoped-rules-frontmatter) \| [Source](https://code.claude.com/docs/en/settings)
- [Path-scoped rules load only when editing matching files, reducing irrelevant context and token usage](domain-3-claude-code-configuration.md#path-scoped-rules-token-savings) \| [Source](https://code.claude.com/docs/en/settings)
- [The advantage of glob-pattern rules over directory-level CLAUDE.md files for conventions that span multiple directories](domain-3-claude-code-configuration.md#glob-pattern-rules-advantage) \| [Source](https://code.claude.com/docs/en/settings)
- [Plan mode for complex tasks involving large-scale changes, multiple valid approaches, architectural decisions, and multi-file modifications](domain-3-claude-code-configuration.md#plan-mode-for-complex-tasks) \| [Source](https://code.claude.com/docs/en/common-workflows)
- [Direct execution for simple, well-scoped changes (e.g., adding a single validation check to one function)](domain-3-claude-code-configuration.md#direct-execution-simple-changes) \| [Source](https://code.claude.com/docs/en/overview)
- [Plan mode enables safe codebase exploration and design before committing to changes, preventing costly rework](domain-3-claude-code-configuration.md#plan-mode-prevents-rework) \| [Source](https://code.claude.com/docs/en/sub-agents)
- [The Explore subagent for isolating verbose discovery output and returning summaries to preserve main conversation context](domain-3-claude-code-configuration.md#explore-subagent) \| [Source](https://code.claude.com/docs/en/sub-agents)
- [Combining plan mode for investigation with direct execution for implementation (e.g., planning a library migration, then executing the planned approach)](domain-3-claude-code-configuration.md#combining-plan-and-direct) \| [Source](https://code.claude.com/docs/en/sub-agents)
- [Concrete input/output examples as the most effective way to communicate expected transformations when prose descriptions are interpreted inconsistently](domain-3-claude-code-configuration.md#concrete-io-examples) \| [Source](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/claude-prompting-best-practices)
- [Test-driven iteration: writing test suites first, then iterating by sharing test failures to guide progressive improvement](domain-3-claude-code-configuration.md#test-driven-iteration) \| [Source](https://code.claude.com/docs/en/overview)
- [The interview pattern: having Claude ask questions to surface considerations the developer may not have anticipated before implementing](domain-3-claude-code-configuration.md#interview-pattern) \| [Source](https://code.claude.com/docs/en/overview)
- [When to provide all issues in a single message (interacting problems) versus fixing them sequentially (independent problems)](domain-3-claude-code-configuration.md#sequential-vs-parallel-issues) \| [Source](https://code.claude.com/docs/en/overview)
- [The `-p` (or `--print`) flag for running Claude Code in non-interactive mode in automated pipelines](domain-3-claude-code-configuration.md#print-flag-ci) \| [Source](https://code.claude.com/docs/en/headless)
- [`--output-format json` and `--json-schema` CLI flags for enforcing structured output in CI contexts](domain-3-claude-code-configuration.md#structured-output-ci) \| [Source](https://code.claude.com/docs/en/headless)
- [CLAUDE.md as the mechanism for providing project context (testing standards, fixture conventions, review criteria) to CI-invoked Claude Code](domain-3-claude-code-configuration.md#claude-md-in-ci) \| [Source](https://code.claude.com/docs/en/memory)
- [Session context isolation: the same Claude session that generated code is less effective at reviewing its own changes compared to an independent review instance](domain-3-claude-code-configuration.md#session-context-isolation-review) \| [Source](https://code.claude.com/docs/en/best-practices)
- [Including prior review findings in context when re-running reviews after new commits, instructing Claude to report only new or still-unaddressed issues to avoid duplicate comments](domain-3-claude-code-configuration.md#incremental-review-context) \| [Source](https://code.claude.com/docs/en/headless)
- [Providing existing test files in context so test generation avoids suggesting duplicate scenarios already covered by the test suite](domain-3-claude-code-configuration.md#existing-test-context) \| [Source](https://code.claude.com/docs/en/common-workflows)

### Cheat Sheet

#### Relevant Legends

- **L3: Scope Appropriately — Neither Over- nor Under-Engineer** — Skills for on-demand context loading, .claude/rules/ for path-scoped conventions. Plan mode for complex changes, direct execution for simple ones.
- **L6: Context Isolation Prevents Contamination** — `context: fork` for skills that generate verbose/exploratory output. Independent instances for review (same session = confirmation bias). Explore subagent for verbose discovery phases. **Trap**: Options that try to manage context within a single session (/compact, instructions to "ignore prior context").
- **L7: Few-Shot Examples > Prose Instructions (for Format/Judgment)** — Concrete input/output examples > prose for transformation tasks. When prose instructions produce inconsistent results → add 3-5 few-shot examples targeting ambiguous cases.

#### Common Traps

| ❌ Wrong (Trap) | ✅ Right |
|---|---|
| ~/.claude/CLAUDE.md for team standards | .claude/CLAUDE.md (project-level, shared) |
| Directory CLAUDE.md for cross-dir rules | .claude/rules/ with glob patterns |
| Verbose skill output pollutes context | context: fork in skill frontmatter |
| CI without -p flag | Always use -p for non-interactive mode |
| Duplicate review comments every run | Include prior findings in prompt |

#### Quick Reference

- Team-shared commands → `.claude/commands/` (version controlled)
- Personal customization → `~/.claude/skills/` with DIFFERENT NAME
- Always-loaded context → CLAUDE.md or .claude/rules/
- On-demand context → Skills (invoked via slash command)
- Path-specific conventions → .claude/rules/ with YAML frontmatter glob patterns
- Verbose skill output → `context: fork` frontmatter
- Complex architecture decisions → Plan mode first
- Simple changes with clear patterns → Direct execution

#### Key Insights

14. **CLAUDE.md Hierarchy**: ~/.claude/ (personal) → .claude/ (project/shared) → subdir/ (specific)
15. **Path-Specific Rules**: .claude/rules/ with YAML frontmatter glob patterns
16. **Skills Frontmatter**: context:fork, allowed-tools, argument-hint
17. **Plan Mode vs Direct**: Plan for complex/multi-file/architectural. Direct for simple/clear-scope
18. **CI/CD Integration**: -p flag REQUIRED, --output-format json, --json-schema
19. **Iterative Refinement**: I/O examples > prose, test-driven, interview pattern

## Domain 4: Prompt Engineering & Structured Output

- [The importance of explicit criteria over vague instructions (e.g., "flag comments only when claimed behavior contradicts actual code behavior" vs "check that comments are accurate")](domain-4-prompt-engineering.md#explicit-criteria-over-vague) \| [Source](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/claude-prompting-best-practices)
- [How general instructions like "be conservative" or "only report high-confidence findings" fail to improve precision compared to specific categorical criteria](domain-4-prompt-engineering.md#general-instructions-fail) \| [Source](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/overview)
- [The impact of false positive rates on developer trust: high false positive categories undermine confidence in accurate categories](domain-4-prompt-engineering.md#false-positive-trust-erosion) \| [Source](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/overview)
- [Writing specific review criteria that define which issues to report (bugs, security) versus skip (minor style, local patterns) rather than relying on confidence-based filtering](domain-4-prompt-engineering.md#specific-review-criteria) \| [Source](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/overview)
- [Temporarily disabling high false-positive categories to restore developer trust while improving prompts for those categories](domain-4-prompt-engineering.md#disabling-false-positive-categories) \| [Source](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/overview)
- [Defining explicit severity criteria with concrete code examples for each severity level to achieve consistent classification](domain-4-prompt-engineering.md#severity-criteria-with-examples) \| [Source](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/claude-prompting-best-practices)
- [Few-shot examples as the most effective technique for achieving consistently formatted, actionable output when detailed instructions alone produce inconsistent results](domain-4-prompt-engineering.md#few-shot-examples-primary-tool) \| [Source](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/claude-prompting-best-practices)
- [The role of few-shot examples in demonstrating ambiguous-case handling (e.g., tool selection for ambiguous requests, branch-level test coverage gaps)](domain-4-prompt-engineering.md#few-shot-ambiguous-case-handling) \| [Source](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/claude-prompting-best-practices)
- [How few-shot examples enable the model to generalize judgment to novel patterns rather than matching only pre-specified cases](domain-4-prompt-engineering.md#few-shot-generalization) \| [Source](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/claude-prompting-best-practices)
- [The effectiveness of few-shot examples for reducing hallucination in extraction tasks (e.g., handling informal measurements, varied document structures)](domain-4-prompt-engineering.md#few-shot-hallucination-reduction) \| [Source](https://github.com/anthropics/prompt-eng-interactive-tutorial)
- [Tool use (`tool_use`) with JSON schemas as the most reliable approach for guaranteed schema-compliant structured output, eliminating JSON syntax errors](domain-4-prompt-engineering.md#tool-use-structured-output) \| [Source](https://platform.claude.com/docs/en/build-with-claude/structured-outputs)
- [The distinction between `tool_choice: "auto"` (model may return text instead of calling a tool), `"any"` (model must call a tool but can choose which), and forced tool selection (model must call a specific named tool)](domain-4-prompt-engineering.md#tool-choice-auto-vs-any-vs-forced) \| [Source](https://platform.claude.com/docs/en/agents-and-tools/tool-use/overview)
- [Strict JSON schemas via tool use eliminate syntax errors but do not prevent semantic errors (e.g., line items that don't sum to total, values in wrong fields)](domain-4-prompt-engineering.md#semantic-vs-schema-errors) \| [Source](https://platform.claude.com/docs/en/build-with-claude/structured-outputs)
- [Schema design considerations: required vs optional fields, enum fields with "other" + detail string patterns for extensible categories](domain-4-prompt-engineering.md#schema-design-patterns) \| [Source](https://platform.claude.com/docs/en/build-with-claude/structured-outputs)
- [Designing optional (nullable) schema fields when source documents may not contain the information, preventing the model from fabricating values to satisfy required fields](domain-4-prompt-engineering.md#nullable-fields-prevent-hallucination) \| [Source](https://platform.claude.com/docs/en/build-with-claude/structured-outputs)
- [Including format normalization rules in prompts alongside strict output schemas to handle inconsistent source formatting](domain-4-prompt-engineering.md#format-normalization-rules) \| [Source](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/claude-prompting-best-practices)
- [Retry-with-error-feedback: appending specific validation errors to the prompt on retry to guide the model toward correction](domain-4-prompt-engineering.md#retry-with-error-feedback) \| [Source](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/overview)
- [The limits of retry: retries are ineffective when the required information is simply absent from the source document (vs format or structural errors)](domain-4-prompt-engineering.md#retry-limits) \| [Source](https://platform.claude.com/docs/en/build-with-claude/structured-outputs)
- [Feedback loop design: tracking which code constructs trigger findings (`detected_pattern` field) to enable systematic analysis of dismissal patterns](domain-4-prompt-engineering.md#feedback-loop-detected-pattern) \| [Source](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/overview)
- [The difference between semantic validation errors (values don't sum, wrong field placement) and schema syntax errors (eliminated by tool use)](domain-4-prompt-engineering.md#semantic-vs-syntax-validation) \| [Source](https://platform.claude.com/docs/en/build-with-claude/structured-outputs)
- [Self-correction validation flows: extracting "calculated_total" alongside "stated_total" to flag discrepancies, adding "conflict_detected" booleans for inconsistent source data](domain-4-prompt-engineering.md#self-correction-validation) \| [Source](https://platform.claude.com/docs/en/build-with-claude/structured-outputs)
- [The Message Batches API: 50% cost savings, up to 24-hour processing window, no guaranteed latency SLA](domain-4-prompt-engineering.md#batch-api-characteristics) \| [Source](https://platform.claude.com/docs/en/build-with-claude/batch-processing)
- [Batch processing is appropriate for non-blocking, latency-tolerant workloads (overnight reports, weekly audits, nightly test generation) and inappropriate for blocking workflows (pre-merge checks)](domain-4-prompt-engineering.md#batch-appropriate-workloads) \| [Source](https://platform.claude.com/docs/en/build-with-claude/batch-processing)
- [The batch API does not support multi-turn tool calling within a single request](domain-4-prompt-engineering.md#batch-no-multi-turn) \| [Source](https://platform.claude.com/docs/en/build-with-claude/batch-processing)
- [`custom_id` fields for correlating batch request/response pairs](domain-4-prompt-engineering.md#batch-custom-id) \| [Source](https://platform.claude.com/docs/en/api/messages/batches)
- [Calculating batch submission frequency based on SLA constraints (e.g., 4-hour windows to guarantee 30-hour SLA with 24-hour batch processing)](domain-4-prompt-engineering.md#batch-sla-calculation) \| [Source](https://platform.claude.com/docs/en/build-with-claude/batch-processing)
- [Handling batch failures: resubmitting only failed documents (identified by `custom_id`) with appropriate modifications (e.g., chunking documents that exceeded context limits)](domain-4-prompt-engineering.md#batch-failure-handling) \| [Source](https://platform.claude.com/docs/en/build-with-claude/batch-processing)
- [Using prompt refinement on a sample set before batch-processing large volumes to maximize first-pass success rates](domain-4-prompt-engineering.md#prompt-refinement-before-batch) \| [Source](https://platform.claude.com/docs/en/build-with-claude/batch-processing)
- [Self-review limitations: a model retains reasoning context from generation, making it less likely to question its own decisions in the same session](domain-4-prompt-engineering.md#self-review-limitations) \| [Source](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/overview)
- [Independent review instances (without prior reasoning context) are more effective at catching subtle issues than self-review instructions or extended thinking](domain-4-prompt-engineering.md#independent-review-instances) \| [Source](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/overview)
- [Multi-pass review: splitting large reviews into per-file local analysis passes plus cross-file integration passes to avoid attention dilution and contradictory findings](domain-4-prompt-engineering.md#multi-pass-review) \| [Source](https://github.com/anthropics/claude-cookbooks/tree/main/patterns/agents)
- [Running verification passes where the model self-reports confidence alongside each finding to enable calibrated review routing](domain-4-prompt-engineering.md#confidence-self-reporting) \| [Source](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/overview)

### Cheat Sheet

#### Relevant Legends

- **L5: Structured Data > Verbose Content** — Return key facts, citations, relevance scores instead of raw content. Extract transactional facts (amounts, dates, IDs) into persistent structured blocks. Distinguish access failures (retry-worthy) from valid empty results (informative). **Trap**: Options that suggest summarization agents, verbose concatenation, or retrieval systems.
- **L7: Few-Shot Examples > Prose Instructions (for Format/Judgment)** — When prose instructions produce inconsistent results → add 3-5 few-shot examples. Examples should target ambiguous cases (not clear-cut ones). Show reasoning for why one choice was made over another. **Trap**: Options that suggest "more detailed instructions" or "more explicit rules" when examples are the answer.

#### Common Traps

| ❌ Wrong (Trap) | ✅ Right |
|---|---|
| "Be conservative" vague guidance | Explicit categorical criteria (REPORT/SKIP) |
| Inconsistent output format | Few-shot examples showing exact output |
| JSON in text response for automation | tool_use with JSON Schema |
| Required fields for optional data | nullable: true for absent information |
| Retry when info absent from source | Only retry when info EXISTS in document |

#### Quick Reference

- Inconsistent formatting → few-shot examples (3-5)
- Ambiguous criteria → explicit criteria with concrete code examples
- Structured output needed → `--output-format json` + `--json-schema` (CLI) or tool_use (API)
- False positives eroding trust → temporarily DISABLE bad categories, fix prompts, re-enable
- Investigation time bottleneck → inline reasoning + confidence with each finding
- Blocking workflows (pre-merge checks) → synchronous API ALWAYS
- Non-blocking overnight/weekly tasks → Message Batches API (50% savings)
- Iterative tool calling → CANNOT use batch (no mid-request tool execution)
- Batch supports tool definitions but NOT client-side tool loops

#### Key Insights

20. **Explicit Criteria > Vague**: "REPORT: bugs, security. SKIP: style, TODOs" beats "be conservative"
21. **Few-Shot = Format Consistency**: 2-3 targeted examples for inconsistent output
22. **tool_use + Schema = Guaranteed JSON**: Eliminates syntax errors (not semantic)
23. **Validation-Retry Loop**: Retry with specific error feedback. Don't retry when info is absent
24. **Batch API**: 50% savings, 24h window, no multi-turn. custom_id for correlation
25. **Self-Review Limitation**: Same session = blind spots. Use separate independent instance

## Domain 5: Context Management & Reliability

- [Progressive summarization risks: condensing numerical values, percentages, dates, and customer-stated expectations into vague summaries](domain-5-context-management.md#progressive-summarization-risks) \| [Source](https://platform.claude.com/docs/en/build-with-claude/context-windows)
- [The "lost in the middle" effect: models reliably process information at the beginning and end of long inputs but may omit findings from middle sections](domain-5-context-management.md#lost-in-the-middle) \| [Source](https://www.anthropic.com/news/prompting-long-context)
- [How tool results accumulate in context and consume tokens disproportionately to their relevance](domain-5-context-management.md#tool-result-accumulation) \| [Source](https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents)
- [The importance of passing complete conversation history in subsequent API requests to maintain conversational coherence](domain-5-context-management.md#complete-conversation-history) \| [Source](https://platform.claude.com/docs/en/api/messages/create)
- [Extracting transactional facts (amounts, dates, order numbers, statuses) into a persistent "case facts" block included in each prompt, outside summarized history](domain-5-context-management.md#case-facts-extraction) \| [Source](https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents)
- [Trimming verbose tool outputs to only relevant fields before they accumulate in context](domain-5-context-management.md#trimming-verbose-outputs) \| [Source](https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents)
- [Placing key findings summaries at the beginning of aggregated inputs and organizing detailed results with explicit section headers to mitigate position effects](domain-5-context-management.md#position-aware-organization) \| [Source](https://www.anthropic.com/news/prompting-long-context)
- [Requiring subagents to include metadata (dates, source locations, methodological context) in structured outputs to support accurate downstream synthesis](domain-5-context-management.md#subagent-metadata-requirements) \| [Source](https://www.anthropic.com/engineering/multi-agent-research-system)
- [Modifying upstream agents to return structured data (key facts, citations, relevance scores) instead of verbose content and reasoning chains when downstream agents have limited context budgets](domain-5-context-management.md#upstream-agent-structured-data) \| [Source](https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents)
- [Appropriate escalation triggers: customer requests for a human, policy exceptions/gaps (not just complex cases), and inability to make meaningful progress](domain-5-context-management.md#escalation-triggers) \| Applied best practice
- [The distinction between escalating immediately when a customer explicitly demands it versus offering to resolve when the issue is straightforward](domain-5-context-management.md#immediate-vs-deferred-escalation) \| Applied best practice
- [Why sentiment-based escalation and self-reported confidence scores are unreliable proxies for actual case complexity](domain-5-context-management.md#unreliable-escalation-proxies) \| Applied best practice
- [How multiple customer matches require clarification (requesting additional identifiers) rather than heuristic selection](domain-5-context-management.md#multiple-customer-matches) \| Applied best practice
- [Adding explicit escalation criteria with few-shot examples to the system prompt demonstrating when to escalate versus resolve autonomously](domain-5-context-management.md#explicit-escalation-criteria) \| Applied best practice
- [Structured error context (failure type, attempted query, partial results, alternative approaches) as enabling intelligent coordinator recovery decisions](domain-5-context-management.md#structured-error-context) \| Applied best practice; `is_error` in [Messages API](https://platform.claude.com/docs/en/api/messages/create)
- [The distinction between access failures (timeouts needing retry decisions) and valid empty results (successful queries with no matches)](domain-5-context-management.md#access-failures-vs-empty-results-propagation) \| Applied best practice; `is_error` in [Messages API](https://platform.claude.com/docs/en/api/messages/create)
- [Why generic error statuses hide valuable context from the coordinator](domain-5-context-management.md#generic-error-statuses-harmful) \| Applied best practice
- [Why silently suppressing errors (returning empty results as success) or terminating entire workflows on single failures are both anti-patterns](domain-5-context-management.md#error-suppression-anti-patterns) \| [Source](https://www.anthropic.com/engineering/multi-agent-research-system)
- [Local recovery for transient failures within subagents, propagating only unresolvable errors with what was attempted and partial results](domain-5-context-management.md#local-recovery-propagation) \| [Source](https://www.anthropic.com/engineering/multi-agent-research-system)
- [Structuring synthesis output with coverage annotations indicating which findings are well-supported versus which topic areas have gaps due to unavailable sources](domain-5-context-management.md#coverage-annotations) \| [Source](https://www.anthropic.com/engineering/multi-agent-research-system)
- [Context degradation in extended sessions: models start giving inconsistent answers and referencing "typical patterns" rather than specific classes discovered earlier](domain-5-context-management.md#context-degradation) \| [Source](https://platform.claude.com/docs/en/build-with-claude/context-windows)
- [The role of scratchpad files for persisting key findings across context boundaries](domain-5-context-management.md#scratchpad-files) \| [Source](https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents)
- [Subagent delegation for isolating verbose exploration output while the main agent coordinates high-level understanding](domain-5-context-management.md#subagent-delegation-exploration) \| [Source](https://code.claude.com/docs/en/sub-agents)
- [Structured state persistence for crash recovery: each agent exports state to a known location, and the coordinator loads a manifest on resume](domain-5-context-management.md#structured-state-persistence) \| [Source](https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents)
- [Summarizing key findings from one exploration phase before spawning sub-agents for the next phase, injecting summaries into initial context](domain-5-context-management.md#phase-summarization) \| [Source](https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents)
- [Using `/compact` to reduce context usage during extended exploration sessions when context fills with verbose discovery output](domain-5-context-management.md#compact-command) \| [Source](https://code.claude.com/docs/en/best-practices)
- [The risk that aggregate accuracy metrics (e.g., 97% overall) may mask poor performance on specific document types or fields](domain-5-context-management.md#aggregate-accuracy-masking) \| Applied best practice
- [Stratified random sampling for measuring error rates in high-confidence extractions and detecting novel error patterns](domain-5-context-management.md#stratified-sampling) \| Applied best practice
- [Field-level confidence scores calibrated using labeled validation sets for routing review attention](domain-5-context-management.md#field-level-confidence) \| Applied best practice
- [The importance of validating accuracy by document type and field segment before automating high-confidence extractions](domain-5-context-management.md#accuracy-validation-before-automation) \| Applied best practice
- [Routing extractions with low model confidence or ambiguous/contradictory source documents to human review, prioritizing limited reviewer capacity](domain-5-context-management.md#routing-to-human-review) \| Applied best practice
- [How source attribution is lost during summarization steps when findings are compressed without preserving claim-source mappings](domain-5-context-management.md#source-attribution-loss) \| [Source](https://www.anthropic.com/engineering/multi-agent-research-system)
- [The importance of structured claim-source mappings that the synthesis agent must preserve and merge when combining findings](domain-5-context-management.md#claim-source-mappings) \| [Source](https://www.anthropic.com/engineering/multi-agent-research-system)
- [How to handle conflicting statistics from credible sources: annotating conflicts with source attribution rather than arbitrarily selecting one value](domain-5-context-management.md#conflicting-statistics-handling) \| [Source](https://www.anthropic.com/engineering/multi-agent-research-system)
- [Temporal data: requiring publication/collection dates in structured outputs to prevent temporal differences from being misinterpreted as contradictions](domain-5-context-management.md#temporal-data-requirements) \| Applied best practice; [Effective Context Engineering](https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents) and [Multi-Agent Research System](https://www.anthropic.com/engineering/multi-agent-research-system)
- [Structuring reports with explicit sections distinguishing well-established findings from contested ones, preserving original source characterizations and methodological context](domain-5-context-management.md#established-vs-contested-findings) \| [Source](https://www.anthropic.com/engineering/multi-agent-research-system)
- [Rendering different content types appropriately in synthesis outputs—financial data as tables, news as prose, technical findings as structured lists—rather than converting everything to a uniform format](domain-5-context-management.md#content-type-appropriate-rendering) \| Applied best practice

### Cheat Sheet

#### Relevant Legends

- **L5: Structured Data > Verbose Content** — Return key facts, citations, relevance scores instead of raw content. Extract transactional facts (amounts, dates, IDs) into persistent structured blocks. Distinguish access failures (retry-worthy) from valid empty results (informative). **Trap**: Options that suggest summarization agents, verbose concatenation, or retrieval systems.
- **L6: Context Isolation Prevents Contamination** — `context: fork` for skills that generate verbose/exploratory output. Independent instances for review (same session = confirmation bias). Explore subagent for verbose discovery phases. **Trap**: Options that try to manage context within a single session (/compact, instructions to "ignore prior context").

#### Common Traps

| ❌ Wrong (Trap) | ✅ Right |
|---|---|
| Middle findings missed in long inputs | Summaries at beginning ("lost in the middle") |
| Context bloat from tool results | PostToolUse trim + persistent case facts |
| Escalate based on sentiment analysis | Escalate on policy gaps / explicit request |
| Trust self-reported confidence scores | Calibrate with labeled validation sets |
| Resume with stale tool results | Fresh session with injected summary |

#### Quick Reference

- Summarization loses facts → extract to persistent "case facts" block
- Lost in the middle → key findings summary at START, section headers throughout
- Too many tokens from upstream → return structured data, not verbose content
- Access failure vs empty result → distinguish! Different recovery strategies
- Context degradation → Explore subagent, context: fork, fresh sessions

#### Key Insights

26. **Lost in the Middle**: Start/end reliable, middle missed. Key summaries at beginning
27. **Context Window Optimization**: PostToolUse trim + case facts block + structured upstream data
28. **Escalation Patterns**: Explicit request or policy gap → escalate. NOT sentiment or self-confidence
29. **Session Management**: --resume (valid), fresh+summary (stale), fork_session (compare)
30. **Large Codebase**: Subagents, scratchpad files, /compact, phase summarization
31. **Confidence Calibration**: Stratify by doc type + field. Don't trust aggregate metrics
