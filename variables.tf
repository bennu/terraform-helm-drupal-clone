variable name {
  description = "Value for drupal-clone name in pods"
  type        = string
  default     = ""
}

variable namespace {
  description = "Namespace where resources are deployed"
  type        = string
  default     = "default"
}

variable chart_repository {
  description = "Helm chart repository for drupal-clone"
  type        = string
  default     = "https://charts.bennu.cl"
}

variable chart_name {
  description = "Helm chart name for drupal-clone"
  type        = string
  default     = "drupal-clone"
}

variable chart_version {
  description = "Helm chart version for drupal-clone"
  type        = string
  default     = "1.0.7"
}

variable timeout {
  description = "Timeout for helm (in seconds)"
  type        = number
  default     = 1500
}

variable db_host {
  description = "Mysql database hostname"
  type        = string
  default     = ""
  
  validation {
    condition     = var.db_host != ""
    error_message = "Variable db_host shouldn't be empty."
  }
}

variable db_port {
  description = "Mysql database port"
  type        = string
  default     = "3306"
}

variable db_name {
  description = "Mysql database name"
  type        = string
  default     = ""

  validation {
    condition     = var.db_name != ""
    error_message = "Variable db_name shouldn't be empty."
  }
}

variable db_secret_name {
  description = "Secret name containing user and password for Mysql"
  type        = string
  default     = ""

  validation {
    condition     = var.db_secret_name != ""
    error_message = "Variable db_secret_name shouldn't be empty."
  }
}

variable s3_hostname {
  description = "s3 bucket or compatible bucket hostname"
  type        = string
  default     = ""

  validation {
    condition     = var.s3_hostname != ""
    error_message = "Variable s3_hostname shouldn't be empty."
  }
}

variable s3_assets_path {
  description = "path/to/assets/ inside s3 bucket or compatible"
  type        = string
  default     = ""

  validation {
    condition     = var.s3_assets_path != ""
    error_message = "Variable s3_assets_path shouldn't be empty."
  }
}

variable s3_assets_filename {
  description = "filename for assets file (tar.gz)"
  type        = string
  default     = ""

  validation {
    condition     = var.s3_assets_filename != ""
    error_message = "Variable s3_assets_filename shouldn't be empty."
  }
}

variable s3_custom_site_path {
  description = "path/to/custom/site inside s3 bucket or compatible"
  type        = string
  default     = ""
}

variable s3_custom_site_filename {
  description = "filename for custom site file (tar.gz)"
  type        = string
  default     = ""
}

variable s3_secret_name {
  description = "Secret name containing user and password for s3 bucket or compatible"
  type        = string
  default     = ""

  validation {
    condition     = var.s3_secret_name != ""
    error_message = "Variable s3_secret_name shouldn't be empty."
  }
}

variable pvc_create {
  description = "Create a new pvc for the deployment"
  type        = bool
  default     = true
}

variable pvc_memory {
  description = "Memory assigned for the new pvc (pvc_create should be true)"
  type        = string
  default     = "5Gi"
}

variable pvc_existing {
  description = "Name of a existing pvc which will be used for the deployment (pvc_create should be false)"
  type        = string
  default     = ""
}

variable preinstall_name {
  description = "name for the pre-install job"
  type        = string
  default     = "files-drupal"
}

variable preinstall_image_repository {
  description = "repository for image used for pre-install job"
  type        = string
  default     = "bennu/mc"
}

variable preinstall_image_tag {
  description = "tag for the image used for pre-install job"
  type        = string
  default     = "testV3"
}

variable postinstall_name {
  description = "name for the post-install job"
  type        = string
  default     = "migration=drupal"
}

variable postinstall_image_repositroy {
  description = "repository for image used for post-install job"
  type        = string
  default     = "bennu/php-cli"
}

variable postinstall_image_tag {
  description = "tag for the image used for post-install job"
  type        = string
  default     = "testv3"
}

variable phpfpm_image_repository {
  description = "repository for image used for php-fpm"
  type        = string
  default     = "bennu/php-fpm"
}

variable phpfpm_image_tag {
  description = "tag for the image used for php-fpm"
  type        = string
  default     = "testdrupal"
}

variable nginx_image_repository {
  description = "repository for image used for nginx"
  type        = string
  default     = "bennu/nginx"
}

variable nginx_image_tag {
  description = "tag for the image used for nginx"
  type        = string
  default     = "testv5.5"
}

variable image_pull_policy {
  description = "pull policy for the images used"
  type        = string
  default     = "IfNotPresent"
}

variable phpfpm_replica_count {
  description = "replica count for php-fpm"
  type        = number
  default     = 1
}

variable nginx_replica_count {
  description = "replica count for nginx"
  type        = number
  default     = 1
}

variable ingress_host {
  description = "Ingress host for drupal-clone"
  type        = string
  default     = ""
  validation {
    condition     = var.ingress_host != ""
    error_message = "Variable ingress_host shouldn't be empty."
  }

}

variable ingress_annotattions {
  description = "Annotations for drupal-clone ingress"
  type        = map
  default     = {}

  validation {
    condition     = length(var.ingress_annotattions) > 0
    error_message = "Map ingress_annotattions shouldn't be empty."
  }
}

variable git_name {
  description = "name of the git remote repository to download drupal code"
  type        = string
  default     = ""
}

variable git_url {
  description = "url of the git remote repository to download drupal code (it should not contain https://)"
  type        = string
  default     = ""
}

variable git_branch {
  description = "branch which will be downloaded from the git remote repository"
  type        = string
  default     = ""
}

variable settings_configmap_name {
  description = "Configmap name containing the settings.php file for drupal (It's only used when downloading drupal from git)"
  type        = string
  default     = ""

  validation {
    condition     = var.settings_configmap_name != ""
    error_message = "Variable settings_configmap_name shouldn't be empty."
  }
}

variable code_provider {
  description = "Name of the drupal code provider. Possible values: git, s3"
  type        = string
  default     = "git"

  validation {
    condition     = var.code_provider == "git" ||  var.code_provider == "s3"
    error_message = "Variable code_provider value should be git or s3."
  }
}

variable git_secret_name {
  description = "Name of the secret containing username and password of the git repository user"
  type        = string
  default     = ""
}

variable git_commit_hash {
  description = "Commit hash to clone an specific commit of the drupal code"
  type        = string
  default     = "" 
}
