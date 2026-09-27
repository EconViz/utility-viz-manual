<p align="center">
  <img src="https://raw.githubusercontent.com/EconViz/econ-viz-docs/main/docs/assets/banner.svg" alt="Econ-Viz" width="480">
</p>

<p align="center">
  <a href="https://github.com/EconViz/utility-viz-manual/actions/workflows/build.yml"><img alt="Build" src="https://img.shields.io/github/actions/workflow/status/EconViz/utility-viz-manual/build.yml?branch=main&style=flat-square&color=181818&labelColor=f3f3f3&label=build"></a>
  <a href="https://github.com/EconViz/utility-viz-manual/releases/latest"><img alt="Release" src="https://img.shields.io/github/v/release/EconViz/utility-viz-manual?style=flat-square&color=181818&labelColor=f3f3f3&label=release"></a>
  <a href="https://pypi.org/project/econ-viz/"><img alt="econ-viz" src="https://img.shields.io/badge/econ--viz-v1.12.0-181818?style=flat-square&color=181818&labelColor=f3f3f3"></a>
  <a href="https://typst.app/"><img alt="Typst" src="https://img.shields.io/badge/Typst-0.15-181818?style=flat-square&color=181818&labelColor=f3f3f3"></a>
  <img alt="Editions" src="https://img.shields.io/badge/editions-en%20%7C%20zh--TW%20%7C%20zh--CN-181818?style=flat-square&color=181818&labelColor=f3f3f3">
  <a href="https://opensource.org/licenses/MIT"><img alt="License" src="https://img.shields.io/badge/License-MIT-181818?style=flat-square&color=181818&labelColor=f3f3f3"></a>
</p>

The printable reference manual for [econ-viz](https://github.com/EconViz/econ-viz),
a Python toolkit for publication-quality microeconomics diagrams. It is
written in Typst and laid out in the l3doc / ctxdoc style: API names, version
notes and parameters hang in a wide left margin, and every change since v1.0.0
is tagged next to the feature it describes and collected in a change history.

The manual comes in three editions built from the same sources:

| Edition | Output |
|---------|--------|
| English | `build/econ-viz-en.pdf` |
| 繁體中文 | `build/econ-viz-zh-TW.pdf` |
| 简体中文 | `build/econ-viz-zh-CN.pdf` |

Download the PDFs from the [latest release](https://github.com/EconViz/utility-viz-manual/releases/latest).
For the online documentation, see [econ-viz.org](https://econ-viz.org).

## Requirements

- [Typst](https://typst.app/) 0.15 or later
- TeX Live or TinyTeX with TeX Gyre Pagella, TeX Gyre Heros, TeX Gyre Pagella
  Math and CMU Typewriter Text (`tlmgr install tex-gyre tex-gyre-math cm-unicode`)
- [uv](https://docs.astral.sh/uv/), only to regenerate the figures
- For the Chinese editions, Kaiti SC / TC (see [Fonts](#fonts))

System fonts are ignored, so every machine builds the same PDF.

## Building

```bash
make            # English edition
make zh-TW      # Traditional Chinese
make zh-CN      # Simplified Chinese
make all        # every edition
make watch EDITION=zh-TW
make figures    # regenerate figures/ with econ-viz
make clean
```

The Makefile finds the TeX fonts through `kpsewhich`. If TeX Live is not on
your `PATH`, pass `TEXMFDIST=/path/to/texmf-dist`, or list font directories
directly with `FONT_DIRS="dir1 dir2"`.

## Continuous integration

[`.github/workflows/build.yml`](.github/workflows/build.yml) builds all three
editions on every push and pull request, fails on any Typst warning, and keeps
the PDFs as a workflow artifact. Pushing a tag `vX.Y.Z` that matches
`version` in `config/meta.toml` also publishes the PDFs as a GitHub release.

## Fonts

Noto Serif TC and Noto Serif SC ship in `fonts/` under the
[SIL Open Font License](fonts/OFL.txt).

Kaiti, used for emphasis in the Chinese editions, is licensed by Apple and is
not in this repository. On macOS, download **Kaiti SC** in Font Book; the
Makefile then finds it automatically. Otherwise, copy `Kaiti.ttc` into
`fonts/`. Without Kaiti, emphasis falls back to the free AR PL UKai, as in the
release PDFs built by GitHub Actions.

## Layout

| Path | Contents |
|------|----------|
| `main.typ` | Entry point; `--input edition=<en\|zh-TW\|zh-CN>` picks the edition |
| `chapters/<edition>/` | Chapter sources, with the same file names in every edition |
| `template/manual.typ` | Page layout and the l3doc-style commands (`api`, `param`, `changed`, `fig`, `tbl`, …) |
| `config/meta.toml` | Package version, release date, author and links |
| `config/i18n.toml` | Interface strings for each edition |
| `config/fonts.toml` | Font stacks for each edition |
| `config/layout.toml` | Page geometry and paragraph settings |
| `config/figures.toml` | Figure fonts and sizes |
| `config/refs.bib` | References, formatted in APA style |
| `scripts/make_figures.py` | Draws every figure in `figures/` with econ-viz |
| `figures/` | Generated SVG figures, shared by all editions |

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md). Report security issues as described in
[SECURITY.md](SECURITY.md).

## License

MIT © Anthony Sung. The bundled Noto fonts are under the SIL Open Font License 1.1.
