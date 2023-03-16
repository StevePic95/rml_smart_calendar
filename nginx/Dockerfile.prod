# First stage: build the React application
FROM node:14 AS build

# Set working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY client/package*.json ./

# Install dependencies
RUN npm install

# Copy the source code
COPY . .

# Build the React application
RUN npm run build


# Second stage: serve the static files with Nginx
FROM nginx

# Remove the default Nginx configuration
RUN rm /etc/nginx/conf.d/default.conf

# Copy your custom Nginx configuration (optional)
COPY ./default.conf /etc/nginx/conf.d/

# Copy the static files from the build stage
COPY --from=build /app/build/* /usr/share/nginx/html/

# Expose the port Nginx is running on
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]

