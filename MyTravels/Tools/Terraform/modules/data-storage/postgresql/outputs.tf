output "address" {
 value = aws_db_instance.db.address
 description = "Connect to the database at this endpoint"
}

output "port" {
 value = aws_db_instance.db.port
 description = "The port the database is listening on"
}

output "db_name" {
 value = aws_db_instance.db.db_name
 description = "The database name"
}

output "username" {
 value = aws_db_instance.db.username
 description = "The database name"
}