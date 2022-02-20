    terraform {
      backend "remote" {
        # The name of your Terraform Cloud organization.
        organization = "kenny_org"

        # The name of the Terraform Cloud workspace to store Terraform state files in.
        workspaces {
          name = "wordpress-demo"
        }
      }
    }
