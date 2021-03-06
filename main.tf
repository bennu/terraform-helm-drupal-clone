resource random_string drupal-clone_name {
  count   = var.name == "" ? 1 : 0
  length  = 8
  special = false
  upper   = false
}

resource helm_release drupal-clone {
  name       = local.name
  atomic     = true
  repository = var.chart_repository
  chart      = var.chart_name
  version    = var.chart_version
  timeout    = var.timeout
  namespace  = var.namespace
  values = [
    yamlencode(
      {
        externalDatabase = {
          name       = var.db_name
          port       = var.db_port
          url        = var.db_host
          secretName = var.db_secret_name
        }
   
        codeProvider = local.code_provider_config
        
        persistenceClaim = {
          enabled       = var.pvc_create
          memory        = var.pvc_memory
          existingClaim = var.pvc_existing
        }
        jobs = {
          preInstall = {
            name = var.preinstall_name
            image = {
              repository = var.preinstall_image_repository
              tag        = var.preinstall_image_tag
              pullPolicy = var.image_pull_policy
            }
          }
          postInstall = {
            settingsConfigMap = var.settings_configmap_name
            name              = var.postinstall_name
            image = {
              repository = var.postinstall_image_repositroy
              tag        = var.postinstall_image_tag
              pullPolicy = var.image_pull_policy
            }
          }
        }
        phpFpm = {
          replicaCount = var.phpfpm_replica_count
          image = {
            repository = var.phpfpm_image_repository
            pullPolicy = var.image_pull_policy
            tag        = var.phpfpm_image_tag
          }
        }
        nginx = {
          replicaCount = var.nginx_replica_count
          image = {
            repository = var.nginx_image_repository
            pullPolicy = var.image_pull_policy
            tag        = var.nginx_image_tag
          }
          ingress = {
            annotations = var.ingress_annotattions
          }
          ingressHost = var.ingress_host
        }
      }
    )
  ]
}
