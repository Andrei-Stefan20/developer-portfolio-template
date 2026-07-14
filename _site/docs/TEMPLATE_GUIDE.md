# Template customization guide

This repository can be reused as a personal portfolio without changing the layouts or application code.

## 1. Identity and deployment

Edit `_config.yml` first:

- `title`, `description`, `url`, `baseurl`, and `repository`;
- the fields under `author`;
- the available languages;
- appearance and optional integrations.

For a user site such as `username.github.io`, keep `baseurl` empty. For a project site such as `username.github.io/portfolio`, set `baseurl: "/portfolio"`.

## 2. Visible text

All interface labels and biography copy live in:

```text
_data/locales/en.yml
_data/locales/it.yml
```

Add another locale file when introducing a language, then register it under `languages.available` in `_config.yml`.

## 3. Content

Projects and articles are kept separate from presentation code:

```text
entries/projects/<slug>/<language>.md
entries/articles/<slug>/<language>.md
```

Translations must share the same `slug`. Use the files in `content-templates/` as a starting point.

## 4. Images

Keep content assets grouped by slug:

```text
images/projects/<slug>/
images/articles/<slug>/
```

Use root-relative paths in front matter. Liquid templates apply `relative_url`, so the same content works for user and project sites.

## 5. Validation

Run these commands before publishing:

```bash
ruby scripts/validate_site.rb
bundle exec jekyll build
```

The validator checks required configuration, front matter, supported languages, duplicate entries, permalinks, and referenced local images.

## 6. Shared modules

The main layout is intentionally small. Shared responsibilities live in dedicated includes:

```text
_includes/head-preferences.html
_includes/head-alternates.html
_includes/site-assets.html
_includes/site-header.html
_includes/site-footer.html
_includes/site-scripts.html
```

Content cards and archive rendering are also reusable includes. Prefer extending an existing include instead of duplicating markup in language-specific pages.

## 7. Safe update workflow

For substantial template changes:

1. create a branch;
2. run validation and the Jekyll build;
3. open a pull request;
4. check the rendered site on desktop and mobile;
5. merge only after the Pages workflow passes.
