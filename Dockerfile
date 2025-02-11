FROM nginx:alpine

# Copy all website files to nginx html directory
COPY index.html /usr/share/nginx/html/
COPY styles.css /usr/share/nginx/html/
COPY script.js /usr/share/nginx/html/
COPY deviations.json /usr/share/nginx/html/
COPY avatars/ /usr/share/nginx/html/avatars/
COPY content/ /usr/share/nginx/html/content/
COPY emojis/ /usr/share/nginx/html/emojis/

# Expose port 80
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
