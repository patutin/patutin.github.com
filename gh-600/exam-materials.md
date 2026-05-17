---
layout: default
title: "GH-600 — Knowledge Domains & Documentation Links"
---

# GH-600 Knowledge Domains — GitHub Copilot Documentation Links

> Extracted from the [Study Guide for Exam GH-600: Developing in Agentic AI Systems](https://learn.microsoft.com/en-us/credentials/certifications/resources/study-guides/gh-600).
> Each domain is mapped to relevant pages from the [GitHub Copilot Documentation](https://docs.github.com/en/copilot/).
> Domains with no confirmed link are marked with `NEED_SEARCH`.

---

## 1. Prepare Agent Architecture and SDLC Processes (15–20%)

### 1.1 Integrate agents into the software development lifecycle (SDLC)

- 🔗 [About GitHub Copilot cloud agent](https://docs.github.com/en/copilot/concepts/agents/cloud-agent/about-cloud-agent)
- 🔗 [Get started with Copilot agents on GitHub](https://docs.github.com/en/copilot/how-tos/copilot-on-github/use-copilot-agents/overview)
- 🔗 [GitHub Agentic Workflows — overview (gh-aw)](https://github.github.com/gh-aw/)
- 🔗 [Agentic workflows vs. regular CI/CD — FAQ (gh-aw)](https://github.github.com/gh-aw/reference/faq/#i-like-deterministic-cicd-isnt-this-non-deterministic)

#### 1.1.1 Identify steps for agents to perform

- 🔗 [About agent skills](https://docs.github.com/en/copilot/concepts/agents/about-agent-skills)
- 🔗 [Kick off a task with Copilot agents on GitHub](https://docs.github.com/en/copilot/how-tos/copilot-on-github/use-copilot-agents/kick-off-a-task)
- 🔗 [Tools reference — edit, bash, github, web-fetch, playwright (gh-aw)](https://github.github.com/gh-aw/reference/tools/)

#### 1.1.2 Identify and mitigate common anti-patterns in agents

- 🔗 [Best practices for using GitHub Copilot](https://docs.github.com/en/copilot/get-started/best-practices)
- 🔗 [Risks and mitigations for GitHub Copilot cloud agent](https://docs.github.com/en/copilot/concepts/agents/cloud-agent/risks-and-mitigations)
- 🔗 [Get the best results from Copilot cloud agent](https://docs.github.com/en/copilot/tutorials/cloud-agent/get-the-best-results)

#### 1.1.3 Define inputs, outputs, and success criteria for agents

- 🔗 [About custom agents (cloud)](https://docs.github.com/en/copilot/concepts/agents/cloud-agent/about-custom-agents)
- 🔗 [Creating custom agents for Copilot cloud agent](https://docs.github.com/en/copilot/how-tos/copilot-on-github/customize-copilot/customize-cloud-agent/create-custom-agents)
- 🔗 [Adding repository custom instructions](https://docs.github.com/en/copilot/how-tos/copilot-on-github/customize-copilot/add-custom-instructions/add-repository-instructions)
- 🔗 [Safe outputs — structured output types and limits (gh-aw)](https://github.github.com/gh-aw/reference/safe-outputs/)
- 🔗 [Frontmatter — defining inputs via triggers and workflow_dispatch (gh-aw)](https://github.github.com/gh-aw/reference/frontmatter/)

---

### 1.2 Define boundaries between planning, reasoning, and action

- 🔗 [Research, plan, and iterate on code changes](https://docs.github.com/en/copilot/how-tos/copilot-on-github/use-copilot-agents/research-plan-iterate)
- 🔗 [Implementation planner (custom agent tutorial)](https://docs.github.com/en/copilot/tutorials/customization-library/custom-agents/implementation-planner)

#### 1.2.1 Configure agent planning to be distinct from agent execution

- 🔗 [Research, plan, and iterate on code changes](https://docs.github.com/en/copilot/how-tos/copilot-on-github/use-copilot-agents/research-plan-iterate)
- 🔗 [Implementation planner (custom agent tutorial)](https://docs.github.com/en/copilot/tutorials/customization-library/custom-agents/implementation-planner)

#### 1.2.2 Configure an agent to output a structured plan

- 🔗 [Research, plan, and iterate on code changes](https://docs.github.com/en/copilot/how-tos/copilot-on-github/use-copilot-agents/research-plan-iterate)
- 🔗 [Implementation planner (custom agent tutorial)](https://docs.github.com/en/copilot/tutorials/customization-library/custom-agents/implementation-planner)
- 🔗 [Creating custom agents for Copilot cloud agent](https://docs.github.com/en/copilot/how-tos/copilot-on-github/customize-copilot/customize-cloud-agent/create-custom-agents)

#### 1.2.3 Validate agent plans

- 🔗 [Review output from Copilot](https://docs.github.com/en/copilot/how-tos/copilot-on-github/use-copilot-agents/review-copilot-output)
- 🔗 [About hooks for GitHub Copilot](https://docs.github.com/en/copilot/concepts/agents/hooks)

#### 1.2.4 Prevent agent action until the agent checked and approved

- 🔗 [About hooks for GitHub Copilot](https://docs.github.com/en/copilot/concepts/agents/hooks)
- 🔗 [Customize agent workflows with hooks (cloud)](https://docs.github.com/en/copilot/how-tos/copilot-on-github/customize-copilot/customize-cloud-agent/use-hooks)
- 🔗 [Allowing GitHub Copilot CLI to work autonomously (autopilot)](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/autopilot)
- 🔗 [Safe outputs — agents request actions, a gated job decides (gh-aw)](https://github.github.com/gh-aw/reference/safe-outputs/)
- 🔗 [Threat detection — blocks output before application (gh-aw)](https://github.github.com/gh-aw/reference/threat-detection/)

---

### 1.3 Configure observability and control for autonomous agents

- 🔗 [Tracking GitHub Copilot's sessions](https://docs.github.com/en/copilot/how-tos/use-copilot-agents/cloud-agent/track-copilot-sessions)
- 🔗 [About agent management](https://docs.github.com/en/copilot/concepts/agents/cloud-agent/agent-management)
- 🔗 [Security architecture — five-layer defense model (gh-aw)](https://github.github.com/gh-aw/introduction/architecture/)

#### 1.3.1 Plan and implement the degree of agent autonomy, including guardrails

- 🔗 [Allowing GitHub Copilot CLI to work autonomously (autopilot)](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/autopilot)
- 🔗 [Build guardrails for Copilot cloud agent](https://docs.github.com/en/copilot/tutorials/cloud-agent/build-guardrails)
- 🔗 [Risks and mitigations for GitHub Copilot cloud agent](https://docs.github.com/en/copilot/concepts/agents/cloud-agent/risks-and-mitigations)
- 🔗 [Safe outputs — per-operation limits and guardrails (gh-aw)](https://github.github.com/gh-aw/reference/safe-outputs/)

#### 1.3.2 Configure agent to produce inspectable artifacts within standard development tooling

- 🔗 [Tracking GitHub Copilot's sessions](https://docs.github.com/en/copilot/how-tos/use-copilot-agents/cloud-agent/track-copilot-sessions)
- 🔗 [Review output from Copilot](https://docs.github.com/en/copilot/how-tos/copilot-on-github/use-copilot-agents/review-copilot-output)
- 🔗 [Safe outputs — agent_output.json artifact for inspection (gh-aw)](https://github.github.com/gh-aw/reference/safe-outputs/)

#### 1.3.3 Configure human intervention for autonomous agents without slowing delivery

- 🔗 [About hooks for GitHub Copilot](https://docs.github.com/en/copilot/concepts/agents/hooks)
- 🔗 [Customize agent workflows with hooks (cloud)](https://docs.github.com/en/copilot/how-tos/copilot-on-github/customize-copilot/customize-cloud-agent/use-hooks)
- 🔗 [Manage and track Copilot cloud agent sessions](https://docs.github.com/en/copilot/how-tos/copilot-on-github/use-copilot-agents/manage-and-track-agents)
- 🔗 [Threat detection — automated pre-action review without manual approvals (gh-aw)](https://github.github.com/gh-aw/reference/threat-detection/)
- 🔗 [Frontmatter — manual-approval trigger option (gh-aw)](https://github.github.com/gh-aw/reference/frontmatter/#trigger-events-on)

---

## 2. Implement Tool Use and Environment Interaction (20–25%)

### 2.1 Select and configure agent tools

- 🔗 [About agent skills](https://docs.github.com/en/copilot/concepts/agents/about-agent-skills)
- 🔗 [Adding agent skills (cloud agent)](https://docs.github.com/en/copilot/how-tos/copilot-on-github/customize-copilot/customize-cloud-agent/add-skills)
- 🔗 [Tools reference (gh-aw)](https://github.github.com/gh-aw/reference/tools/)

#### 2.1.1 Identify required tools

- 🔗 [About agent skills](https://docs.github.com/en/copilot/concepts/agents/about-agent-skills)
- 🔗 [Choosing the right AI tool for your task](https://docs.github.com/en/copilot/concepts/tools/ai-tools)
- 🔗 [Tools reference — edit, github, bash, web-fetch, playwright, cache-memory (gh-aw)](https://github.github.com/gh-aw/reference/tools/)

#### 2.1.2 Configure agent tools

- 🔗 [Adding agent skills (cloud agent)](https://docs.github.com/en/copilot/how-tos/copilot-on-github/customize-copilot/customize-cloud-agent/add-skills)
- 🔗 [Adding agent skills for GitHub Copilot CLI](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/add-skills)
- 🔗 [Frontmatter tools: section — configure tools in workflow frontmatter (gh-aw)](https://github.github.com/gh-aw/reference/frontmatter/)

#### 2.1.3 Configure agent tool permissions

- 🔗 [Allowing and denying tool use (CLI)](https://docs.github.com/en/copilot/how-tos/copilot-cli/use-copilot-cli/allowing-tools)
- 🔗 [Configuring GitHub Copilot CLI](https://docs.github.com/en/copilot/how-tos/copilot-cli/set-up-copilot-cli/configure-copilot-cli)
- 🔗 [Architecture — MCP tool allowlisting and sandboxing (gh-aw)](https://github.github.com/gh-aw/introduction/architecture/#mcp-server-sandboxing)

---

### 2.2 Configure MCP servers

- 🔗 [About Model Context Protocol (MCP)](https://docs.github.com/en/copilot/concepts/context/mcp)
- 🔗 [MCP server usage in your company](https://docs.github.com/en/copilot/concepts/mcp-management)
- 🔗 [Using MCP servers in agentic workflows (gh-aw)](https://github.github.com/gh-aw/guides/mcps/)

#### 2.2.1 Add an MCP server as a tool to an agent

- 🔗 [Adding MCP servers for GitHub Copilot CLI](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/add-mcp-servers)
- 🔗 [Connect agents to external tools (cloud agent + MCP)](https://docs.github.com/en/copilot/how-tos/copilot-on-github/customize-copilot/customize-cloud-agent/extend-cloud-agent-with-mcp)
- 🔗 [Configuring MCP servers — stdio, Docker, HTTP types (gh-aw)](https://github.github.com/gh-aw/guides/mcps/)
- 🔗 [Architecture — MCP Gateway and Firewall integration (gh-aw)](https://github.github.com/gh-aw/introduction/architecture/#mcp-gateway-and-firewall-integration)
- 🔗 [Extend Copilot Chat with MCP](https://docs.github.com/en/copilot/how-tos/provide-context/use-mcp-in-your-ide/extend-copilot-chat-with-mcp)

#### 2.2.2 Configure a GitHub remote MCP server

- 🔗 [Set up the GitHub MCP Server](https://docs.github.com/en/copilot/how-tos/provide-context/use-mcp-in-your-ide/set-up-the-github-mcp-server)
- 🔗 [Use the GitHub MCP Server](https://docs.github.com/en/copilot/how-tos/provide-context/use-mcp-in-your-ide/use-the-github-mcp-server)
- 🔗 [MCP and GitHub Copilot cloud agent](https://docs.github.com/en/copilot/concepts/agents/cloud-agent/mcp-and-cloud-agent)

#### 2.2.3 Configure the MCP registries

- 🔗 [Change MCP registry](https://docs.github.com/en/copilot/how-tos/provide-context/use-mcp-in-your-ide/change-mcp-registry)
- 🔗 [Configure MCP registry (admin)](https://docs.github.com/en/copilot/how-tos/administer-copilot/manage-mcp-usage/configure-mcp-registry)

#### 2.2.4 Configure MCP allow lists

- 🔗 [MCP allowlist enforcement](https://docs.github.com/en/copilot/reference/mcp-allowlist-enforcement)
- 🔗 [Configure MCP server access](https://docs.github.com/en/copilot/how-tos/administer-copilot/manage-mcp-usage/configure-mcp-server-access)

---

### 2.3 Integrate agents within development environments

- 🔗 [Configure the development environment (cloud agent)](https://docs.github.com/en/copilot/how-tos/copilot-on-github/customize-copilot/customize-cloud-agent/customize-the-agent-environment)
- 🔗 [Trigger events reference — push, issues, schedule, workflow_dispatch (gh-aw)](https://github.github.com/gh-aw/reference/triggers/)
- 🔗 [Frontmatter — on: trigger configuration (gh-aw)](https://github.github.com/gh-aw/reference/frontmatter/#trigger-events-on)

#### 2.3.1 Evaluate the execution context for an agent

- 🔗 [Configure the development environment (cloud agent)](https://docs.github.com/en/copilot/how-tos/copilot-on-github/customize-copilot/customize-cloud-agent/customize-the-agent-environment)
- 🔗 [Configuring agent settings](https://docs.github.com/en/copilot/how-tos/use-copilot-agents/cloud-agent/configuring-agent-settings)

#### 2.3.2 Configure an agent's scope to a specific repository

- 🔗 [Creating custom agents for Copilot cloud agent](https://docs.github.com/en/copilot/how-tos/copilot-on-github/customize-copilot/customize-cloud-agent/create-custom-agents)
- 🔗 [Adding repository custom instructions](https://docs.github.com/en/copilot/how-tos/copilot-on-github/customize-copilot/add-custom-instructions/add-repository-instructions)

#### 2.3.3 Configure an agent to be invoked in a CI workflow

- 🔗 [Automating tasks with Copilot CLI and GitHub Actions](https://docs.github.com/en/copilot/how-tos/copilot-cli/automate-copilot-cli/automate-with-actions)
- 🔗 [Running GitHub Copilot CLI programmatically](https://docs.github.com/en/copilot/how-tos/copilot-cli/automate-copilot-cli/run-cli-programmatically)
- 🔗 [Trigger events — schedule, push, pull_request for CI integration (gh-aw)](https://github.github.com/gh-aw/reference/triggers/)

#### 2.3.4 Configure an agent to use branch-based scope

- 🔗 [Kick off a task with Copilot agents on GitHub](https://docs.github.com/en/copilot/how-tos/copilot-on-github/use-copilot-agents/kick-off-a-task)
- 🔗 [Research, plan, and iterate on code changes](https://docs.github.com/en/copilot/how-tos/copilot-on-github/use-copilot-agents/research-plan-iterate)

#### 2.3.5 Enable an agent to perform autonomous actions, including creating branches and pull requests

- 🔗 [Allowing GitHub Copilot CLI to work autonomously (autopilot)](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/autopilot)
- 🔗 [Kick off a task with Copilot agents on GitHub](https://docs.github.com/en/copilot/how-tos/copilot-on-github/use-copilot-agents/kick-off-a-task)
- 🔗 [Managing pull requests with the /pr command](https://docs.github.com/en/copilot/how-tos/copilot-cli/use-copilot-cli/manage-pull-requests)

#### 2.3.6 Configure an agent to handle environment-specific constraints

- 🔗 [Configure the development environment (cloud agent)](https://docs.github.com/en/copilot/how-tos/copilot-on-github/customize-copilot/customize-cloud-agent/customize-the-agent-environment)
- 🔗 [Configure secrets and variables for Copilot cloud agent](https://docs.github.com/en/copilot/how-tos/copilot-on-github/customize-copilot/customize-cloud-agent/configure-secrets-and-variables)
- 🔗 [Customizing or disabling the firewall for cloud agent](https://docs.github.com/en/copilot/how-tos/copilot-on-github/customize-copilot/customize-cloud-agent/customize-the-agent-firewall)
- 🔗 [Architecture — Agent Workflow Firewall: network constraints and chroot mode (gh-aw)](https://github.github.com/gh-aw/introduction/architecture/#agent-workflow-firewall-awf)

---

### 2.4 Operate agents with safe execution paths and robust error handling

- 🔗 [Risks and mitigations for GitHub Copilot cloud agent](https://docs.github.com/en/copilot/concepts/agents/cloud-agent/risks-and-mitigations)
- 🔗 [About hooks for GitHub Copilot](https://docs.github.com/en/copilot/concepts/agents/hooks)
- 🔗 [Safe outputs — permission-isolated execution paths (gh-aw)](https://github.github.com/gh-aw/reference/safe-outputs/)
- 🔗 [Threat detection — pre-action security scanning (gh-aw)](https://github.github.com/gh-aw/reference/threat-detection/)

#### 2.4.1 Implement error handling

- 🔗 [Error handling hook (SDK)](https://docs.github.com/en/copilot/how-tos/copilot-sdk/use-hooks/error-handling)
- 🔗 [Customize agent workflows with hooks (cloud)](https://docs.github.com/en/copilot/how-tos/copilot-on-github/customize-copilot/customize-cloud-agent/use-hooks)

#### 2.4.2 Implement retries

- 🔗 [About hooks for GitHub Copilot](https://docs.github.com/en/copilot/concepts/agents/hooks)
- ⚠️ NEED_SEARCH — No dedicated page for agent retry patterns

#### 2.4.3 Implement rollbacks

- 🔗 [Canceling a Copilot CLI operation and rolling back changes](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/cancel-and-roll-back)
- 🔗 [Rolling back changes made during a Copilot CLI session](https://docs.github.com/en/copilot/how-tos/copilot-cli/use-copilot-cli/roll-back-changes)

#### 2.4.4 Implement escalation paths

- 🔗 [About hooks for GitHub Copilot](https://docs.github.com/en/copilot/concepts/agents/hooks)
- 🔗 [Customize agent workflows with hooks (cloud)](https://docs.github.com/en/copilot/how-tos/copilot-on-github/customize-copilot/customize-cloud-agent/use-hooks)
- ⚠️ NEED_SEARCH — No dedicated page for agent escalation patterns

#### 2.4.5 Implement traceability and accountability for agent actions

- 🔗 [Agentic audit log events](https://docs.github.com/en/copilot/reference/agentic-audit-log-events)
- 🔗 [Tracking GitHub Copilot's sessions](https://docs.github.com/en/copilot/how-tos/use-copilot-agents/cloud-agent/track-copilot-sessions)
- 🔗 [Review audit logs (enterprise)](https://docs.github.com/en/copilot/how-tos/administer-copilot/manage-for-enterprise/review-audit-logs)
- 🔗 [Safe outputs — agent_output.json as auditable artifact (gh-aw)](https://github.github.com/gh-aw/reference/safe-outputs/)
- 🔗 [Threat detection — detection log artifact (gh-aw)](https://github.github.com/gh-aw/reference/threat-detection/)

---

## 3. Manage Memory, State, and Execution (10–15%)

### 3.1 Implement agent memory strategies

- 🔗 [About GitHub Copilot Memory](https://docs.github.com/en/copilot/concepts/agents/copilot-memory)
- 🔗 [Using Copilot Memory](https://docs.github.com/en/copilot/how-tos/use-copilot-agents/copilot-memory)
- 🔗 [Cache memory — persistent cross-run storage in workflows (gh-aw)](https://github.github.com/gh-aw/reference/cache-memory/)

#### 3.1.1 Choose between short-term, long-term, and external memory

- 🔗 [About GitHub Copilot Memory](https://docs.github.com/en/copilot/concepts/agents/copilot-memory)
- 🔗 [Managing context in GitHub Copilot CLI](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/context-management)
- 🔗 [Cache memory vs. repo memory — 7-day cache vs. unlimited git-based storage (gh-aw)](https://github.github.com/gh-aw/reference/cache-memory/#comparison-with-repo-memory)

#### 3.1.2 Scope agent memory to task-relevant information

- 🔗 [About GitHub Copilot Memory](https://docs.github.com/en/copilot/concepts/agents/copilot-memory)
- 🔗 [Managing context in GitHub Copilot CLI](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/context-management)
- 🔗 [Content exclusion for GitHub Copilot](https://docs.github.com/en/copilot/concepts/context/content-exclusion)

#### 3.1.3 Define memory expiration, pruning, and reset rules

- 🔗 [About GitHub Copilot Memory](https://docs.github.com/en/copilot/concepts/agents/copilot-memory)
- 🔗 [Using Copilot Memory](https://docs.github.com/en/copilot/how-tos/use-copilot-agents/copilot-memory)

---

### 3.2 Persist agent state and manage context drift

- 🔗 [Managing context in GitHub Copilot CLI](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/context-management)
- 🔗 [Session persistence in the Copilot SDK](https://docs.github.com/en/copilot/how-tos/copilot-sdk/use-copilot-sdk/session-persistence)

#### 3.2.1 Capture task progress and decisions as durable artifacts

- 🔗 [Tracking GitHub Copilot's sessions](https://docs.github.com/en/copilot/how-tos/use-copilot-agents/cloud-agent/track-copilot-sessions)
- 🔗 [About GitHub Copilot CLI session data (chronicle)](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/chronicle)
- 🔗 [Session persistence in the Copilot SDK](https://docs.github.com/en/copilot/how-tos/copilot-sdk/use-copilot-sdk/session-persistence)
- 🔗 [Safe outputs — upload-artifact for durable per-run artifacts (gh-aw)](https://github.github.com/gh-aw/reference/safe-outputs/#artifact-uploads-upload-artifact)

#### 3.2.2 Resume agent work without repeating steps or diverging from prior decisions

- 🔗 [About GitHub Copilot CLI session data (chronicle)](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/chronicle)
- 🔗 [Using GitHub Copilot CLI session data](https://docs.github.com/en/copilot/how-tos/copilot-cli/use-copilot-cli/chronicle)
- 🔗 [Session persistence in the Copilot SDK](https://docs.github.com/en/copilot/how-tos/copilot-sdk/use-copilot-sdk/session-persistence)

#### 3.2.3 Detect and correct drift during extended agent execution

- 🔗 [Managing context in GitHub Copilot CLI](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/context-management)
- 🔗 [Manage and track Copilot cloud agent sessions](https://docs.github.com/en/copilot/how-tos/copilot-on-github/use-copilot-agents/manage-and-track-agents)

---

### 3.3 Ensure continuity of agent memory and state across tools and environments

- 🔗 [About GitHub Copilot Memory](https://docs.github.com/en/copilot/concepts/agents/copilot-memory)
- 🔗 [Session persistence in the Copilot SDK](https://docs.github.com/en/copilot/how-tos/copilot-sdk/use-copilot-sdk/session-persistence)

#### 3.3.1 Share agent state

- 🔗 [About GitHub Copilot Memory](https://docs.github.com/en/copilot/concepts/agents/copilot-memory)
- 🔗 [Session persistence in the Copilot SDK](https://docs.github.com/en/copilot/how-tos/copilot-sdk/use-copilot-sdk/session-persistence)
- 🔗 [About GitHub Copilot Spaces](https://docs.github.com/en/copilot/concepts/context/spaces)

#### 3.3.2 Prevent conflicting context

- 🔗 [Managing context in GitHub Copilot CLI](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/context-management)
- 🔗 [Content exclusion for GitHub Copilot](https://docs.github.com/en/copilot/concepts/context/content-exclusion)

#### 3.3.3 Prevent stale context

- 🔗 [Managing context in GitHub Copilot CLI](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/context-management)
- 🔗 [Indexing repositories for GitHub Copilot](https://docs.github.com/en/copilot/concepts/context/repository-indexing)

---

## 4. Perform Evaluation, Error Analysis, and Tuning (15–20%)

### 4.1 Define success criteria and evaluation signals for agent tasks

- 🔗 [Review output from Copilot](https://docs.github.com/en/copilot/how-tos/copilot-on-github/use-copilot-agents/review-copilot-output)
- 🔗 [Implementation planner (custom agent tutorial)](https://docs.github.com/en/copilot/tutorials/customization-library/custom-agents/implementation-planner)

#### 4.1.1 Specify expected outcomes and operational constraints for agent tasks

- 🔗 [Adding repository custom instructions](https://docs.github.com/en/copilot/how-tos/copilot-on-github/customize-copilot/add-custom-instructions/add-repository-instructions)
- 🔗 [Implementation planner (custom agent tutorial)](https://docs.github.com/en/copilot/tutorials/customization-library/custom-agents/implementation-planner)

#### 4.1.2 Identify qualitative and quantitative evaluation signals to evaluate agents

- 🔗 [GitHub Copilot usage metrics](https://docs.github.com/en/copilot/concepts/copilot-usage-metrics/copilot-metrics)
- 🔗 [Copilot usage metrics reference](https://docs.github.com/en/copilot/reference/copilot-usage-metrics/copilot-usage-metrics)

#### 4.1.3 Align evaluation criteria with development intent

- 🔗 [Review output from Copilot](https://docs.github.com/en/copilot/how-tos/copilot-on-github/use-copilot-agents/review-copilot-output)
- 🔗 [Review AI-generated code](https://docs.github.com/en/copilot/tutorials/review-ai-generated-code)

#### 4.1.4 Generate evaluation signals by using automated scanning tools

- 🔗 [Customize agent workflows with hooks (cloud)](https://docs.github.com/en/copilot/how-tos/copilot-on-github/customize-copilot/customize-cloud-agent/use-hooks)
- 🔗 [About hooks for GitHub Copilot](https://docs.github.com/en/copilot/concepts/agents/hooks)
- 🔗 [Threat detection — custom post-steps for scanning tools (gh-aw)](https://github.github.com/gh-aw/reference/threat-detection/)

---

### 4.2 Analyze agent failures and identify root causes

- 🔗 [Troubleshoot common issues](https://docs.github.com/en/copilot/how-tos/troubleshoot-copilot/troubleshoot-common-issues)
- 🔗 [Troubleshoot Copilot cloud agent](https://docs.github.com/en/copilot/how-tos/use-copilot-agents/cloud-agent/troubleshoot-cloud-agent)

#### 4.2.1 Identify failures by using logs, plans, traces, outputs, and workflow artifacts

- 🔗 [View logs](https://docs.github.com/en/copilot/how-tos/troubleshoot-copilot/view-logs)
- 🔗 [Tracking GitHub Copilot's sessions](https://docs.github.com/en/copilot/how-tos/use-copilot-agents/cloud-agent/track-copilot-sessions)
- 🔗 [Agentic audit log events](https://docs.github.com/en/copilot/reference/agentic-audit-log-events)
- 🔗 [Threat detection — detection log as failure analysis artifact (gh-aw)](https://github.github.com/gh-aw/reference/threat-detection/)

#### 4.2.2 Classify root causes, including reasoning errors, tool misuse, and context or environment issues

- 🔗 [Troubleshoot Copilot cloud agent](https://docs.github.com/en/copilot/how-tos/use-copilot-agents/cloud-agent/troubleshoot-cloud-agent)
- 🔗 [Troubleshoot common issues](https://docs.github.com/en/copilot/how-tos/troubleshoot-copilot/troubleshoot-common-issues)

---

### 4.3 Tune agent behavior based on evaluation results

- 🔗 [Customize Copilot for your project](https://docs.github.com/en/copilot/how-tos/copilot-on-github/customize-copilot/customize-copilot-overview)

#### 4.3.1 Revise instructions, workflows, or constraints

- 🔗 [Adding repository custom instructions](https://docs.github.com/en/copilot/how-tos/copilot-on-github/customize-copilot/add-custom-instructions/add-repository-instructions)
- 🔗 [Creating custom agents for Copilot cloud agent](https://docs.github.com/en/copilot/how-tos/copilot-on-github/customize-copilot/customize-cloud-agent/create-custom-agents)
- 🔗 [Adding custom instructions for Copilot CLI](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/add-custom-instructions)

#### 4.3.2 Refine memory usage

- 🔗 [About GitHub Copilot Memory](https://docs.github.com/en/copilot/concepts/agents/copilot-memory)
- 🔗 [Using Copilot Memory](https://docs.github.com/en/copilot/how-tos/use-copilot-agents/copilot-memory)

#### 4.3.3 Refine tool usage and tool access

- 🔗 [Allowing and denying tool use (CLI)](https://docs.github.com/en/copilot/how-tos/copilot-cli/use-copilot-cli/allowing-tools)
- 🔗 [Adding agent skills (cloud agent)](https://docs.github.com/en/copilot/how-tos/copilot-on-github/customize-copilot/customize-cloud-agent/add-skills)

---

## 5. Orchestrate Multi-Agent Coordination (15–20%)

### 5.1 Operate and manage multi-agent workflows

- 🔗 [Custom agents and sub-agent orchestration (SDK)](https://docs.github.com/en/copilot/how-tos/copilot-sdk/use-copilot-sdk/custom-agents)
- 🔗 [Running tasks in parallel with the /fleet command](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/fleet)
- 🔗 [Safe outputs — dispatch-workflow for triggering other agents (gh-aw)](https://github.github.com/gh-aw/reference/safe-outputs/#workflow-dispatch-dispatch-workflow)

#### 5.1.1 Apply an orchestration pattern to coordinate multiple agents

- 🔗 [Custom agents and sub-agent orchestration (SDK)](https://docs.github.com/en/copilot/how-tos/copilot-sdk/use-copilot-sdk/custom-agents)
- 🔗 [Running tasks in parallel with the /fleet command](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/fleet)
- 🔗 [Microsoft Agent Framework integration](https://docs.github.com/en/copilot/how-tos/copilot-sdk/integrations/microsoft-agent-framework)

#### 5.1.2 Configure agent isolation for parallel execution

- 🔗 [Running tasks in parallel with the /fleet command](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/fleet)
- 🔗 [Speeding up task completion with the /fleet command](https://docs.github.com/en/copilot/how-tos/copilot-cli/use-copilot-cli/speed-up-task-completion)
- 🔗 [Working with agent sessions in the Copilot app](https://docs.github.com/en/copilot/how-tos/github-copilot-app/agent-sessions)
- 🔗 [Architecture — AWF container isolation for parallel agent execution (gh-aw)](https://github.github.com/gh-aw/introduction/architecture/)

#### 5.1.3 Detect and resolve agent conflicts, including overlapping code changes, duplicated effort, and contradictory outputs

- 🔗 [Manage and track Copilot cloud agent sessions](https://docs.github.com/en/copilot/how-tos/copilot-on-github/use-copilot-agents/manage-and-track-agents)
- ⚠️ NEED_SEARCH — No dedicated page for inter-agent conflict resolution

---

### 5.2 Configure observability for multi-agent behavior by using logs, artifacts, and operational signals

- 🔗 [Tracking GitHub Copilot's sessions](https://docs.github.com/en/copilot/how-tos/use-copilot-agents/cloud-agent/track-copilot-sessions)
- 🔗 [Agentic audit log events](https://docs.github.com/en/copilot/reference/agentic-audit-log-events)

#### 5.2.1 Configure multi-agent workflows to produce artifacts suitable for review and audit

- 🔗 [Agentic audit log events](https://docs.github.com/en/copilot/reference/agentic-audit-log-events)
- 🔗 [Review audit logs (enterprise)](https://docs.github.com/en/copilot/how-tos/administer-copilot/manage-for-enterprise/review-audit-logs)
- 🔗 [Safe outputs — structured agent_output.json per-run (gh-aw)](https://github.github.com/gh-aw/reference/safe-outputs/)

#### 5.2.2 Document key decisions, handoffs, and outcomes across agents

- 🔗 [Tracking GitHub Copilot's sessions](https://docs.github.com/en/copilot/how-tos/use-copilot-agents/cloud-agent/track-copilot-sessions)
- 🔗 [About GitHub Copilot CLI session data (chronicle)](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/chronicle)

#### 5.2.3 Perform post-hoc analysis of multi-agent behavior

- 🔗 [Agentic audit log events](https://docs.github.com/en/copilot/reference/agentic-audit-log-events)
- 🔗 [Monitor agentic activity (enterprise)](https://docs.github.com/en/copilot/how-tos/administer-copilot/manage-for-enterprise/manage-agents/monitor-agentic-activity)

---

### 5.3 Detect and respond to multi-agent failures and degraded behavior

- 🔗 [Manage and track Copilot cloud agent sessions](https://docs.github.com/en/copilot/how-tos/copilot-on-github/use-copilot-agents/manage-and-track-agents)

#### 5.3.1 Identify failed, partial, or stalled agent executions

- 🔗 [Manage and track Copilot cloud agent sessions](https://docs.github.com/en/copilot/how-tos/copilot-on-github/use-copilot-agents/manage-and-track-agents)
- 🔗 [About agent management](https://docs.github.com/en/copilot/concepts/agents/cloud-agent/agent-management)
- 🔗 [Agent session filters](https://docs.github.com/en/copilot/reference/agent-session-filters)

#### 5.3.2 Respond to degraded behavior or coordination across agents

- 🔗 [Manage and track Copilot cloud agent sessions](https://docs.github.com/en/copilot/how-tos/copilot-on-github/use-copilot-agents/manage-and-track-agents)
- 🔗 [Troubleshoot Copilot cloud agent](https://docs.github.com/en/copilot/how-tos/use-copilot-agents/cloud-agent/troubleshoot-cloud-agent)

#### 5.3.3 Implement multi-agent recovery patterns, including rollback and human-in-the-loop

- 🔗 [Canceling a Copilot CLI operation and rolling back changes](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/cancel-and-roll-back)
- 🔗 [Rolling back changes made during a Copilot CLI session](https://docs.github.com/en/copilot/how-tos/copilot-cli/use-copilot-cli/roll-back-changes)
- 🔗 [About hooks for GitHub Copilot](https://docs.github.com/en/copilot/concepts/agents/hooks)

---

### 5.4 Manage the lifecycle of agents within multi-agent workflows

- 🔗 [About agent management](https://docs.github.com/en/copilot/concepts/agents/cloud-agent/agent-management)
- 🔗 [Agent management for enterprises](https://docs.github.com/en/copilot/concepts/agents/enterprise-management)

#### 5.4.1 Add agents to existing multi-agent workflows

- 🔗 [Creating custom agents for Copilot cloud agent](https://docs.github.com/en/copilot/how-tos/copilot-on-github/customize-copilot/customize-cloud-agent/create-custom-agents)
- 🔗 [Creating and using custom agents for Copilot CLI](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/create-custom-agents-for-cli)

#### 5.4.2 Update, reconfigure, or replace agents without disrupting active workflows

- 🔗 [Testing and releasing custom agents](https://docs.github.com/en/copilot/how-tos/copilot-on-github/customize-copilot/customize-cloud-agent/test-custom-agents)
- 🔗 [Prepare for custom agents (enterprise)](https://docs.github.com/en/copilot/how-tos/administer-copilot/manage-for-enterprise/manage-agents/prepare-for-custom-agents)

#### 5.4.3 Retire agents while preserving auditability and workflow continuity

- 🔗 [Agentic audit log events](https://docs.github.com/en/copilot/reference/agentic-audit-log-events)
- 🔗 [Monitor agentic activity (enterprise)](https://docs.github.com/en/copilot/how-tos/administer-copilot/manage-for-enterprise/manage-agents/monitor-agentic-activity)

---

## 6. Implement Guardrails and Accountability (10–15%)

### 6.1 Define autonomy levels

- 🔗 [Allowing GitHub Copilot CLI to work autonomously (autopilot)](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/autopilot)
- 🔗 [Build guardrails for Copilot cloud agent](https://docs.github.com/en/copilot/tutorials/cloud-agent/build-guardrails)
- 🔗 [Architecture — five security layers as autonomy bounds (gh-aw)](https://github.github.com/gh-aw/introduction/architecture/)
- 🔗 [Safe outputs — per-operation limits define action scope (gh-aw)](https://github.github.com/gh-aw/reference/safe-outputs/)

#### 6.1.1 Classify agent actions by operational, security, and compliance risk to right-size human interventions

- 🔗 [Risks and mitigations for GitHub Copilot cloud agent](https://docs.github.com/en/copilot/concepts/agents/cloud-agent/risks-and-mitigations)
- 🔗 [Allowing GitHub Copilot CLI to work autonomously (autopilot)](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/autopilot)
- 🔗 [Agent management for enterprises](https://docs.github.com/en/copilot/concepts/agents/enterprise-management)
- 🔗 [Safe outputs — output type permissions map to risk level (gh-aw)](https://github.github.com/gh-aw/reference/safe-outputs/)

#### 6.1.2 Assign autonomy levels to maximize delivery speed while remaining compliant with organizational security and Responsible AI standards

- 🔗 [Allowing GitHub Copilot CLI to work autonomously (autopilot)](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/autopilot)
- 🔗 [Copilot policies to control availability of features and models](https://docs.github.com/en/copilot/concepts/policies)
- 🔗 [Responsible use of Copilot cloud agent](https://docs.github.com/en/copilot/responsible-use/copilot-cloud-agent)

---

### 6.2 Implement guardrails and human-in-the-loop workflows

- 🔗 [Build guardrails for Copilot cloud agent](https://docs.github.com/en/copilot/tutorials/cloud-agent/build-guardrails)
- 🔗 [About hooks for GitHub Copilot](https://docs.github.com/en/copilot/concepts/agents/hooks)
- 🔗 [Architecture — built-in five-layer guardrails (gh-aw)](https://github.github.com/gh-aw/introduction/architecture/)
- 🔗 [Safe outputs — gated job pattern as HITL mechanism (gh-aw)](https://github.github.com/gh-aw/reference/safe-outputs/)
- 🔗 [Threat detection — AI-powered pre-write blocking (gh-aw)](https://github.github.com/gh-aw/reference/threat-detection/)

#### 6.2.1 Identify the subset of actions that require human judgment

- 🔗 [About hooks for GitHub Copilot](https://docs.github.com/en/copilot/concepts/agents/hooks)
- 🔗 [Build guardrails for Copilot cloud agent](https://docs.github.com/en/copilot/tutorials/cloud-agent/build-guardrails)
- 🔗 [Allowing GitHub Copilot CLI to work autonomously (autopilot)](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/autopilot)

#### 6.2.2 Block actions that violate defined security, compliance, or Responsible AI policies

- 🔗 [Copilot policies to control availability of features and models](https://docs.github.com/en/copilot/concepts/policies)
- 🔗 [Customizing or disabling the firewall for cloud agent](https://docs.github.com/en/copilot/how-tos/copilot-on-github/customize-copilot/customize-cloud-agent/customize-the-agent-firewall)
- 🔗 [Responsible use of Copilot cloud agent](https://docs.github.com/en/copilot/responsible-use/copilot-cloud-agent)
- 🔗 [Threat detection — blocks policy-violating output automatically (gh-aw)](https://github.github.com/gh-aw/reference/threat-detection/)
- 🔗 [Architecture — AWF network-level blocking of unauthorized traffic (gh-aw)](https://github.github.com/gh-aw/introduction/architecture/#agent-workflow-firewall-awf)

#### 6.2.3 Scope permissions and execution contexts to enforce least-privilege access

- 🔗 [Managing access to Copilot cloud agent](https://docs.github.com/en/copilot/concepts/agents/cloud-agent/access-management)
- 🔗 [Allowing and denying tool use (CLI)](https://docs.github.com/en/copilot/how-tos/copilot-cli/use-copilot-cli/allowing-tools)
- 🔗 [Configuring GitHub Copilot CLI](https://docs.github.com/en/copilot/how-tos/copilot-cli/set-up-copilot-cli/configure-copilot-cli)
- 🔗 [Architecture — read-only agent token with scoped write jobs (gh-aw)](https://github.github.com/gh-aw/introduction/architecture/)

#### 6.2.4 Require explicit authorization or controlled paths for irreversible or compliance-sensitive changes

- 🔗 [About hooks for GitHub Copilot](https://docs.github.com/en/copilot/concepts/agents/hooks)
- 🔗 [Customize agent workflows with hooks (cloud)](https://docs.github.com/en/copilot/how-tos/copilot-on-github/customize-copilot/customize-cloud-agent/use-hooks)
- 🔗 [Build guardrails for Copilot cloud agent](https://docs.github.com/en/copilot/tutorials/cloud-agent/build-guardrails)
- 🔗 [Safe outputs — gated write job pattern for irreversible changes (gh-aw)](https://github.github.com/gh-aw/reference/safe-outputs/)
- 🔗 [Threat detection — blocks agent output before application (gh-aw)](https://github.github.com/gh-aw/reference/threat-detection/)

#### 6.2.5 Preserve execution velocity by minimizing approvals that do not materially reduce risk

- 🔗 [Allowing GitHub Copilot CLI to work autonomously (autopilot)](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/autopilot)
- 🔗 [Build guardrails for Copilot cloud agent](https://docs.github.com/en/copilot/tutorials/cloud-agent/build-guardrails)

---

## Summary of NEED_SEARCH Items

| Domain | Reason |
|--------|--------|
| 2.4.2 Implement retries | No dedicated page for agent retry patterns in Copilot docs |
| 2.4.4 Implement escalation paths | No dedicated page for agent escalation patterns in Copilot docs |
| 5.1.3 Detect and resolve agent conflicts | No dedicated page for inter-agent conflict resolution in Copilot docs |
