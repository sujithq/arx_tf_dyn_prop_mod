output "principal_id" {
  value = var.stageName == "d" ? null : azurerm_data_factory.gendfanovsts[0].identity[0].principal_id
}