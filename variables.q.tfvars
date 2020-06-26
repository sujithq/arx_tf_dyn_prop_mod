  stageName = "q"
  
  kv_policies = [
    {
    object_id = "data.azurerm_client_config.current.object_id"    
    key_permissions = [
      "create",
      "get",
    ]
    secret_permissions = [
      "set",
      "get",
      "delete",
    ]
    }
    ,{
      object_id = "b32d73b1-3277-43ac-afb6-b14c28507d2d"   #PT - Data Gateway Platform - IT
      key_permissions = [
        "create",
        "get"]
      secret_permissions = [
        "set",
        "get",
        "list",
        "delete"]
    }
    ,{
    object_id = "14b93bc2-b6c0-4cc8-af76-d15734ff2ba4"   #PT - Data Gateway Platform - Admin

    key_permissions = [
      "create",
      "get",
    ]

    secret_permissions = [
      "set",
      "get",
      "list",
      "delete",
    ]
    }
    ,{
    object_id = "azurerm_data_factory.gendfanovsts[0].identity[0].principal_id"  #DFA managed identity
    key_permissions = [
      "create",
      "get",
    ]
    secret_permissions = [
      "set",
      "get",
      "list",
      "delete",
    ]
    }
  ]