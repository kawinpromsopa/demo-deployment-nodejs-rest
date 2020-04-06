# demo-deployment-nodejs-rest

Provisioning infrastructure microservices application on Amazon Web Services with terraform!.

![demo-nodejs-mongodb-rest (1)](https://user-images.githubusercontent.com/44109187/78571542-83ab9b80-7850-11ea-8116-54a142304435.png)

The results will be create:

* Network
    - VPC Public subnet 3 Availability zone (AZs)

* Compute
    - Elastic Compute Cloud (EC2)
      - 1). Application Server
        - Demo nodejs running on base docker container
        - Jenkins server running on base docker container
      - 2). Database Server 
        - Mongodb running on base docker container

* Amazon Machine Images (AMI)
    - Ubuntu xenial 16.04

* Security Group
    - Allow HTTP/HTTPS for `Application Server`.
    - Allow only internal remote access to connect `Database server`.
    - Allow secure shell

## Requirements

Dependencies

* Python >= 3.5
* Packer >= 1.5.5
* Ansible >= 2.5.2
* Terraform >= 0.11.1

Provisioning tools

* Packer
  - Build private base image.
* Ansible
  - Install services and configuration as: awscli, docker, nginx, and hardening.
* Terraform
  - Provisioning resources on Amazon Web Services (AWS).

AWS Account

* IAM Permissions to create services.
* AWS credentials and region.


## Build Application

* Forked [demo-nodejs-mongodb-rest](https://github.com/CleverCloud/demo-nodejs-mongodb-rest)
  - Also I'm already have builded docker container and pushed on Dockerhub registry.
  - Probably you could reviews for How to automated `build` and `deploy` on my forked repo: [kawinpromsopa/demo-nodejs-mongodb-rest](https://github.com/kawinpromsopa/demo-nodejs-mongodb-rest)

## Stages Environment

* I have designed to separate stages environment values with Directory : `Production`, `Staging`

## Provision.

Step 1). Clone repositry.

```
$ git clone https://github.com/kawinpromsopa/demo-deployment-nodejs-rest
```

Step 2). Export aws credentials keys.

```
$ export AWS_DEFAULT_REGION=ap-southeast-1
$ export AWS_ACCESS_KEY_ID=<YOUR_ACCESS_KEY>
$ export AWS_SECRET_ACCESS_KEY==<YOUR_SECRET_ACCESS_KEY>
```

* Reference : https://docs.aws.amazon.com/amazonswf/latest/awsrbflowguide/set-up-creds.html

### Packer

Step 3). Build private base image for provision servers, at path `./demo-nodejs-deployment/packer` wait utill created, and `COPY AMI_ID` to do something in the next step.

```
$ packer build ubuntu16_base_image.json
```
<img width="684" alt="Screen Shot 2563-04-04 at 18 57 48" src="https://user-images.githubusercontent.com/44109187/78508611-58726f00-77b2-11ea-95b5-3becccd65e8f.png">

Step 4). After received the `AMI_ID`, Please enter value to file `main.tf`, at path `./demo-nodejs-deployment/terraform/demo-nodejs-mongodb-rest/staging/main.tf` in line : 10, For example:

```
base_ami = "ami-xxxxxxx"
```

### Terraform

Step 5). Initial terraform modules, at path `./demo-nodejs-deployment/terraform/demo-nodejs-mongodb-rest/staging/

```
$ terraform init
```
<img width="737" alt="Screen Shot 2563-04-06 at 03 03 14" src="https://user-images.githubusercontent.com/44109187/78509003-1a2a7f00-77b5-11ea-8842-21fbb6c66923.png">

Step 6). Run `terraform apply` and then resource will be create 18 resources and enter `yes` to comfirm to deployment following command:
* Note: Processing deployment take time around few mins.
```
$ terraform apply
```
<img width="662" alt="Screen Shot 2563-04-06 at 03 05 04" src="https://user-images.githubusercontent.com/44109187/78509056-7ab9bc00-77b5-11ea-96cc-9f7d866ef92f.png">

Step 7). Copy the `Endpoint` value shown on display output and Enter that in your web browser. So, Let's see the result!

<img width="604" alt="Screen Shot 2563-04-06 at 22 01 24" src="https://user-images.githubusercontent.com/44109187/78572866-36c8c480-7852-11ea-9a59-501618a8331d.png">

<img width="1680" alt="Screen Shot 2563-04-06 at 21 57 35" src="https://user-images.githubusercontent.com/44109187/78573329-cff7db00-7852-11ea-86c0-edab92f4d610.png">

Step 9). Run `terraform destroy` to delete everything created by terraform, enter `yes` to comfirm to destroy following command:

```
$ terraform destroy
```

<img width="765" alt="Screen Shot 2563-04-06 at 22 06 28" src="https://user-images.githubusercontent.com/44109187/78573401-e6059b80-7852-11ea-8e13-13e66cddd5aa.png">

## [BONUS] Automated deployment application designed for CI/CD

With continuous integration and continuous deployment, I using Jenkins written multiple pipeline for: `Build`, `Push images to registry`, `Deployment stages`.
On the application repository that has somefile called `Dockerfile` for Automated building and `Jenkinsfile` for Automated deployment stages.
Could you see a further information on my forked repo: [kawinpromsopa/demo-nodejs-mongodb-rest](https://github.com/kawinpromsopa/demo-nodejs-mongodb-rest)
