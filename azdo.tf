resource "azuredevops_project" "this" {
  name        = "AWS Service Endpoint ${var.env}"
  description = "Usage: management of service endpoints across the organization"
  features = {
    "artifacts"    = "disabled"
    "boards"       = "disabled"
    "pipelines"    = "disabled"
    "repositories" = "disabled"
    "testplans"    = "disabled"
  }
}

resource "azuredevops_serviceendpoint_aws" "this" {
  project_id            = azuredevops_project.this.id
  service_endpoint_name = "aws"
  access_key_id         = aws_iam_access_key.this.id
  secret_access_key     = aws_iam_access_key.this.secret
}
