#!/bin/bash --login
# The --login ensures the bash configuration is loaded,
# enabling Conda.

# Enable strict mode.
set -euo pipefail
# ... Run whatever commands ...

# Temporarily disable strict mode and activate conda:
set +euo pipefail
source activate /opt/conda/env/this_env

# Re-enable strict mode:
set -euo pipefail

# Run external command
"$@"