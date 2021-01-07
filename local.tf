locals {
  name = var.name == "" ? format("drupal-clone-%s", random_string.drupal-clone_name.0.result) : var.name

  code_s3 = var.code_provider == "s3" ? local.code_s3_config : {}
  code_s3_config = {
    name               = var.code_provider 
    s3Bucket           = var.s3_hostname
    assetsRoute        = var.s3_assets_path
    customSiteRoute    = var.s3_custom_site_path
    assetsFileName     = var.s3_assets_filename
    customSiteFileName = var.s3_custom_site_filename
    s3BucketSecretName = var.s3_secret_name
  }

  code_git = var.code_provider == "git" ? local.code_git_config : {}
  code_git_config = {
    name               = var.code_provider 
    gitRepoName        = var.git_name 
    gitRepo            = var.git_url 
    gitBranch          = var.git_branch
    gitSecretName      = var.git_secret_name 
    commitHash         = var.git_commit_hash
    s3BucketSecretName = var.s3_secret_name
    s3Bucket           = var.s3_hostname
    assetsRoute        = var.s3_assets_path
    assetsFileName     = var.s3_assets_filename
  }

  code_provider_config = merge(local.code_s3, local.code_git)

}
