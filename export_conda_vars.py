#!/usr/bin/env python3
import os
import json
for k, v in os.environ.items():
    print(f"set -gx {k} {json.dumps(v)}")
