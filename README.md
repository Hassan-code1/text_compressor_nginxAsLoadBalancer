# Nginx Load Balancer ⚖️

This repository contains the configuration for a Dockerized Nginx Load Balancer, designed specifically to route traffic across multiple instances of the Text Compressor Backend. 

Implementing this load balancer ensures high availability, handles cross-origin resource sharing (CORS) preflight passing, and effectively manages heavy file-upload workloads via round-robin distribution.

## Architecture & Features

* **Dynamic Environment Injection:** Uses Docker's `envsubst` to dynamically inject backend URLs at runtime via `default.conf.template`.
* **HTTPS SNI Proxying:** Configured with `proxy_ssl_server_name on;` to securely proxy traffic to PaaS-hosted backends (like Render) that enforce HTTPS and SNI routing.
* **Large File Support:** Configured with `client_max_body_size 50M;` to support large text file uploads.
* **Extended Timeouts:** Network timeouts (`proxy_read_timeout`) are increased to accommodate long-running C++ compression tasks.

## Configuration Guide

The core configuration lives in `default.conf.template`. This template uses environment variables to define the upstream servers.

### Environment Variables

When running the container, you must provide the following variables (without `https://`):
* `BACKEND_1`: Domain of your first backend instance (e.g., `text-compressor-backend-1.onrender.com`)
* `BACKEND_2`: Domain of your second backend instance (e.g., `text-compressor-backend-2.onrender.com`)

## Running Locally (Docker)

1. **Build the Docker Image:**
   ```bash
   docker build -t text-compressor-lb .
   ```

2. **Run the Container:**
   ```bash
   docker run -d -p 8080:80 \
     -e BACKEND_1="host.docker.internal:3001" \
     -e BACKEND_2="host.docker.internal:3002" \
     --name huffman-lb text-compressor-lb
   ```
   *(Note: Adjust the variables to match your local backend ports).*

## Production Deployment (Render / Railway)

This repository is designed to be deployed as a Docker service on platforms like Render.

1. Create a new **Web Service** on Render and connect this repository.
2. Render will automatically detect the `Dockerfile` and build the Nginx container.
3. Under **Environment Variables**, add your backend domains:
   * `BACKEND_1` = `backend-instance-1.onrender.com`
   * `BACKEND_2` = `backend-instance-2.onrender.com`
4. Deploy the service.

## Testing the Load Balancer

Once deployed, point your frontend (`VITE_BACKEND_URL`) to the load balancer's URL.

To test the load distribution via cURL:
```bash
curl -I https://your-load-balancer-url.com/
```
By monitoring your backend logs, you should see requests alternating between `BACKEND_1` and `BACKEND_2` (Round-Robin behavior).
