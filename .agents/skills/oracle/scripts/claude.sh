#!/bin/sh

exec claude --print --safe-mode --no-session-persistence \
	--model "$1" --permission-mode auto --output-format stream-json --verbose
