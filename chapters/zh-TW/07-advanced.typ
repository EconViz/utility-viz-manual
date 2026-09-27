#import "/template/manual.typ": *

= 進階模型 <sec-advanced>

`CustomUtility` 定義二變數效用函數。`MultiGoodCD` 表示多商品 Cobb-Douglas；固定其他商品的數量後，可將模型投影為二維圖。

=== 自訂效用函數

#api(("CustomUtility",), syntax: [#raw("CustomUtility(func=")#meta("callable")#raw(", name=")#meta("str")#raw(")")])[
  接受向量化的 Python 函數，回傳的模型可用於 `solve()` 與 `Canvas`。函數須接受兩個 #pkg("NumPy") 陣列，並回傳相同形狀的效用陣列。以下以對數效用為例：
  $ u(x, y) = ln x + ln y. $
]

#param("func")[以 $x$ 與 $y$ 為變數的向量化效用函數。]
#param("name")[模型的顯示名稱。]

```python
import numpy as np
from econ_viz import Canvas, levels, solve
from econ_viz.models import CustomUtility

model = CustomUtility(
    func=lambda x, y: np.log(x) + np.log(y),
    name="log+log",
)
eq = solve(model, px=2.0, py=3.0, income=30.0)

(
    Canvas(x_max=20, y_max=15, title="Custom Utility")
    .add_utility(model, levels=levels.around(eq.utility, n=5))
    .add_budget(2.0, 3.0, 30.0)
    .add_equilibrium(eq)
    .save("custom.png")
)
```

#fig("/figures/models/custom.svg", width: 42%, caption: [
  對數自訂模型。
])

=== 多商品 Cobb-Douglas

#api(("MultiGoodCD", "MultiGoodCD.freeze"), syntax: [
  #raw("MultiGoodCD(")#meta("shares")#raw(")") \
  #raw(".freeze(")#meta("good")#raw("=")#meta("quantity")#raw(", ...)")
])[
  `MultiGoodCD` 表示 $N$ 種商品的 Cobb-Douglas：
  $ u(x_1, ..., x_N) = product_(i=1)^N x_i^(alpha_i). $
  使用 `freeze()` 固定 $x$、$y$ 以外的商品數量，回傳可用於二維 `Canvas` 的 `CustomUtility`。
]

#param("shares")[商品名稱與指數 $alpha_i$ 的對應。]
#param("freeze(...)")[$x$、$y$ 以外商品的固定數量。]

```python
from econ_viz import Canvas, levels, solve
from econ_viz.models import MultiGoodCD

model = MultiGoodCD({"x": 0.3, "y": 0.3, "z": 0.4})
two_good_model = model.freeze(z=10.0)
eq = solve(two_good_model, px=2.0, py=3.0, income=30.0)

(
    Canvas(x_max=20, y_max=15, title="Multi-Good Cobb-Douglas")
    .add_utility(
        two_good_model,
        levels=levels.around(eq.utility, n=5),
    )
    .add_budget(2.0, 3.0, 30.0, fill=True)
    .add_equilibrium(eq)
    .save("multigood.png")
)
```

#fig("/figures/models/multigood.svg", width: 42%, caption: [
  三商品固定 $z=10$。
])
