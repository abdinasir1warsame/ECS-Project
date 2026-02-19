variable "frontend_alb_sg" {
  type = string
}
variable "backend_alb_sg" {
  type = string
}
variable "public_subnets" {
  type = list(any)
}
variable "private_subnets" {
  type = list(any)

}
variable "vpc_id" {

}
variable "certificate_arn" {
  description = "ARN of the SSL certificate"
  type        = string
}
