---
title: "I built and shipped a SaaS in production — here's the full stack behind it"
subtitle: "Matchply is live. Stripe subscriptions, Docker, a self-hosted VPS, GitHub Actions CI/CD, and an LLM layer with multi-provider routing. This is how it came together."
date: 2026-05-31
tags: ["SaaS", "Docker", "GitHub Actions", "Stripe", "OpenRouter", "LLM", "Full Stack"]
lang: "en"
draft: false
translation: "2026-05-31/lanzamiento-matchply"
---

A few months ago I had an idea that felt genuinely useful: what if you could paste a job offer and get your CV rewritten — not generically, but precisely adapted to that role? Not a template filler. A tool that actually reads the offer, understands the language, and rewrites your profile to match.

That idea became Matchply. And today it's running in production, with real users, real subscriptions, and infrastructure I own end to end.

Here's what it took to get there.

## The problem worth solving

Sending the same CV to fifty job offers is ineffective — everyone knows that. But tailoring a CV manually for each application takes time most people don't have. The gap between knowing what to do and actually doing it is where Matchply lives. It automates the adaptation process so you can apply smarter, not harder.

> "The goal wasn't to build something clever. It was to build something people would actually pay for."

## The infrastructure layer

I wanted to own the deployment stack — not because it's easier (it isn't), but because it gives me full control over costs, performance, and data. Matchply runs on a self-hosted VPS, containerized with Docker. Every push to main triggers a GitHub Actions pipeline that builds the image, runs checks, and deploys automatically. Zero downtime. No manual SSH. Clean.

* **Runtime:** Docker + VPS
* **CI/CD:** GitHub Actions
* **Payments:** Stripe
* **AI Routing:** OpenRouter

## Payments that actually work

Stripe handles the subscription layer. Monthly and annual plans, webhook events for subscription state changes, and plan-gated features throughout the app. Getting this right — handling edge cases like failed payments, cancellations, and plan upgrades — took longer than I expected. But doing it properly from the start meant I didn't have to revisit it later.

## The AI layer: one API, multiple providers

This is the part I'm most proud of architecturally. Instead of hardcoding a single AI provider, Matchply routes all LLM calls through OpenRouter. This gives me access to dozens of models — GPT-4, Claude, Mistral, and others — through a single, unified API.

More importantly, it lets me serve different models to different subscription tiers. Free users get a capable but lighter model. Paid users get access to the most powerful options. The routing logic lives in one place, and swapping or adding models requires zero changes to the rest of the codebase.

## Three optimization modes

Matchply offers three CV adaptation strategies. The first stays faithful to your original experience. The second adapts the framing and language to match the offer. The third pushes hard on transferable skills and potential — useful when you're pivoting or applying to a stretch role. Each mode produces a meaningfully different output from the same input CV.

## What I learned shipping solo

Building and deploying a full product alone forces you to care about every layer — auth, billing, AI integration, deployment, error handling. You can't skip the boring parts because there's no one else to handle them. That constraint is also what makes it a real education.

Matchply is live at <a href="https://matchply.com" target="_blank" rel="noopener noreferrer">matchply.com</a>. If you're job hunting, try it.
