# Ch. 6 — Schur's Lemma for Continuous Unitary Irreducibles

- **Blueprint:** `\label{chap:schur}`
- **Lean module:** [`PeterWeylComp/Schur.lean`](https://github.com/JonCYeh/peter-weyl-lean/blob/main/PeterWeylComp/Schur.lean)
- **Status:** 6 items, 1 sorry (the distinct-irreducible case; the scalar form is real).

## Statement

For $\rho : \texttt{UnitaryRep G H}$ irreducible and $T : H \to_L H$ a **compact** intertwiner $\rho \to \rho$, there exists $z \in \mathbb C$ with $T = z \cdot \mathrm{Id}$.

This is weaker than classical Schur (which doesn't require compactness on $T$), but it's enough for the rest of the project, because every intertwiner we ever encounter factors through a compact operator (typically $T_\phi$).

## The argument, three steps

1. **`def:RealImag` + `thm:RealImag-equiv`.** Decompose $T = \mathrm{Re}(T) + i\,\mathrm{Im}(T)$ with both pieces self-adjoint. Both inherit $\rho$-equivariance from $T$ (the adjoint of an intertwiner is an intertwiner via unitarity).
2. **`thm:irrep-selfadj-scalar`.** A compact self-adjoint $\rho$-equivariant operator on an irreducible is a real scalar (or zero): apply `thm:spectral-nonzero-eval` (Ch. 5) to get a non-zero eigenspace $H_\lambda$; eigenspaces of intertwiners are invariant (`thm:eigenspace-invariant`); irreducibility forces $H_\lambda = H$.
3. **`thm:schur-scalar`.** Combine: $T = \mathrm{Re}(T) + i\,\mathrm{Im}(T)$ is a complex scalar.

The compactness hypothesis enters in step 2 — it's what lets us invoke the spectral theorem from Ch. 5. Compactness of $\mathrm{Re}(T)$ and $\mathrm{Im}(T)$ follows from compactness of $T$ and $T^*$ (`IsCompactOperator.add`, `IsCompactOperator.smul`, `IsCompactOperator.adjoint` — the last is the second external assumption).

## Key items

| Name | Lean | Status |
|---|---|---|
| Re/Im decomposition | `ContinuousLinearMap.realPart`, `ContinuousLinearMap.imagPart` | (mostly definitional) |
| Re/Im of intertwiner is intertwiner | `PeterWeyl.UnitaryRep.IsIntertwiner.realPart_imagPart` | `\leanok` |
| Eigenspace of intertwiner is invariant | `PeterWeyl.UnitaryRep.IsIntertwiner.eigenspace_isInvariant` | `\leanok` |
| Self-adjoint $\rho$-equivariant on irreducible $\Rightarrow$ scalar | `PeterWeyl.UnitaryRep.IsIrreducible.compact_selfAdjoint_intertwiner_eq_smul_or_zero` | `\leanok` |
| **Schur scalar form** | `PeterWeyl.UnitaryRep.IsIrreducible.intertwiner_self_eq_smul` | `\leanok` |
| Schur for inequivalent irreducibles | `PeterWeyl.UnitaryRep.IsIrreducible.compact_intertwiner_eq_zero_of_not_equiv` | **sorry** |

## What the remaining sorry is

`thm:schur-distinct`: if $\rho, \sigma$ are inequivalent irreducibles and $T : H \to_L K$ is a compact intertwiner $\rho \to \sigma$, then $T = 0$. The argument given in the blueprint:

1. $T \neq 0$ ⟹ $T$ injective (irreducibility of $\rho$) and dense-range (irreducibility of $\sigma$).
2. $T^* T : H \to_L H$ is compact, self-adjoint, positive, $\rho$-equivariant ⟹ scalar by `thm:schur-scalar`, with positive scalar $c > 0$.
3. $U := T / \sqrt c$ is then a unitary equivalence $\rho \to \sigma$, contradicting inequivalence.

Step 2 uses `\textbf{compact operators absorb bounded ones}` (Mathlib: `IsCompactOperator.comp` or similar). Step 3 uses density-of-range + closed-image-of-an-isometry.

Atomic issue: [`[Schur] thm:schur-distinct`](https://github.com/JonCYeh/peter-weyl-lean/issues?q=is%3Aissue+schur-distinct).
