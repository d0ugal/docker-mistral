#!/bin/bash
set -euo pipefail

id=$1
url="https://review.openstack.org/changes/?q=$id&o=DOWNLOAD_COMMANDS&o=CURRENT_REVISION"
# Because gerrit hates users...
json=$(curl -s $url | sed 's/^.\{4\}//g');
# Extract the git command
git_command=$(echo $json | jq ".[0].revisions[.[0].current_revision].fetch.\"anonymous http\".commands.Checkout" -r);
# Remove the && in the middle, we need to run it as two commands. We can't add them as a variable.
IFS='&' read -a git_command_parts <<< $git_command;

cd $(mktemp -d);
git clone https://git.openstack.org/openstack/mistral mistral;
cd mistral;
${git_command_parts[0]} && ${git_command_parts[2]};
pip install .;
