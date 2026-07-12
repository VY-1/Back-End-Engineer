#!/usr/bin/env bash
# Publishes the iOS Developments monorepo to https://github.com/VY-1/iOS-Developments
# Prerequisite: create an empty public repo named "iOS-Developments" under VY-1 on GitHub.
set -euo pipefail

REPO_URL="${1:-https://github.com/VY-1/iOS-Developments.git}"
SOURCE_DIR="$(cd "$(dirname "$0")/.." && pwd)"
WORKDIR="$(mktemp -d)"
BRANCH="ios-developments-export"

cleanup() { rm -rf "$WORKDIR"; }
trap cleanup EXIT

echo "→ Splitting iOS Developments history..."
git -C "$SOURCE_DIR" subtree split --prefix="iOS Developments" -b "$BRANCH"

echo "→ Preparing iOS-Developments repository..."
git init -b main "$WORKDIR/repo"
git -C "$WORKDIR/repo" pull "$SOURCE_DIR" "$BRANCH"
git -C "$WORKDIR/repo" remote add origin "$REPO_URL"

echo "→ Pushing to $REPO_URL ..."
git -C "$WORKDIR/repo" push -u origin main

git -C "$SOURCE_DIR" branch -D "$BRANCH" 2>/dev/null || true

echo "✓ Published to $REPO_URL"
echo "  Spatial3DConverter: $REPO_URL/tree/main/Spatial3DConverter"
