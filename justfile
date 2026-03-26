#!/usr/bin/env just -f

# -----------------------------------------------------------------------------
# Variables
# -----------------------------------------------------------------------------

# Default virtual environment directory
export VENV_DIR := ".venv"

# Default recipe executed when running `just` without arguments
default: tidy

# =============================================================================
# CI Pipeline
# =============================================================================

# Run all CI checks: linting, formatting, type checking, and testing
ci: check typecheck test
    @echo "All CI checks passed."

# =============================================================================
# Read-Only Checks (CI & Local Verification)
# =============================================================================

# Verify formatting and linting rules without modifying files
check:
    @echo "Checking Python code..."
    @uv run ruff format --check src
    @uv run ruff check src

# Run static type analysis
typecheck:
    @echo "Type checking Python code..."
    @uv run ty check src

# =============================================================================
# Local Development (File Modifying)
# =============================================================================

# Run all formatters, auto-fixers, and type checks
tidy: format lint typecheck

# Apply formatting to all code
format:
    @echo "Formatting Python code..."
    @uv run ruff format src

# Apply auto-fixes for linting issues
lint:
    @echo "Linting Python code..."
    @uv run ruff check --fix src

# =============================================================================
# Testing
# =============================================================================

# Run the full test suite
test:
    @echo "Running Python tests..."
    @uv run pytest
    @echo "All tests passed."

# =============================================================================
# Setup & Maintenance
# =============================================================================

# Bootstrap a fresh development environment from scratch
setup: clean
    @echo "Setting up development environment..."
    @echo "  Installing Python version..."
    uv python install --quiet
    @echo "  Removing old virtual environment..."
    rm -rf {{VENV_DIR}}
    @just update
    @echo "  Installing git hooks..."
    @uv run pre-commit install --hook-type pre-commit --hook-type pre-push
    @echo "Setup complete. Pre-commit hooks are active."

# Update all dependencies to their latest allowed versions and sync
update:
    @echo "Updating dependencies..."
    @echo "  Locking Python dependencies (updating uv.lock)..."
    @uv lock
    @echo "  Syncing environment..."
    @just sync

# Sync the local environment with current lock files
sync:
    @echo "Syncing Python environment with uv.lock..."
    @uv sync

# Update pre-commit hook definitions to their latest versions
update-hooks:
    @echo "Updating pre-commit hook versions..."
    @uv run pre-commit autoupdate
    @echo "Hooks updated. Review changes in '.pre-commit-config.yaml' and commit them."

# Remove all generated files, caches, and build artifacts
clean:
    @echo "Cleaning caches and build artifacts..."

    @# Python cache directories
    @rm -rf \
        .ruff_cache \
        .pytest_cache \
        .uv_cache \
        .coverage

    @# Python distribution artifacts
    @rm -rf dist

    @# Python bytecode
    @find . -type d -name "__pycache__" -exec rm -rf {} +
    @find . -type f -name "*.pyc" -delete

    @echo "Clean complete."
