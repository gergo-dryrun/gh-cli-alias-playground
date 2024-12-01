#!/bin/bash

# Install all aliases from the aliases directory
for alias_dir in aliases/*/; do
    if [ -f "${alias_dir}alias.sh" ]; then
        source "${alias_dir}alias.sh"
        echo "Installed alias from ${alias_dir}"
    fi
done 