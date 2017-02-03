#!/bin/bash

cat <<EOF > ~/.gem/credentials
---
:rubygems_api_key: $RUBYGEMS_API_KEY
EOF