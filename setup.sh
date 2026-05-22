#!/bin/bash
# =============================================================
# Phase 1 Setup Script — Sigma Detection Pipeline
# Run this once from inside your project folder
# =============================================================

set -e

echo ""
echo "================================================"
echo "  Sigma Detection Pipeline — Phase 1 Setup"
echo "================================================"
echo ""

# Step 1: Create directory structure
echo "[1/4] Creating directory structure..."
mkdir -p .github/workflows
mkdir -p rules
mkdir -p output/splunk
mkdir -p output/sentinel
mkdir -p docs/rules
mkdir -p screenshots
mkdir -p tests

# Create placeholder files so git tracks the empty folders
touch output/splunk/.gitkeep
touch output/sentinel/.gitkeep
touch screenshots/.gitkeep

echo "      ✓ Directory structure created"

# Step 2: Install sigma-cli and backends
echo ""
echo "[2/4] Installing sigma-cli and platform backends..."
pip install sigma-cli pysigma-backend-splunk pysigma-backend-kusto --quiet
echo "      ✓ sigma-cli installed"
echo "      ✓ Splunk backend installed"
echo "      ✓ Kusto (KQL/Sentinel) backend installed"

# Step 3: Verify sigma-cli works
echo ""
echo "[3/4] Verifying sigma-cli..."
sigma version
sigma list backends | grep -E "splunk|kusto" && echo "      ✓ Backends confirmed"

# Step 4: Test convert the first rule
echo ""
echo "[4/4] Testing conversion of T1059.001 rule..."
if [ -f "rules/T1059.001-powershell-encoded.yml" ]; then
    sigma convert -t splunk -p splunk_windows rules/T1059.001-powershell-encoded.yml > output/splunk/T1059.001-powershell-encoded.spl
    sigma convert -t kusto -p microsoft_xdr rules/T1059.001-powershell-encoded.yml > output/sentinel/T1059.001-powershell-encoded.kql
    echo "      ✓ Rule converted to SPL and KQL"
    echo ""
    echo "  --- SPL Output ---"
    cat output/splunk/T1059.001-powershell-encoded.spl
    echo ""
    echo "  --- KQL Output ---"
    cat output/sentinel/T1059.001-powershell-encoded.kql
else
    echo "      ⚠ Rule file not found — copy rules/ folder first, then re-run this step manually:"
    echo "        sigma convert -t splunk -p splunk_windows rules/T1059.001-powershell-encoded.yml"
fi

echo ""
echo "================================================"
echo "  Phase 1 setup complete."
echo "  Next step: git init, create GitHub repo,"
echo "  push — and watch Actions run."
echo "================================================"
echo ""
