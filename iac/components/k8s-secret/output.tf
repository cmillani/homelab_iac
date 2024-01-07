output "k8s_token" {
  value = format("%s.%s", random_password.lower.result, random_password.upper.result)
  sensitive = true
}
output "k8s_key" {
  value = random_bytes.cert_key.hex
  sensitive = true
}