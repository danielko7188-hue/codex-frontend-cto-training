# Tools

## `harvest-reference-bank.ps1`

Purpose:

- read a curated reference manifest
- verify URLs when possible
- generate structured markdown entries
- save metadata snapshots
- optionally capture desktop and mobile screenshots with Playwright

## Recommended usage

Run in batches by category instead of trying to harvest everything in one giant command.

### Metadata-only pass

```powershell
& "C:/Users/wsk71.DKO/Desktop/Frontend Developer/design-memory/tools/harvest-reference-bank.ps1" `
  -ManifestPath "C:/Users/wsk71.DKO/Desktop/Frontend Developer/design-memory/manifests/2026-04-07-minimalist-premium-reference-set.json" `
  -OverwriteMarkdown
```

### Screenshot pass

```powershell
& "C:/Users/wsk71.DKO/Desktop/Frontend Developer/design-memory/tools/harvest-reference-bank.ps1" `
  -ManifestPath "C:/Users/wsk71.DKO/Desktop/Frontend Developer/design-memory/manifests/2026-04-07-minimalist-premium-reference-set.json" `
  -PlaywrightCli "C:/Users/wsk71.DKO/Desktop/AI Inbound Revenue Agent for Remodeling/apps/web/node_modules/.bin/playwright.cmd" `
  -CaptureScreenshots `
  -OverwriteMarkdown `
  -MaxItems 8
```

## Notes

- Some sites block plain HTTP fetches but still render fine in a browser screenshot.
- A blocked fetch should not stop the entry from being saved.
- Screenshot capture is slower, so prefer smaller category-sized batches.

## `ingest-source-library.ps1`

Purpose:

- read a curated open-source frontend learning manifest
- verify docs and repo URLs
- generate structured source-library markdown entries
- save metadata snapshots
- optionally shallow-clone selected repos for later study

## Recommended usage

### Metadata-only pass

```powershell
& "C:/Users/wsk71.DKO/Desktop/Frontend Developer/design-memory/tools/ingest-source-library.ps1" `
  -ManifestPath "C:/Users/wsk71.DKO/Desktop/Frontend Developer/design-memory/manifests/2026-04-07-open-source-frontend-learning-pack.json" `
  -OverwriteMarkdown
```

### Metadata plus shallow clones

```powershell
& "C:/Users/wsk71.DKO/Desktop/Frontend Developer/design-memory/tools/ingest-source-library.ps1" `
  -ManifestPath "C:/Users/wsk71.DKO/Desktop/Frontend Developer/design-memory/manifests/2026-04-07-open-source-frontend-learning-pack.json" `
  -OverwriteMarkdown `
  -CloneRepos `
  -MaxItems 3
```

## Notes

- This is for learning frontend structure, not copying whole products.
- Source-library entries should teach implementation quality, not replace the visual reference-bank.
- Shallow clones are the right default because full-history clones are usually unnecessary for study.
