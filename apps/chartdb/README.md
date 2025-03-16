# ChartDB Container

This container runs [ChartDB](https://github.com/chartdb/chartdb), a web-based application that requires an OpenAI API key.

## Security Update

This container has been updated to use Docker secrets for handling sensitive information like the OpenAI API key, rather than environment variables, which is more secure.

## Usage

### Using Docker Secrets (Recommended)

```bash
# Create a file containing your OpenAI API key
echo "your-openai-api-key" > openai_api_key.txt

# Run with Docker
docker run -d \
  --name chartdb \
  -p 8080:8080 \
  -v $(pwd)/openai_api_key.txt:/run/secrets/openai_api_key:ro \
  -v /path/to/config:/config \
  your-registry/chartdb:latest
```

### Using Docker Compose with Secrets

```yaml
version: '3.8'

services:
  chartdb:
    image: your-registry/chartdb:latest
    ports:
      - "8080:8080"
    volumes:
      - /path/to/config:/config
    secrets:
      - openai_api_key

secrets:
  openai_api_key:
    file: ./openai_api_key.txt
```

### Kubernetes Deployment with Secrets

When deploying to Kubernetes, you can use a Secret mounted as a file:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: openai-api-key
type: Opaque
stringData:
  openai_api_key: "your-openai-api-key"
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: chartdb
spec:
  template:
    spec:
      containers:
      - name: chartdb
        image: your-registry/chartdb:latest
        volumeMounts:
        - name: openai-api-key
          mountPath: /run/secrets/openai_api_key
          subPath: openai_api_key
          readOnly: true
      volumes:
      - name: openai-api-key
        secret:
          secretName: openai-api-key
```

### Fallback to Environment Variables

While not recommended for production, you can still use environment variables as a fallback:

```bash
docker run -d \
  --name chartdb \
  -p 8080:8080 \
  -e OPENAI_API_KEY=your-openai-api-key \
  -v /path/to/config:/config \
  your-registry/chartdb:latest
```

## Building the Image

When building the image, you no longer need to pass the API key:

```bash
docker build -t chartdb:latest \
  --build-arg VERSION=1.0.0 \
  apps/chartdb/
```

The API key will be injected at runtime from the Docker secret.
