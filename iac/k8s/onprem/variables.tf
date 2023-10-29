variable "tags" {
  description = "AWS add to each resource"
  type        = map(string)
  default     = {}
}

variable "namespace" {
  description = "namespace to place the service"
  type        = string
  default     = "satellite"
}
