variable "account" {
  type        = "string"
  description = "account id"
}

variable "timezone_name" {
  type        = "string"
  description = "timezone to define hours to stop and start Ex.: America/Sao_Paulo"
}

variable "region_name" {
  type        = "string"
  description = "region name of aws ex.: us-east-1"
}

variable "tags" {
  type        = "map"
  default     = {}
  description = "lista de tags"
}


