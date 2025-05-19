# 📦 Infraestructura-Config

**Implementación de despliegue e integración continua de un sistema de reservas web para una microempresa del sector gastronómico.**

---

## 👥 Colaboradores del Proyecto

| Nombre            | Rol                                | Perfil                     |
|------------------|-------------------------------------|----------------------------|
| Javier Aguilar    | Líder del Proyecto y Backend Dev   | [LinkedIn/Javier Aguilar]() |
| Dylan Acevedo     | Base de Datos y Backend Dev        | [LinkedIn/Dylan Acevedo]()  |
| Orlando Padilla   | Seguridad y QA                     | —                          |
| Gino Guevara      | Diseño y Frontend Dev              | [LinkedIn/Gino Guevara]()   |
| Jaime Palomino    | Frontend Dev                       | [LinkedIn/Jaime Palomino]() |

---

## 🎯 Objetivos

- Comprender y aplicar los fundamentos de **despliegue** e **integración continua**.
- Automatizar la infraestructura usando **Terraform**.
- Configurar **Jenkins** como orquestador de CI/CD.
- Desplegar el sistema de reservas en **AWS EC2**, con servicios complementarios como **S3**, **RDS** y **Lambda**.
- Asegurar el proceso mediante validaciones automáticas y buenas prácticas de seguridad.

---

## 🏢 Contexto de Negocio

El proyecto responde a la necesidad de una microempresa gastronómica que busca mejorar su servicio a través de un sistema web de reservas. Inicialmente alojado en servidores gratuitos, se requiere ahora una infraestructura profesional que permita escalar, asegurar y mantener la aplicación eficientemente.

La solución propuesta:
- Infraestructura en AWS
- Automatización con Terraform
- Jenkins como CI/CD
- Entornos reproducibles y seguros

---

## 🧱 Arquitectura General

Servicios clave:
- **EC2**: alojamiento del backend y frontend.
- **RDS**: base de datos relacional (PostgreSQL o MySQL).
- **S3**: almacenamiento de recursos estáticos (ej. imágenes).
- **Lambda**: posibles tareas automatizadas o servicios sin servidor.

> El diagrama será añadido en formato Lucidchart o Excalidraw.

---

## 🔁 Flujo CI/CD

1. El desarrollador hace un `git push`.
2. Jenkins detecta el cambio.
3. Se ejecuta:
   - Validación del código e infraestructura (`lint`, `tfsec`, pruebas).
   - `terraform plan` y `terraform apply`.
   - Despliegue de la app al EC2.
4. Jenkins notifica resultado (Slack/Email).

---

## 🛠️ Tecnologías Utilizadas

| Herramienta   | Propósito                                 |
|---------------|--------------------------------------------|
| Terraform     | Provisión de infraestructura en AWS        |
| Jenkins       | Pipeline CI/CD automatizado                |
| GitHub        | Repositorio y control de versiones         |
| AWS (EC2, RDS, S3, Lambda) | Servicios de infraestructura    |
| Nginx / Apache| Servidor web (en EC2)                      |

---

## 🔐 Seguridad

- Uso de `GitHub Secrets` y variables de entorno.
- Revisión de seguridad en código Terraform (`tfsec`, `checkov`).
- Control de acceso IAM en AWS.
- Auditoría de cambios vía Git y Jenkins.

---

## 📦 Estructura del Repositorio

```bash
├── infra/                # Archivos Terraform
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
├── jenkins/
│   └── Jenkinsfile
├── app/
│   ├── backend/
│   └── frontend/
├── README.md
```

---

## 🚀 Comandos de Despliegue

### 🔧 Inicializar Terraform
```bash
cd infra/
terraform init
```

### 📐 Ver plan de cambios
```bash
terraform plan
```

### ✅ Aplicar infraestructura
```bash
terraform apply
```



## 📅 Estado Actual

✅ Planificación  
✅ Infraestructura en Terraform  
🔄 Integración en Jenkins (en proceso)  
🔲 Despliegue final y validaciones  
🔲 Documentación completa
