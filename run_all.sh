#!/usr/bin/env bash
set -e

##############################################################################
#
# A script to run static analysis and all tests - will exit if any check fails
#
##############################################################################

# Assume this script is in the root directory
PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"

source "$PROJECT_DIR/scripts/include.bash"

echo_info "\nRunning Static Analysis"
./run_static_analysis.sh

echo_info "\nRunning Unit Tests"
./run_unit_tests.sh -c

echo_info "\nRunning Audit"
./run_audit.sh

echo_success "All checks/tests successful"
