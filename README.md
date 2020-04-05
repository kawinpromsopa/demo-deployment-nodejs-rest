# demo-deployment-nodejs-rest

Provisioning infrastructure microservices application on Amazon Web Services with terraform!.

![demo-nodejs-mongodb-rest](https://user-images.githubusercontent.com/44109187/78508240-62df3980-77af-11ea-8c6e-ebfde7d3be0e.png)

The results will be create:

* Network
    - VPC Public subnet 3 Availability zone

* Compute
    - Elastic Compute Cloud (EC2)

* Security Group
    - Allow HTTP/HTTPS for Application Server.
    - Allow remote access to Database server from Application Server.
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
  - Probably could reviews for How to automated `build` and `deploy` on my forked repo: [kawinpromsopa/demo-nodejs-mongodb-rest](https://github.com/kawinpromsopa/demo-deployment-nodejs-rest)

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

Step 4). After received the `AMI_ID`, Please enter value to file `main.tf`, at path `./demo-nodejs-deployment/terraform/demo-nodejs-mongodb-rest/staging/main.tf` in line : 9, For example:

```
app_image = "ami-xxxxxxx"
```

### Terraform

Step 5). Initial terraform modules, at path `./demo-nodejs-deployment/terraform/demo-nodejs-mongodb-rest/staging/

```
$ terraform init
```
<img width="737" alt="Screen Shot 2563-04-06 at 03 03 14" src="https://user-images.githubusercontent.com/44109187/78509003-1a2a7f00-77b5-11ea-8842-21fbb6c66923.png">

Step 6). Run `terraform apply` and then resource will be create 14 resources and enter `yes` to comfirm to deployment following command:
* Note: Processing deployment take time around few mins.
```
$ terraform apply
```
<img width="662" alt="Screen Shot 2563-04-06 at 03 05 04" src="https://user-images.githubusercontent.com/44109187/78509056-7ab9bc00-77b5-11ea-96cc-9f7d866ef92f.png">

Step 7). Copy the DNS_NAME value in file, Enter in your web browser, and enjoy!

<img width="1680" alt="Screen Shot 2562-07-30 at 16 06 59" src="https://user-images.githubusercontent.com/44109187/62116700-d063cd80-b2e4-11e9-9f8b-b2462dea5a54.png">

Step 9). Run `terraform destroy` to delete everything created by terraform, enter `yes` to comfirm to destroy following command:

```
$ terraform destroy
```

## Development application designs for CI/CD

With continuous integration and continuous deployment I using Jenkins written pipeline as a code workflow: `Build`, `Push images to registry`, `Deployment stages` by separate `environment values` and `configuration of resource systems` with terraform workspace or directory enivonment, like deployed example this. And also these architecture infrastructure supported blue/green deployment
