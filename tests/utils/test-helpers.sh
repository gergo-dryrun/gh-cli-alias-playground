#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Test assertion functions
assert_equals() {
    local expected="$1"
    local actual="$2"
    local message="$3"
    
    if [ "$expected" = "$actual" ]; then
        echo -e "${GREEN}✓ $message${NC}"
        return 0
    else
        echo -e "${RED}✗ $message${NC}"
        echo "  Expected: $expected"
        echo "  Actual:   $actual"
        return 1
    fi
}

setup_git_repo() {
    local temp_dir=$(mktemp -d)
    cd "$temp_dir"
    git init
    git config --global user.email "test@example.com"
    git config --global user.name "Test User"
    git remote add origin "https://github.com/username/repo.git"
    echo "# Test Repo" > README.md
    git add README.md
    git commit -m "Initial commit"
    echo "$temp_dir"
}

cleanup_git_repo() {
    local temp_dir="$1"
    rm -rf "$temp_dir"
} 