output "address" {
  value       = module.db.address
  description = "Connect to the database at this endpoint"
}

output "port" {
  value       = module.db.port
  description = "The port the database is listening on"
}

output "db_name" {
  value       = module.db.db_name
  description = "The database name"
}

output "username" {
  value       = module.db.username
  description = "The database name"
}