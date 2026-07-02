# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

A personal website published to GitHub Pages (https://francisco-kim.github.io), authored in
**Emacs Org-mode** and exported to static HTML. It hosts musical compositions and
musicological analyses (currently the Fuga I), mixing prose, scores, audio, and
Python/`music21` analysis written as literate Org-babel code blocks.

## Build & deploy

```sh
./build.sh                       # empties docs/, then runs the Emacs export
emacs -Q --script build-site.el  # the export step alone (does not clean docs/ first)
```

- Output goes to `docs/`. Preview by opening `docs/index.html` in a browser.
- Deploy is automatic: pushing to `main` triggers `.github/workflows/publish.yml`, which
  runs `build.sh` on a clean Ubuntu runner and deploys `docs/` to the `gh-pages` branch.
- `build-site.el` installs its only dependency, `htmlize`, into `./.packages/` (which is
  committed and pinned to `htmlize-20210825.2150`), so the build is self-contained.

There are no tests or linters.

## The key architectural fact: publishing is decoupled from Python

The HTML build runs **only Emacs + htmlize — no Python, no `music21`**. Every Python block
in `src/fuga_1.suborg` is marked `:eval never-export`, and its outputs are pre-computed and
committed: plots as PNGs under `src/assets/images/...`, text results pasted into
`#+RESULTS:`/`:results:` drawers. So the website can always be regenerated from any machine
with Emacs, regardless of Python/`music21`/laptop changes.

`music21` and Python matter **only** when re-running an analysis to produce a *new* image or
result. That is a separate, optional, manual step: the commented-out
`#+BEGIN_SRC ipython :session fugue ... :ipyfile ...` blocks (sitting just above each active
block) are the originals, run interactively against a Jupyter/IPython session in Emacs; the
new figure/result is then committed and the matching `:eval never-export` block left in
place. See `requirements.txt` for the Python package versions this workflow expects.

## Source layout

- `src/index.org`, `src/compositions.org`, `src/cryptograms.org` — the published pages.
  Only files matching `:base-extension "org"` in `build-site.el` become standalone HTML.
  `compositions.org` is the index of pieces: new compositions get an entry there, not a
  new nav link.
- `src/*.suborg` — `#+INCLUDE` fragments (`fuga_1.suborg`). The `.suborg` extension
  deliberately keeps them from being published as their own pages; they only appear via
  the `#+INCLUDE` directives in the `.org` pages.
- `src/assets/` — committed images (png), audio (mp3), PDFs, and the site stylesheet
  (`css/site.css`). The `org-static` project in `build-site.el` copies `png|pdf|mp3|css`
  straight through to `docs/`.

## Things to know before editing

- Editing a `.suborg` produces no visible change until the including `.org` is re-exported.
  `build.sh` always rebuilds everything, so just rerun it.
- The entire look of the site is hand-written in `src/assets/css/site.css` (no external
  theme, no CDNs): pages link it via `src/common.setup`, and `build-site.el` disables Org's
  default CSS/JS and supplies the shared nav header/footer through `org-html-preamble` /
  `org-html-postamble`. To add a page to the nav, edit the preamble in `build-site.el`.
- The Fuga I page keeps Org's table of contents: `site.css` renders it as a fixed sidebar
  on wide screens and a collapsed, tap-to-expand block on narrow ones (a small inline
  script in `common.setup` toggles the `.toc-open` class). Short pages set
  `#+OPTIONS: toc:nil`.
- `build-site.el` defines a custom `color:` Org link type so `[[color:green][text]]` renders
  as colored HTML/LaTeX spans. Keep it if you touch that file.
- `docs/` is build output committed to the repo; never hand-edit it — change `src/` and
  rebuild.
