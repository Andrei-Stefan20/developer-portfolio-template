---
title: "Template guide"
layout: article
lang: en
permalink: /guide/
date: 2026-07-14
category: "Documentation"
excerpt: "How to edit identity, content, translations and appearance, and how to publish updates."
no_alternates: true
---

Every part of the portfolio is driven by text and configuration files: routine work never requires touching code. This page collects the most common tasks.

## Repository structure

Everything you'll need to edit regularly lives in four places. The rest (`_layouts/`, `_includes/`, `css/`, `js/`) is the template's machinery and rarely needs to change.

| What | Where | When to touch it |
|---|---|---|
| Identity, languages, appearance | `_config.yml` | Name, role, social links, colors |
| Content | `entries/` | One project or article, one file per language |
| Interface text | `_data/locales/` | Labels, headings, messages |
| Images | `images/` | Covers and thumbnails for content |

Locally, run `bundle exec jekyll serve` and open `http://localhost:4000` to see every change before publishing it.

## Site identity

Name, role, links and description are read from `_config.yml` and appear in the header, home page and footer.

```yaml
author:
  name: "Your Name"
  role: "Your Role"
  education: "Your Second Role or Field of Study"
  location: "Your City, Country"
  email: ""
  github: "https://github.com/yourname"
  linkedin: "https://linkedin.com/in/..."
  cv: "/files/cv.pdf"
```

Any field left empty (`""`) automatically disappears from the interface: no need to comment out or delete lines, just empty them.

To add a downloadable CV, drop the PDF into `files/` (e.g. `files/cv.pdf`) and point `author.cv` at that path. It must start with `/` and match the file name exactly. This adds a "CV" link to the header and footer; leaving `cv: ""` hides that link entirely.

![Home page with profile, biography and recent content](/docs/readme/guide/home.png)

## Adding a project

Every project lives in `entries/projects/<slug>/`, with one Markdown file per language. The `slug` must be identical across languages: that's how the language switcher finds the matching page.

1. Create `entries/projects/project-name/en.md` and `it.md` (start from `content-templates/project.md`).
2. Fill in the front matter:

```yaml
---
title: "Project title"
type: project
layout: case-study
lang: en
slug: project-name
permalink: /entries/project-name/
date: 2026-01-15
role: "Machine Learning Engineering"
technologies: [Python, PyTorch]
thumbnail: "/images/projects/project-name/thumb.png"
cover: "/images/projects/project-name/cover.png"
code: "https://github.com/yourname/repo"
excerpt: "Short summary shown in listings."
---
```

Every non-default language needs its own permalink, prefixed the same way as its top-level pages (`lang: it` → `permalink: /it/entries/project-name/`). Reusing the English permalink makes Jekyll silently overwrite one language's page with the other at build time.

3. Add cover and thumbnail images under `images/projects/project-name/` (same folder name as the slug).
4. Check it locally: the project immediately shows up in Projects, on the home page among the latest entries, and in the Archive. No other file needs updating.

![Project list with thumbnails](/docs/readme/guide/work.png)

![Project detail page](/docs/readme/guide/case-study.png)

## Adding an article

Same logic as projects, under `entries/articles/<slug>/`, with `layout: article` instead of `case-study` and a couple of extra editorial fields.

```yaml
---
title: "Article title"
type: article
layout: article
lang: en
slug: article-name
permalink: /entries/article-name/
date: 2026-01-15
category: "Knowledge Graphs"
read_time: 8
cover: "/images/articles/article-name/cover.png"
excerpt: "Short abstract for listings and social previews."
---
```

Same rule as projects: give the `it` version its own `/it/entries/article-name/` permalink instead of reusing the English one.

The body is written in plain Markdown below the front matter: headings, paragraphs, inline images with `![alt](/images/...)`.

![Article list with date, category and read time](/docs/readme/guide/writing.png)

## Translations and adding a language

Every interface label (menus, buttons, headings, empty-state messages) lives in `_data/locales/en.yml` and `it.yml`, never hand-written inside a template.

![Archive page in English](/docs/readme/guide/archive-en.png)

![Archive page in Italian](/docs/readme/guide/archive-it.png)

To add a new language (e.g. Spanish):

1. Copy `_data/locales/en.yml` to `_data/locales/es.yml` and translate the values.
2. Register the language in `_config.yml` under `languages.available`.
3. Duplicate the top-level pages (`index.html`, `work.html`, etc.) into an `/es/` folder: front matter with `lang: es` and a permalink, body reduced to a single {% raw %}`{% include page-*.html %}`{% endraw %}. The real content stays in the shared includes.

Every translated project or article must share the same `slug` across languages: that's the key that links the versions together in the language switcher.

## Color, background and typeface

Three visual options are set from `_config.yml`, under `appearance:`, and also become buttons visitors can change themselves (their choice is remembered in the browser).

```yaml
appearance:
  accent_color: "#2b2b2b"
  background_pattern: "grid"   # none, grid, dots
  theme_mode: "auto"           # auto, light, dark
  font_style: "default"        # default, hand
```

![Grid background pattern](/docs/readme/guide/bg-grid.png)

![Dots background pattern](/docs/readme/guide/bg-dots.png)

## The three buttons in the top right

Background pattern, handwritten font and light/dark theme are three independent buttons in `_includes/site-header.html`. Each button is self-contained: deleting its block simply makes the linked script in `js/` a no-op, nothing else needs to change.

- `.bg-toggle`: cycles none, grid, dots.
- `.font-toggle`: toggles the handwritten font.
- `.theme-toggle`: switches between light and dark.

![Mobile navigation menu open, with the three buttons at the bottom](/docs/readme/guide/mobile-menu.png)

To **hide** one or more buttons, open `_includes/site-header.html` and delete the matching block:

```html
<button type="button" class="bg-toggle" ...>
  ...
</button>

<button type="button" class="font-toggle" ...>
  ...
</button>

<button type="button" class="theme-toggle" ...>
  ...
</button>
```

Delete one of the three `<button>...</button>` blocks to remove that button everywhere on the site (desktop and mobile, since the header is a single shared include).

If you remove `theme-toggle`, the theme is still chosen automatically based on the visitor's operating system thanks to `theme_mode: "auto"`. Removing the button only removes the ability to switch it manually.

## Comments and analytics

Both are off until you fill in the configuration: no external script loads by default.

**Comments (Giscus, via GitHub Discussions):**

```yaml
discussions:
  enabled: true
  repo: "yourname/yourname.github.io"
  repo_id: "..."
  category: "Announcements"
  category_id: "..."
```

The `repo_id` and `category_id` values come from the official generator at giscus.app, after enabling Discussions on the repository.

**Analytics (Plausible):**

```yaml
analytics:
  plausible_domain: "yoursite.github.io"
```

Just a domain: if the field is left empty, no analytics script is included on the page.

## Validating and publishing

Before any significant push:

```bash
ruby scripts/validate_site.rb
bundle exec jekyll build
```

`validate_site.rb` checks the required `_config.yml` fields, every content file's front matter, the configured languages, duplicate permalinks, and referenced local images.

Every push to `main` automatically triggers the GitHub Actions pipeline: Jekyll build → Pagefind search index → GitHub Pages publish. No manual step is required.

## Quick file map

| File / folder | Contains |
|---|---|
| `_config.yml` | Identity, languages, appearance, integrations |
| `_data/locales/*.yml` | All interface text, per language |
| `entries/projects/<slug>/` | One `.md` file per language, per project |
| `entries/articles/<slug>/` | One `.md` file per language, per article |
| `images/projects/`, `images/articles/` | Covers and thumbnails, grouped by slug |
| `content-templates/` | Starting front matter for new content |
| `_includes/site-header.html` | Menu, appearance buttons, language switcher |
| `_includes/page-*.html` | Shared body for the home/work/writing/about pages |
| `scripts/validate_site.rb` | Automated check before publishing |
