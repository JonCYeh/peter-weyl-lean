# Ch. 11 — Isotypic Decomposition of $L^2(G)$ and Plancherel

- **Blueprint:** `\label{chap:isotypic}`
- **Lean module:** [`PeterWeylComp/Isotypic.lean`](https://github.com/JonCYeh/peter-weyl-lean/blob/main/PeterWeylComp/Isotypic.lean)
- **Status:** 13 items, 9 sorries (2 real: `IrreducibleClass` setoid and `isotypicComponent`).

## The destination

This chapter is where everything packaged in chapters 7–10 turns into the final statement of Peter–Weyl:

$$
L^2(G) \;=\; \widehat\bigoplus_{[\rho] \in \widehat G} L^2(G)_{[\rho]}
\qquad\text{(Hilbert sum)}
$$

where $\widehat G$ is the set of equivalence classes of finite-dim continuous unitary irreducible representations of $G$, and $L^2(G)_{[\rho]}$ is the **isotypic component** corresponding to $[\rho]$ — the closed subspace spanned by matrix coefficients of any representative $\rho \in [\rho]$.

Plus the Plancherel identity giving the norm of $f \in L^2(G)$ as a sum over $\widehat G$ of contributions from each isotypic projection.

## $\widehat G$ — the IrrSkeleton refactor

The natural-feeling object is `UnitaryRep.IrreducibleClass G`: a structure carrying a representative finite-dim irreducible. But this is **not** a quotient — two distinct `ξ₁, ξ₂ : IrreducibleClass G` can have `ξ₁.rep ≅ ξ₂.rep` and yet be distinct as elements. That breaks `IsHilbertSum`, which requires distinct indices to give orthogonal subspaces.

**Fix.** Define `UnitaryRep.IrrSkeleton G := Quotient (IrreducibleClass.setoid G)` and re-index every Hilbert-sum statement over `IrrSkeleton G`. This is `\leanok` already; see the architectural-fix note in [`blueprint/src/status.tex`](https://github.com/JonCYeh/peter-weyl-lean/blob/main/blueprint/src/status.tex).

## Key items

| Name | Lean | Status |
|---|---|---|
| `IrreducibleClass G` | `UnitaryRep.IrreducibleClass` | `\leanok` |
| Setoid on `IrreducibleClass G` | `UnitaryRep.IrreducibleClass.setoid` | `\leanok` |
| `IrrSkeleton G = ⟦IrreducibleClass G⟧` | `UnitaryRep.IrrSkeleton` | sorry (`def:Ghat`) |
| Isotypic component | `PeterWeyl.isotypicComponent` | `\leanok` |
| Isotypic projection | `PeterWeyl.isotypicProjection` | sorry |
| Orthogonality between distinct isotypics | `PeterWeyl.isotypic_orthogonal_of_neq` | sorry |
| Span of all isotypics = $L^2(G)$ | `PeterWeyl.iSup_isotypic_eq_top` | sorry |
| `IsHilbertSum` packaging | `PeterWeyl.isHilbertSum_isotypic` | sorry |
| Plancherel norm formula | `PeterWeyl.plancherel_norm_sq` | sorry |

The 2 real items (`IrreducibleClass` and `isotypicComponent`) are the type-level pieces; the 9 sorries are the actual decomposition lemmas, which need Ch. 10 (Schur orthogonality) and an `OrthogonalFamily` / `IsHilbertSum` bridge.

## Why this is the largest chapter

Two reasons:

1. **Plancherel itself** is `\sum_{[\rho]} \dim(L^2(G)_{[\rho]}) \cdot \frac{1}{d_\rho^2}\|f \text{ projected}\|^2` style — it's a Hilbert sum identity, and translating Mathlib's `IsHilbertSum` API into the isotypic indexing is non-trivial.
2. **It's downstream of Ch. 10**, which is downstream of `area:fubini` (the Bochner stuff). So sorry-counts only go down here when chapter 10 starts going green.

Cluster: [`[Cluster] Ch.11 Isotypic Plancherel`](https://github.com/JonCYeh/peter-weyl-lean/issues?q=is%3Aissue+chapter%3Aisotypic).

## Order to attack

Pre-Ch. 10:
- `isotypicComponent` (real already), `isotypicProjection` (the orthogonal projection onto the closed span of matrix coefficients).

Once Ch. 10 lands:
- `isotypic_orthogonal_of_neq` (one-liner from `matrixCoeff_orth_of_not_equiv`).
- `iSup_isotypic_eq_top` (from Ch. 9 density + the fact every matrix coefficient lives in some isotypic).
- `isHilbertSum_isotypic` (combines the two).
- `plancherel_norm_sq` (from same-irreducible orthogonality `matrixCoeff_orth_self`).
