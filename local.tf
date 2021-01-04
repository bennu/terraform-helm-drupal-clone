locals {
  name = var.name == "" ? format("drupal-clone-%s", random_string.drupal-clone_name.0.result) : var.name
}
