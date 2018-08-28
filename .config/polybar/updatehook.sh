#!/bin/env bash

# general script to update polybar hooks after x interval

echo "running $HOOK_NAME hook watcher.."
while sleep "$UPDATE_INTERVAL"; do
	polybar-msg hook "$HOOK_NAME" "$HOOK_INDEX"
done
