 WORDPRESS: A WEB APPLICATION
 This web application is created using docker,docker-compose and packaged in a Docker Containers.
 
 The docker-wordress contains the SRC and the docker-compose.yml
 In the SRC, 
 We have the Terraform script that would download the required dependencies unto your server.
 It also contains the commands that would create, build the docker conatiners with wordpress and mysql database attaches to it.
 
 All you need is to download the docker-compose.yml file in your local machine. In my case its "~/project/Vscode/docker-wordpress/docker-compose.yml"
 So you need line 142 in my main.tf to the path where you have the docker-compose.yml in your local machine.
 
 The docker-compose.yml file,
 We have two services, wordpress and mysql as our database
 The docker-compose file is going to enable you acces the wordpress site with five(5) different port  
 
 
 ALL YOU NEED TO DO IS TERRAFORM APPLY AND YOUR WORDPRESS SITE SHOULD READY ON LOCALHOST:8080-8085
 NOTE: IT TAKES UP TO 12MINS AFTER TERRAFORM APPLY FOR THE SITE TO BE READY DEPENDING ON YOUR NETWORK
