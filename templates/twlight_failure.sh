#!/usr/bin/env bash

if [ -z "$@" ]; then
    exit 1;
fi

failed_cmd = "$@"

# Report failed command via email.
echo '${failed_cmd} failed. Please check the logs.' | mail -s 'task failed for $(hostname -f)' <%= @error_mailto %>
