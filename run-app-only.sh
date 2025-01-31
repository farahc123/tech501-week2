# note that this is for the 2-subnet-vnet app vm with user data; for 3-subnet we need to change the private ip to 10.0.4.4

#!/bin/bash

# navigating into app folder
cd /repo/nodejs20-sparta-test-app/app

#export DB_HOST= correct private IP
export DB_HOST=mongodb://10.0.3.4:27017/posts

#starting the app
pm2 start app.js