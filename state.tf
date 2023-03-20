terraform{
    backend "s3" {
        bucket = "terraform-codepipeline068"
        encrypt = true
        key = "terraform.tfstate"
        region = "us-east-1"
    }
}

provider "aws" {
    region = "us-east-1"
    version = "3.13.0"

}