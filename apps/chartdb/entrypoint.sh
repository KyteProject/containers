#!/usr/bin/env bash

# Replace the OpenAI API key in the built files
find /app/public -type f -name "*.js" -exec sed -i "s/VITE_OPENAI_API_KEY/${OPENAI_API_KEY}/g" {} +

exec busybox httpd -f -p 8080 -h /app/public
