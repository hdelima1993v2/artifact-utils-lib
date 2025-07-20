locals {
  semantic_version = try(regex("^version\\s*=\\s*\"([0-9\\.]+)\"", file("${path.module}/../pyproject.toml"))[0], "0.0.0")
  final_version    = local.semantic_version != "" ? local.semantic_version : "0.0.0"
}
