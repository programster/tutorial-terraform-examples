
output "NETBIRD_IDP_MGMT_CLIENT_SECRET" {
    value = keycloak_openid_client.netbird_backend_client.client_secret
    sensitive = true
}

output NETBIRD_AUTH_OIDC_CONFIGURATION_ENDPOINT {
    value = "${var.keycloak_url}/realms/netbird/.well-known/openid-configuration"
}

output "NETBIRD_AUTH_AUDIENCE" {
    value = keycloak_openid_client.netbird_application_client.client_id
}

output "NETBIRD_AUTH_DEVICE_AUTH_CLIENT_ID" {
    value = keycloak_openid_client.netbird_application_client.client_id
}

output "NETBIRD_USE_AUTH0" {
    value = false
}

output "NETBIRD_AUTH_SUPPORTED_SCOPES" {
    value = "openid profile email offline_access api"
}

output "NETBIRD_MGMT_IDP" {
    value = "keycloak"
}

output "NETBIRD_IDP_MGMT_CLIENT_ID" {
    value = keycloak_openid_client.netbird_backend_client.client_id
}

output "NETBIRD_IDP_MGMT_EXTRA_ADMIN_ENDPOINT" {
    value = "${var.keycloak_url}/admin/realms/netbird"
}

# output "keycloak_user_id" {
#     value = keycloak_user.netbird_admin_user.id
# }