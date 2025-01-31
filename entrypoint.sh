#!/bin/bash

# Matar cualquier instancia previa de Ollama (opcional)
pkill -f "ollama serve"

# Iniciar Ollama en segundo plano y redirigir salida para evitar bloqueo
OLLAMA_HOST=0.0.0.0 ollama serve > /dev/null 2>&1 &

# Esperar hasta que Ollama esté en ejecución
while ! pgrep -f "ollama serve" > /dev/null; do
    sleep 1
done

echo "Ollama está en ejecución en 0.0.0.0."

# Lista de modelos a verificar y descargar si no están presentes
models=(
    "deepseek-r1:1.5b"
    "deepseek-coder:6.7b"
    # "mistral:7b"
    # "gemma:2b"
    # "mixtral:8x7b"
    # "starcoder:15b"
    # "codellama:34b"
)

# Descargar modelos si no están presentes
for model in "${models[@]}"; do
    if ! ollama list | awk '{print $1}' | grep -qE "^$model$"; then
        echo "Descargando modelo: $model..."
        ollama pull "$model"
    else
        echo "El modelo $model ya está presente."
    fi
done

echo "Todos los modelos están listos."

# Mantener el proceso en ejecución
wait
