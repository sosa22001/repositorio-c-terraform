variable "subscription_id" {
    description = "ID de la suscripción de Azure"
    type        = string
}

variable "project"{
    type = string
    description = "Nombre proyecto"
    default = "ecommerce"
}

variable "location"{
    type = string
    description = "Locación del despliegue de recursos en azure"
    default = "Central US"
}

variable "environment"{
    type = string
    description = "Entorno de despliegue"
    default = "dev"
}

variable "tags"{
    description = "Etiquetas de los recursos"
    type = map(string)
    default = {
        environment = "development"
        date = "marzo-2025"
        createdBy = "Terraform"
    }
}

variable "admin_sql_password"{
    type = string
    description = "Contraseña para el administrador de la base de datos"
    default = "AAbbcc123."
}