# VM 1-3 steps

- [VM 1-3 steps](#vm-1-3-steps)
  - [First VM for app](#first-vm-for-app)
  - [Creating a git repo and syncing it to Github](#creating-a-git-repo-and-syncing-it-to-github)
  - [Creating the second VM](#creating-the-second-vm)
  - [SCP method](#scp-method)
  - [Git clone method](#git-clone-method)
- [Second VM: app from image, following along from above](#second-vm-app-from-image-following-along-from-above)
  - [Creating image of the first VM on Azure](#creating-image-of-the-first-vm-on-azure)
  - [Steps to set up new VM using first VM's image](#steps-to-set-up-new-vm-using-first-vms-image)
- [Third app: database app, eventually linked to second VM](#third-app-database-app-eventually-linked-to-second-vm)
  - [First steps when using a VM for the first time](#first-steps-when-using-a-vm-for-the-first-time)
  - [Check a VM has access to the internet](#check-a-vm-has-access-to-the-internet)
  - [Installing MongoDB](#installing-mongodb)
  - [Establishing and verifying the MongoDB-App VM connection](#establishing-and-verifying-the-mongodb-app-vm-connection)
  - [Setting up reverse proxy on the second VM:](#setting-up-reverse-proxy-on-the-second-vm)
  - [Getting app running in background using \& -- note the issues](#getting-app-running-in-background-using-----note-the-issues)
  - [Getting app running in background with pm2](#getting-app-running-in-background-with-pm2)


> ## [For Sparta: see important rules about use](https://teams.microsoft.com/l/entity/com.microsoft.teamspace.tab.planner/tt.c_19:TrpQwMO1PhqN7mR8x3SAhj2rcRGRLydw29ZVM26z2m01@thread.tacv2_p_rzzvyNukM0GzIMpb8EjAVJYAD4Ih_h_1736761296374?tenantId=ff15c67c-2870-4e9f-adc1-7d61d855b667&webUrl=https%3A%2F%2Ftasks.teams.microsoft.com%2Fteamsui%2FpersonalApp%2Falltasklists&context=%7B%22subEntityId%22%3A%22%2Fv1%2Fplan%2FrzzvyNukM0GzIMpb8EjAVJYAD4Ih%2Ftask%2FiqUxoyhSfUu-MTXos5X1yZYAA60s%22%2C%22channelId%22%3A%2219%3ATrpQwMO1PhqN7mR8x3SAhj2rcRGRLydw29ZVM26z2m01%40thread.tacv2%22%7D)

- When deleting a VM, delete everything associated with its name (e.g. if VM ends with week1-vm, everything week1-vm's name is associated with it), so vm, ip, network security group, network interface, disk
- BE SURE NOT TO DELETE RESOURCE GROUP
- go into three-dot menu, apply force delete, confirm deletion with typing

## First VM for app

1. Create new git repo and sync it to Github
2. Create VM
3. Log into VM using existing SSH
4. Update and upgrade with -y flag
5. Install NGINX with -y flag
6. Check NGINX status
7. Install dependencies:
   1. NodeJS and maybe NPM
   2. Check if node is installed with *node -v*, same with npm
8. Download app folder from SP, extract it into home folder on local machine
9. In git on the local machine, use SCP or git clone to copy the app folder to the VM's home:
   1.  *scp* method
   2.  Git clone method: *git clone https://github.com/farahc123/tech501-sparta-app repo*
10. Once app is on the VM, cd into the app folder
11. Install NPM
12. start npm [should see a listening on port 3000 message]
13.  Get IP from Azure portal and add :3000 to the end, use this as URL to check app is working

## Creating a git repo and syncing it to Github

1. Create local folder
2. Navigate to it via Git Bash
3. <code> git init </code>
4. <code> git branch -m master main </code>
5. <code> git add . </code>
6. <code> git commit -m "initial commit </code>
7. Go into GitHub and create a new repo (ideally with the same name as the local repo folder); don't change any other settings
8. Copy the GitHub URL and run:
   1. <code> git remote add origin [URL] </code>
9. <code> git push -u origin main </code>

## Creating the second VM

> **Basics tab**: 
>   - **Name**: tech501-farah-first-deploy-app-vm
>   - **Security type**: Standard
>   - **OS**: Ubuntu server 22.04 lts x64 gen2
>   - **All other settings default**
>   - Use our existing SSH key
>   - Allow SSH and HTTP ports
> 
> - **Disk tab**:
>   - Standard SSD
> 
> - **Networking tab**:
>   -  Set to your  public subnet
  > - The following allows NSG to be reusable when we delete this VM:
  >      - Select **Advanced** network security group
  >     - Create new security group
  >      - Add inbound rule, set Service to HTTP 
  >   - Add inbound rule, set **Destination port range** 3000, set protocol to **TCP** 
   >     - Rename network security group to **tech501-farah-sparta-app-allow-HTTP-SSH-3000**
   - [for future VMs using this NSG, press advanced and choose from drop down]
>      - Back in networking tab, enable** Delete public IP[...]**


## SCP method

> - 
- *scp -i ~/.ssh/tech501-farah-az-key -r ~/repo azureuser@20.254.65.158:~*

## Git clone method

- We upload the app or whatever code to a public Github repository (i.e. by creating a local git repo, putting the files in there, pushing etc.)
- Then we use git clone to download it from the Github to the VM
> - git clone [link to github repo] [path to destination on VM]
- *git clone https://github.com/farahc123/tech501-sparta-app repo*

# Second VM: app from image, following along from above

## Creating image of the first VM on Azure

- We do this to create a **generalised** image of the first VM from which future VMs can be created; this means it wipes out the user, so you can't log in to this VM again 
- **unconnectable** after the following:
  - Go to the first VM, click Capture and Image from top menu
  - Choose "No, capture only a managed image" option (i.e. uncheck gallery option)
  - Create image

## Steps to set up new VM using first VM's image

- Fill in settings as usual, but instead of an Ubuntu image, click See all images
- On left tab, navigate to My images and select relevant named image

# Third app: database app, eventually linked to second VM 

- Note that we use existing SSH key
- We create a new NSG (because we don't want HTTP in this one as it's a database)

> **Dependencies**:
> - **Name**: tech501-yourname-sparta-app-db-vm
>-  **Disk**: Ubuntu 22.04 LTS image
>-  Same size as usual (**Standard B1s**)
> - **NSG**: new, allow SSH
> - **Public IP**: yes
> - **Virtual network**: existing [our name] 2-net one
>     - **Subnet**: private-subnet
- Login & run update & upgrade

## First steps when using a VM for the first time

- sudo apt-get update -y 
- sudo apt-get upgrade -y

## Check a VM has access to the internet

- note that this does **not** mean it allows HTTP port access
- *sudo apt-get update -y*

## Installing MongoDB

> High-level steps of Tuesday's first MongoDB task 
> 1. on db vm: install mongodb
> 2. change bind ip
> 3. enable mongodb
> 4. restart mongodb


- **MongoDB**: open-source, cross-platform database system
- by default, MongoDB only accepts connections from the machine it's running from
- to fix this, we need to change the **bind IP** from local host (127.0.0.1) to accept connections from any IP address (0.0.0.0) and then restart mongodb -- note this is **ONLY FOR TESTING**, not production
- [script](deploy-db-app-third-task-script.sh) largely sourced from MongoDB site; edited version number 5 times to make it version 7.0.6
- check MongoDB is started with:
- > *sudo systemctl start mongod*
- we haven't used the following commands but they might be useful for later; their purpose is to "freeze" the version of mongodb installed; sourced from [MongoDB site](https://www.mongodb.com/docs/v7.0/tutorial/install-mongodb-on-ubuntu/):
>- echo "mongodb-org hold" | sudo dpkg --set-selections
> - echo "mongodb-org-database hold" | sudo dpkg --set-selections
> - echo "mongodb-org-server hold" | sudo dpkg --set-selections
> - echo "mongodb-mongosh hold" | sudo dpkg --set-selections
> - echo "mongodb-org-mongos hold" | sudo dpkg --set-selections
>- echo "mongodb-org-tools hold" | sudo dpkg --set-selections

## Establishing and verifying the MongoDB-App VM connection

- Note that only need <code>*npm start*</code> when reopening an app after it has been deployed
- We need to tell the app where to go to connect to the app (using what  is known as a **connection string**)
  - **do NOT save this anywhere public** as it's sensitive
  - we save this as an environment variable using <code>*export*</code> command in the app VM (***tech501-farah-second-deploy-app-from-image***) terminal:
    -  this will connect to the app via private ip (10...) via the mongodb port; this connection string is saved in DB_HOST environment variable
    -  not storing this string here for security reasons but DO THIS
    - <code> *printenv DB_HOST*
    - <code>*npm install*</code>
    - <code>*npm start* </code>
    - Successful message: database cleared, seeded with 100 records, connection closed -- this means it wiped records in the DB and populated it with dummy records
    - Verify the database and the VM are connected and that the DB is seeded with 100 records by visiting *\<public-IP>:3000/posts* in the URL
  - note that if we install *npm* and there are still no records in database, we need to manually seed (i.e. populate with records)
    - this is done FROM APP FOLDER like:
      - <code>*node seeds/seed.js*</code>

- **to start the *posts/* part on the app, we need to run the <code>export</code> command from the app folder in the second-vm every time**
- then <code>npm start</code>

## Setting up reverse proxy on the second VM: 
- We want port 80 to be redirected to port 3000 so we don't need to append *:3000* to the URL to see the app
- to do this, we need to:
  1. Backup the nginx configuration file at <code>/etc/nginx/sites-available/default</code>
  2. In the original config file, edit the default location to the following:

> #**to get into nginx config file**
>
> <code>sudo nano /etc/nginx/sites-available/default</code>
> 
> #remove *try_files* line
> #replace with:
> - <code>proxy_pass http://127.0.0.1:3000;}</code>
>
>#check nginx config file syntax is okay 
> 
> <code>sudo nginx -t</code>
>
> #reloads nginx to put new edit into place
> 
> <code>sudo systemctl reload nginx</code>
> 
3. visit http://20.39.219.168/ to check; app should now be default page
 

## Getting app running in background using & -- note the issues

- This causes an issue when killing the app because it hasn't been properly terminated so the port is still in use
- use <code>ps aux | grep node</code> to find process ID(s) of the app
- <code>kill [process id of node app]</code>
- Restarting the app (via <code>npm start</code> in app folder) gives me this issue:

>node:events:496
      throw er; // Unhandled 'error' event
      ^
>
>Error: listen EADDRINUSE: address already in use :::3000
    at Server.setupListenHandle [as _listen2] (node:net:1908:16)
    at listenInCluster (node:net:1965:12)
    at Server.listen (node:net:2067:7)
    at Function.listen (/repo/nodejs20-sparta-test-app/app/node_modules/express/lib/application.js:635:24)
    at Object.<anonymous> (/repo/nodejs20-sparta-test-app/app/app.js:47:5)
    at Module._compile (node:internal/modules/cjs/loader:1469:14)
    at Module._extensions..js (node:internal/modules/cjs/loader:1548:10)
    at Module.load (node:internal/modules/cjs/loader:1288:32)
    at Module._load (node:internal/modules/cjs/loader:1104:12)
    at Function.executeUserEntryPoint [as runMain] (node:internal/modules/run_main:173:12)
Emitted 'error' event on Server instance at:
    at emitErrorNT (node:net:1944:8)
    at process.processTicksAndRejections (node:internal/process/task_queues:82:21) {
  code: 'EADDRINUSE',
  errno: -98,
  syscall: 'listen',
  address: '::',
  port: 3000
}
>
>Node.js v20.18.2


## Getting app running in background with pm2

>High-level steps:
> 1. Install PM2
> 2. Check it's working with <code?--version</code>
> 3. Navigate to the app folder in the second-vm
> 4. Start the app using PM2 command
> 5. Stop the app using PM2 command

- This method uses *pm2*, a process manager for node.js apps
- code:

> - sudo npm install -g pm2
> - pm2 --version
> - [navigate to app]
> - pm2 start app.js
> - pm2 stop app.js

