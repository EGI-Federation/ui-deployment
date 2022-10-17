# Deploying an UI

Repo deploying a VM and provisioning a UI.

## Requirements

Python 3.

```shell
# Create a python3 virtualenv
python3 -m venv ~/.virtualenvs/ssc-ui-deployment
# Activate virtual env
source ~/.virtualenvs/ssc-ui-deployment/bin/activate
# Install required python modules
pip install -r requirements.txt
# Install required ansible modules
ansible-galaxy install -r requirements.yml
```

## Using

```shell
# Activate virtual env
source ~/.virtualenvs/ssc-ui-deployment/bin/activate
```

## Creating a test VM
