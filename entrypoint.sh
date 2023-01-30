#!/bin/bash

# Enable strict mode.
set -euo pipefail
# ... Run whatever commands ...

# Temporarily disable strict mode and activate conda:
set +euo pipefail
source activate /opt/conda/envs/this_env

# Re-enable strict mode:
set -euo pipefail

# Run external command
"$@"