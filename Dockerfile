# --- Etapa 1: Build ---
FROM node:20-alpine AS builder
WORKDIR /app

# Copiar archivos de dependencias
COPY package*.json ./

# Instalar dependencias
RUN npm install

# Copiar el resto del código del proyecto
COPY . .

# Compilar la aplicación estática
RUN npm run build

# --- Etapa 2: Runner ---
FROM nginx:stable-alpine AS runner

# Copiar la configuración optimizada de Nginx
COPY nginx.conf /etc/nginx/nginx.conf

# Copiar los archivos estáticos construidos desde la etapa builder
COPY --from=builder /app/dist /usr/share/nginx/html

# Exponer el puerto por defecto de Nginx
EXPOSE 80

# Iniciar Nginx en primer plano
CMD ["nginx", "-g", "daemon off;"]
