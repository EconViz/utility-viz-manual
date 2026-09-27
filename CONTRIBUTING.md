# Contributing to the econ-viz manual

Thank you for helping improve the manual. This guide covers the build setup
and the conventions every edition follows.

## Setting up

```bash
git clone https://github.com/EconViz/utility-viz-manual.git
cd utility-viz-manual
make all
```

See the [README](README.md#requirements) for the required tools and fonts.
Run `uv sync` before `make figures` to install econ-viz.

## How to contribute

- **Errors in the manual**: open an issue that names the edition, the page or
  section, and what is wrong.
- **Errors in econ-viz itself**: report them in
  [EconViz/econ-viz](https://github.com/EconViz/econ-viz/issues).
- **Pull requests**: fork the repository, create a branch, and open a PR
  against `main`.

Before you submit a PR, check that `make all` finishes without warnings, and
review the pages you changed in every edition.

## Keeping the editions in step

The three editions share the same structure. A change in one chapter goes into
the same file in `chapters/en/`, `chapters/zh-TW/` and `chapters/zh-CN/`:

- the same APIs, parameters, figures, tables and labels;
- the same `#changed(...)` entries, one per release note, placed next to the
  feature they describe;
- code, mathematics and cross-references unchanged across editions.

## Writing conventions

- Describe parameters, methods and returned fields with `#param(...)`, one per
  entry, never several in one sentence of prose.
- English uses British spelling.
- The Chinese editions follow [WRITING-STYLE-ZH.md](WRITING-STYLE-ZH.md).
  zh-CN is localised, not just converted to simplified characters.
- In CJK text, write a reference followed directly by a CJK character as
  `#ref(<label>)`; `@label` would swallow the following characters.
- Cite works in `config/refs.bib` with `#citep` or `#citet`.

## Figures

Figures contain no prose, so every edition shares `figures/`. Change figures
in `scripts/make_figures.py` or `config/figures.toml`, then run
`make figures`. Do not edit the SVG files by hand.

## Updating for a new econ-viz release

1. Update `version` and `date` in `config/meta.toml`, and the release dates in
   `template/manual.typ`.
2. Add a `#changed(...)` entry for each user-facing change, in all three
   editions. Leave out documentation-only changes.
3. Document new APIs and parameters, and regenerate figures if their output
   changed.
4. Once `main` builds cleanly, run `make publish` and commit the updated PDFs
   in econ-viz-docs (see the [README](README.md#publishing)).

## License

By contributing you agree that your work will be released under the
[MIT License](LICENSE).
