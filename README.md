# GitHub CLI Aliases

A collection of useful GitHub CLI aliases with integrated testing.

## Installation

1. Clone this repository
2. Run the installation script:

```bash
./scripts/install-aliases.sh
```
## Available Aliases

### start-work

Creates a new branch and PR for starting work on a ticket.

Usage:
```bash
gh start-work <JIRA_TICKET> [ISSUE_TYPE]
```

See [start-work documentation](aliases/start-work/README.md) for more details.

## Development

### Running Tests

To run all tests:
```bash
for test_file in tests/integration/.test.sh; do
bash "$test_file"
done
```
### Adding New Aliases

1. Create a new directory under `aliases/` for your alias
2. Add your alias script as `alias.sh`
3. Add documentation in `README.md`
4. Add tests in `tests/integration/`
5. Submit a PR!