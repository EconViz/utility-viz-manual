#import "/template/manual.typ": *

= 安装 <sec-install>

== 系统需求

#changed("1.0.2", label: "econ-viz")[删除 NumPy 的版本上限，避免在 Colab 上发生冲突]
#changed("1.0.1", label: "econ-viz")[固定 `numpy<2`，避免 Colab 与本机安装时 ABI 不兼容]
#changed("1.0.1", label: "econ-viz")[放宽 Python 与 NumPy 的版本限制；`pytest` 固定在 8.x]
#changed("1.7.0", label: "econ-viz")[软件包管理与构建改用 #pkg("uv")]
#changed("1.10.0", label: "econ-viz")[Python 3.10 使用 #pkg("tomli") 读取 TOML 配置文件]

#pkg("econ-viz") 需要 Python #doc-meta.package.python 以上版本#footnote[Python 官方网站提供各操作系统的安装程序：#url("https://www.python.org/downloads/")。]。本章以 #pkg("uv")#footnote[#pkg("uv") 是 Astral 开发的 Python 软件包与项目管理工具，速度快且可一并管理 Python 版本；安装方式与完整说明见官方文档：#url("https://docs.astral.sh/uv/")。] 管理软件包与项目，并附上对应的 #pkg("pip") 命令。

安装软件包时会一并安装 #pkg("NumPy")、#pkg("SciPy")、#pkg("matplotlib") 与 #pkg("SymPy")，分别用于数组运算、数值求解、绘图与符号运算#footnote[一般 Python 绘图不需要另外安装 #LaTeX；只有要编译导出的 TikZ 源代码时，才需要 #LaTeX 环境。]。

== 安装 #pkg("uv")

本手册的命令以 #pkg("uv") 为准。现有项目仍可使用 #pkg("pip")、#pkg("pipx") 或 #pkg("Poetry")；软件包 API 不受管理工具影响。

依操作系统运行下列安装命令。

=== macOS、Linux

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```
=== Windows

```powershell
powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"
```

== 安装 #pkg("econ-viz")

创建项目并添加 #pkg("econ-viz")：

```bash
uv init my-diagrams
cd my-diagrams
uv add econ-viz
```

使用 `uv run` 在项目环境中运行程序：

```bash
uv run python main.py
```

将#ref(<sec-quickstart>)的基本示例存为项目目录下的 `main.py`，再运行上述命令。`uv add` 记录项目依赖，`uv run` 使用该项目的 Python 环境。安装与运行必须使用同一个环境。

若要固定本手册使用的版本，可在添加依赖时指定版本号：

```bash
uv add "econ-viz==1.12.0"
```

若使用现有的 Python 虚拟环境，可通过 #pkg("pip") 安装：

```bash
python -m pip install -U econ-viz
```

软件包名称是 `econ-viz`，Python 导入名称是 `econ_viz`：

```python
from econ_viz import Canvas, solve
```

`import` 语句不得使用连字符。若发生 `ModuleNotFoundError`，检查运行程序的解释器是否与安装软件包时使用的环境相同。

== 可选依赖 <sec-extras>

#changed("1.4.0", label: "econ-viz[extras]")[添加可选依赖 `animation`、`interactive` 与 `all`]

动画与 Jupyter 交互组件需要可选依赖。按用途安装其中一组：

#param("animation")[供 `Animator` 写入 GIF（详见#ref(<sec-animation>)）；安装 #pkg("Pillow")。]
#param("interactive")[供 `WidgetViewer` 在 Jupyter 显示控件（详见#ref(<sec-widgets>)）；安装 #pkg("ipywidgets") 与 #pkg("IPython")。]
#param("all")[全部可选依赖。]

```bash
uv add "econ-viz[animation]"    # GIF 导出（Pillow）
uv add "econ-viz[interactive]"  # 笔记本交互组件
uv add "econ-viz[all]"          # 全部可选依赖
```

安装可选依赖不会自动运行动画或打开笔记本，仍需按各章示例调用对应的 API。

== 安装命令行工具 <sec-install-cli>

仅使用命令行接口时，可将 #pkg("econ-viz") 安装为独立工具（详见#ref(<sec-cli>)）：

```bash
uv tool install econ-viz
```

此方式将命令行工具安装在独立环境。需要在 Python 程序中导入软件包时，仍须在该项目运行 `uv add econ-viz`。在项目内以 `uv run econ-viz` 调用工具，可让命令行与 Python 程序使用同一版本。

== 开发环境设置

```bash
git clone https://github.com/EconViz/econ-viz.git
cd econ-viz
uv sync --all-extras
```

其中 `uv sync --all-extras` 会安装开发依赖与所有可选依赖。完成后运行测试：

```bash
uv run pytest
```

== 验证安装

#changed("1.7.0", label: "econ-viz")[修正示例脚本，使其可在新检出的源代码目录中直接运行]
#changed("1.5.0", label: "econ-viz")[Colab 上的笔记本安装流程在重新启动后也能正常运作]

```bash
uv run econ-viz --version   # econ-viz 1.12.0
uv run econ-viz help
```

注释中的版本号仅为示例，实际输出取决于安装版本。也可用以下命令确认 Python 能导入绘图与求解接口：

```bash
uv run python -c "from econ_viz import Canvas, solve; print('OK')"
```

在服务器或其他没有图形界面的环境中，请以 `save()` 或命令行的 `--output` 输出文件。`show()` 需要可用的交互式绘图后端，窗口打不开不代表安装失败。
