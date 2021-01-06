## Drupal-clone module

This repo bring to use Drupal-clone helm chart.

### About

This module bring to use drupal-clone helm chart which help us to migrate and deploy a existing Drupal site with ease in K8s.

In any case, there are some previous steps that needs to be done before using this module.

- A existing and populated database accesible from K8s
- A s3 bucket (or compatible bucket) with a tar.gz file for Drupal itself 
- A s3 bucket (or compatible bucket) with a tar.gz file for the 'files' folder containing all the assets uploaded by the users
- A existing secret (basich-auth) containing the username and password for the database
- A existing secret (basich-auth containing the username and password for the s3 bucket 


### Requeriments

| Name | Version |
|:----:|:-------:|
| Terraform | `>= 0.13` |
| Kubernetes | `>= 1.16` |
| MySQL | `>= 5.5.3` |


### Chart

| Name | Repository | Version |
|:----:|:----------:|:-------:|
| drupal-clone | https://charts.bennu.cl | `>= 1.0.6` |



#### Example main.tf file

```hcl
module "my-site" {
  source                  = "bennu/drupal-clone/helm"
  version                 = "1.0.0"
  name                    = "my-drupal-website"
  namespace               = "my-namespace"
  db_host                 = "192.168.5.10"
  db_name                 = "my-database-name"
  db_secret_name          = "mysql-credentials"
  s3_hostname             = "https://my.s3.bucket/"
  s3_assets_path          = "path/to/files"
  s3_assets_filename      = "files.tar.gz"
  s3_custom_site_path     = "path/to/drupal"
  s3_custom_site_filename = "my-drupal-site.tar.gz"
  s3_secret_name          = "s3-credentials"
  ingress_host            = "my-drupal-site.k8s.com"
  ingress_annotattions = {
    "kubernetes.io/ingress.class"                    = "nginx"
    "nginx.ingress.kubernetes.io/force-ssl-redirect" = "true"
    "nginx.ingress.kubernetes.io/proxy-buffer-size"  = "16k"
    "nginx.ingress.kubernetes.io/ssl-redirect"       = "true"
  }
}
```

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
| s3_custom_site_path | path/to/custom/site inside s3 bucket or compatible | `string` | `""` | yes |
| s3_custom_site_filename | filename for custom site file (tar.gz)| `string` | `""` | yes |
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
| git_user | Username for git remote repository to download drupal code | `string` | `""` | no |
| git_password | Password for git remote repository to download drupal code | `string` | `""` | no |
| git_name | name of the git remote repository to download drupal code | `string` | `""` | no |
| git_url | "url of the git remote repository to download drupal code (it should not contain https://) | `string` | `""` | no |
| git_branch | branch which will be downloaded from the git remote repository | `string` | `""` | no |
| settings_configmap_name | Configmap name containing the settings.php file for drupal (It's only used when downloading drupal from git) | `string` | `""` | no |
| git_enabled | Enable download drupal code download from a git repository | `bool` | `false` | no |


