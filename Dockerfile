# Utilizar la imagen base de Ubuntu 20.04
FROM ubuntu:20.04

# Establecer variables de entorno para evitar interacciones durante la instalación
ENV DEBIAN_FRONTEND=noninteractive

# Actualizar e instalar dependencias necesarias
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    vim \
    git \
    python3-pip \
    python3-venv \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Descargar e instalar Ollama
RUN curl -fsSL https://ollama.com/install.sh | sh

# Configurar directorio de datos persistentes para Ollama
RUN mkdir -p /root/.ollama && chown -R root:root /root/.ollama

# Exponer el puerto de Ollama
EXPOSE 11434

# Script de arranque que inicia Ollama y descarga modelos si no existen
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Comando de inicio
CMD ["/entrypoint.sh"]
