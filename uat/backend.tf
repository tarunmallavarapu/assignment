
terraform{
    backend "s3" {
        bucket      = "test-braze1"
        profile     = "test"
        key         =  "test1/terraform.tfstate"
        encrypt     = "true"
        region      = "ap-northeast-2"
    }
}