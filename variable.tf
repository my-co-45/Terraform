# variable  "instance_type"  {
#  description = "instance_type t3.large"
#   type     = string
#   default  = "t3.large"
# }


# variable "user_names" {
#   description = "IAM usernames"
#   type        = list(string)
#   default     = ["vk1", "vk2", "vk3"]
# }

# variable "instance_type" {
#     type = string
#     default = "t3.micro"
# }



# variable "userage"{
#     type = map
#     default = {
#         vishakha = 23
#         neha = 40
#     }

# }

# output "userage" {
#     value = "my name is vishakha and my age is ${lookup(var.userage,"vishakha")}"
  
# }
  

#   variable "ingressrules" {
#   type = list(number)
#   default = [80,443,8080,22]
# }

# variable "egressrules" {
#   type = list(number)
#   default = [80,443,8080,22]
# }

# variable "vpc_id" {}
    

# variable "instance1_id" {}
# variable "instance2_id" {}
# variable "subnet1" {}
# variable "subnet2" {}
