---
layout: default
title: Domain 3: Claude Code Configuration & Workflows
---

# Domain 3: Claude Code Configuration & Workflows

## claude-md-hierarchy
**Knowledge:** The CLAUDE.md configuration hierarchy: managed policy (system-level), project-level (`.claude/CLAUDE.md` or root `CLAUDE.md`), user-level (`~/.claude/CLAUDE.md`), and directory-level (subdirectory `CLAUDE.md` files)
**Source:** [Claude Code Memory](https://code.claude.com/docs/en/memory)

Claude Code reads CLAUDE.md files at four levels:

1. **Managed policy** (macOS: `/Library/Application Support/ClaudeCode/CLAUDE.md`, Linux/WSL: `/etc/claude-code/CLAUDE.md`, Windows: `C:\Program Files\ClaudeCode\CLAUDE.md`): Organization-wide instructions managed by IT/DevOps. Cannot be excluded by individual settings.
2. **Project-level** (`.claude/CLAUDE.md` or `CLAUDE.md` at repo root): Shared with all team members through version control.
3. **User-level** (`~/.claude/CLAUDE.md`): Applies only to the individual user. Not shared via version control.
4. **Directory-level** (subdirectory `CLAUDE.md` files): Scoped to that directory and its children. Loaded on demand when Claude reads files in that subdirectory.

All levels are loaded into context at runtime. More specific locations take precedence over broader ones. If contradictory instructions exist, Claude may pick one arbitrarily. CLAUDE.md files in the directory hierarchy above the working directory are loaded in full at launch; subdirectory CLAUDE.md files load on demand.

CLAUDE.md content is delivered as a **user message after the system prompt**. After `/compact`, Claude re-reads all CLAUDE.md files from disk — making CLAUDE.md more durable than conversational instructions.

---

## user-level-not-shared
**Knowledge:** User-level settings apply only to that user—instructions in `~/.claude/CLAUDE.md` are not shared with teammates via version control
**Source:** [Claude Code Memory](https://code.claude.com/docs/en/memory)

Instructions in `~/.claude/CLAUDE.md` are invisible to teammates. If a new team member isn't receiving instructions, check whether rules are in user-level (not shared) instead of project-level (shared via version control). Always put team standards in project-level config.

---

## import-syntax
**Knowledge:** The `@import` syntax for referencing external files to keep CLAUDE.md modular
**Source:** [Claude Code Memory](https://code.claude.com/docs/en/memory)

The `@path` syntax references external files from CLAUDE.md:

```markdown
See @README for project overview and @package.json for available npm commands.
@docs/git-instructions.md
@~/.claude/my-project-instructions.md
```

| Path Type | Syntax | Resolution |
|-----------|--------|------------|
| Relative | `@docs/style-guide.md` | Resolved relative to the **containing file** |
| Absolute | `@/home/user/shared/rules.md` | Resolved as-is |
| Home directory | `@~/.claude/my-preferences.md` | Expanded to user's home |

Any file type can be imported. Imported files can recursively import (max depth of 5 hops). Imports don't work inside code blocks.

---

## claude-rules-directory
**Knowledge:** `.claude/rules/` directory for organizing topic-specific rule files as an alternative to a monolithic CLAUDE.md
**Source:** [Claude Code Settings](https://code.claude.com/docs/en/settings)

Split rules into topic-specific files instead of one massive CLAUDE.md:

```
.claude/rules/
  testing.md
  api-conventions.md
  deployment.md
  security.md
```

Each file focuses on one topic — easier to maintain, review, and version-control. Files are automatically discovered recursively.

---

## memory-command-verification
**Knowledge:** Using the `/memory` command to verify which memory files are loaded and diagnose inconsistent behavior across sessions
**Source:** [Claude Code Memory](https://code.claude.com/docs/en/memory)

`/memory` shows all loaded CLAUDE.md files, rules, and auto-memory status. It's the primary debugging tool when Claude isn't following instructions.

| Problem | Debug Step |
|---------|-----------|
| Claude ignores a rule | Run `/memory` — if the file isn't listed, it's not loaded |
| Inconsistent behavior | Check all loaded files for contradictory instructions |
| Path-scoped rule not working | Rule not listed → ask Claude to read a matching file → run `/memory` again |
| Instructions lost after `/compact` | CLAUDE.md survives compaction (re-read from disk) |

---

## project-vs-user-commands
**Knowledge:** Project-scoped skills in `.claude/skills/` (shared via version control) vs user-scoped skills in `~/.claude/skills/` (personal), with enterprise skills at highest priority
**Source:** [Extend Claude with Skills](https://code.claude.com/docs/en/skills)

| Location | Scope | Priority | Shared? |
|----------|-------|----------|---------|
| Managed settings | Enterprise | 1 (highest) | Yes — deployed by IT |
| `~/.claude/skills/<name>/SKILL.md` | Personal (all projects) | 2 | No |
| `.claude/skills/<name>/SKILL.md` | Project | 3 | Yes — via version control |
| Plugin `skills/` directory | Where plugin is enabled | 4 (lowest) | Via plugin |

A skill at `.claude/skills/review/SKILL.md` becomes `/review`. When skills share the same name across levels, higher-priority locations win (enterprise > personal > project). Plugin skills use a `plugin-name:skill-name` namespace, so they cannot conflict with other levels.

Legacy `.claude/commands/` files still work the same way, but if a skill and a command share the same name, the skill takes precedence.

---

## skills-with-frontmatter
**Knowledge:** Skills in `.claude/skills/` with `SKILL.md` files that support frontmatter configuration including `context: fork`, `allowed-tools`, and `argument-hint`
**Source:** [Extend Claude with Skills](https://code.claude.com/docs/en/skills)

Skills live in `.claude/skills/<name>/SKILL.md` with YAML frontmatter:

| Field | Purpose |
|---|---|
| `name` | Display name for the skill (lowercase, hyphens, max 64 chars). If omitted, uses directory name |
| `description` | What the skill does and when to use it. Claude uses this to decide when to apply the skill |
| `argument-hint` | Hint shown during autocomplete to indicate expected arguments (e.g., `[issue-number]`) |
| `disable-model-invocation` | Set to `true` to prevent Claude from automatically loading this skill; user must type `/name` |
| `user-invocable` | Set to `false` to hide from the `/` menu; only Claude can invoke it |
| `allowed-tools` | Tools Claude can use without asking permission when this skill is active |
| `model` | Model to use when this skill is active |
| `context: fork` | Runs in isolated sub-agent context — output doesn't pollute main conversation |
| `agent` | Which subagent type to use when `context: fork` is set (e.g., `Explore`, `Plan`, `general-purpose`) |
| `hooks` | Hooks scoped to this skill's lifecycle |

---

## context-fork-isolation
**Knowledge:** The `context: fork` frontmatter option for running skills in an isolated sub-agent context, preventing skill outputs from polluting the main conversation
**Source:** [Extend Claude with Skills](https://code.claude.com/docs/en/skills)

When `context: fork` is set:
1. A new context window is created — no access to main conversation history
2. The SKILL.md content becomes the sub-agent's task/prompt
3. CLAUDE.md files are still loaded into the forked context
4. Results are summarized and returned to the main conversation
5. Side effects in the sub-agent's context do not pollute the main conversation

The `agent` field specifies which subagent configuration to use: built-in agents (`Explore`, `Plan`, `general-purpose`) or any custom subagent from `.claude/agents/`. If omitted, uses `general-purpose`.

Critical for skills that explore large codebases, generate reports, or produce extensive intermediate output.

---

## personal-skill-customization
**Knowledge:** Personal skill customization: creating personal variants in `~/.claude/skills/` with different names to extend (not shadow) project skills
**Source:** [Extend Claude with Skills](https://code.claude.com/docs/en/skills)

Create personal variants of skills in `~/.claude/skills/` with **different names** to avoid conflicts with project-level skills.

**Critical precedence distinction:** Skills follow **Enterprise > Personal > Project** precedence. A personal skill with the *same name* as a project skill completely shadows the project version for that user only.

### Worked Example: Personal Review Skill

**Project skill** — `.claude/skills/review/SKILL.md` (shared via git):
```yaml
---
name: review
description: Review code against team standards
allowed-tools: Read, Grep, Glob
---
# Team Code Review
1. Error handling: All async calls need try/catch
2. Tests: Every new public function needs a unit test
3. Security: No secrets in source
```

**Personal skill** — `~/.claude/skills/my-review/SKILL.md` (NOT committed):
```yaml
---
name: my-review
description: Personal review layering my preferences on team standards
disable-model-invocation: true
allowed-tools: Read, Grep, Glob, Skill
---
# Step 1: Run /review (team skill)
# Step 2: Also check: functional style, const-by-default, guard clauses
# Step 3: Output team results + personal findings separately
```

The different name (`my-review` vs `review`) lets both coexist. The personal skill uses `allowed-tools: Skill` to chain-invoke the project `/review` skill.

**What goes wrong with the same name:** If the user creates `~/.claude/skills/review/SKILL.md`, it shadows the project `review` for that user — they never benefit from team updates to the project skill.

### Decision Criteria

| Situation | Action |
|---|---|
| Add personal preferences on top of team standards | Different name + chain-invoke team skill |
| Completely replace a team workflow for yourself | Same name (use cautiously — loses team updates) |
| Behavior should apply across all projects | Create in `~/.claude/skills/` |
| Team should adopt your improvement | Modify project skill and commit |

---

## skills-vs-claude-md
**Knowledge:** Choosing between skills (on-demand invocation for task-specific workflows) and CLAUDE.md (always-loaded universal standards)
**Source:** [Extend Claude with Skills](https://code.claude.com/docs/en/skills)

| Use Skills (.claude/skills/) | Use CLAUDE.md |
|---|---|
| On-demand invocation for specific workflows | Always-loaded universal standards |
| Task-specific (code review, migration, analysis) | Project-wide conventions (formatting, naming) |
| May need isolation (context: fork) | Should always be in context |
| Invoked explicitly by the developer | Applied automatically to every interaction |

---

## path-scoped-rules-frontmatter
**Knowledge:** `.claude/rules/` files with YAML frontmatter `paths` fields containing glob patterns for conditional rule activation
**Source:** [Claude Code Settings](https://code.claude.com/docs/en/settings)

Files in `.claude/rules/` can include YAML frontmatter with `paths` fields:

```yaml
---
paths:
  - "terraform/**/*"
---
# Terraform Conventions
Always use `terraform fmt` before committing...
```

Rules with `paths:` load zero context at launch — they only load when Claude reads a matching file. Rules without frontmatter load unconditionally at session launch.

---

## path-scoped-rules-token-savings
**Knowledge:** Path-scoped rules load only when editing matching files, reducing irrelevant context and token usage
**Source:** [Claude Code Settings](https://code.claude.com/docs/en/settings)

| Rule Type | Context Cost at Launch | When Loaded |
|-----------|----------------------|-------------|
| No frontmatter | Full file loaded | Unconditionally at session launch |
| With `paths:` | Zero | On demand — only when Claude reads a matching file |

This saves context window tokens by not loading irrelevant rules.

---

## glob-pattern-rules-advantage
**Knowledge:** The advantage of glob-pattern rules over directory-level CLAUDE.md files for conventions that span multiple directories
**Source:** [Claude Code Settings](https://code.claude.com/docs/en/settings)

| Approach | Best For |
|---|---|
| Directory-level CLAUDE.md | Conventions scoped to a single directory tree |
| Path-scoped .claude/rules/ | Conventions for file types spread across the codebase |

Path-scoped rules with glob patterns like `**/*.test.tsx` match files by type regardless of location. Directory-level CLAUDE.md files can't target test files spread across many directories.

---

## plan-mode-for-complex-tasks
**Knowledge:** Plan mode for complex tasks involving large-scale changes, multiple valid approaches, architectural decisions, and multi-file modifications
**Source:** [Claude Code Common Workflows](https://code.claude.com/docs/en/common-workflows)

Plan mode instructs Claude to create a plan by analyzing the codebase with read-only operations. It is designed for:
- Multi-step implementation requiring edits to many files
- Code exploration when you want to research thoroughly before changing anything
- Interactive development when you want to iterate on the direction with Claude
- Multi-file modifications with interdependencies
- Unfamiliar codebases where exploration is needed before changes

Plan mode enables safe codebase exploration and design before committing to changes, preventing costly rework.

---

## direct-execution-simple-changes
**Knowledge:** Direct execution for simple, well-scoped changes (e.g., adding a single validation check to one function)
**Source:** [Claude Code Overview](https://code.claude.com/docs/en/overview)

Direct execution is appropriate for simple, well-scoped changes: adding a single validation check, fixing a typo, well-understood changes with clear scope and no architectural ambiguity.

| Factor | Plan Mode | Direct Execution |
|---|---|---|
| Files affected | Many (multi-file) | One or few |
| Approach clarity | Multiple valid approaches | Single obvious approach |
| Architectural impact | Significant | Minimal |

---

## plan-mode-prevents-rework
**Knowledge:** Plan mode enables safe codebase exploration and design before committing to changes, preventing costly rework
**Source:** [Claude Code Subagents](https://code.claude.com/docs/en/sub-agents)

Plan mode prevents costly rework by investigating dependencies, understanding the architecture, and designing the approach before writing any code. A powerful pattern: use plan mode for investigation, then switch to direct execution for implementation.

---

## explore-subagent
**Knowledge:** The Explore subagent for isolating verbose discovery output and returning summaries to preserve main conversation context
**Source:** [Claude Code Subagents](https://code.claude.com/docs/en/sub-agents)

The Explore subagent is a fast, read-only agent optimized for searching and analyzing codebases:

- **Model**: Haiku (fast, low-latency)
- **Tools**: Read-only tools (denied access to Write and Edit tools)
- **Thoroughness levels**: When invoking Explore, Claude specifies a level — **quick** for targeted lookups, **medium** for balanced exploration, or **very thorough** for comprehensive analysis

Claude delegates to Explore when it needs to search or understand a codebase without making changes. This keeps exploration results out of the main conversation context, preventing context window exhaustion.

---

## combining-plan-and-direct
**Knowledge:** Combining plan mode for investigation with direct execution for implementation (e.g., planning a library migration, then executing the planned approach)
**Source:** [Claude Code Subagents](https://code.claude.com/docs/en/sub-agents)

Combine plan mode for investigation with direct execution for implementation. Explore and design first, then execute with confidence. Example: plan a library migration (identify all import sites, understand dependency chain), then execute the planned approach file by file.

---

## concrete-io-examples
**Knowledge:** Concrete input/output examples as the most effective way to communicate expected transformations when prose descriptions are interpreted inconsistently
**Source:** [Prompting Best Practices](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/claude-prompting-best-practices)

When prose descriptions produce inconsistent results, concrete input/output examples are the most effective way to communicate expected transformations:

```
Input:  "john_doe_2024"  → Output: "JohnDoe2024"
Input:  "hello_world"    → Output: "HelloWorld"
```

This eliminates ambiguity about edge cases that natural language descriptions leave unclear. Use when Claude's first attempt doesn't match expectations.

---

## test-driven-iteration
**Knowledge:** Test-driven iteration: writing test suites first, then iterating by sharing test failures to guide progressive improvement
**Source:** [Claude Code Overview](https://code.claude.com/docs/en/overview)

Write test suites **before** implementation, then iterate by sharing test failures:

1. Write tests first — covering expected behavior, edge cases, performance requirements
2. Ask Claude to implement — provide the tests as context
3. Share test failures — exact failure output
4. Iterate — Claude uses failure messages to fix issues

Test failures serve as precise, unambiguous specifications.

---

## interview-pattern
**Knowledge:** The interview pattern: having Claude ask questions to surface considerations the developer may not have anticipated before implementing
**Source:** [Claude Code Overview](https://code.claude.com/docs/en/overview)

Before implementing solutions in unfamiliar domains, have Claude ask questions:

"Before implementing this payment processing system, ask me questions about the requirements, constraints, and edge cases I should consider."

Claude surfaces error handling scenarios, domain-specific edge cases, architectural trade-offs, and regulatory requirements you hadn't considered. Use when working in unfamiliar domains or with complex features.

---

## sequential-vs-parallel-issues
**Knowledge:** When to provide all issues in a single message (interacting problems) versus fixing them sequentially (independent problems)
**Source:** [Claude Code Overview](https://code.claude.com/docs/en/overview)

| Scenario | Approach | Rationale |
|---|---|---|
| Issues **interact** with each other | Single detailed message with all issues | Fixes may conflict; Claude needs full picture |
| Issues are **independent** | Fix them sequentially, one at a time | Each fix is self-contained; easier to verify |

---

## print-flag-ci
**Knowledge:** The `-p` (or `--print`) flag for running Claude Code in non-interactive mode in automated pipelines
**Source:** [Claude Code Agent SDK (CLI)](https://code.claude.com/docs/en/headless)

Running Claude in CI requires `-p` for non-interactive mode: `claude -p "Analyze this PR"`. Without `-p`, Claude waits for interactive input and the pipeline **hangs indefinitely**. This is the most common CI integration mistake.

---

## structured-output-ci
**Knowledge:** `--output-format json` and `--json-schema` CLI flags for enforcing structured output in CI contexts
**Source:** [Claude Code Headless Mode](https://code.claude.com/docs/en/headless)

Two flags enable machine-parseable output:
- `--output-format json`: Produces JSON output instead of human-readable text
- `--json-schema`: Constrains final output to a user-defined JSON Schema

Together, these produce structured findings that can be automatically parsed and posted as inline PR comments.

---

## claude-md-in-ci
**Knowledge:** CLAUDE.md as the mechanism for providing project context (testing standards, fixture conventions, review criteria) to CI-invoked Claude Code
**Source:** [Claude Code Memory](https://code.claude.com/docs/en/memory)

CLAUDE.md provides project context to CI-invoked Claude Code: testing standards, available test fixtures, code review expectations and focus areas. The same CLAUDE.md that guides interactive development also guides automated CI pipelines.

---

## session-context-isolation-review
**Knowledge:** Session context isolation: the same Claude session that generated code is less effective at reviewing its own changes compared to an independent review instance
**Source:** [Claude Code Best Practices](https://code.claude.com/docs/en/best-practices)

The same Claude session that generated code retains reasoning context, making it biased toward confirming its own decisions. Fresh sessions provide more objective review. CI pipelines should use separate sessions for generation and review.

---

## incremental-review-context
**Knowledge:** Including prior review findings in context when re-running reviews after new commits, instructing Claude to report only new or still-unaddressed issues to avoid duplicate comments
**Source:** [Claude Code Headless Mode](https://code.claude.com/docs/en/headless)

When re-running reviews after new commits: include prior review findings in context and instruct Claude to report **only new or still-unaddressed issues**. This prevents Claude from re-reporting already-addressed issues and creating noise.

---

## existing-test-context
**Knowledge:** Providing existing test files in context so test generation avoids suggesting duplicate scenarios already covered by the test suite
**Source:** [Claude Code Common Workflows](https://code.claude.com/docs/en/common-workflows)

Provide existing test files in context so test generation avoids duplicate scenarios already covered. Without this context, Claude will suggest tests that already exist, wasting effort.

### Worked Example: Test Context Prevents Duplicates

**Setup:** `src/utils.ts` has 6 functions. `tests/utils.test.ts` already covers 3 (`formatCurrency`, `parseDate`, `slugify`) with 5 test cases.

**Without context:**
```
> Write tests for src/utils.ts
```
Claude generates tests for all 6 functions — duplicating 5 existing tests.

**With context (using `@` reference):**
```
> Write tests for src/utils.ts. Existing tests are in @tests/utils.test.ts
```
Claude reads existing coverage and generates tests only for the 3 uncovered functions (`truncateText`, `deepMerge`, `retryAsync`). Zero duplication. New tests also match the existing `describe`/`it` structure.

**Reinforcing via CLAUDE.md:**
```markdown
# Testing
- When generating tests, always read existing test files first.
- Only generate tests for uncovered functions — never duplicate existing scenarios.
- Match assertion style from existing tests.
```
