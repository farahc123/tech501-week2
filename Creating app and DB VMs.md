# Azure VM steps

- [Azure VM steps](#azure-vm-steps)
  - [Steps when creating first app VM](#steps-when-creating-first-app-vm)
  - [Workflow for creating a Git repo and syncing it to Github](#workflow-for-creating-a-git-repo-and-syncing-it-to-github)
  - [Creating the second app VM](#creating-the-second-app-vm)
  - [SCP method](#scp-method)
  - [Git clone method](#git-clone-method)
- [Third app VM: using image from second VM](#third-app-vm-using-image-from-second-vm)
  - [Creating image of the first VM on Azure](#creating-image-of-the-first-vm-on-azure)
  - [Steps to set up new VM using first VM's image](#steps-to-set-up-new-vm-using-first-vms-image)
- [Database VM, eventually linked to app VM](#database-vm-eventually-linked-to-app-vm)
  - [First steps when using a VM for the first time](#first-steps-when-using-a-vm-for-the-first-time)
  - [Check a VM has access to the internet](#check-a-vm-has-access-to-the-internet)
  - [Installing MongoDB](#installing-mongodb)
  - [Establishing and verifying the MongoDB-App VM connection](#establishing-and-verifying-the-mongodb-app-vm-connection)
  - [Setting up reverse proxy on the second VM:](#setting-up-reverse-proxy-on-the-second-vm)
  - [Getting app running in background using \& — note the issues](#getting-app-running-in-background-using---note-the-issues)
  - [Getting app running in background with `pm2`](#getting-app-running-in-background-with-pm2)
- [Creating DB VM and app VM images](#creating-db-vm-and-app-vm-images)
  - [Creating an app VM and a DB app VM from the previous 2 created images](#creating-an-app-vm-and-a-db-app-vm-from-the-previous-2-created-images)
  - [*run-app-only* script to be used in User Data field](#run-app-only-script-to-be-used-in-user-data-field)
  - [Levels of automation in order of lowest-highest](#levels-of-automation-in-order-of-lowest-highest)
  - [Creating an app VM with User Data field](#creating-an-app-vm-with-user-data-field)
  - [Troubleshooting](#troubleshooting)
    - [Thursday morning's issue:](#thursday-mornings-issue)


> ## [For Sparta: see important rules about use](https://teams.microsoft.com/l/entity/com.microsoft.teamspace.tab.planner/tt.c_19:TrpQwMO1PhqN7mR8x3SAhj2rcRGRLydw29ZVM26z2m01@thread.tacv2_p_rzzvyNukM0GzIMpb8EjAVJYAD4Ih_h_1736761296374?tenantId=ff15c67c-2870-4e9f-adc1-7d61d855b667&webUrl=https%3A%2F%2Ftasks.teams.microsoft.com%2Fteamsui%2FpersonalApp%2Falltasklists&context=%7B%22subEntityId%22%3A%22%2Fv1%2Fplan%2FrzzvyNukM0GzIMpb8EjAVJYAD4Ih%2Ftask%2FiqUxoyhSfUu-MTXos5X1yZYAA60s%22%2C%22channelId%22%3A%2219%3ATrpQwMO1PhqN7mR8x3SAhj2rcRGRLydw29ZVM26z2m01%40thread.tacv2%22%7D)

- When deleting a VM, delete everything associated with its name (e.g. if VM ends with week1-vm, everything week1-vm's name is associated with it), so vm, ip, network security group, network interface, disk
- BE SURE NOT TO DELETE RESOURCE GROUP
- go into three-dot menu, apply force delete, confirm deletion with typing
- note that, until the VM from [Creating a first VM with User Data field](#creating-a-first-vm-with-user-data-field), the user was set as *azureuser* — this has now been corrected to *adminuser* from this point on  

## Steps when creating first app VM

1. Create new git repo and sync it to Github
2. Create VM
3. Log into VM using existing SSH
4. Update and upgrade with -y flag
5. Install NGINX with -y flag
6. Enable NGINX
7. Restart NGINX
8. Check NGINX status
9. Install dependencies:
   1. NodeJS and NPM
   2. Check if node is installed with `node -v`, same with npm
10. Download app folder from SP, extract it into home folder on local machine
11. In Git on the local machine, use SCP or `git clone` to copy the app folder to the VM's home:
   1.  `scp` method: `scp -i ~/.ssh/tech501-farah-az-key -r nodejs20-sparta-test-app azureuser@20.254.65.158:~`
   2.  `git clone` method: `git clone https://github.com/farahc123/tech501-sparta-app repo`
12. Once app is on the VM, `cd` into the app folder
13. `npm install`
14. `npm start` [should see a "listening on port 3000" message]
15.  Get IP from Azure portal and add :3000 to the end; use this as URL to check app is working

## Workflow for creating a Git repo and syncing it to Github

1. Create local folder
2. Navigate to it via Git Bash
3. `git init`
4. `git branch -m master main`
5. `git add .`
6. `git commit -m "initial commit`
7. Go into GitHub and create a new repo (ideally with the same name as the local repo folder); don't change any other settings
8. Copy the GitHub URL and run:
   - `git remote add origin [URL]`
9. `git push -u origin main`
   - afterwards, can just use `git push`  

## Creating the second app VM

> **Basics tab**: 
>   - **Name**: tech501-farah-second-deploy-app-vm
>   - **Security type**: Standard
>   - **OS**: Ubuntu server 22.04 lts x64 gen2
>   - **username**: adminuser
>   - **All other settings default**
> - **Security type**: Standard
> - Use our **existing SSH key**
> - **Allow SSH and HTTP ports**
> 
> - **Disk tab**:
>   - **Disk**: Standard SSD
> 
> - **Networking tab**:
>   -  Set to my **public-subnet**
  > - The following allows NSG to be reusable when we delete this VM:
  >      - Select **Advanced** network security group
  >     - Create new security group
  >      - Add inbound rule, set Service to HTTP 
  >   - Add inbound rule, set **Destination port range** 3000, set protocol to **TCP** 
   >     - Rename network security group to **tech501-farah-sparta-app-allow-HTTP-SSH-3000**
   - [for future VMs using this NSG, press advanced and choose from drop down]
> - Back in networking tab, enable **Delete public IP[...]**


## SCP method

- From within the directory holding the app folder, run:
 
  `scp -i ~/.ssh/tech501-farah-az-key -r nodejs20-sparta-test-app azureuser@20.254.65.158:~`

## Git clone method

- We upload the app or whatever code to a public Github repository (i.e. by creating a local git repo, putting the files in there, pushing etc.)
- Then we use `git clone` to download it from the Github to the VM
> - `git clone [link to github repo] [path to destination on VM]`
- e.g. `git clone https://github.com/farahc123/tech501-sparta-app repo`

# Third app VM: using image from second VM

## Creating image of the first VM on Azure

- We do this to create a **generalised** image of the first VM from which future VMs can be created; this means it wipes out users, so you can't log in to this VM again 
- **unconnectable** after the following:
  - Go to the first VM, click **Capture** and **Image** from top menu
  - Choose **"No, capture only a managed image"** option (i.e. uncheck gallery option)
  - **Create image**

## Steps to set up new VM using first VM's image

- Fill in settings as usual, but instead of an Ubuntu image, click **See all images**
- On left tab, navigate to My images and select relevant named image
- Alternatively, can begin from the **Images** resource page on Azure, select the image, and then create VM 

# Database VM, eventually linked to app VM

- Note that we use our existing SSH key again here
- We create a new NSG (because we don't want HTTP in this one as it's a database)

> - **Name**: tech501-yourname-sparta-app-db-vm
> - **Security**: Standard 
>-  **Disk**: Ubuntu 22.04 LTS image
>-  Same size as usual (**Standard B1s**)
> - my existing SSH key
> - **Disks tab:** Standard SSD
> - **NSG**: new, allow SSH
> - **Public IP**: yes (note that in  later versions of this VM, we removed the public IP for greater security)
> - **Virtual network**: existing 2-net one
>     - **Subnet**: private-subnet
- Login & run `update` & `upgrade`

## First steps when using a VM for the first time

- `sudo apt-get update -y`
- `sudo apt-get upgrade -y`

## Check a VM has access to the internet

- note that this does **not** mean it allows HTTP port access
- `sudo apt-get update -y`

## Installing MongoDB

> High-level steps of Tuesday's first MongoDB task 
> 1. on DB VM: install *mongodb*
> 2. change bindip
> 3. enable mongodb
> 4. restart mongodb


- **MongoDB**: open-source, cross-platform database system
- by default, MongoDB only accepts connections from the machine it's running from
- to fix this, we need to change the **bind IP** from local host (127.0.0.1) to accept connections from any IP address (0.0.0.0) and then restart mongodb — note this is **ONLY FOR TESTING**, not production
- [script](deploy-db-app-third-task-script.sh) largely sourced from MongoDB site; edited version number 5 times to make it version 7.0.6
- check MongoDB is started with:
 > `sudo systemctl start mongod`
- we haven't used the following commands but they might be useful for later; their purpose is to "freeze" the version of mongodb installed; sourced from [MongoDB site](https://www.mongodb.com/docs/v7.0/tutorial/install-mongodb-on-ubuntu/):
>- echo "mongodb-org hold" | sudo dpkg --set-selections
> - echo "mongodb-org-database hold" | sudo dpkg --set-selections
> - echo "mongodb-org-server hold" | sudo dpkg --set-selections
> - echo "mongodb-mongosh hold" | sudo dpkg --set-selections
> - echo "mongodb-org-mongos hold" | sudo dpkg --set-selections
>- echo "mongodb-org-tools hold" | sudo dpkg --set-selections

## Establishing and verifying the MongoDB-App VM connection

- Note that we only need `npm start` when reopening an app after it has already been deployed
- We need to tell the app where to go to connect to the app (using what  is known as a **connection string**)
  - **do NOT save this anywhere public** as it's sensitive
  - we save this as an environment variable using the `export` command in the app VM's (***tech501-farah-second-deploy-app-from-image***) terminal:
    -  this will connect to the app via private ip (10...) using the mongodb port; this connection string is saved in the `DB_HOST` environment variable
    -  `export DB_HOST=mongodb://10.0.3.4:27017/posts`
    - `*printenv DB_HOST*`
    - `npm install`
    - `npm start`
    - **Successful message**: database cleared, seeded with 100 records, connection closed — this means it wiped any records in the DB and populated it with dummy records
    - Verify the database and the VM are connected and that the DB is seeded with 100 records by visiting *\<public-IP>:3000/posts* in the URL
  - note that if we install *npm* and there are still no records in database, we need to manually seed (i.e. populate with records)
    - this is done FROM APP FOLDER like:
      - `node seeds/seed.js`

- **to start the *posts/* part on the app, we need to run the `export` command from the app folder in the second-vm every time**
- then `npm start`

## Setting up reverse proxy on the second VM: 
- We want port 80 to be redirected to port 3000 so we don't need to append *:3000* to the URL to see the app
- to do this, we need to:
  1. Backup the nginx configuration file at `/etc/nginx/sites-available/default` like `cp default default.backup`
  2. In the original config file, edit the default location to the following:

> #**to get into nginx config file**
>
> `sudo nano /etc/nginx/sites-available/default`
> 
> #remove *try_files* line
> #replace with:
> - `proxy_pass http://127.0.0.1:3000;}`
> or
> `proxy_pass http://localhost:3000;}`
>
>#check nginx config file syntax is okay 
> 
> `sudo nginx -t`
>
> #reloads nginx to put new edit into place
> 
> `sudo systemctl reload nginx`
> 
3. visit app VM's public IP to check; app should now be default page
 

## Getting app running in background using & — note the issues

- This causes an issue when killing the app because it hasn't been properly terminated so the port is still in use
- use `ps aux | grep node` to find process ID(s) of the app
- `kill [process id of node app]`
- Restarting the app (via `npm start` in app folder) gives me this issue:

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


## Getting app running in background with `pm2`

- From now on, we want the app running in the background using PM2
- note that PM2 is a **daemon**, which means it runs in the background — by default programmes running in the background need to be **explicitly stopped** after every use
- We want it to run in the background because this means the app will keep running **even if the terminal session ends or crashes**
- High-level steps:
> 1. Install PM2 globally
> 2. Check it's working with `--version`
> 3. Navigate to the app folder in the app Vm
> 4. Start the app using PM2 command
> 5. Stop the app using PM2 command

- This method uses `pm2`, a process manager for node.js apps
- code:

> `sudo npm install -g pm2`
> `pm2 --version`
> #navigate to app
> `pm2 start app.js`
> `pm2 stop app.js` #once done with app

# Creating DB VM and app VM images

- We do this to create a generalised image of the app VM from which future VMs can be created — doing this because the app VM now includes a **reverse proxy** so we want this to be our app image from now on
- The point of creating these images is that we've got the VM working manually with all the **required dependencies** once (i.e. at this stage, we've added reverse proxy and PM2 on the app VM), so now we want this as our model to be replicated via automation
- Again, creating an image from a VM  means it wipes out the user, so you can't log in to this VM again
- unconnectable after the following standard procedure:
  - Go to the first VM, click **Capture** and **Image** from top menu
  - Choose "No, capture only a managed image" option (i.e. uncheck gallery option)
  - **Create image**
- if a Trusted Launch error, need to recreate the DB VM because this means the **Security setting** in VM creation was set to Trusted Launch, when it **should be Standard** (note that you need to remake the app because you can't downgrade security type after creation, only upgrade)

## Creating an app VM and a DB app VM from the previous 2 created images

> Image names:
> - tech501-farah-sparta-app-dp-from-image-vm
> - tech501-farah-app-demo-from-img-vm
>  
- The point of creating these images is that we've got the VM working manually with all the required dependencies once (i.e. at this stage, we've added reverse proxy and PM2), so now we want this as our model to be replicated via automation
  - in general, need to be aware of cost-benefit ratio of spending time on these automation tasks if they don't actually save that much time
- Go into **Images** page on Azure Portal, then **Create VM** from correct images 
- Fill in settings as usual:
  - **DB VM**: private subnet, non-HTTP rule NSG
  - **app VM**: public subnet, HTTP rule NSG
- Test connection between the two using normal steps:
    - SSH into both
    - on app VM, navigate to app folder, run `export` command and `pm2 start app.js`

## *run-app-only* script to be used in User Data field

- We want to create a script that means that, on the **first login**, we don't have to run the `export` and `pm2 start app.js` commands — we want the app to simply run once we have started the VMs the first time
- every other time, we need to run the usual `export` and `pm2 start app.js` and `pm2 stop app.js`
- We want to design this script so it can be put into the **User data** field during Azure VM creation process (which runs as **root user** once immediately after the VM is created)
- This should:
  1. begin with shebang
  2. correctly `cd` into *app* folder as **scripts automatically start in the root directory**
  3. export environmental variable (be sure to check private IP is correct for new app VM from image)
  4. `pm2 start app.js`
  5. later: `pm2 stop app.js`

- Note that in `export` commands, it goes **private IP:PORT NUMBER**
- Note that we would also want to create a script that means we don't have to SSH in to execute the script, but we won't have time to do this on the course

## Levels of automation in order of lowest-highest

1. Manually configuring everything
2. Using a script to install dependencies
3. Using our *run-app-only.sh* Bash script in User Data (which still requires us to SSH in to start the app)
- creating an image from any of the above is the quickest way to get the app up and running 

## Creating an app VM with User Data field

- Get DB VM started and connect
  - ensure MongoDB is working with `sudo systemctl status mongod`
-  Once the above two VMs are created from images, we need to create a new app VM from the latest app VM image with these settings (note: use the *Images* page on Azure as it's faster this way)
> -  **Name**: tech501-farah-app-demo-from-img-vm
> -  **Set username**: adminuser
> -  Use my **existing SSH**
> -  Don't need to edit inbound ports on Basic tab as we'll be using our existing NSG which is configured to accept HTTP
> -  Choose **Other** on license type
> -  **Disks tab**: Standard SSD
> -  Enable **Delete with VM**
> -  **Networking tab**:
>     -  choose my vnet and my public subnet
>     -  choose existing NSG with HTTP 3000 rules
> -  Enable **Delete public IP...**
> -  **Advanced tab**:
>   -  Enable **User Data** option
>   -  In resulting box, **paste *run-app-only.sh* script**
> -  Set usual **Tags**

- After this, wait 2—3 minutes to test the app by visiting the public IP as URL, and /posts/ page
- **be sure to run `pm2 stop app.js` after this first login and every subsequent login to ensure no `pm2` processes are left over for the next login as this causes issues**

## Troubleshooting

- check permissions of folder/file if that's the issue — change ownership or use `sudo`
- run `sudo -E` commands to access environment variables for a command that relies on them in case the env variable is saved in a different subshell
### Thursday morning's issue:
- ran these commands:
> - *sudo -E npm install*
> - *sudo -E pm2 start app.js*
> - *sudo pm2 stop all*
> - *ps aux*
> - If pm2 processes are still running when run ` ps aux | grep pm2`, kill them as pm2 is the parent process for the app; try `pm2 stop all -f`
> for Thursday morning's issue of "Cannot get posts" after checking everything:
>   -  the issue really was that I had *pm2* processes still lingering in `ps aux` so had to `kill` them
> - however I also changed ownership of the *app* folder to adminuser as I had just corrected this in my new VM creation process (was previously azureuser) — this shouldn't need to be done again
> - I manually killed pm2 and node processes that still existed on `ps aux | grep pm2` after running `pm2 stop all` (but should be able to leapfrog this step via the `-f` option) — this should  be fixed from now on **SO LONG AS I BE SURE TO RUN** `pm2 stop app.js` **AT END OF EVERY USE BEFORE LOGGING OUT OF THE VM**, but run this `pm2 stop all -f` command if issue arises again
