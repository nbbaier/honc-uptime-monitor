# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a serverless website uptime monitoring application built on Cloudflare's HONC stack (Hono + OpenTelemetry + Neon/D1 + Cloudflare). The application monitors website availability by performing periodic health checks using Cloudflare Durable Objects and stores results in a D1 database.

## Key Architecture

### Core Components

1. **Hono Application** (`src/index.tsx`): Main web server providing:
   - RESTful API for CRUD operations on monitored websites
   - JSX-rendered UI for viewing monitored sites
   - OpenAPI spec generation and Fiberplane integration at `/fp/*`

2. **Durable Objects Monitor** (`src/monitor.ts`): Singleton class that:
   - Schedules periodic uptime checks for each website using `setInterval`
   - Performs HTTP health checks and records response time, status codes, and availability
   - Each website gets its own Durable Object instance identified by website ID
   - Alternative to Cloudflare Workers Cron Triggers (noted in comments)

3. **Database Schema** (`src/db/schema.ts`):
   - `websites` table: Stores monitored websites (url, name, checkInterval)
   - `uptime_checks` table: Stores check results with cascade delete on website removal
   - Uses Drizzle ORM with SQLite/D1 dialect

### Configuration Files

- **wrangler.jsonc**: Cloudflare Workers configuration
  - D1 database binding: `DB`
  - Durable Objects binding: `SCHEDULED_MONITOR` → `Monitor` class
  - Uses new SQLite classes migration (`migrations.new_sqlite_classes`)

- **drizzle.config.ts**: Environment-aware Drizzle configuration
  - Local: Auto-discovers `.sqlite` file in `.wrangler/` directory
  - Production: Uses D1 HTTP driver with credentials from `.prod.vars`

## Development Commands

### Database Setup (Local)

```bash
# Complete local database setup (first time)
npm run db:setup  # Runs: db:touch → db:generate → db:migrate → db:seed

# After schema changes
npm run db:generate  # Generate migration files from schema.ts
npm run db:migrate   # Apply migrations to local D1 database

# Optional: Seed database with test data
npm run db:seed

# View database in Drizzle Studio
npm run db:studio
```

### Development Server

```bash
npm run dev  # Start Wrangler dev server
```

### Code Quality

```bash
npm run format  # Format and lint with Biome
```

## Deployment

### Database Setup (Production)

1. Create `.prod.vars` file with Cloudflare credentials:
   - `CLOUDFLARE_D1_TOKEN`: API token with D1 edit permissions
   - `CLOUDFLARE_ACCOUNT_ID`: Account ID from Workers & Pages dashboard
   - `CLOUDFLARE_DATABASE_ID`: Database ID from D1 console

2. Run production migrations:
```bash
npm run db:migrate:prod  # Uses ENVIRONMENT=production
```

### Deploy Application

```bash
npm run deploy           # Deploy with minification
npm run postdeploy       # Auto-runs db:migrate:dtw (remote migration)
```

Note: `db:migrate:dtw` applies migrations to the remote database named `DB` (the binding name).

## Important Patterns

### Durable Objects Lifecycle

When a new website is created (`POST /api/website`):
1. Website record is inserted into D1 database
2. A Durable Object is retrieved/created using `idFromName(websiteId)`
3. The Monitor's `/schedule` endpoint is called with the website ID
4. Monitor fetches website details from D1 and starts `setInterval` timer

Each website has a dedicated Durable Object instance that persists its check schedule.

### Database Operations

- All database interactions use Drizzle ORM with the `drizzle(c.env.DB)` pattern
- Type-safe schema exports: `Website`, `NewWebsite`, `NewUptimeCheck`
- Timestamps stored as ISO strings in SQLite text columns
- Booleans stored as integers with `{ mode: "boolean" }`

### UI Rendering

- Uses Hono's JSX renderer with CSS-in-JS (`hono/css`)
- Components in `src/components/` export typed functional components
- Main UI route renders server-side HTML with inline styles

## Technology Stack

- **Framework**: Hono (lightweight web framework)
- **Database**: Cloudflare D1 (serverless SQLite)
- **ORM**: Drizzle ORM
- **Runtime**: Cloudflare Workers
- **Scheduler**: Durable Objects (instead of Cron Triggers)
- **Observability**: Fiberplane + OpenTelemetry
- **Formatter**: Biome
