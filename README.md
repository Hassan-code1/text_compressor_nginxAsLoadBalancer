# Nginx Load Balancer

This directory contains the configuration to run Nginx as a load balancer for the Text Compressor backend servers.

## Configuration

1. Open `nginx.conf`.
2. Locate the `upstream backend_servers` block.
3. Replace the placeholder `server` entries with the actual URLs, IPs, or ports of your two backend servers.
   - For local testing with two backends on ports 3001 and 3002, use:
     ```nginx
     server host.docker.internal:3001;
     server host.docker.internal:3002;
     ```

## Running with Docker

The easiest way to run this load balancer is using Docker.

1. Build the Docker image:
   ```bash
   docker build -t text-compressor-lb .
   ```

2. Run the Docker container:
   ```bash
   docker run -d -p 8080:80 --name my-nginx-lb text-compressor-lb
   ```

3. Update your Frontend's `.env` file to point to the Nginx Load Balancer URL:
   ```env
   VITE_BACKEND_URL=http://localhost:8080
   ```

Now, when the frontend sends a request to `http://localhost:8080`, Nginx will intercept it and route it to one of the configured backend servers using Round Robin load balancing.
