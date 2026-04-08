<!-- Source: https://www.mintlify.com/VineeTagarwaL-code/claude-code/reference/sdk/hooks-reference -->

# Claude Code Hooks Reference

## Overview

Hooks are shell commands, HTTP endpoints, LLM prompts, or in-process callbacks that fire at defined points in Claude's agentic loop.

These mechanisms enable injection of custom logic at specific execution points, permitting tool call interception, permission management, session lifecycle handling, and more.

---

## Configuration Architecture

### Settings File Hierarchy

| Scope   | Location                  | Priority |
|---------|---------------------------|----------|
| User    | `~/.claude/settings.json` | Low      |
| Project | `.claude/settings.json`   | Medium   |
| Local   | `.claude/settings.json`   | High     |

Higher-priority files take precedence. Importantly, all hooks across all files run; they are not overridden.

### Matcher Configuration

The `matcher` field filters hook execution based on event type:

- **Tool events** (`PreToolUse`, `PostToolUse`, `PostToolUseFailure`, `PermissionRequest`, `PermissionDenied`): Match against `tool_name`
- **Notifications**: Match against `notification_type`
- **Session events**: Match against `source` values like `startup`, `resume`, `clear`, `compact`
- **Setup**: Match against `trigger` (`init` or `maintenance`)
- **Subagent events**: Match against `agent_type`
- **Compaction**: Match against `trigger`
- **File changes**: Match against filenames using patterns
- **Other events**: Various event-specific fields

Omitting `matcher` runs the hook for all instances of that event type.

---

## Hook Types

### 1. Command-Based Hooks

```json
{
  "type": "command",
  "command": "jq '.tool_name' && my-validator",
  "timeout": 30,
  "shell": "bash",
  "async": false,
  "once": false,
  "if": "Bash(git *)",
  "statusMessage": "Validating command..."
}
```

**Key Properties:**

- **command** (required): Shell command to execute
- **timeout**: Seconds before termination (default: 60s)
- **shell**: `bash` (default) or `powershell`
- **async**: Runs in background without blocking Claude
- **asyncRewake**: Runs async but wakes model on exit code 2
- **once**: Removes hook after first execution
- **if**: Permission rule syntax for conditional execution
- **statusMessage**: Custom spinner message during execution

**Environment Variables:**
- `CLAUDE_ENV_FILE`: Set for `CwdChanged` and `FileChanged` hooks; write `export KEY=value` lines to inject variables into subsequent Bash commands

**Exit Code Behavior:**

| Code | Behavior |
|------|----------|
| 0    | Output hidden; JSON applied if valid |
| 2    | Stderr shown to Claude; tool blocked |
| Other| Stderr shown to user only; tool continues |

### 2. Prompt-Based Hooks (LLM Evaluation)

```json
{
  "type": "prompt",
  "prompt": "Check whether this bash command is safe: $ARGUMENTS",
  "model": "claude-haiku-4-5",
  "timeout": 30
}
```

- **prompt** (required): Message sent to model; use `$ARGUMENTS` for hook input JSON
- **model**: Target LLM (defaults to fast small model)
- Model response treated as hook output

### 3. Agent-Based Hooks (Agentic Verification)

```json
{
  "type": "agent",
  "prompt": "Verify that unit tests ran and passed.",
  "model": "claude-haiku-4-5",
  "timeout": 120
}
```

Runs a short agentic loop capable of tool invocation for verification tasks, particularly useful for `PostToolUse` scenarios requiring file inspection or command execution.

### 4. HTTP Hooks

```json
{
  "type": "http",
  "url": "https://my-server.example.com/hook",
  "headers": {
    "Authorization": "Bearer $MY_TOKEN"
  },
  "allowedEnvVars": ["MY_TOKEN"],
  "timeout": 10
}
```

**Properties:**
- **url** (required): POST endpoint for hook input JSON
- **headers**: Custom request headers with optional environment variable interpolation
- **allowedEnvVars**: Permitted environment variables for header value substitution
- Only listed variables are interpolated using `$VAR_NAME` syntax

---

## Universal Hook Input Schema

Every hook receives a JSON object containing:

```json
{
  "hook_event_name": "string - Event identifier",
  "session_id": "string - Current session ID",
  "transcript_path": "string - Absolute path to JSONL transcript",
  "cwd": "string - Current working directory",
  "permission_mode": "default|acceptEdits|bypassPermissions|plan|dontAsk",
  "agent_id": "string - Subagent ID (when applicable)",
  "agent_type": "string - Agent type name (when applicable)"
}
```

---

## Sync Hook Output Schema

Blocking hooks write JSON to stdout:

```json
{
  "continue": true,
  "suppressOutput": false,
  "decision": "approve|block",
  "reason": "Human-readable explanation",
  "systemMessage": "Text injected into Claude context",
  "hookSpecificOutput": {
    "hookEventName": "EventName",
    "additionalContext": "Event-specific context"
  }
}
```

**Core Fields:**
- **continue**: `false` stops current turn immediately
- **suppressOutput**: `true` hides stdout from transcript mode
- **decision**: Explicit approval/denial (for permission-related events)
- **reason**: Explanation shown when blocking actions
- **systemMessage**: Injected as system turn in Claude's context
- **hookSpecificOutput**: Event-specific fields (see below)

---

## Hook Events Reference

### PreToolUse

**Timing:** Before every tool invocation

**Input Fields:**
- `tool_name`: Identifier of tool about to execute
- `tool_input`: Raw tool input object from Claude
- `tool_use_id`: Unique invocation identifier

**hookSpecificOutput Fields:**
- `permissionDecision`: Override with `allow|deny|ask`
- `permissionDecisionReason`: Reason string for deny/ask
- `updatedInput`: Replacement tool input object
- `additionalContext`: Injected into Claude's context

**Exit Codes:**

| Code | Effect |
|------|--------|
| 0    | Output hidden; JSON applied |
| 2    | Stderr shown; tool blocked |
| Other| Stderr shown to user; continues |

---

### PostToolUse

**Timing:** After successful tool completion

**Input Fields:**
- `tool_name`: Tool that executed
- `tool_input`: Input passed to tool
- `tool_response`: Tool output
- `tool_use_id`: Invocation identifier

**hookSpecificOutput Fields:**
- `additionalContext`: Context injected after tool result
- `updatedMCPToolOutput`: Replacement output (MCP tools only)

**Exit Codes:**

| Code | Effect |
|------|--------|
| 0    | Stdout shown in transcript mode |
| 2    | Stderr shown to Claude as system message |
| Other| Stderr shown to user |

---

### PostToolUseFailure

**Timing:** When tool ends in error or interruption

**Input Fields:**
- `tool_name`: Failed tool name
- `tool_input`: Input passed to tool
- `tool_use_id`: Invocation identifier
- `error`: Error message from tool
- `is_interrupt`: Boolean indicating interrupt-caused failure

**Behavior:** Hook output and exit codes logged but do not affect failed tool result.

---

### PermissionRequest

**Timing:** When permission dialog would appear

**Input Fields:**
- `tool_name`: Tool requesting permission
- `tool_input`: Input tool would receive if approved
- `permission_suggestions`: Suggested allow/deny rules

**Exit Codes:**

| Code | Effect |
|------|--------|
| 0    | Hook decision applied if present; otherwise shows dialog |
| Other| Stderr shown; falls through to normal dialog |

**hookSpecificOutput.decision Structure:**

**Allow Decision:**
```json
{
  "behavior": "allow",
  "updatedInput": {},
  "updatedPermissions": []
}
```

**Deny Decision:**
```json
{
  "behavior": "deny",
  "message": "Blocked by security policy.",
  "interrupt": false
}
```

When `interrupt` is `true`, current turn aborts after denial.

---

### PermissionDenied

**Timing:** After permission denial occurs

**Input Fields:**
- `tool_name`: Denied tool
- `tool_input`: Denied input
- `tool_use_id`: Invocation identifier
- `reason`: Denial reason string

**hookSpecificOutput Fields:**
- `retry`: When `true`, Claude may attempt denied action again

---

### Stop

**Timing:** Just before Claude concludes current turn response

**Input Fields:**
- `stop_hook_active`: Boolean preventing infinite loops
- `last_assistant_message`: Text content of final assistant message

**Exit Codes:**

| Code | Effect |
|------|--------|
| 0    | Output hidden |
| 2    | Stderr injected as system message; Claude continues |
| Other| Stderr shown to user; stops |

**Use case:** Use exit code 2 from a Stop hook to check Claude's output and keep the conversation going if a condition is unmet -- for example, if tests are still failing.

---

### StopFailure

**Timing:** When turn ends due to API error

**Input Fields:**
- `error`: Category (`authentication_failed|billing_error|rate_limit|invalid_request|server_error|unknown|max_output_tokens`)
- `error_details`: Detailed error message
- `last_assistant_message`: Final message produced, if any

**Behavior:** Fire-and-forget; output and exit codes ignored.

---

### SubagentStart

**Timing:** When Claude spawns subagent via Agent tool

**Input Fields:**
- `agent_id`: Unique subagent instance ID
- `agent_type`: Agent type name

**Exit Codes:**

| Code | Effect |
|------|--------|
| 0    | Stdout shown to subagent as context |
| Other| Stderr shown to user |

**hookSpecificOutput Fields:**
- `additionalContext`: Injected into subagent conversation start

---

### SubagentStop

**Timing:** Just before subagent concludes response

**Input Fields:**
- `agent_id`: Subagent instance ID
- `agent_type`: Agent type name
- `agent_transcript_path`: Path to subagent JSONL transcript
- `stop_hook_active`: Whether SubagentStop hook already running
- `last_assistant_message`: Subagent's final message

**Exit Codes:**

| Code | Effect |
|------|--------|
| 0    | Output hidden |
| 2    | Stderr shown to subagent; subagent continues |
| Other| Stderr shown to user; stops |

---

### SessionStart

**Timing:** When session begins (startup, resume, clear, or post-compaction)

**Input Fields:**
- `source`: Trigger type (`startup|resume|clear|compact`)
- `model`: Active model for session

**Exit Codes:**

| Code | Effect |
|------|--------|
| 0    | Stdout shown to Claude as initial context |
| Other| Stderr shown to user |

**hookSpecificOutput Fields:**
- `additionalContext`: Injected into system prompt
- `initialUserMessage`: Auto-submitted as first user message
- `watchPaths`: Array of absolute paths to register with FileChanged watcher

---

### SessionEnd

**Timing:** When session is about to terminate

**Input Fields:**
- `reason`: Termination cause (`clear|resume|logout|prompt_input_exit|other|bypass_permissions_disabled`)

**Exit Codes:**
- Code 0: Completes successfully
- Other: Stderr shown to user

---

### Setup

**Timing:** During repository initialization and maintenance

**Input Fields:**
- `trigger`: What fired setup (`init|maintenance`)

**Exit Codes:**

| Code | Effect |
|------|--------|
| 0    | Stdout shown to Claude |
| Other| Stderr shown to user; blocking errors ignored |

**hookSpecificOutput Fields:**
- `additionalContext`: Provided to Claude during setup phase

---

### PreCompact

**Timing:** Before context compaction begins

**Input Fields:**
- `trigger`: Compaction source (`manual|auto`)
- `custom_instructions`: Existing compaction instructions (if any)

**Exit Codes:**

| Code | Effect |
|------|--------|
| 0    | Stdout appended as custom compaction instructions |
| 2    | Compaction blocked |
| Other| Stderr shown; continues |

---

### PostCompact

**Timing:** After compaction completes

**Input Fields:**
- `trigger`: How compaction was triggered (`manual|auto`)
- `compact_summary`: Generated summary text

**Exit Codes:**
- Code 0: Stdout shown to user
- Other: Stderr shown to user

---

### UserPromptSubmit

**Timing:** When user submits prompt before Claude processes it

**Input Fields:**
- `prompt`: Raw prompt text submitted

**Exit Codes:**

| Code | Effect |
|------|--------|
| 0    | Stdout shown to Claude as additional context |
| 2    | Processing blocked; prompt erased; stderr shown |
| Other| Stderr shown to user |

**hookSpecificOutput Fields:**
- `additionalContext`: Appended to Claude's prompt view

---

### Notification

**Timing:** When Claude Code sends internal notification

**Input Fields:**
- `message`: Notification message text
- `title`: Notification title
- `notification_type`: Category (`permission_prompt|idle_prompt|auth_success|elicitation_dialog|elicitation_complete|elicitation_response`)

**Exit Codes:**
- Code 0: No output
- Other: Stderr shown to user

---

### Elicitation

**Timing:** When MCP server requests user input

**Input Fields:**
- `mcp_server_name`: MCP server name
- `message`: Prompt message from server
- `mode`: Input mode (`form|url`)
- `elicitation_id`: Request identifier
- `requested_schema`: JSON schema for expected input

**Exit Codes:**

| Code | Effect |
|------|--------|
| 0    | Use hook response if provided; otherwise show dialog |
| 2    | Deny elicitation |
| Other| Stderr shown to user |

**hookSpecificOutput Fields:**
- `action`: Response mode (`accept|decline|cancel`)
- `content`: Form data for accept action

---

### ElicitationResult

**Timing:** After user responds to MCP elicitation

**Input Fields:**
- `mcp_server_name`: MCP server name
- `elicitation_id`: Request identifier
- `action`: User response (`accept|decline|cancel`)
- `content`: Submitted form data if accepted

**hookSpecificOutput Fields:**
- `action`: Override user response
- `content`: Override submitted content

---

### ConfigChange

**Timing:** When settings files change during session

**Input Fields:**
- `source`: Changed settings type (`user_settings|project_settings|local_settings|policy_settings|skills`)
- `file_path`: Absolute path to changed file

**Exit Codes:**

| Code | Effect |
|------|--------|
| 0    | Allow change to be applied |
| 2    | Block change from being applied |
| Other| Stderr shown to user |

---

### InstructionsLoaded

**Timing:** When CLAUDE.md or instruction rule file loads (observability-only)

**Input Fields:**
- `file_path`: Loaded file path
- `memory_type`: Scope (`User|Project|Local|Managed`)
- `load_reason`: Why loaded (`session_start|nested_traversal|path_glob_match|include|compact`)
- `globs`: Matched `paths:` patterns (if applicable)
- `trigger_file_path`: File Claude accessed causing load
- `parent_file_path`: File that `@include`d this one

**Behavior:** Blocking unsupported; exit 0 completes normally; other codes show stderr to user.

---

### WorktreeCreate

**Timing:** When isolated worktree must be created

**Input Fields:**
- `name`: Suggested slug for worktree directory

**Behavior:** Write absolute worktree path to stdout; exit 0 for success; other codes signal failure.

---

### WorktreeRemove

**Timing:** When worktree task completes and cleanup required

**Input Fields:**
- `worktree_path`: Absolute path to remove

**Behavior:** Exit 0 means success; other codes show stderr.

---

### CwdChanged

**Timing:** After working directory changes

**Input Fields:**
- `old_cwd`: Previous directory
- `new_cwd`: New directory

**hookSpecificOutput Fields:**
- `watchPaths`: Paths to add to FileChanged watcher

**Special:** `CLAUDE_ENV_FILE` environment variable set; write `export KEY=value` lines for subsequent Bash tool environment injection.

---

### FileChanged

**Timing:** When watched file modified, added, or removed

**Input Fields:**
- `file_path`: Absolute changed file path
- `event`: Filesystem event type (`change|add|unlink`)

**hookSpecificOutput Fields:**
- `watchPaths`: Update watch list with absolute paths

**Special:** `CLAUDE_ENV_FILE` environment variable set.

---

## Asynchronous Hook Pattern

For background hook execution without delaying Claude:

```json
{
  "async": true,
  "asyncTimeout": 30
}
```

**Fields:**
- **async** (required): Literal `true` value
- **asyncTimeout**: Maximum runtime in seconds before cancellation

**Limitation:** Async hooks cannot block tool execution or inject context. Use them for side effects like notifications, logging, or metrics that must not slow down the agentic loop.

---

## Configuration Example

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "echo 'About to run bash command' >&2"
          }
        ]
      }
    ],
    "PostToolUse": [
      {
        "matcher": "Write",
        "hooks": [
          {
            "type": "command",
            "command": "/usr/local/bin/lint-changed-file '$TOOL_INPUT'"
          }
        ]
      }
    ],
    "Stop": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "notify-send 'Claude finished'"
          }
        ]
      }
    ]
  }
}
```

---

## Key Patterns

1. **Permission Control:** PreToolUse, PermissionRequest, and PermissionDenied hooks manage tool access
2. **Output Validation:** PostToolUse hooks verify tool execution outcomes
3. **Lifecycle Management:** SessionStart, Stop, and SessionEnd hooks control session boundaries
4. **File Monitoring:** CwdChanged and FileChanged hooks track filesystem state
5. **Context Injection:** Multiple events permit system message and context injection
6. **Async Operations:** Background tasks via async acknowledgment pattern without blocking Claude
