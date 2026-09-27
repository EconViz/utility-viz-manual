#import "/template/manual.typ": *

= 安裝 <sec-install>

== 系統需求

#changed("1.0.2", label: "econ-viz")[移除 NumPy 的版本上限，避免在 Colab 上發生衝突]
#changed("1.0.1", label: "econ-viz")[固定 `numpy<2`，避免 Colab 與本機安裝時 ABI 不相容]
#changed("1.0.1", label: "econ-viz")[放寬 Python 與 NumPy 的版本限制；`pytest` 固定在 8.x]
#changed("1.7.0", label: "econ-viz")[套件管理與建置改用 #pkg("uv")]
#changed("1.10.0", label: "econ-viz")[Python 3.10 使用 #pkg("tomli") 讀取 TOML 設定檔]

#pkg("econ-viz") 需要 Python #doc-meta.package.python 以上版本#footnote[Python 官方網站提供各作業系統的安裝程式：#url("https://www.python.org/downloads/")。]。本章以 #pkg("uv")#footnote[#pkg("uv") 是 Astral 開發的 Python 套件與專案管理工具，速度快且可一併管理 Python 版本；安裝方式與完整說明見官方文件：#url("https://docs.astral.sh/uv/")。] 管理套件與專案，並附上對應的 #pkg("pip") 指令。

安裝套件時會一併安裝 #pkg("NumPy")、#pkg("SciPy")、#pkg("matplotlib") 與 #pkg("SymPy")，分別用於陣列運算、數值求解、繪圖與符號運算#footnote[一般 Python 繪圖不需要另外安裝 #LaTeX；只有要編譯匯出的 TikZ 原始碼時，才需要 #LaTeX 環境。]。

== 安裝 #pkg("uv")

本手冊的指令以 #pkg("uv") 為準。既有專案仍可使用 #pkg("pip")、#pkg("pipx") 或 #pkg("Poetry")；套件 API 不受管理工具影響。

依作業系統執行下列安裝指令。

=== macOS、Linux

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```
=== Windows

```powershell
powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"
```

== 安裝 #pkg("econ-viz")

建立專案並加入 #pkg("econ-viz")：

```bash
uv init my-diagrams
cd my-diagrams
uv add econ-viz
```

使用 `uv run` 在專案環境中執行程式：

```bash
uv run python main.py
```

將#ref(<sec-quickstart>)的基本範例存為專案目錄下的 `main.py`，再執行上述指令。`uv add` 記錄專案依賴，`uv run` 使用該專案的 Python 環境。安裝與執行必須使用同一個環境。

若要固定本手冊使用的版本，可在加入依賴時指定版本號：

```bash
uv add "econ-viz==1.12.0"
```

若使用既有的 Python 虛擬環境，可透過 #pkg("pip") 安裝：

```bash
python -m pip install -U econ-viz
```

套件名稱是 `econ-viz`，Python 匯入名稱是 `econ_viz`：

```python
from econ_viz import Canvas, solve
```

`import` 陳述式不得使用連字號。若發生 `ModuleNotFoundError`，檢查執行程式的直譯器是否與安裝套件時使用的環境相同。

== 選用依賴 <sec-extras>

#changed("1.4.0", label: "econ-viz[extras]")[新增選用依賴 `animation`、`interactive` 與 `all`]

動畫與 Jupyter 互動元件需要選用依賴。依用途安裝其中一組：

#param("animation")[供 `Animator` 寫出 GIF（詳見#ref(<sec-animation>)）；安裝 #pkg("Pillow")。]
#param("interactive")[供 `WidgetViewer` 在 Jupyter 顯示控制項（詳見#ref(<sec-widgets>)）；安裝 #pkg("ipywidgets") 與 #pkg("IPython")。]
#param("all")[全部選用依賴。]

```bash
uv add "econ-viz[animation]"    # GIF 匯出（Pillow）
uv add "econ-viz[interactive]"  # 筆記本互動元件
uv add "econ-viz[all]"          # 全部選用依賴
```

安裝選用依賴不會自動執行動畫或開啟筆記本，仍需依各章範例呼叫對應的 API。

== 安裝命令列工具 <sec-install-cli>

僅使用命令列介面時，可將 #pkg("econ-viz") 安裝為獨立工具（詳見#ref(<sec-cli>)）：

```bash
uv tool install econ-viz
```

此方式將命令列工具安裝在獨立環境。需要在 Python 程式中匯入套件時，仍須在該專案執行 `uv add econ-viz`。在專案內以 `uv run econ-viz` 呼叫工具，可讓命令列與 Python 程式使用同一版本。

== 開發環境設定

```bash
git clone https://github.com/EconViz/econ-viz.git
cd econ-viz
uv sync --all-extras
```

其中 `uv sync --all-extras` 會安裝開發依賴與所有選用依賴。完成後執行測試：

```bash
uv run pytest
```

== 驗證安裝

#changed("1.7.0", label: "econ-viz")[修正範例腳本，使其可在新簽出的原始碼目錄中直接執行]
#changed("1.5.0", label: "econ-viz")[Colab 上的筆記本安裝流程在重新啟動後也能正常運作]

```bash
uv run econ-viz --version   # econ-viz 1.12.0
uv run econ-viz help
```

註解中的版本號僅為範例，實際輸出依安裝版本而定。也可用以下指令確認 Python 能匯入繪圖與求解介面：

```bash
uv run python -c "from econ_viz import Canvas, solve; print('OK')"
```

在伺服器或其他沒有圖形介面的環境中，請以 `save()` 或命令列的 `--output` 輸出檔案。`show()` 需要可用的互動式繪圖後端，視窗打不開不代表安裝失敗。
