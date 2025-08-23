# Use an official Ubuntu base image
FROM ubuntu:22.04

# Install dependencies (nginx, git, curl, etc.)
RUN apt-get update && apt-get install -y \
    nginx \
    git \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Clone miniPaint into nginx web directory
RUN git clone https://github.com/viliusle/miniPaint.git /var/www/html/miniPaint

# Remove default nginx config and replace with custom one
RUN rm /etc/nginx/sites-enabled/default
RUN echo 'server {\n\
    listen 80;\n\
    server_name _;\n\
    root /var/www/html/miniPaint;\n\
    index index.html;\n\
    location / {\n\
        try_files $uri $uri/ =404;\n\
    }\n\
}' > /etc/nginx/sites-available/miniPaint.conf \
    && ln -s /etc/nginx/sites-available/miniPaint.conf /etc/nginx/sites-enabled/

# Expose port 80
EXPOSE 80

# Start nginx in foreground
CMD ["nginx", "-g", "daemon off;"]
