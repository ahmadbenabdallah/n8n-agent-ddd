#!/usr/bin/env bash
set -euo pipefail

echo "Workflow drift check"
echo "Source of truth: Git"
echo "Compare normalized workflow definitions, versions, activation state and credential references."
echo "Critical drift must block promotion and create an incident."
