# CORRECCIÓN CONTENEDOR: Imagen base moderna y actualizada
FROM python:3.11-slim

WORKDIR /app

# Crear usuario no privilegiado
RUN useradd -m appuser

COPY app/ /app/
RUN pip install --no-cache-dir -r requirements.txt
# Cambiar a usuario no-root
USER appuser

# --- AGREGAR ESTA SECCIÓN DE HEALTHCHECK ---
# Verifica cada 30 segundos si el servidor responde en el puerto 8080
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:8080/', timeout=2)" || exit

EXPOSE 8080
CMD ["python", "app.py"]
