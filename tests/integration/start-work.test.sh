#!/bin/sh

. "tests/utils/test-helpers.sh"

test_start_work_help() {
    output=$(gh start-work --help)
    status=$?
    assert_equals 0 "$status" "Help command should exit with 0"
    first_line=$(echo "$output" | head -n1)
    assert_equals "Usage: gh start-work <JIRA_TICKET> [ISSUE_TYPE]" "$first_line" "Help message should show usage"
}

test_start_work_invalid_type() {
    output=$(gh start-work INTEGRATION_TEST-123 invalid_type 2>&1)
    status=$?
    assert_equals 1 "$status" "Invalid type should exit with 1"
    assert_equals "Error: ISSUE_TYPE must be feature, bug, maintenance, or chore" "$output" "Should show error for invalid type"
}

test_start_work_creates_branch() {
    temp_dir=$(setup_git_repo)
    
    gh start-work INTEGRATION_TEST-123 feature
    branch_name=$(git branch --show-current)
    assert_equals "feature/INTEGRATION_TEST-123" "$branch_name" "Should create correct branch name"
    
    cleanup_git_repo "$temp_dir"
}

# Run all tests
run_tests() {
    echo "Running start-work tests"
    test_start_work_help
    test_start_work_invalid_type
    # test_start_work_creates_branch
    print_test_summary
}

run_tests