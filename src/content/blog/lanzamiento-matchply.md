---
title: "Cómo construí y lancé un SaaS en producción"
subtitle: "Stripe, Docker, GitHub Actions, OpenRouter — el stack completo detrás de Matchply"
date: 2026-06-06
tags: ["SaaS", "Docker", "IA y LLMs", "Stripe"]
lang: "es"
draft: false
---

Crear y lanzar un producto de software como servicio (SaaS) es un proceso increíble que pone a prueba todas las habilidades de un desarrollador. Hace poco publiqué **Matchply**, una plataforma que optimiza currículums de forma automatizada mediante modelos de lenguaje artificial para adaptarlos a las ofertas de empleo.

En este artículo, comparto las decisiones de arquitectura y tecnologías principales detrás del desarrollo del proyecto.

## Arquitectura e Infraestructura

Para garantizar que el despliegue fuese consistente en cualquier entorno, empaqueté toda la aplicación usando Docker:

- **Frontend**: Una SPA rápida construida con Next.js que gestiona el panel y los flujos de usuario.
- **Backend API**: Servicios optimizados en Node.js que ejecutan los algoritmos de parseo y optimización.
- **Base de Datos**: PostgreSQL para almacenar los perfiles de los usuarios y el historial de aplicaciones.

### Configuración de Docker Compose

Así es como estructuré el entorno de contenedores:

```yaml
services:
  web:
    build: .
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=production
      - DATABASE_URL=postgresql://user:pass@db:5432/matchply
```

## Integración de IA con OpenRouter

En lugar de vincular la plataforma a una única API de LLM (como la de OpenAI), utilicé **OpenRouter**. Esto permite a Matchply cambiar dinámicamente de modelo según el costo, ventana de contexto y complejidad de la oferta de trabajo:

1. **Preanálisis rápido**: Mediante modelos ligeros (como Llama 3) para mapear habilidades clave.
2. **Reescritura estratégica**: Mediante modelos avanzados (como GPT-4o) para redactar descripciones de experiencia que coincidan con la oferta de trabajo.

## Automatización y Despliegue (CI/CD)

Cada commit subido a la rama principal activa un flujo de trabajo en **GitHub Actions** que se encarga de:
- Pasar el linter de TypeScript y verificar que los tests unitarios sean exitosos.
- Reconstruir las imágenes de Docker optimizadas.
- Desplegar los nuevos contenedores en el servidor VPS de producción de forma automática.
