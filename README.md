# versent-create-new-snowflake-user

Prerequisites:
1. AWS CLI installation
2. stax2aws (https://support.stax.io/hc/en-us/articles/4428445276943-About-stax2aws)


### Setup python virtual environment
```
pip install virtualenv
python -m venv venv
venv\Scripts\Activate
```

### Install python modules in venv
```
pip install wheel
pip install -r requirements.txt
```
### How to use AWS CLI to call Snowflake stored procedure

1. Log in to stax2aws ans select the staxid-admin-role when prompted
2. aws sts
3. Use below template to call invoke the lambda function
   On the payload parameter sample, change the email address with the correct email address for the new user
    ```
   aws lambda invoke \
   --profile stax-stax-au1-versent \
   --region ap-southeast-2 \
   --function-name  versent-create-new-snowflake-user out \
   --cli-binary-format raw-in-base64-out \
   --payload '{"email_address": "it_support_test7.acct@versent.com.au"}' \
   --log-type Tail \
   --query 'LogResult' \
   --output text --cli-binary-format raw-in-base64-out | base64 --decode
   ```
   Execution logs will be visible in the terminal.

### AWS SAM Deployment

1. Clone the repository to local machine
2. Log in to stax2aws and select the staxid-admin-role for the role when prompted 
    ```
    stax2aws login --installation stax-au1 --org-alias versent -f
    ```
3. After signing in stax2aws, use the generated profile name to log in via aws cli
    ```
   aws sts get-caller-identity --profile stax-profile-name
   ```
4. Open cmd on the repository path to start deploying if there are changes on the code or config of the resources.
    For the very first build, execute the command below to create samconfig.toml file which stores all the default config
    ```
   sam build --guided --profile stax-profile-name
   ```
   For the succeeding build, the command below can be used.
    ```
   sam build --profile stax-profile-name
   ```
   Remember to change stax-profile-name with the correct profile name provided upon logging in to stax2aws



