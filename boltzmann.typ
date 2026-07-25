#import "@preview/touying:0.6.1": *
#import themes.metropolis: *
#import "@preview/physica:0.9.8": dd, dv, pdv, grad, div, curl, laplacian

// ─── 字体 ─────────────────────────────────────────────────────────────────────
#let F-body   = ("New Computer Modern", "Source Han Sans")
#let F-math   = ("New Computer Modern Math", "New Computer Modern")
#let F-title  = ("FZZongYi-M05S",  "New Computer Modern")  // 综艺体：大标题
#let F-sec    = ("FZWeiBei-S03S",  "New Computer Modern")  // 魏碑体：幻灯片标题
#let F-kw     = ("FZDaHei-B02S",   "New Computer Modern")  // 大黑体：关键词
#let F-focus  = ("FZCaiYun-M09S",  "New Computer Modern")  // 彩云体：焦点页
#let F-outro  = ("FZXingKai-S04S", "New Computer Modern")  // 行楷体：结语

// ─── 全局排版 ─────────────────────────────────────────────────────────────────
#set text(font: F-body, lang: "zh", size: 20pt, cjk-latin-spacing: auto)
#show math.equation: set text(font: F-math)
#set strong(delta: 100)
#set par(justify: true, leading: 0.85em)

#show heading.where(level: 1): it => text(font: F-title, it)
#show heading.where(level: 2): it => text(font: F-sec, it)

// ─── 主题 ─────────────────────────────────────────────────────────────────────
#show: metropolis-theme.with(
  aspect-ratio: "16-9",
  footer: self => self.info.institution,
  config-colors(
    primary:          rgb("#1b3a6b"),
    primary-light:    rgb("#c0cfe8"),
    secondary:        rgb("#102040"),
    neutral-lightest: rgb("#f7f8fa"),
    neutral-dark:     rgb("#2c3e50"),
    neutral-darkest:  rgb("#0f1e30"),
  ),
  config-info(
    title:       text(font: F-title)[玻耳兹曼方程及相关方程族],
    subtitle:    [从动理论到随机过程],
    date:        datetime(year: 2026, month: 7, day: 25),
    institution: [统计物理专题],
  ),
)

// ─── 便捷宏 ───────────────────────────────────────────────────────────────────
#let kw(body) = text(font: F-kw, fill: rgb("#1b3a6b"), weight: "bold")[#body]
#let note(body) = text(size: 0.78em, fill: rgb("#556677"))[#body]
#let eq-box(body) = block(
  fill: rgb("#eef2f8"),
  stroke: (left: 3pt + rgb("#1b3a6b")),
  inset: (left: 12pt, rest: 8pt),
  radius: 2pt, width: 100%,
)[#body]
#let node(col, body) = block(
  fill: col, stroke: 1pt + white,
  inset: 10pt, radius: 4pt, width: 100%,
)[#body]

// ══════════════════════════════════════════════════════════════════════════════
#title-slide()

= 目录 <touying:hidden>
#components.adaptive-columns(outline(title: none, indent: 1em, depth: 1))

// ══════════════════════════════════════════════════════════════════════════════
= Boltzmann 方程

== 单粒子分布函数

设粒子处于六维相空间 $(bold(x), bold(v)) in RR^3 times RR^3$，

#kw[单粒子分布函数] $f(bold(x), bold(v), t)$ 满足归一化条件：

$ integral_(RR^3 times RR^3) f(bold(x), bold(v), t) dd(bold(x)) dd(bold(v)) = N $

- $f dd(bold(x)) dd(bold(v))$：$t$ 时刻位于体积元中的粒子数期望
- 宏观量由 $f$ 的矩给出：

$ n = integral f dd(bold(v)), quad
  rho bold(u) = integral m bold(v) f dd(bold(v)), quad
  cal(E) = integral frac(m, 2) abs(bold(v))^2 f dd(bold(v)) $

== Boltzmann 方程的形式

#eq-box[$
  underbrace(
    pdv(f, t) + bold(v) dot.op grad_(bold(x)) f
      + frac(bold(F), m) dot.op grad_(bold(v)) f,
    "自由流动（Liouville 算子）"
  )
  = underbrace(Q(f, f), "碰撞项")
$]

碰撞积分（#kw[分子混沌假设] Stosszahlansatz）：

$ Q(f, f) = integral_(RR^3) integral_(S^2)
  B(abs(bold(v) - bold(v)_*), cos theta)
  (f' f'_* - f f_*)
  dd(sigma) dd(bold(v)_*) $

#note[碰后速度 $bold(v)', bold(v)'_*$ 由弹性碰撞守恒律确定；$B >= 0$ 为碰撞截面，依赖相对速度与偏折角 $theta$。]

== H 定理与熵增

定义 #kw[H 函数]：
$ H(t) = integral f ln f dd(bold(v)) dd(bold(x)) $

#pause

由碰撞项的对称性可证：

#eq-box[$ dv(H, t) <= 0 $]

等号当且仅当 $f$ 为 #kw[Maxwell–Boltzmann 分布] 时成立：

$ f_0(bold(v)) = n lr((frac(m, 2 pi k_B T)))^(3 slash 2)
  exp lr([ -frac(m abs(bold(v) - bold(u))^2, 2 k_B T) ]) $

#note[$H$ 定理给出热力学第二定律的动理论根基：$S = -k_B H$；$H$ 减少即熵增。]

// ══════════════════════════════════════════════════════════════════════════════
= Markov 过程与 Master 方程

== Markov 过程与 Chapman–Kolmogorov 方程

随机过程 $X_t$（$t >= 0$）满足 #kw[Markov 性质]（无记忆性）：

$ P(X_(t_n) | X_(t_(n-1)), dots, X_(t_0))
  = P(X_(t_n) | X_(t_(n-1))), quad t_0 < dots < t_n $

全部信息由 #kw[转移概率密度] $p(y, t | x, s)$（$s < t$）完全刻画。

#pause

#kw[Chapman–Kolmogorov 方程]（半群性质）：

#eq-box[$
  p(y, t+s | x, t_0)
  = integral p(y, t+s | z, t) , p(z, t | x, t_0) dd(z)
$]

取 $s -> 0^+$ 极限 → 导出 Master 方程（微分形式）。

== Master 方程

设 $W(y | x)$ 为单位时间内从 $x$ 跳至 $y$ 的速率（$y != x$），

概率密度 $P(x, t)$ 满足 #kw[Master 方程]（Pauli 方程）：

#eq-box[$
  pdv(P(x,t), t)
  = integral lr([
      W(x | y) P(y, t)
      - W(y | x) P(x, t)
    ]) dd(y)
$]

- *增益*：从状态 $y$ 跳入 $x$；*损失*：从 $x$ 跳出

#pause

#kw[细致平衡]（平衡态充分条件）：

$ W(x | y) P_"eq"(y) = W(y | x) P_"eq"(x) $

#note[对应 Boltzmann 方程 $Q = 0$，即 $f' f'_* = f f_*$（微可逆性）。]

// ══════════════════════════════════════════════════════════════════════════════
= Fokker–Planck 方程

== Kramers–Moyal 展开

定义第 $n$ 阶 #kw[跳跃矩]：

$ a^((n))(x) = integral (y - x)^n W(y | x) dd(y) $

对 Master 方程形式展开——#kw[Kramers–Moyal 展开]：

$ pdv(P, t) = sum_(n=1)^infinity
  frac((-1)^n, n!) frac(partial^n, partial x^n)
  lr([ a^((n))(x) P(x, t) ]) $

#pause

#kw[Pawula 定理]：若 $a^((n_0)) = 0$ 对某 $n_0 >= 3$ 成立，则 $n >= 3$ 的所有项全消 → 截断为前两项即 Fokker–Planck 方程。

== Fokker–Planck 方程

$d$ 维一般形式：

#eq-box[$
  pdv(P, t)
  = -sum_i pdv(, x_i) lr([mu_i (bold(x), t) P])
    + frac(1, 2) sum_(i,j) pdv(, x_i, x_j)
      lr([D_(i j)(bold(x), t) P])
$]

- $bold(mu)$：#kw[漂移系数]（drift），$mu_i = a^((1))_i$
- $bold(D)$：#kw[扩散张量]（diffusion），$D_(i j) = a^((2))_(i j)$

#pause

一维概率流形式（$J$ 为概率流密度）：

$ pdv(P, t) = -pdv(J, x), quad quad
  J = mu P - frac(1, 2) pdv(, x)(D P) $

#note[平衡态 $J equiv 0$（细致平衡）。]

// ══════════════════════════════════════════════════════════════════════════════
= Fokker–Planck 方程与随机微分方程

== Itô 随机微分方程

#kw[Itô SDE]（$d$ 维，$bold(W)_t$ 为 $m$ 维 Wiener 过程）：

#eq-box[$
  dd(bold(X)_t)
  = bold(b)(bold(X)_t, t) dd(t)
  + bold(sigma)(bold(X)_t, t) dd(bold(W)_t)
$]

设 $p(bold(x), t)$ 为 $bold(X)_t$ 的概率密度，由 #kw[Itô 公式] 推出对应 FP 方程：

#eq-box[$
  pdv(p, t)
  = -div (bold(b) p)
    + frac(1, 2) grad grad : (bold(D) p), quad
  bold(D) = bold(sigma) bold(sigma)^top
$]

== SDE ↔ Fokker–Planck 对应

#align(center)[
  #table(
    columns: (auto, 1fr, 1fr),
    align: (center, left, left),
    stroke: none,
    fill: (col, row) =>
      if row == 0 { rgb("#c0cfe8") }
      else if calc.odd(row) { rgb("#f0f4fa") }
      else { white },
    inset: 10pt,
    [#text(font: F-kw)[量]],
    [#text(font: F-kw)[SDE 侧]],
    [#text(font: F-kw)[FP 方程侧]],
    [漂移], [$bold(b)(bold(x), t)$], [$bold(mu) = bold(b)$],
    [扩散], [$bold(sigma) bold(sigma)^top$], [$D_(i j)$],
    [初始条件], [$bold(X)_0 tilde p_0$], [$p(bold(x), 0) = p_0(bold(x))$],
    [解的对象], [样本轨迹 $bold(X)_t (omega)$], [概率密度 $p(bold(x), t)$],
  )
]

#pause

#kw[Stratonovich 解释]与 Itô 的漂移换算：

$ mu_i^"Itô" = b_i + frac(1, 2) sum_(k, j) sigma_(k j) pdv(sigma_(i j), x_k) $

#note[Stratonovich 在物理噪声问题（Langevin 方程的白噪声极限）中更自然。]

// ══════════════════════════════════════════════════════════════════════════════
= Fokker–Planck–Landau 方程

== 长程 Coulomb 碰撞

Boltzmann 方程碰撞截面 $B$ 对 Coulomb 势发散（$B tilde theta^(-4)$，掠射碰撞主导）。

Landau（1936）令偏折角 $theta -> 0^+$ 积分，得 #kw[Landau 碰撞算子]：

$ Q_"L"(f, f)
  = mu grad_(bold(v)) dot.op
    integral_(RR^3) cal(A)(bold(v) - bold(v)_*)
    lr([f_* grad_(bold(v)) f - f grad_(bold(v)_*) f_*])
    dd(bold(v)_*) $

#kw[Landau 张量]（将相对速度投影到垂直平面）：

$ cal(A)_(i j)(bold(z)) = abs(bold(z))^(-1)
  lr((delta_(i j) - frac(z_i z_j, abs(bold(z))^2))) $

== Fokker–Planck–Landau 方程

#eq-box[$
  pdv(f, t) + bold(v) dot.op grad_(bold(x)) f
  = mu grad_(bold(v)) dot.op
    integral_(RR^3) cal(A)(bold(v) - bold(v)_*)
    lr([f_* grad_(bold(v)) f - f grad_(bold(v)_*) f_*])
    dd(bold(v)_*)
$]

右端改写为 FP 形式：
$-grad_(bold(v)) dot.op (bold(F)[f] f) + grad_(bold(v)) dot.op (bold(D)[f] grad_(bold(v)) f)$

- $bold(F)[f]$、$bold(D)[f]$ 均是 $f$ 的线性泛函 → *整体方程非线性*
- 质量、动量、能量守恒；H 定理成立
- Coulomb 情形 $abs(bold(z))^(-1)$；广义幂次 $abs(bold(z))^gamma$

// ══════════════════════════════════════════════════════════════════════════════
= 方程族关系总览 <touying:hidden>

#focus-slide[
  #set text(fill: white, size: 14pt)

  #grid(
    columns: (1fr, 2em, 1fr),
    rows: (auto, 1.4em, auto, 1.4em, auto),
    gutter: 8pt,

    // ── 顶行 ──
    node(rgb("#1e3f74"))[
      #text(font: F-focus, size: 17pt)[Boltzmann 方程] \
      $pdv(f, t) + bold(v) dot.op grad f = Q(f,f)$ \
      #text(size: 0.82em, fill: rgb("#aac4f0"))[稀薄气体 · 短程碰撞]
    ],
    [],
    node(rgb("#1e3f74"))[
      #text(font: F-focus, size: 17pt)[Master 方程] \
      $pdv(P, t) = integral [W P(y) - W P] dd(y)$ \
      #text(size: 0.82em, fill: rgb("#aac4f0"))[Markov 过程 · CK 半群]
    ],

    // ── 箭头行 ──
    align(center + horizon)[↓ #text(size: 0.88em)[掠射极限 $theta->0$]],
    [],
    align(center + horizon)[↓ #text(size: 0.88em)[KM 展开 + Pawula]],

    // ── 中间行 ──
    node(rgb("#14305a"))[
      #text(font: F-focus, size: 17pt)[FPL 方程] \
      $pdv(f, t) = mu grad_(bold(v)) dot.op integral cal(A)[dots] dd(bold(v)_*)$ \
      #text(size: 0.82em, fill: rgb("#aac4f0"))[Coulomb · 等离子体]
    ],
    align(center + horizon)[#text(size: 1.5em)[↔]],
    node(rgb("#14305a"))[
      #text(font: F-focus, size: 17pt)[Fokker–Planck 方程] \
      $pdv(p, t) = -div(bold(b) p) + frac(1,2) laplacian(D p)$ \
      #text(size: 0.82em, fill: rgb("#aac4f0"))[漂移 + 扩散结构]
    ],

    // ── 箭头行 ──
    [],
    [],
    align(center + horizon)[↕ #text(size: 0.88em)[Itô 公式等价]],

    // ── 底行 ──
    [],
    [],
    node(rgb("#0c2040"))[
      #text(font: F-focus, size: 17pt)[Itô SDE] \
      $dd(bold(X)_t) = bold(b) dd(t) + bold(sigma) dd(bold(W)_t)$ \
      #text(size: 0.82em, fill: rgb("#aac4f0"))[轨迹描述 ↔ 密度描述]
    ],
  )
]

// ══════════════════════════════════════════════════════════════════════════════
= 总结 <touying:hidden>

#slide(self => [
  #let c = self.colors
  #set text(size: 18pt)

  #table(
    columns: (0.32fr, 1fr),
    stroke: none,
    fill: (col, row) =>
      if col == 0 { c.primary-light }
      else if calc.odd(row) { rgb("#f5f8ff") }
      else { white },
    align: (right + horizon, left + horizon),
    inset: (x: 14pt, y: 9pt),
    [#text(font: F-kw)[Boltzmann]],
    [稀薄气体；短程弹性碰撞；H 定理；Maxwell 平衡态],
    [#text(font: F-kw)[FPL 方程]],
    [长程 Coulomb；掠射极限；FP 结构；守恒律保持],
    [#text(font: F-kw)[Master 方程]],
    [Markov 过程微分形式；Chapman–Kolmogorov 半群],
    [#text(font: F-kw)[Fokker–Planck]],
    [KM 截断；Pawula 定理；漂移 $+$ 扩散结构],
    [#text(font: F-kw)[SDE $<->$ FP]],
    [轨迹 $<->$ 密度；Itô $<->$ Stratonovich 互换],
  )

  #v(1.2em)
  #align(center)[
    #text(font: F-outro, fill: c.primary, size: 22pt)[
      从动理论到随机微积分：同一概率流的不同面貌
    ]
  ]
])
