#!/bin/sh

# Initialize counters
TESTS_RUN=0
TESTS_FAILED=0

# Debug info
echo "=== Test Helper Debug Info ==="
echo "Shell: $SHELL"
echo "PWD: $(pwd)"
echo "PATH: $PATH"
echo "Shell version:"
sh --version 2>&1 || echo "sh version not available"
echo "=========================="

# Error handling
handle_error() {
    echo "ERROR: $1"
    echo "Command: $2"
    echo "Exit status: $3"
    echo "Output: $4"
    echo "stderr: $5"
}

# Assert equals with better error messages
assert_equals() {
    TESTS_RUN=$((TESTS_RUN + 1))
    expected="$1"
    actual="$2"
    message="$3"
    
    echo "--- Testing: $message ---"
    echo "Expected: '$expected'"
    echo "Actual: '$actual'"
    
    if [ "$expected" != "$actual" ]; then
        TESTS_FAILED=$((TESTS_FAILED + 1))
        echo "✗ FAILED: $message"
        echo "  Expected: '$expected'"
        echo "  Actual:   '$actual'"
        return 1
    else
        echo "✓ PASSED: $message"
        return 0
    fi
}

# Run command and capture both stdout and stderr
run_command() {
    # Create temporary files for output
    stdout_file=$(mktemp)
    stderr_file=$(mktemp)
    
    # Run command and capture output
    if "$@" > "$stdout_file" 2> "$stderr_file"; then
        status=0
    else
        status=$?
    fi
    
    # Read output
    stdout=$(cat "$stdout_file")
    stderr=$(cat "$stderr_file")
    
    # Debug output
    echo "=== Command Debug ===" >&2
    echo "Command: $*" >&2
    echo "Exit status: $status" >&2
    echo "stderr: $stderr" >&2
    echo "===================" >&2
    
    # Cleanup
    rm -f "$stdout_file" "$stderr_file"
    
    # Output just stdout for capture
    echo "$stdout"
    return $status
}

# Setup a temporary git repository for testing
setup_git_repo() {
    echo "Setting up test git repository..."
    temp_dir=$(mktemp -d)
    echo "Created temp dir: $temp_dir"
    
    if ! cd "$temp_dir"; then
        echo "Failed to cd into $temp_dir"
        exit 1
    fi
    
    echo "Initializing git repository..."
    if ! run_command git init; then
        echo "Failed to initialize git repository"
        exit 1
    fi
    
    echo "Configuring git..."
    git config --local user.email "test@example.com"
    git config --local user.name "Test User"
    
    echo "Creating initial commit..."
    touch README.md
    git add README.md
    git commit -m "Initial commit"
    
    echo "Git repo setup complete in $temp_dir"
    echo "$temp_dir"
}

# Cleanup temporary git repository
cleanup_git_repo() {
    temp_dir="$1"
    echo "Cleaning up test repository..."
    echo "Returning to original directory: $OLDPWD"
    if ! cd "$OLDPWD"; then
        echo "Failed to return to original directory"
        exit 1
    fi
    echo "Removing temporary directory: $temp_dir"
    rm -rf "$temp_dir"
}

# Print test summary
print_test_summary() {
    echo ""
    echo "=== Test Summary ==="
    echo "Tests completed: $TESTS_RUN"
    echo "Tests failed: $TESTS_FAILED"
    echo "=================="
    if [ "$TESTS_FAILED" -gt 0 ]; then
        return 1
    fi
    return 0
} 