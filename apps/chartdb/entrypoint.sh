#!/usr/bin/env bash

# Check for API key in Docker secrets first, then fallback to environment variable
API_KEY=""
if [[ -f "/run/secrets/openai_api_key" ]]; then
    API_KEY=$(cat /run/secrets/openai_api_key)
elif [[ -n "${OPENAI_API_KEY}" ]]; then
    # Fallback to environment variable with warning
    echo "WARNING: Using OPENAI_API_KEY from environment variable is less secure. Consider using Docker secrets instead."
    API_KEY="${OPENAI_API_KEY}"
fi

# Replace the placeholder in the built files if API key is provided
if [[ -n "${API_KEY}" ]]; then
    find /app/public -type f -name "*.js" -exec sed -i "s/OPENAI_API_KEY_PLACEHOLDER/${API_KEY}/g" {} +
fi

# Start Python HTTP server
exec python3 -m http.server 8080 --directory /app/public
