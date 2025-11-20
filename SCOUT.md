# Codebase Scout Report: honc-uptime-monitor

**Last Updated:** November 19, 2025

## Overview
This is a serverless website uptime monitoring application built with the HONC stack (Hono, OpenTelemetry, and Cloudflare). It monitors multiple websites simultaneously, tracks response times and HTTP status codes, and calculates uptime percentages.

## Architecture

### Core Components

1. **Entry Point** (`src/index.tsx`)
   - Hono web application with RESTful API endpoints
   - Serves SSR UI using Hono's JSX renderer
   - API routes: `/api/websites`, `/api/website/:id`, `/api/website/:id/checks`, `/websites/:id/uptime`
   - Creates Monitor Durable Objects when websites are added

2. **Database Layer** (`src/db/schema.ts`)
   - `websites` table: stores URL, name, check interval, creation date
   - `uptimeChecks` table: stores check results (timestamp, status, response time, isUp)
   - Uses Drizzle ORM for type-safe database operations

3. **Monitoring Engine** (`src/monitor.ts`)
   - Durable Object that handles periodic health checks
   - Uses `setInterval` for scheduling (runs every X seconds per website)
   - Performs HTTP requests and stores results in D1 database

4. **UI Components** (`src/components/WebsiteList.tsx`)
   - Simple card-based interface showing monitored websites
   - Displays name, URL, and check interval for each site

### Data Flow
1. User adds website via API → creates database record
2. Monitor Durable Object created → schedules periodic checks
3. Monitor performs HTTP requests → stores results in uptimeChecks table
4. UI/API queries database → displays current status and historical data

## Development Commands
- `npm run dev` - Start local development server
- `npm run db:setup` - Initialize database (create, migrate, seed)
- `npm run format` - Format code with Biome
- `npm run deploy` - Deploy to Cloudflare Workers

## Key Files to Understand
- `src/index.tsx:62-96` - Website creation logic with Monitor initialization
- `src/monitor.ts:90-133` - Core health check implementation
- `src/db/schema.ts:7-24` - Database schema definition

## When Resuming Development

### Quick Start Tasks:
1. Run `npm run dev` to start local server
2. Visit `http://localhost:8787` to see the UI
3. Add a website via the API: `POST /api/website` with `{url, name, checkInterval}`
4. Check logs to verify Monitor is running checks

### Common Development Tasks:
- **Add new API endpoints**: Extend routes in `src/index.tsx`
- **Modify database schema**: Update `src/db/schema.ts`, then run `npm run db:generate && npm run db:migrate`
- **Improve monitoring logic**: Edit `src/monitor.ts` (check intervals, retry logic, etc.)
- **Enhance UI**: Modify components in `src/components/`

### Current Limitations to Address:
- No error handling on some API endpoints (marked with TODO comments)
- No authentication/authorization
- Basic UI with no real-time updates
- No alerting when sites go down
- Limited to 100 most recent checks per website

The codebase is well-structured and follows Cloudflare Workers patterns. Start with the API endpoints and Monitor logic when making changes.