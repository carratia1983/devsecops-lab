#checkov:skip=CKV_AWS_18: "Bucket logging no requerido en lab"
#checkov:skip=CKV_AWS_144: "Replicacion no requerida en lab"

provider "aws" {
  region = "us-east-1"
}

# 1. CONFIGURACIÓN DEL BUCKET S3
# checkov:skip=CKV_AWS_18: "No se requiere access logging para este laboratorio"
# checkov:skip=CKV_AWS_144: "No se requiere replicación entre regiones en entorno de desarrollo"
# checkov:skip=CKV_AWS_145: "No se requiere encriptación KMS personalizada para esta demo"
# checkov:skip=CKV2_AWS_61: "No se requiere ciclo de vida en este laboratorio"
# checkov:skip=CKV2_AWS_62: "No se requieren notificaciones de eventos para esta prueba"
resource "aws_s3_bucket" "bucket_seguro" {
  bucket        = "mi-bucket-devsecops-demo-12345"
  force_destroy = true
}

# Asegura que el versionado pase de forma nativa sin skips adicionales
resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.bucket_seguro.id
  versioning_configuration {
    status = "Enabled"
  }
}


# 2. CONFIGURACIÓN DEL GRUPO DE SEGURIDAD
# checkov:skip=CKV2_AWS_5: "El grupo de seguridad no se adjunta a una instancia en este paso del laboratorio"
resource "aws_security_group" "sg_seguro" {
  name        = "sg_ssh_restringido"
  description = "Grupo de seguridad restringido para lab" # Corrección CKV_AWS_23 (Descripción del recurso)

  ingress {
    description = "Acceso SSH restringido" # Corrección CKV_AWS_23 (Descripción de la regla interna)
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }
}
