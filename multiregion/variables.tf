variable "regions" {
  type = map(string)
  default = {
    "tokyo"     = "ap-northeast-1",
    "singapore" = "ap-southeast-1"
  }
}