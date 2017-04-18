# redmine-all-in-one with docker

# Prerequisites
This readme assumes you are familiar with running Docker. You also need to run a Docker Registry.

# Step 1 Build docker image
docker build -t example/redmine

# Step 2 Push image
docker push example/redmine

# Step 3 Start redmine services
/bin/bash start_redmine.sh

# Step 4 Start Apache mysql service
docker exec your_container /bin/bash /opt/start.sh

