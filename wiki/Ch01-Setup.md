# Ch. 1 — Setup, Haar Measure, $L^2(G)$

- **Blueprint:** `blueprint/src/content_comp.tex`, `\label{chap:setup}`
- **Lean module:** [`PeterWeylComp/Basic.lean`](https://github.com/JonCYeh/peter-weyl-lean/blob/main/PeterWeylComp/Basic.lean) (with most content actually living under the `PeterWeyl` library since it's Mathlib wrappers).
- **Status:** 11 items, 0 sorries. All real, mostly thin wrappers around Mathlib.

## What this chapter sets up

The standing hypotheses, used unchanged for the rest of the project:

```
[Group G] [TopologicalSpace G] [IsTopologicalGroup G]
[CompactSpace G] [T2Space G] [MeasurableSpace G] [BorelSpace G]
```

and the scalar field $\mathbb C$ (an `[RCLike k]` version was considered and rejected for clarity).

## Key objects

| Name | Lean | What |
|---|---|---|
| $\mu_G$ | `PeterWeyl.haarProb` | The Haar **probability** measure on $G$: Mathlib's `haarMeasure` rescaled by `haarScalarFactor` so $\mu_G(G) = 1$. |
| $L^2(G)$ | `PeterWeyl.L2` | `Lp ℂ 2 μ_G` — the Bochner $L^2$ space, a Hilbert space (`L2.innerProductSpace`). |
| $\iota_{C \to L^2}$ | `PeterWeyl.continuousMapToL2` | The dense inclusion $C(G,\mathbb C) \hookrightarrow L^2(G)$ via `ContinuousMap.toLp`. |

## The five Haar facts the rest of the project leans on

1. `haarProb_isHaarMeasure` — $\mu_G$ is a Haar measure.
2. `haarProb_isProbabilityMeasure` — $\mu_G(G) = 1$.
3. `haarProb_isMulLeftInvariant` — left translation preserves $\mu_G$.
4. `haarProb_isMulRightInvariant` — and so does right translation (compact $\Rightarrow$ unimodular).
5. `haarProb_inv_eq_self` — $\mu_G \circ {}^{-1} = \mu_G$.

The last three feed into nearly every $L^2$ change-of-variable argument in chapters 2, 3, 10.

## Why probability normalization

Because chapters 4 and 8 use $\|\phi\|_{L^1} \leq \mu_G(G)^{1/2}\|\phi\|_{L^2} = \|\phi\|_{L^2}$ (Cauchy–Schwarz with $\mu_G(G) = 1$), and the convergence proof for approximate identities needs $\|\phi_n\|_{L^1} = 1$ for the bumps. Normalizing here means no rescaling factors anywhere downstream.

## Things to know if you're editing this chapter

- The thin wrappers around `MeasureTheory.Measure.haarMeasure` exist because Mathlib's Haar measure isn't normalized; downstream code wants a single canonical $\mu_G$ with $\mu_G(G) = 1$.
- `Lp_monotone` (`PeterWeyl.L2_norm_le_Linfty_norm`) is the one place where probability normalization is genuinely load-bearing — don't drop it.
