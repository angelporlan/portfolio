---
title: "How I automated agent orchestration with an autonomous AI team"
subtitle: "Migrating Ceferly to React, Vite, Node.js, and Prisma autonomously with a local team of parallel-coordinated agents."
date: 2026-06-28
tags: ["AI", "Automation", "Docker", "Git", "Prisma", "React"]
lang: "en"
draft: false
translation: "2026-06-28/como-automatice-orquestacion-agentes"
cover: "./agent-orchestration.jpg"
---

A few months ago I started a project to practice my English and prepare for the B2/C1 exams. I decided it was time to rebuild it from scratch (**Ceferly**), dockerize it, and migrate the tech stack to **React + Vite**, **Node.js with TypeScript**, **PostgreSQL**, and **Prisma ORM**, using **OpenRouter** as the sole AI provider.

To get the AI to develop the project for me step-by-step and completely autonomously, we structured the following workflow.

## 1. Frictionless Git Identity Management (SSH + `includeIf`)

On my local machine, I use two Git accounts. To avoid conflicts when pushing code and to change identity automatically, I divide my projects into different directories and we configured an **`includeIf`** rule in my global `~/.gitconfig`.

This way, when working inside a specific directory, Git automatically applies the configuration assigned to that folder, signing commits with the corresponding identity and using the correct SSH key. Zero manual configuration from there on!

## 2. Controlling GitHub from the Terminal (GitHub CLI)

Using the official GitHub CLI (`gh`), we switched the active account to my personal user, allowing us to rename the remote repository from `quickgram` to `ceferly` with a single command:

```bash
gh repo rename ceferly -y
```

After renaming it, we updated the local URL to the new SSH remote to maintain a secure channel and prevent any credential friction.

## 3. The Secret of Agentic AI: Atomization into 60 Issues

Autonomous development AIs work infinitely better if the tasks are extremely small, concise, and bounded (preventing them from getting overloaded with context). We wrote an automation script in **Python** that:
*   Created **color-customized tags** on GitHub (`setup`, `backend`, `frontend`, `auth`, `database`, `ai`, `gamification`, `stripe`).
*   Bulk-populated **60 granular issues in English** in my GitHub repository, detailing the exact goal, minimum requirements, and files to modify for each.

> "Don't ask an AI to build your entire application at once. The secret lies in breaking down your vision into atomic, manageable tasks."

## 4. Launching the Autonomous Runner (`/goal` + `/teamwork-preview`)

To set **Antigravity**'s AI agents to work, we activated the long-term goal and multi-agent orchestration commands in the chat:

![Activating the Autonomous Runner](./runner-activation.jpg)

A collaborative team was spun up: a supervisor **Sentinel**, a task **Orchestrator**, and virtual **Developers**. The AI's autonomous workflow for each issue consisted of:

1.  Reading the issue from GitHub.
2.  Creating a dedicated Git branch (e.g., `feature/issue-3`).
3.  Implementing the files locally.
4.  Verifying that everything compiles and connects by spinning up the complete environment with **Docker Compose** (`docker-compose up --build -d`).
5.  Pushing to GitHub, opening a Pull Request, and automatically merging it to `main` after passing checks. If it fails, it pauses and asks for my feedback.

During this process, the system asked me key questions to align on decisions, such as how to handle compilation failures:

![Failed compilation question](./question-compilation-failure.jpg)

Or selecting the allowed development practices:

![Allowed practices question](./question-practices.jpg)

## 5. Resilience to Failures and Self-Healing

One of the most impressive features of this flow is the orchestrator's resilience. At one point during development, a failure was detected due to a network issue, and the control subagent acted autonomously to restore the state:

![Orchestrator self-healing message](./orchestrator-recovery.jpg)

🚀 **Outcome**: The AI has already resolved, tested, and integrated the repository's first issue (`[Setup] #1 - Configure root .gitignore`) 100% autonomously, opening and merging PR #62 without me having to write a single line of code.

Docker Compose acts as the perfect objective "referee" in automated development, verifying that the backend, frontend, and database compile and connect correctly before merging.
