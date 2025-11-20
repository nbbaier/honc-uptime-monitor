# Agent Guidelines

## Commands
- **Dev Server**: `npm run dev` (Wrangler)
- **Deploy**: `npm run deploy`
- **Lint/Format**: `npm run format` (Biome)
- **DB Setup**: `npm run db:setup` (Touch, Generate, Migrate, Seed)
- **Testing**: No automated tests currently. Verify manually via `npm run dev`.

## Code Style
- **Stack**: Cloudflare Workers, Hono, Drizzle ORM (D1), TypeScript.
- **Formatting**: Use Biome (`npm run format`). Tabs for indentation, double quotes.
- **Naming**: camelCase for vars/funcs, PascalCase for components/classes.
- **Imports**: Organized by Biome. Group 3rd party, then local.
- **Structure**: Entry: `src/index.tsx`. Components: `src/components/`. DB: `src/db/`.
- **Types**: Strict TypeScript. Define types for Hono bindings and Drizzle schemas.
- **Error Handling**: Wrap DB/Fetch ops in try-catch. Return JSON errors (400/500).
