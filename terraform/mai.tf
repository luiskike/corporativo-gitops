provider "local" {}

# 1. simular la creacion de un servidor (como si fuera EC2 aws)
resource "local_file" "servidor_produccion" {
  content  = "servidor Ubuntu 24.04 - IP:192.168.1.100"
  filename = "${path.module}/servidor_simulado.txt"
}

# puente de conexion TA, crear el host.ini para ansible
resource "local_file" "generar_inventario_ansible" {
  content = <<EOF
[produccion]
localhost ansible_connection=local

[produccion:vars]
entorno=produccion_critica
EOF

  filename = "../ansible/host.ini"

  # obligando a terraform a crear el servidor PRIMERO
  depends_on = [local_file.servidor_produccion]
}
