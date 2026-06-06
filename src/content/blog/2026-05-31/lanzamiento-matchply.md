---
title: "Lancé mi primer SaaS en producción — esto es todo lo que hay detrás"
subtitle: "Matchply ya está en producción. Suscripciones con Stripe, Docker, VPS propio, CI/CD con GitHub Actions y una capa de IA con enrutamiento multi-proveedor. Así fue el proceso."
date: 2025-06-01
tags: ["SaaS", "Docker", "GitHub Actions", "Stripe", "OpenRouter", "LLM", "Full Stack"]
lang: "es"
draft: false
translation: "2026-05-31/matchply-launch"
---

Hace unos meses tuve una idea que me pareció genuinamente útil: ¿y si pudieras pegar una oferta de trabajo y obtener tu CV reescrito — no de forma genérica, sino adaptado con precisión a ese puesto? No un rellena-plantillas. Una herramienta que lee la oferta, entiende el lenguaje y reescribe tu perfil para encajar.

Esa idea se convirtió en Matchply. Y hoy está corriendo en producción, con usuarios reales, suscripciones reales e infraestructura que controlo de principio a fin.

Esto es lo que hizo falta para llegar aquí.

## El problema que vale la pena resolver

Enviar el mismo CV a cincuenta ofertas es ineficaz — todo el mundo lo sabe. Pero adaptar el CV manualmente para cada candidatura requiere un tiempo que casi nadie tiene. La brecha entre saber lo que hay que hacer y realmente hacerlo es donde vive Matchply. Automatiza el proceso de adaptación para que puedas aplicar de forma más inteligente.

> "El objetivo no era construir algo ingenioso. Era construir algo por lo que la gente pagara."

## La capa de infraestructura

Quería ser dueño del stack de despliegue — no porque sea más fácil (no lo es), sino porque me da control total sobre costes, rendimiento y datos. Matchply corre en un VPS propio, containerizado con Docker. Cada push a main dispara un pipeline de GitHub Actions que construye la imagen, ejecuta checks y despliega automáticamente. Sin downtime. Sin SSH manual. Limpio.

* **Runtime:** Docker + VPS
* **CI/CD:** GitHub Actions
* **Pagos:** Stripe
* **Enrutamiento IA:** OpenRouter

## Pagos que funcionan de verdad

Stripe gestiona toda la capa de suscripciones. Planes mensuales y anuales, eventos webhook para cambios de estado, y features bloqueadas por plan en toda la app. Hacerlo bien — gestionar edge cases como pagos fallidos, cancelaciones y cambios de plan — llevó más tiempo del esperado. Pero hacerlo bien desde el principio significa no tener que retocarlo después.

## La capa de IA: una API, múltiples proveedores

Esta es la parte de la que más orgulloso estoy a nivel de arquitectura. En lugar de hardcodear un único proveedor de IA, Matchply enruta todas las llamadas LLM a través de OpenRouter. Esto me da acceso a decenas de modelos — GPT-4, Claude, Mistral y otros — a través de una API unificada.

Más importante aún, me permite servir modelos distintos según el plan de suscripción. Los usuarios del plan gratuito obtienen un modelo capaz pero más ligero. Los de pago acceden a las opciones más potentes. La lógica de enrutamiento vive en un único lugar y añadir o cambiar modelos no requiere tocar nada más en el codebase.

## Tres modos de optimización

Matchply ofrece tres estrategias de adaptación del CV. La primera permanece fiel a tu experiencia original. La segunda adapta el enfoque y el lenguaje para encajar con la oferta. La tercera aprieta al máximo las habilidades transferibles y el potencial — útil cuando estás pivotando o apuntando a un rol más ambicioso. Cada modo produce un output significativamente diferente a partir del mismo CV de entrada.

## Lo que aprendí lanzando en solitario

Construir y desplegar un producto completo solo te obliga a ocuparte de cada capa — auth, facturación, integración IA, despliegue, manejo de errores. No puedes saltarte las partes aburridas porque no hay nadie más para hacerlas. Esa restricción es también lo que lo convierte en una educación real.

Matchply está en producción en [matchply.com](https://matchply.com). Si estás buscando trabajo, pruébalo.
