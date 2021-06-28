HOW TO INSTALL JENKINS

    $ sudo apt update
    $ sudo apt install openjdk-8-jdk
    $ wget –q –O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add –
    
Next, open your /etc/apt/sources.list file for editing
sudo nano /etc/apt/sources.list
3. Scroll to the bottom of the list, and add the following lines:

#  Jenkins software repository
deb https://pkg.jenkins.io/debian binary

Step 3: Install Jenkins
1. To install Jenkins on Ubuntu, use the command:

    $ sudo apt update
    $ sudo apt install Jenkins
2. The system prompts you to confirm the download and installation. Press Y and hit Enter, and the system downloads and installs Jenkins.

3. To check Jenkins was installed and is running enter:

sudo systemctl status jenkins

You need to open Port 8080 to allow Jenkins to communicate.

If you’re using the default UFW firewall, enter the following:

    $ sudo ufw allow 8080
    $ sudo ufw status
-------------------------------------------------------
            HOW TO USE JENKINS

you can access it from localhost:8080 by default

you can start with admin password which will be located at 
/var/lib/jenkins/secrets/initialAdminPassword

so as default jenkins folder located at /var/lib/jenkins in case you need to change your default jenkins folder you can 

create new dir which you want to make home directory and then copy all data from /var/lib/jenkins to path of you newly created dir

then just edit this file        sudo nano /etc/default/jenkins
set JENKINS_HOME=/home/new_home save  it 
and restart jenkins