#import "/template/manual.typ": *

= Installation <sec-install>

== Requirements

#changed("1.0.2", label: "econ-viz")[NumPy upper bound removed to avoid conflicts on Colab]
#changed("1.0.1", label: "econ-viz")[Pin `numpy<2` to avoid ABI mismatches on Colab and local installs]
#changed("1.0.1", label: "econ-viz")[Relaxed Python and NumPy bounds; `pytest` pinned to 8.x]
#changed("1.7.0", label: "econ-viz")[Package management and builds migrated to #pkg("uv")]
#changed("1.10.0", label: "econ-viz")[Python 3.10 reads TOML configuration files with #pkg("tomli")]

#pkg("econ-viz") requires Python #doc-meta.package.python or
later#footnote[The Python website provides installers for every operating system: #url("https://www.python.org/downloads/").].
This chapter manages packages and projects with
#pkg("uv")#footnote[#pkg("uv") is a fast Python package and project manager by Astral that can also manage Python versions; see its documentation for installation and usage: #url("https://docs.astral.sh/uv/").]
and gives the matching #pkg("pip") command where useful.

Installing the package also installs #pkg("NumPy"), #pkg("SciPy"),
#pkg("matplotlib") and #pkg("SymPy"), for array computation, numerical
solving, plotting and symbolic
algebra#footnote[Ordinary Python plotting needs no #LaTeX installation; a #LaTeX distribution is only required to compile exported TikZ code.].

== Installing #pkg("uv")

The commands in this manual use #pkg("uv"). Existing projects can keep using
#pkg("pip"), #pkg("pipx") or #pkg("Poetry"); the package API does not depend
on the tool that installed it.

Run the installer for your operating system.

=== macOS, Linux

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

=== Windows

```powershell
powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"
```

== Installing #pkg("econ-viz")

Create a project and add #pkg("econ-viz") as a dependency:

```bash
uv init my-diagrams
cd my-diagrams
uv add econ-viz
```

Run scripts inside the project environment with `uv run`:

```bash
uv run python main.py
```

Save the basic example of @sec-quickstart as `main.py` in the project
directory, then run the command above. `uv add` records the dependency and
`uv run` uses the project's Python environment; install and run in the same
environment.

To pin the version this manual describes, give it when adding the
dependency:

```bash
uv add "econ-viz==1.12.0"
```

In an existing Python virtual environment, install it with #pkg("pip"):

```bash
python -m pip install -U econ-viz
```

The package is named `econ-viz`; its Python import name is `econ_viz`:

```python
from econ_viz import Canvas, solve
```

An `import` statement cannot contain a hyphen. On `ModuleNotFoundError`,
check that the interpreter running the script is the one the package was
installed into.

== Optional dependencies <sec-extras>

#changed("1.4.0", label: "econ-viz[extras]")[Optional extras `animation`, `interactive` and `all`]

Animation and Jupyter widgets need optional dependencies. Install the group
you need:

#param("animation")[
  GIF export with `Animator` (@sec-animation); pulls in #pkg("Pillow").
]
#param("interactive")[
  Notebook widgets with `WidgetViewer` (@sec-widgets); pulls in
  #pkg("ipywidgets") and #pkg("IPython").
]
#param("all")[
  Every optional dependency.
]

```bash
uv add "econ-viz[animation]"    # GIF export (Pillow)
uv add "econ-viz[interactive]"  # notebook widgets
uv add "econ-viz[all]"          # all extras
```

Installing an extra does not run an animation or open a notebook by itself;
call the API as shown in the relevant chapter.

== Installing the command-line tool <sec-install-cli>

To use only the command-line interface, install #pkg("econ-viz") as a
standalone tool (@sec-cli):

```bash
uv tool install econ-viz
```

This installs the tool in an environment of its own. To import the package
in your own Python code, still run `uv add econ-viz` in that project; calling
`uv run econ-viz` inside the project keeps the CLI and your code on the same
version.

== Development setup

```bash
git clone https://github.com/EconViz/econ-viz.git
cd econ-viz
uv sync --all-extras
```

`uv sync --all-extras` installs the development dependencies and every
optional dependency. Then run the tests:

```bash
uv run pytest
```

== Verifying the installation

#changed("1.7.0", label: "econ-viz")[All example scripts run from a clean checkout]
#changed("1.5.0", label: "econ-viz")[Notebook install flow on Colab is restart-safe]

```bash
uv run econ-viz --version   # econ-viz 1.12.0
uv run econ-viz help
```

The version in the comment is only an example; the output reflects the
installed version. To check that Python can import the drawing and solving
API:

```bash
uv run python -c "from econ_viz import Canvas, solve; print('OK')"
```

On a server or any environment without a display, write files with `save()`
or the CLI's `--output`. `show()` needs an interactive plotting backend, so a
window that fails to open does not mean the installation failed.
