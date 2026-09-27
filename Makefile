# Build the manual.
#
#   make              English edition (default)
#   make zh-TW        Traditional Chinese edition
#   make EDITION=zh-TW
#   make watch        live preview of $(EDITION)
#   make figures      regenerate figures/ with econ-viz (uv)
#
# Fonts: CJK fonts from fonts/ (Kaiti.ttc is not in the repository; see
# README), Latin fonts follow ctxdoc: TeX Gyre Pagella, TeX Gyre Heros,
# CMU Typewriter Text and TeX Gyre Pagella Math, taken from the matching
# TeX Live directories only (Typst scans each --font-path recursively, so
# pointing it at all of TeX Live would be slow).
# CMU comes from the cm-unicode package (tlmgr install cm-unicode).
# System fonts are ignored, so every machine builds deterministically.
# Without TeX Live (e.g. in CI), set FONT_DIRS to the directories to use.

TYPST     ?= typst
EDITION   ?= en
EDITIONS  := en zh-TW zh-CN
OUT       ?= build
TEXMFDIST ?= $(shell kpsewhich -var-value TEXMFDIST 2>/dev/null)
TEX_FONTS := $(if $(TEXMFDIST),$(addprefix $(TEXMFDIST)/fonts/opentype/public/, \
	tex-gyre tex-gyre-math cm-unicode))
# Kaiti (emphasis in the Chinese editions): fonts/Kaiti.ttc if present,
# otherwise the copy macOS downloads through Font Book. Without either, the
# Chinese editions fall back to AR PL UKai (config/fonts.toml).
KAITI_DIR ?= $(patsubst %/,%,$(dir $(firstword $(wildcard /System/Library/AssetsV2/com_apple_MobileAsset_Font*/*/AssetData/Kaiti.ttc))))
FONT_DIRS ?= $(TEX_FONTS) $(KAITI_DIR)
KAI       ?= $(if $(or $(wildcard fonts/Kaiti.ttc),$(KAITI_DIR)),kaiti,fallback)

TYPST_FLAGS = --root . --font-path fonts \
	$(foreach d,$(FONT_DIRS),--font-path "$(d)") \
	--ignore-system-fonts --input kai=$(KAI)

.PHONY: pdf all watch figures clean $(EDITIONS)

pdf:
	@mkdir -p $(OUT)
	$(TYPST) compile $(TYPST_FLAGS) --input edition=$(EDITION) main.typ $(OUT)/econ-viz-$(EDITION).pdf

$(EDITIONS):
	@$(MAKE) --no-print-directory pdf EDITION=$@

all: $(EDITIONS)

watch:
	$(TYPST) watch $(TYPST_FLAGS) --input edition=$(EDITION) main.typ $(OUT)/econ-viz-$(EDITION).pdf

figures:
	uv run python scripts/make_figures.py

clean:
	rm -rf $(OUT)
