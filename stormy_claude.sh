#!/bin/sh
#copied from  Set AWS environment variables
export AWS_ACCESS_KEY_ID="YOUR_AWS_ACCESS_KEY_ID"
export AWS_SECRET_ACCESS_KEY="YOUR_AWS_SECRET_ACCESS_KEY"
export AWS_SESSION_TOKEN="YOUR_AWS_SESSION_TOKEN"

#claude setup
export CLAUDE_CODE_USE_BEDROCK=1
export AWS_REGION=us-west-2

# Configure all Claude model tiers for dynamic switching with /model.
# Dynamic switching works only if you use one of these commands:
#   /model opus
#   /model sonnet
#   /model haiku
#   /model without parameters calling menu that does not allow to change bedrock models
export ANTHROPIC_DEFAULT_OPUS_MODEL="us.anthropic.claude-opus-4-6-v1"
export ANTHROPIC_DEFAULT_SONNET_MODEL="us.anthropic.claude-sonnet-4-5-20250929-v1:0"
export ANTHROPIC_DEFAULT_HAIKU_MODEL="us.anthropic.claude-haiku-4-5-20251001-v1:0"

# Set starting model to Opus
export ANTHROPIC_MODEL="opus"

# Optional: Configure subagent model (used by background agents)
export CLAUDE_CODE_SUBAGENT_MODEL="us.anthropic.claude-haiku-4-5-20251001-v1:0"

# this is to fix an error when connecting claude to bedrock
# see https://github.com/musistudio/claude-code-router/issues/1161
export CLAUDE_CODE_ATTRIBUTION_HEADER=0


# run claude.
# 
# if you add "$@", it will pass the CLI params of stormy_claude.sh 
# to claude, e.g. stormy_claude.sh -p "hi" returns a simple response instead of opening the CLI

claude "$@"
