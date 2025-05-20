variable "alb_sg_id" {
  type = list(string)
  description = "this is sg of lb"
}

variable "alb_subnet_ids" {
  description = "List of subnet IDs"
  type        = list(string)
}

variable "alb_tg_vpc_id" {
    type = string
  description = "this is target of lb"
}



