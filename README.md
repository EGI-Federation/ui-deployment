# Deploying an UI

Repo deploying a VM and provisioning a UI.

## Requirements

Python 3.

```shell
# Create a python3 virtualenv
python3 -m venv ~/.virtualenvs/ui-deployment
# Activate virtual env
source ~/.virtualenvs/ui-deployment/bin/activate
# Install required python modules
pip install -r requirements.txt
# Install required ansible modules
ansible-galaxy install -r requirements.yml
```

## Using

```shell
# Activate virtual env
source ~/.virtualenvs/ui-deployment/bin/activate
```

## Creating the VM with terraform

Instead of creating the server manually, it is possible to use
[terraform with EGI Cloud Compute](https://docs.egi.eu/users/compute/cloud-compute/openstack/#terraform).

The
[Terraform OpenStack provider](https://registry.terraform.io/providers/terraform-provider-openstack/openstack/latest/docs)
provides official documentation.

Terraform provides
[installation instructions](https://www.terraform.io/downloads) for all usual
platforms.

Once terraform is installed locally, you can make use of it.

Setting up the environment (OS\_\* variables will be used by terraform):

> This assumes a working setup of
> [fedcloudclient](https://fedcloudclient.fedcloud.eu/), relying on
> [oidc-agent](https://indigo-dc.gitbook.io/oidc-agent/installation) to get OIDC
> tokens from [EGI Check-in](https://docs.egi.eu/users/aai/check-in/).

```shell
$ source ~/.virtualenvs/ui-deployment/bin/activate
$ export EGI_VO='vo.access.egi.eu'
$ export EGI_SITE='IN2P3-IRES'
# A valid OIDC_ACCESS_TOKEN should be available in the env
$ eval `fedcloud site env`
# Retrieve an OS_TOKEN for terraform
$ export OS_TOKEN=$(fedcloud openstack token issue --site "$EGI_SITE" \
    --vo "$EGI_VO" -j | jq -r '.[0].Result.id')
```

Configure flavor, image, network variables for the site you want to use, see
example of [`IN2P3-IRES.tfvars`](IN2P3-IRES.tfvars).

Review/adapt [cloud-init.yaml](cloud-init.yaml) to add your ssh key to the `egi`
user that will be created, without this you won't be able to log into the VM.

```shell
# Initialise working directory, install dependencies
$ terraform init
# Review plan of actions for creating the infrastructure
# Use relevant site-specific config file
$ terraform plan --var-file="${EGI_SITE}.tfvars"
# Create the infrastructure
# Manual approval can be skipped using -auto-approve
# The virtual machine IP will be returned by terraform
$ terraform apply --var-file="${EGI_SITE}.tfvars"
# Wait a few minutes for the setup to be finalised
# Connect to the server IP returned by terraform
$ ssh egi@SERVER_IP
```

### Debugging terraform

The token used by Terraform for accessing OpenStack is short lived, it will have
to be renewed from time to time.

```shell
# Creating a new token to access the OpenStack endpoint
$ export OS_TOKEN=$(fedcloud openstack token issue --site "$EGI_SITE"
    --vo "$EGI_VO" -j | jq -r '.[0].Result.id')
```

It is possible to print a verbose/debug output to get details on interactions
with the OpenStack endpoint.

```shell
# Debugging
OS_DEBUG=1 TF_LOG=DEBUG terraform apply --var-file="${EGI_SITE}.tfvars"
```

### Destroying the resources created by terraform

```shell
# Destroying the created infrastructure
terraform destroy --var-file="${EGI_SITE}.tfvars"
```
