# Terraform AWS ALB Demo

This repo provides some Terraform code used to deploy an Appliacation Load Balancer on AWS, just for testing purposes. There are also 2 ECS instances (t2-micro) deployed with docker installed on both of them. On the first instance you'll have an nginx container and for the 2nd, an apache httpd image is used. 

## File Structure

- **providers.tf**: provider configuration (AWS for this demo). You have to set up your own profile in the aws config file. Also, you might have to setup your IAM access keys in order to connect to the AWS API. I suggest to setup a IAM user (without password assignment, just an access key) and setup a proper permission policy. For the sake of this demo, i've created a user called "terraform" and attached a direct policy called "AdministratorAccess". I do not recommend do it this way, and **PLEASE BE CAREFUL: Do not share, by any means, your access keys.... never!**\
In this file you also define the region to be used in this demo.

- **data.tf**: a data source file to retrieve the availability zone in the configured region. Useful if you don't want to have this hardcoded all over the code. 

- **variables.tf**: this files defines all the variables we use in the code. These are VPC or EC2 related. The most important ones are:
    - **instance_count**: how many instances we want to lauch. This number is limited by the number of AZs your chosen region have (because it will launch one instance per AZ, for high availability reasons). For example for us-east-1 there are 6 AZs, so this will be the max number you can use.
    - **instance_userdata**: due to the use of different containers (apache httpd and nginx) for our EC2 instances, we have to define a list with 2 different user-data scripts. We could use a Docker Provider for Terraform, and just use the same user-data script, but it is out of scope of this demo. 

- **networking.tf**: where most of the networking stuff is defined: we create a VPC, a public subnet per AZ, an Internet Gateway, and the remaining routing elements. Have in mind that most of the definitions are dynamic, to avoid repeating blocks. This allow us to save some code. 

- **ec2-instances.tf**: basic instance definition code.

- **alb.tf**: this file contains the basic parameters you need to create an ALB (Application Load Balancer): target group and its association with our instances, and a listener definition for port 80/TCP (HTTP). 

- **security-group.tf**: firewall rules deinitions (for inbound and outbound traffic).

- **outputs.tf**: a couple of terraform outputs. You will need the `aws_lb.lb.dns_name` in order to test the ALB.

- **userdata-docker-apache.sh**: user-data script used to install Docker and run an apache httpd container.

- **userdata-docker-nginx.sh**: user-data script used to install Docker and run an nginx container.

## How to use this code

1. Clone this repo.

2. OFC you need to have Terraform installed on your computer. Then, you have to setup an authentication method for AWS. There are parameters in the providers.tf file you can use. If you have the AWS CLI installed, you can create a profile and use the ~/.aws/credentials and config files like I did. 

3. You will have to put a region in the **providers.tf** file (I used us-east-1).

4. Then go to the **variables.tf** file and setup all the variables (or used the default ones). Be careful if you use another AMI, because the user-data scripts were wrote for Ubuntu. 

5. Execute the `terraform init` command, and then a `terraform plan` to see the 16 additions.

6. See the magic happens whe you run `terraform apply -auto-approve`. Use the ALB DNS name displayed in the output and remember use *http://* instead of *https://*

> Note: All the AWS resources deployed are free-tier elegible. But please read the free tier limitations [here](https://aws.amazon.com/free/).



