# get updates of packages

sudo apt-get update -y

# downloads and installs the latest updates for packages based on above command

sudo apt-get upgrade -y

# installs mongodb 7.0.6; no user input

#installs gnupg and curl
sudo apt-get install gnupg curl

#downloads gpg key
curl -fsSL https://www.mongodb.org/static/pgp/server-7.0.asc | \
   sudo gpg -o /usr/share/keyrings/mongodb-server-7.0.gpg \
   --dearmor

#creates file list
echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list

#updates and installs
sudo apt-get update

# installs mongo db 7.0.6 components; DOES REQUIRE INPUT SO NEED TO FIX
sudo apt-get install -y mongodb-org=7.0.6 mongodb-org-database=7.0.6 mongodb-org-server=7.0.6 mongodb-mongosh mongodb-org-mongos=7.0.6 mongodb-org-tools=7.0.6

# configure the bindIP - will have to work out a command to change this to 0.0.0.0 like sudo nano /etc/mongod.conf

# do we need to include enabling mongod code?
sudo systemctl enable mongod
sudo systemctl is-enabled mongod # checking it's enabled
sudo systemctl start mongod

# restarts mongodb to save new enabled setting 
sudo systemctl restart mongod


