terraform{
    backend "s3" {
        bucket      = "coyni-eu-testbucket"
        profile     = "test"
        key         =  "test2/terraform.tfstate"
        encrypt     = "true"
        region      = "ap-northeast-2"
    }
}