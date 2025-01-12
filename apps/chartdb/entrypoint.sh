#!/usr/bin/env bash

# Replace the OpenAI API key in the built files if provided
if [[ -n "${OPENAI_API_KEY}" ]]; then
    find /app/public -type f -name "*.js" -exec sed -i "s/VITE_OPENAI_API_KEY/${OPENAI_API_KEY}/g" {} +
fi

# Start Python HTTP server
exec python3 -m http.server 8080 --directory /app/public
