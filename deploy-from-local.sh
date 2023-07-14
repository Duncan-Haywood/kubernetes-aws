# this is a script to deploy the infrastructure from local machine
# it should generally not be used in production
# but it is useful for personal devleopment and testing.

terraform init
terraform apply

# to destroy infrastructure:
terraform destroy
