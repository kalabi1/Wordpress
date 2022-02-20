variable "vpc_cidr" {
  default     = "10.0.0.0/16"
  description = "the cidr block of the vpc"
}
variable "sub_cidr_1" {
  default     = "10.0.1.0/24"
  description = "the cidr block of pub sub"
}
variable "az_1" {
  default     = "eu-west-2a"
  description = "the zone to be created"
}
variable "az_2" {
  default     = "eu-west-2c"
  description = "the zone to be created"
}
variable "all_cidr" {
  default     = "0.0.0.0/0"
  description = "the route cidr"
}
variable "port_ssh" {
  default     = "22"
  description = "port for the ssh"
}
variable "port_http" {
  default     = "80"
  description = "the port for http"
}
variable "port_proxy5" {
  default     = "8085"
  description = "the port for proxy"
}
variable "port_proxy4" {
  default     = "8084"
  description = "the port for proxy"
}
variable "port_proxy3" {
  default     = "8083"
  description = "the port for proxy"
}
variable "port_proxy2" {
  default     = "8082"
  description = "the port for proxy"
}
variable "port_proxy1" {
  default     = "8081"
  description = "the port for proxy"
}
variable "port_proxy" {
  default     = "8080"
  description = "the port for proxy"
}
variable "PATH_TO_PUBLIC_KEY" {
  default     = "./Pap_key.pub"
  description = "path to Public key"
}
variable "ami" {
  default     = "ami-0ad8ecac8af5fc52b"
  description = "ami for instance"
}
variable "type" {
  default     = "t2.small"
  description = "instance type"
}
