# Modern integrations documentation

This repository contains the Modern documentation site, built with Mintlify.

## Repository structure

- `docs.json`: site configuration and navigation
- `index.mdx`: docs homepage
- `integrations/`: integration guides (one file per integration)
- `images/`: local image assets used by docs pages
- `snippets/`: reusable MDX snippets

## Prerequisites

- Node.js 18+ recommended
- Mintlify CLI

Install Mintlify CLI:

```bash
npm i -g mint
```

## Local development

From the repository root:

```bash
mint dev
```

Preview at `http://localhost:3000`.

## Validate links

Before opening a PR:

```bash
mint broken-links
```

## Writing standards

- Use active voice and second person ("you")
- Keep sentences concise
- Use sentence case for headings
- Bold UI labels: `Click **Settings**`
- Use code formatting for commands, file names, paths, and identifiers

See [CONTRIBUTING.md](CONTRIBUTING.md) and `AGENTS.md` for project-specific conventions.

## Image standards

- Store images in `images/`
- Reference images with local paths: `/images/<file-name>.png`
- Do not add `mintcdn.com/serval...` image URLs in docs pages

## Add or update an integration page

1. Create or edit `integrations/<slug>.mdx`
2. Add/update frontmatter (`title`, `description`)
3. Add the page path in `docs.json` under `navigation.tabs[].groups[]`
4. Run `mint dev` and `mint broken-links`

## Deployment

Changes are deployed by Mintlify after pushes to the default branch (when the Mintlify GitHub app is connected).

## AI-assisted docs work

Install Mintlify product knowledge for your AI coding tool:

```bash
npx skills add https://mintlify.com/docs
```

## Resources

- [Mintlify docs](https://mintlify.com/docs)
