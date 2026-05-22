# Use the official Nginx image from Docker Hub
FROM nginx:alpine

# Copy the template to the directory where the nginx entrypoint expects templates
COPY default.conf.template /etc/nginx/templates/default.conf.template

# Expose port 80
EXPOSE 80

# The official Nginx Alpine image automatically runs `envsubst` on files 
# ending in .template within /etc/nginx/templates/ and places the output
# into /etc/nginx/conf.d/ (replacing the default configuration).
