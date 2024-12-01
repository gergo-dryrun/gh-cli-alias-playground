#!/bin/sh

echo "=== Start Work Test Debug Info ==="
echo "Current directory: $(pwd)"
echo "List of files in current directory:"
ls -la
echo "=================================="

echo "Loading test helpers..."
if ! . "./tests/utils/test-helpers.sh"; then
    echo "Failed to load test helpers"
    exit 1
fi
echo "Test helpers loaded successfully"

test_start_work_help() {
    echo "\nTesting help command..."
    echo "Running: gh start-work --help"
    output=$(gh start-work --help)
    status=$?
    echo "Command output: '$output'"
    echo "Exit status: $status"
    
    assert_equals 0 "$status" "Help command should exit with 0"
    first_line=$(echo "$output" | head -n1)
    assert_equals "Usage: gh start-work <JIRA_TICKET> [ISSUE_TYPE]" "$first_line" "Help message should show usage"
}

test_start_work_invalid_type() {
    echo "\nTesting invalid type..."
    echo "Running: gh start-work INTEGRATION_TEST-123 invalid_type"
    output=$(gh start-work INTEGRATION_TEST-123 invalid_type 2>&1)
    status=$?
    echo "Command output: '$output'"
    echo "Exit status: $status"
    
    assert_equals 1 "$status" "Invalid type should exit with 1"
    assert_equals "Error: ISSUE_TYPE must be feature, bug, maintenance, or chore" "$output" "Should show error for invalid type"
}

test_start_work_creates_branch() {
    echo "\nTesting branch creation..."
    temp_dir=$(setup_git_repo)
    echo "Test repository created at: $temp_dir"
    
    echo "Running: gh start-work INTEGRATION_TEST-123 feature"
    gh start-work INTEGRATION_TEST-123 feature
    branch_name=$(git branch --show-current)
    echo "Current branch: $branch_name"
    
    assert_equals "feature/INTEGRATION_TEST-123" "$branch_name" "Should create correct branch name"
    
    cleanup_git_repo "$temp_dir"
}

# Run all tests
run_tests() {
    echo "\n=== Running start-work tests ==="
    echo "Verifying gh CLI installation..."
    if ! command -v gh >/dev/null 2>&1; then
        echo "Error: GitHub CLI (gh) is not installed"
        exit 1
    fi
    echo "gh CLI version: $(gh --version)"
    
    echo "\nVerifying git installation..."
    if ! command -v git >/dev/null 2>&1; then
        echo "Error: git is not installed"
        exit 1
    fi
    echo "git version: $(git --version)"
    
    test_start_work_help
    test_start_work_invalid_type
    # test_start_work_creates_branch
    print_test_summary
}

run_tests