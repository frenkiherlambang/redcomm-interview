# Base image
FROM node:18-alpine

# Set the working directory
WORKDIR /var/www/html

# Copy the project files to the container
COPY ./nuxt /var/www/html

# Install dependencies
RUN npm install

# Build the production version
RUN npm run build

ENV HOST 0.0.0.0
# ENV WATCHPACK_POLLING true
# Expose the Nuxt.js port
#EXPOSE 3000

# Start the Nuxt.js server
#CMD ["npm", "run", "dev"]
