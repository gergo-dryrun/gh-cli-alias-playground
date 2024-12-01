#!/bin/bash

source "tests/utils/test-helpers.sh"

test_start_work_help() {
    local output
    output=$(gh start-work --help)
    assert_equals 0 $? "Help command should exit with 0"
    assert_equals "Usage: gh start-work <JIRA_TICKET> [ISSUE_TYPE]" "$(echo "$output" | head -n1)" "Help message should show usage"
}

test_start_work_invalid_type() {
    local output
    output=$(gh start-work TICKET-123 invalid_type 2>&1)
    assert_equals 1 $? "Invalid type should exit with 1"
    assert_equals "Error: ISSUE_TYPE must be feature, bug, or maintenance" "$output" "Should show error for invalid type"
}

test_start_work_creates_branch() {
    local temp_dir=$(setup_git_repo)
    
    gh start-work TICKET-123 feature
    local branch_name=$(git branch --show-current)
    assert_equals "feature/TICKET-123" "$branch_name" "Should create correct branch name"
    
    cleanup_git_repo "$temp_dir"
}

# Run all tests
run_tests() {
    echo "Running start-work tests"
    # test_start_work_help
    # test_start_work_invalid_type
    # test_start_work_creates_branch
}

run_tests 