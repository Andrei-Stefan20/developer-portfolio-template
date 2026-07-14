---
published: false
---

# Add content here

This is the only folder you need for projects and articles.

- Create a folder per project under `projects/<slug>/`, or per article under `articles/<slug>/`.
- Inside it, add one file per language: `en.md`, `it.md`, etc. Start from `content-templates/project.md` or `content-templates/article.md`.
- Use the same `slug` in every language's front matter: that's how the language switcher finds the matching page.
- Give each non-default language its own permalink (e.g. `/it/entries/<slug>/`). Reusing the English one makes Jekyll silently overwrite one language's page with the other at build time.
- Fill in the fields between `---` and write the full content below them.

The `date` field controls the order everywhere, including the mixed home feed.
