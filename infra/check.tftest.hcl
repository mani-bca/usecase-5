run "setup_tests" {
    module {
        source = "git::https://github.com/mani-bca/set-aws-infra.git//modules/s3?ref=main"
        source = "git::https://github.com/mani-bca/set-aws-infra.git//modules/sns?ref=main"
    }
}