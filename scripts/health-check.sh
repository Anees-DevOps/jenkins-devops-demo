#!/bin/bash

set -e

echo "=== Application Health Check ==="

echo "Hostname: $(hostname)"
echo "Date: $(date)"

echo
echo "Disk:"
df -h /

echo
echo "Memory:"
free -h

echo
echo "Health check completed successfully."
