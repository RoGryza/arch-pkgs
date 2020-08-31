#!/bin/bash
set -euo pipefail

cd out && \
hub release edit 0.0.1-1 \
    -a rogryza.db -a *.tar.xz \
    --message 0.0.1-1