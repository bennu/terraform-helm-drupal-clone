## Drupal-clone module

This repo bring to use Drupal-clone helm chart.

### About

This module bring to use drupal-clone helm chart which help us to migrate and deploy a existing Drupal site with ease in K8s.

In any case, there are some previous steps that needs to be done before using this module.

- A existing and populated database accesible from K8s
- A s3 bucket (or compatible bucket) with a tar.gz file for Drupal itself or a git remote repository with Drupal 
- A s3 bucket (or compatible bucket) with a tar.gz file for the 'files' folder containing all the assets uploaded by the users
- A existing secret (basic-auth) containing the username and password for the database
- A existing secret (basic-auth containing the username and password for the s3 bucket 

### Requeriments

| Name | Version |
|:----:|:-------:|
| Terraform | `>= 0.13` |
| Kubernetes | `>= 1.16` |
| MySQL | `>= 5.5.3` or what is needed by Drupal |


### Chart

| Name | Repository | Version |
|:----:|:----------:|:-------:|
| drupal-clone | https://charts.bennu.cl | `>= 1.0.7` |



#### Example main.tf file

```hcl
module "my-drupal-site" {

  source  = "bennu/drupal-clone/helm"
  version = "1.0.3"
  name                          = "my-drupal-site"
  namespace                     = "my-namespace"
  db_host                       = "192.168.1.5"
  chart_version                 = "1.0.7"
  code_provider                 = "s3"
  preinstall_image_repository   = "bennu/mc"
  preinstall_image_tag          = "testV3"
  settings_configmap_name       = "my-settings-configmpa"
  db_name                       = "my-database"
  db_secret_name                = "mysql-credentials"
  s3_hostname                   = "https://my.s3.com"
  s3_assets_path                = "path/to/asserts"
  s3_assets_filename            = "my-assets.tar.gz"
  s3_secret_name                = "s3-credentials"
  s3_custom_site_path           = "path/to/site/code"
  s3_custom_site_filename       = "my-site-code.tar.gz"
  ingress_host                  = "my-site.my-domain.com"
  ingress_annotattions = {
    "kubernetes.io/ingress.class"                    = "nginx"
    "nginx.ingress.kubernetes.io/force-ssl-redirect" = "true"
    "nginx.ingress.kubernetes.io/proxy-buffer-size"  = "16k"
    "nginx.ingress.kubernetes.io/ssl-redirect"       = "true"
  }
}

```

#### Drupal code provider

For now, there are two ways to migrate a existing Drupal website using Drupal clone:

- s3 Bucket or compatbiel
- Git remote repository

You need to specify which provider will be used, assigned the value s3 or git to the input code_provider

| Name | Description | Type | Default | Required |
|:----:|:-----------:|:----:|:-------:|:--------:|
| code_provider | Name of the drupal code provider. Possible values: git, s3 | `string` | `"git"` | yes |

Depending of the chosen value, you will need to assign certain values

#### Needed inputs for s3 provider

| Name | Description | Type | Default | Required |
|:----:|:-----------:|:----:|:-------:|:--------:|
| s3_custom_site_path | path/to/custom/site inside s3 bucket or compatible | `string` | `""` | no |
| s3_custom_site_filename | filename for custom site file (tar.gz)| `string` | `""` | no |

#### Needed inputs for git provider
| Name | Description | Type | Default | Required |
|:----:|:-----------:|:----:|:-------:|:--------:|
| git_name | name of the git remote repository to download drupal code | `string` | `""` | no |
| git_url | "url of the git remote repository to download drupal code (it should not contain https://) | `string` | `""` | no |
| git_branch | branch which will be downloaded from the git remote repository | `string` | `""` | no |
| settings_configmap_name | Configmap name containing the settings.php file for drupal (It's only used when downloading drupal from git) | `string` | `""` | yes |
| code_provider | Name of the drupal code provider. Possible values: git, s3 | `string` | `"git"` | yes |
| git_secret_name | Name of the secret containing username and password of the git repository user | `string` | `""` | no |
| git_commit_hash | Commit hash to clone an specific commit of the drupal code | `string` | `""` | no |

#### Cloning an specific commit

If you need to deploy an specific commit from your git, you can set the following variable:

| Name | Description | Type | Default | Required |
|:----:|:-----------:|:----:|:-------:|:--------:|
| git_commit_hash | Commit hash to clone an specific commit of the drupal code | `string` | `""` | no |


#### Inputs
| Name | Description | Type | Default | Required |
|:----:|:-----------:|:----:|:-------:|:--------:|
| name | Value for drupal-clone name in pods | `string` | `""` | no |
| namespace | Namespace where resources are deployed | `string` | `"default"` | no |
| chart_repository | Helm chart repository for drupal-clones | `string` | `"https://charts.bennu.cl"` | no |
| chart_name | Helm chart name for drupal-clone | `string` | `"drupal-clone"` | no |
| chart_version  | Helm chart version for drupal-clone | `string` | `"1.0.5"` | no |
| timeout | Timeout for helm (in seconds) | `number` | `1200` | no |
| db_host | Mysql database hostname | `string` | `""` | yes |
| db_port | Mysql database port | `string` | `"3306"` | no |
| db_name | Mysql database name | `string` | `""` | yes |
| db_secret_name | Secret name containing user and password for Mysql | `string` | `""` | yes |
| s3_hostname | s3 bucket or compatible bucket hostname | `string` | `""` | yes |
| s3_assets_path | path/to/assets/ inside s3 bucket or compatible | `string` | `""` | yes |
| s3_assets_filename | filename for assets file (tar.gz) | `string` | `""` | yes |
| s3_custom_site_path | path/to/custom/site inside s3 bucket or compatible | `string` | `""` | no |
| s3_custom_site_filename | filename for custom site file (tar.gz)| `string` | `""` | no |
| s3_secret_name | Secret name containing user and password for s3 bucket or compatible| `string` | `""` | yes |
| pvc_create | Create a new pvc for the deployment | `bool` | `true` | no |
| pvc_memory | Memory assigned for the new pvc (pvc_create should be true) | `string` | `"5Gi"` | no |
| pvc_existing | Name of a existing pvc which will be used for the deployment (pvc_create should be false) | `string` | `""` | no |
| preinstall_name | name for the pre-install job | `string` | `"files-drupal"` | no |
| preinstall_image_repository | repository for image used for pre-install job | `string` | `"minio/mc"` | no |
| preinstall_image_tag | tag for the image used for pre-install job | `string` | `"RELEASE.2020-12-18T10-53-53Z"` | no |
| postinstall_name | name for the post-install job | `string` | `"migration=drupal"` | no |
| postinstall_image_repositroy | repository for image used for post-install job | `string` | `"bennu/php-cli"` | no |
| postinstall_image_tag | tag for the image used for post-install job | `string` | `"testv3"` | no |
| phpfpm_image_repository | repository for image used for php-fpm | `string` | `"bennu/php-fpm"` | no |
| phpfpm_image_tag | tag for the image used for php-fpm | `string` | `"testdrupal"` | no |
| nginx_image_repository | repository for image used for nginx | `string` | `"bennu/nginx"` | no |
| nginx_image_tag | tag for the image used for nginx | `string` | `"testv5.5"` | no |
| image_pull_policy | pull policy for the images used | `string` | `"IfNotPresent"` | no |
| phpfpm_replica_count | replica count for php-fpm | `number` | `1` | no |
| nginx_replica_count | replica count for nginx| `number` | `1` | no |
| ingress_host | Ingress host for drupal-clone | `string` | `""` | yes |
| ingress_annotattions | Annotations for drupal-clone ingress | `map` | `{}` | yes |
| git_name | name of the git remote repository to download drupal code | `string` | `""` | no |
| git_url | "url of the git remote repository to download drupal code (it should not contain https://) | `string` | `""` | no |
| git_branch | branch which will be downloaded from the git remote repository | `string` | `""` | no |
| settings_configmap_name | Configmap name containing the settings.php file for drupal (It's only used when downloading drupal from git) | `string` | `""` | yes |
| code_provider | Name of the drupal code provider. Possible values: git, s3 | `string` | `"git"` | yes |
| git_secret_name | Name of the secret containing username and password of the git repository user | `string` | `""` | no |
| git_commit_hash | Commit hash to clone an specific commit of the drupal code | `string` | `""` | no |




