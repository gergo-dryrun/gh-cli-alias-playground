#!/bin/sh

# Initialize counters
TESTS_RUN=0
TESTS_FAILED=0

# Assert equals with better error messages
assert_equals() {
    TESTS_RUN=$((TESTS_RUN + 1))
    expected="$1"
    actual="$2"
    message="$3"
    
    if [ "$expected" != "$actual" ]; then
        TESTS_FAILED=$((TESTS_FAILED + 1))
        echo "✗ $message"
        echo "  Expected: $expected"
        echo "  Actual:   $actual"
        return 1
    else
        echo "✓ $message"
        return 0
    fi
}

# Setup a temporary git repository for testing
setup_git_repo() {
    temp_dir=$(mktemp -d)
    cd "$temp_dir" || exit 1
    git init
    git config --local user.email "test@example.com"
    git config --local user.name "Test User"
    touch README.md
    git add README.md
    git commit -m "Initial commit"
    echo "$temp_dir"
}

# Cleanup temporary git repository
cleanup_git_repo() {
    local temp_dir="$1"
    cd "$OLDPWD" || exit 1
    rm -rf "$temp_dir"
}

# Print test summary
print_test_summary() {
    echo "Tests completed: $TESTS_RUN"
    echo "Tests failed: $TESTS_FAILED"
    if [ "$TESTS_FAILED" -gt 0 ]; then
        return 1
    fi
    return 0
} 