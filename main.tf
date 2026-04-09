module "tools" {
  for_each = var.tools
  source = "./module-ec2"
  tool_name = each.key
  sg_port = each.value["port"]
  volume = each.value["port"]
}