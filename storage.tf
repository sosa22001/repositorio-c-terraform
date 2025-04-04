resource "random_string" "db_suffix" {
  length  = 4
  special = false
  upper   = false
}

//Esta solo es la máquina a la que nos vamos a conectar remotamente de sqlserver
resource "azurerm_mssql_server" "sqlserver" {
  name = "dbserver-${var.project}${var.environment}${random_string.db_suffix.result}"
  resource_group_name          = data.azurerm_resource_group.rg.name
  location                     = var.location
  version                      = "12.0"
  administrator_login          = "sql_admin"
  administrator_login_password = var.admin_sql_password

  tags = var.tags
}


//esta sería la base de datos:
resource "azurerm_mssql_database" "db" {
    name = "db${var.project}${random_string.db_suffix.result}"
    server_id = azurerm_mssql_server.sqlserver.id
    sku_name = "S0"

    tags = var.tags
}

//Base de datos de caché:
resource "azurerm_redis_cache" "db-cache" {
  name                 = "db-redis-${var.project}"
  location             = var.location
  resource_group_name  = data.azurerm_resource_group.rg.name
  capacity             = 1
  family               = "C"
  sku_name             = "Basic"
  non_ssl_port_enabled = false
  minimum_tls_version  = "1.2"

  redis_configuration {
  }

  tags = var.tags
}

# Crear el Service Plan para Azure Functions
resource "azurerm_service_plan" "func_plan" {
  name                = "func-service-plan-${var.project}-${var.environment}"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg.name
  os_type             = "Linux"
  sku_name            = "B1"
}


//Vamos a crear la función serverless para que se active cuando haya un mensaje en la cola q1.
# Ahora, el Function App puede usar esta cola como trigger
resource "azurerm_linux_function_app" "func_app" {
  name                       = "serverless-${var.project}"
  location                   = var.location
  resource_group_name        = data.azurerm_resource_group.rg.name
  service_plan_id            = azurerm_service_plan.func_plan.id  # Usando el Service Plan
  storage_account_name       = data.azurerm_storage_account.saccount.name
  storage_account_access_key = data.azurerm_storage_account.saccount.primary_access_key

  site_config {
    
  }

  tags = var.tags
}