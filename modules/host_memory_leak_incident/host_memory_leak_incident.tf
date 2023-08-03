resource "shoreline_notebook" "host_memory_leak_incident" {
  name       = "host_memory_leak_incident"
  data       = file("${path.module}/data/host_memory_leak_incident.json")
  depends_on = [shoreline_action.invoke_process_memory_check]
}

resource "shoreline_file" "process_memory_check" {
  name             = "process_memory_check"
  input_file       = "${path.module}/data/process_memory_check.sh"
  md5              = filemd5("${path.module}/data/process_memory_check.sh")
  description      = "Memory leaks in the software running on the host machine."
  destination_path = "/agent/scripts/process_memory_check.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_process_memory_check" {
  name        = "invoke_process_memory_check"
  description = "Memory leaks in the software running on the host machine."
  command     = "`chmod +x /agent/scripts/process_memory_check.sh && /agent/scripts/process_memory_check.sh`"
  params      = ["PROCESS_NAME","MEMORY_THRESHOLD","MEMORY_USED","PATH_TO_LOG_FILE"]
  file_deps   = ["process_memory_check"]
  enabled     = true
  depends_on  = [shoreline_file.process_memory_check]
}

