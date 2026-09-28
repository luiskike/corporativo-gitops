pipeline {
    agent any

    environment {
        // Garantiza que terraform resuelva aunque el servicio Jenkins
        // no haya recogido todavia el PATH de usuario actualizado.
        PATH = "C:\\Users\\EQUIPO\\bin;${env.PATH}"
        TF_DIR  = "C:\\Users\\EQUIPO\\terraform"
        ANS_DIR = "C:\\Users\\EQUIPO\\ansible"
    }

    stages {
        stage('1. Descargar Codigo') {
            steps {
                echo 'Simulando git clone del repositorio...'
                bat 'wsl -- bash -lc "ls -la /mnt/c/Users/EQUIPO/terraform /mnt/c/Users/EQUIPO/ansible"'
            }
        }

        stage('2. Planificacion (Terraform Plan)') {
            steps {
                bat 'where terraform'
                bat "cd /d %TF_DIR% && terraform init"
                bat "cd /d %TF_DIR% && terraform plan"
            }
        }

        stage('3. Aprobacion Manual (Gatekeeper)') {
            steps {
                input message: 'El terraform plan se ve correcto? Aprobar infraestructura', ok: 'Aprobar y Desplegar'
            }
        }

        stage('4. Aprovisionamiento (Terraform Apply)') {
            steps {
                bat "cd /d %TF_DIR% && terraform apply -auto-approve"
                // El apply regenera el inventario que consume el stage 5.
                bat "type %ANS_DIR%\\host.ini"
            }
        }

        stage('5. Configuracion Ansible') {
            steps {
                echo 'Esperando 5 seg a que la red del servidor se estabilice'
                sleep 5
                // Publica en WSL el inventario [produccion] recien generado
                // por Terraform junto al playbook de handlers, y lo ejecuta.
                bat 'wsl -- bash -lc "mkdir -p ~/ansible-clase && cp /mnt/c/Users/EQUIPO/ansible/host.ini /mnt/c/Users/EQUIPO/ansible/playbook_handlers.yml ~/ansible-clase/ && cd ~/ansible-clase && ansible-playbook -i host.ini playbook_handlers.yml"'
            }
        }
    }
}
