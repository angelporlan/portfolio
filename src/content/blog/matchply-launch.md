---
title: "I built and shipped a SaaS in production"
subtitle: "Stripe, Docker, GitHub Actions, OpenRouter — the full stack behind Matchply"
date: 2026-06-06
tags: ["SaaS", "Docker", "AI & LLMs", "Stripe"]
lang: "en"
draft: false
---

Building and launching a software-as-a-service (SaaS) product is an incredible journey that tests all dimensions of a software engineer's skillset. Recently, I launched **Matchply**, a platform designed to automatically optimize resumes for job postings using AI language models.

Here is a breakdown of the core decisions and stack choices behind the launch.

## Architecture and Infrastructure

To ensure scalability and consistency across different environments, I containerized the entire stack using Docker:

- **Frontend & Router**: A Next.js application handling the dashboard and onboarding flows.
- **Backend API**: Optimized Node.js services executing the resume optimization algorithms.
- **Database**: PostgreSQL storing candidates' profiles, historical applications, and token analytics.

### Docker Compose Configuration

Here is a look at the base development container setup:

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

## AI Integrations with OpenRouter

Instead of coupling the product to a single LLM provider like OpenAI, I integrated **OpenRouter**. This allowed Matchply to dynamically switch models depending on the cost, context window, and complexity requirements of each candidate's resume:

1. **Fast Analysis**: Using lightweight models (e.g., Llama-3-8B) for initial job scan.
2. **Deep Optimization**: Using larger models (e.g., GPT-4o) for adjusting the professional summary and experience descriptions to align with key criteria.

## Continuous Integration & Deployment (CI/CD)

Every commit pushed to the main branch triggers a **GitHub Actions** workflow that:
- Runs TypeScript syntax checks and unit tests.
- Rebuilds the production Docker image.
- Deploys the updated containers to the host VPS.
