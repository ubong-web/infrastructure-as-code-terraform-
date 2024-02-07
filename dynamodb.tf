resource "aws_dynamodb_table" "views" {
  name           = "views"
  billing_mode   = "PROVISIONED"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "UserId"


   attribute {
    name = "UserId"
    type = "S"
  }
 

}

resource "aws_dynamodb_table_item" "views" {
  table_name = aws_dynamodb_table.views.name
  hash_key   = aws_dynamodb_table.views.hash_key

  item = <<ITEM
{
  "UserId": {"S": "0"},
  "views":{"N": "0"}
 
}
ITEM
}

resource "aws_appautoscaling_target" "dynamodb_table_read_target" {
  max_capacity       = 10
  min_capacity       = 1
  resource_id        = "table/views"
  scalable_dimension = "dynamodb:table:ReadCapacityUnits"
  service_namespace  = "dynamodb"
}

resource "aws_appautoscaling_target" "dynamodb_table_write_target" {
  max_capacity       = 10
  min_capacity       = 1
  resource_id        = "table/views"
  scalable_dimension = "dynamodb:table:WriteCapacityUnits"
  service_namespace  = "dynamodb"
}