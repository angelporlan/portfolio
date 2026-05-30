# --- Etapa 1: Dependencias ---
FROM node:20-alpine AS dependencies
WORKDIR /app
COPY package*.json ./
RUN npm install

# --- Etapa 2: Desarrollo (para recarga en vivo) ---
FROM dependencies AS development
COPY . .
EXPOSE 4321
CMD ["npm", "run", "dev", "--", "--host"]

# --- Etapa 3: Build para Producción ---
FROM dependencies AS builder
COPY . .
RUN npm run build

# --- Etapa 4: Runner (Servidor Nginx para producción) ---
FROM nginx:stable-alpine AS runner
COPY nginx.conf /etc/nginx/nginx.conf
COPY --from=builder /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
