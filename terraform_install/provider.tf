provider "aws" {
  allowed_account_ids = ["${var.account}"]
  region              =  "${var.region_name}"
}
