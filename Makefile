# Build the manual.
#
#   make              English edition (default)
#   make zh-TW        Traditional Chinese edition
#   make EDITION=zh-TW
#   make watch        live preview of $(EDITION)
#   make figures      regenerate figures/ with econ-viz (uv)
#   make publish      build every edition and copy it into econ-viz-docs
#
# Fonts: CJK fonts from fonts/ (Kaiti.ttc is not in the repository; see
# README), Latin fonts follow ctxdoc: TeX Gyre Pagella, TeX Gyre Heros,
# CMU Typewriter Text and TeX Gyre Pagella Math. Their TeX Live directories
# are passed separately because Typst does not recursively scan --font-path.
# TeXGyrePagellaX (newpx) is only a build fallback when Pagella OTF is absent.
# CMU comes from the cm-unicode package (tlmgr install cm-unicode).
# System fonts are ignored, so every machine builds deterministically.

TYPST     ?= typst
EDITION   ?= en
EDITIONS  := en zh-TW zh-CN
OUT       ?= build
TEXMFDIST ?= $(shell kpsewhich -var-value TEXMFDIST 2>/dev/null)
TEX_GYRE_FONTS ?= $(TEXMFDIST)/fonts/opentype/public/tex-gyre
TEX_MATH_FONTS ?= $(TEXMFDIST)/fonts/opentype/public/tex-gyre-math
CMU_FONTS      ?= $(TEXMFDIST)/fonts/opentype/public/cm-unicode
NCM_FONTS      ?= $(TEXMFDIST)/fonts/opentype/public/newcomputermodern
NEWPX_FONTS    ?= $(TEXMFDIST)/fonts/opentype/public/newpx
# Kaiti (emphasis in the Chinese editions): fonts/Kaiti.ttc if present,
# otherwise the copy macOS downloads through Font Book.
KAITI_DIR      ?= $(patsubst %/,%,$(dir $(firstword $(wildcard /System/Library/AssetsV2/com_apple_MobileAsset_Font*/*/AssetData/Kaiti.ttc))))

# `make publish` copies the PDFs to econ-viz-docs, which serves them at
# econ-viz.org/assets/manual/econ-viz-manual-<edition>.pdf.
DOCS           ?= ../econ-viz-docs
MANUAL_DIR      = $(DOCS)/docs/assets/manual

TYPST_FLAGS = --root . --font-path fonts \
	--font-path "$(TEX_GYRE_FONTS)" \
	--font-path "$(TEX_MATH_FONTS)" \
	--font-path "$(CMU_FONTS)" \
	--font-path "$(NCM_FONTS)" \
	--font-path "$(NEWPX_FONTS)" \
	$(if $(KAITI_DIR),--font-path "$(KAITI_DIR)") \
	--ignore-system-fonts

.PHONY: pdf all watch figures publish clean $(EDITIONS)

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

# The published PDFs must use the same fonts as a local build, so refuse to
# publish without Kaiti.
publish:
	@test -f fonts/Kaiti.ttc -o -n "$(KAITI_DIR)" || \
		{ echo "Kaiti not found; see README (Fonts)." >&2; exit 1; }
	@test -d "$(DOCS)/docs" || { echo "econ-viz-docs not found at $(DOCS); pass DOCS=..." >&2; exit 1; }
	@$(MAKE) --no-print-directory all
	@mkdir -p "$(MANUAL_DIR)"
	@for e in $(EDITIONS); do \
		cp $(OUT)/econ-viz-$$e.pdf "$(MANUAL_DIR)/econ-viz-manual-$$e.pdf"; \
		echo "published $(MANUAL_DIR)/econ-viz-manual-$$e.pdf"; \
	done

clean:
	rm -rf $(OUT)
