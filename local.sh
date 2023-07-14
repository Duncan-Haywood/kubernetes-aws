# Pull the latest nginx image
docker pull nginx:alpine

# Run a new container from the image 
# '-d' runs detached 
# '--name' names it 'my-nginx'
# 'nginx' is the image name
docker run -d --name my-nginx nginx:alpine

# List running containers and verify my-nginx is up
docker ps 

# Ping localhost inside the running my-nginx container
# 'exec' executes a command in container
# '-i' keeps STDIN open for interactive
docker exec -i my-nginx ping 127.0.0.1