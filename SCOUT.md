# Codebase Scout Report: honc-uptime-monitor

## Overview
This project is a website uptime monitor built on the Cloudflare stack. It allows users to add websites to be monitored, tracks their uptime status and response times, and displays the results.

## Tech Stack
- **Runtime:** Cloudflare Workers
- **Framework:** Hono (Web Application Framework)
- **Database:** Drizzle ORM with SQLite (Cloudflare D1)
- **Scheduling:** Cloudflare Durable Objects (`Monitor` class)
- **Language:** TypeScript
- **Tooling:**
  - `wrangler`: Cloudflare development and deployment CLI
  - `biome`: Formatting and Linting
  - `fiberplane`: API exploration

## Key Components

### 1. Application Entry Point (`src/index.tsx`)
- Defines the Hono application.
- Serves the UI using Server-Side Rendering (SSR) with Hono's JSX renderer.
- Provides API endpoints for:
  - CRUD operations for websites (`/api/website`, `/api/websites`).
  - Fetching uptime checks (`/api/website/:id/checks`).
  - Calculating uptime statistics (`/websites/:id/uptime`).
- Initializes the `Monitor` Durable Object when a new website is created.

### 2. Database Schema (`src/db/schema.ts`)
- **`websites` table:** Stores website configuration (URL, name, check interval).
- **`uptimeChecks` table:** Stores the results of each check (timestamp, status, response time, isUp).

### 3. Monitor Durable Object (`src/monitor.ts`)
- The `Monitor` class is a Durable Object responsible for scheduling and executing uptime checks.
- It uses `setInterval` to perform periodic fetch requests to the target website.
- Results are logged to the D1 database.
- **Note:** The scheduling mechanism relies on `setInterval` within the Durable Object. While supported, consider if Cloudflare Alarms might be a more robust future improvement for long-term reliability.

## Getting Started

### Prerequisites
- Node.js installed.
- Cloudflare account (for `wrangler` login).

### Setup
1.  **Install Dependencies:**
    ```bash
    npm install
    ```
2.  **Database Setup:**
    Initializes the D1 database (create, generate, migrate, seed).
    ```bash
    npm run db:setup
    ```
3.  **Run Development Server:**
    Starts the local development environment.
    ```bash
    npm run dev
    ```

### Development Workflow
- **Linting/Formatting:** `npm run format`
- **Database Migrations:** `npm run db:generate` (create migration files) -> `npm run db:migrate` (apply locally).

## Next Steps
- Review `src/index.tsx` to understand the API flow.
- Check `src/monitor.ts` to understand how the monitoring loop works.
- Run the app locally and try adding a website to monitor.
