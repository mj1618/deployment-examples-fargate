# Deployment Examples Fargate (dxfar) Pipeline

All deployment-examples are from a blank AWS and Terraform account as no assumptions are made about pre-existing knowledge or infrastructure.

In this example we create a Fargate cluster, an Aurora Postgres database and launch a node server into the cluster.

The basic sequence of steps is as follows:
- Create an AWS and Terraform account and save credentials
- Create the `deploymentuser` in AWS so we are not using root credentials
- Create the VPC
- Create the database
- Create an ECR repo to push images to
- Create the reusable ECS infrastrcture like security groups, roles, the cluster itself etc.
- Build the image and push to the repo
- Deploy an image to the cluster
- See it running in the logs
- Create a deployment pipeline in Github Actions

## Get Deployed

### 1. Prerequisites

- Get an AWS account and look up your root credentials. `Login -> Your Name -> My Security Credentials -> Access Keys -> Create New Access Key.`
- Register a domain name for your application in AWS and set the TF_VAR_dx_root_domain environment variable to the domain name. `Route53 -> Registered Domains -> Register Domain -> Follow the prompts`
- Create a Terraform account.
- `brew install jq` - used in the script: `./bin/docker-login`

### 2. Setup Terraform Cloud

- Create a terraform account
- run `terraform login` in your console

Setup workspaces:
```
./bin/tf-workspaces-create
```

### 3. Create and Configure AWS DeploymentUser

Create a profile from your root credentials (this profile can be deleted after this section):
```sh
aws configure --profile root
# enter root AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY
# note that the profile name "root" is used by the infra/user terraform script
```

Create DeploymentUser:
```sh
./bin/tf-user-create # creates deploymentuser with permissions to deploy
```

Now configure the credentials of the DeploymentUser (outputted to the console from the last step) and configure them locally:
```sh
aws configure --profile deploymentuser
# enter the credentials printed from the Create DeploymentUser step
# note the profile name "deploymentuser" is used by all further terraform scripts
```

### 4. Install Base Infra

```sh
./bin/tf-vpc-create dev
./bin/tf-pg-create dev
./bin/tf-ecr-create
./bin/tf-cluster-create dev
./bin/docker-login
./bin/docker-app-build
./bin/docker-app-push
./bin/tf-app-create dev
./bin/logs dev
```

### 5. Github Action for Deployment

Go into your Repository -> Settings and add the following variables:
- `TF_API_TOKEN` - your terrform API token (create a new one using `terraform login` if you need to)
- `AWS_ACCESS_KEY_ID` - your deploymentuser access key ID from the earlier step
- `AWS_SECRET_ACCESS_KEY` - your deploymentuser secret key from the earlier step

You'll also need to edit `.github/workflows/build.yml` and change `TF_VAR_dx_root_domain: deploymentexamples.com` to your domain name.

Now push commits will deploy automatically to dev.


## Local Docker Compose

Run the pg+node stack locally with:
```sh
docker compose up --build
```
