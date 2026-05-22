# Nginx Load Balancer

This directory contains the configuration to run Nginx as a load balancer for the Text Compressor backend servers.

## Configuration using Environment Variables

The Nginx configuration relies on Docker's built-in `envsubst` feature. When the container starts, it reads `default.conf.template` and replaces the variables with your environment variables.

### Running with Docker

You must provide the backend URLs via environment variables when running the container.

1. Build the Docker image:
   ```bash
   docker build -t text-compressor-lb .
   ```

2. Run the Docker container, injecting the two backend URLs as environment variables:
   ```bash
   docker run -d -p 8080:80 \
     -e BACKEND_1="backend1.yourdomain.com" \
     -e BACKEND_2="backend2.yourdomain.com" \
     --name my-nginx-lb text-compressor-lb
   ```

3. Update your Frontend's `.env` file to point to the Nginx Load Balancer URL:
   ```env
   VITE_BACKEND_URL=http://localhost:8080
   ```

Now, when the frontend sends a request to `http://localhost:8080`, Nginx will intercept it and route it to either `BACKEND_1` or `BACKEND_2` using Round Robin load balancing.
