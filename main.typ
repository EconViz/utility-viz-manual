// econ-viz manual — single entry point for every language edition.
//
// The edition is chosen at compile time:
//   make                 # English (default)
//   make zh-TW           # 繁體中文
//   make zh-CN           # 简体中文
//   typst compile --root . --input edition=zh-TW main.typ
//
// Chapters live in chapters/<edition>/ with the same file names in every
// edition, so the list below is shared.

#import "/template/manual.typ": *

#let edition = sys.inputs.at("edition", default: "en")
#show: manual.with(edition: edition)

#let chapters = (
  "01-introduction",
  "02-installation",
  "03-quickstart",
  "04-canvas",
  "05-figures",
  "06-models",
  "07-advanced",
  "08-analysis",
  "09-themes",
  "10-export",
  "11-cli",
  "12-animation",
  "13-widgets",
  "14-latex",
  "15-changelog",
)

#for name in chapters {
  include "chapters/" + edition + "/" + name + ".typ"
}

#command-index()
#references()
