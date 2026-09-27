#import "/template/manual.typ": *

= Advanced models <sec-advanced>

Advanced models extend the built-in families with user-defined functions
or more than two goods.

=== Custom utility

#api(("CustomUtility",), syntax: [#raw("CustomUtility(func=")#meta("callable")#raw(", name=")#meta("str")#raw(")")])[
  Wrap any vectorised Python callable as an #pkg("econ-viz") model. The
  callable must accept two #pkg("NumPy") arrays and return an array of the
  same shape. The example below uses
  $ u(x, y) = ln x + ln y. $
]

#param("func")[Vectorised utility function of $x$ and $y$.]
#param("name")[Display name of the model.]

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
  A custom model, $ln x + ln y$.
])

=== Many-good Cobb-Douglas

#api(("MultiGoodCD", "MultiGoodCD.freeze"), syntax: [
  #raw("MultiGoodCD(")#meta("shares")#raw(")") \
  #raw(".freeze(")#meta("good")#raw("=")#meta("quantity")#raw(", ...)")
])[
  Cobb-Douglas preferences over $N$ goods:
  $ u(x_1, ..., x_N) = product_(i=1)^N x_i^(alpha_i). $
  `freeze()` fixes every good except $x$ and $y$ and returns a
  `CustomUtility` that can be drawn on a two-dimensional canvas.
]

#param("shares")[Mapping from each good's name to its exponent $alpha_i$.]
#param("freeze(...)")[Fixed quantities of the goods other than $x$ and $y$.]

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
  A three-good Cobb-Douglas model with $z = 10$ fixed.
])
