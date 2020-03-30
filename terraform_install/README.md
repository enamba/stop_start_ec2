
First all to use this script you need to have access to target account by awscli.
Second, you need to download terraform 0.11 or higher https://www.terraform.io/downloads.html

After that steps run terraform command using 3 required parameters account, region_name and timezone_name, tags parameter is optional

Follow a example as execution.

```
terraform init
terraform apply \
  -var 'region_name=us-east-2' \
  -var 'account=748159021624' \
  -var 'timezone_name=Portugal' \
  -var 'tags={owner="XXXX"}'

  ```