# Ch. 2 — Continuous Unitary Representations

- **Blueprint:** `\label{chap:rep}`
- **Lean module:** [`PeterWeylComp/Rep.lean`](https://github.com/JonCYeh/peter-weyl-lean/blob/main/PeterWeylComp/Rep.lean)
- **Status:** 18 items, 8 sorries — all 8 are in the left/right regular representation construction.

## Why this chapter exists

Mathlib has `Representation k G V` (purely algebraic, no topology / continuity). For Peter–Weyl we need continuous **unitary** representations on Hilbert spaces. That's everything in this chapter — purely new code.

## The core bundle

```lean
structure UnitaryRep (G : Type _) (H : Type _) [...] where
  toMonoidHom        : G →* (H →L[ℂ] H)
  isUnitary          : ∀ g, IsUnitary (toMonoidHom g)
  strongContinuous   : ∀ v, Continuous (fun g => toMonoidHom g v)
```

Three facts that drop out immediately and get used everywhere:

- `UnitaryRep.inner_apply` — $\langle \rho(g)u, \rho(g)v\rangle = \langle u, v\rangle$.
- `UnitaryRep.norm_apply` — $\|\rho(g)v\| = \|v\|$.
- `UnitaryRep.opNorm_apply_le_one` — $\|\rho(g)\|_\mathrm{op} \leq 1$.

## Subrepresentations and irreducibility

| Name | Lean | What |
|---|---|---|
| `IsInvariant V` | `UnitaryRep.IsInvariant` | Predicate: closed subspace $V$ is $\rho$-stable. |
| `IsInvariant.orthogonalComplement` | same module | $V^\perp$ is invariant whenever $V$ is — the workhorse of Maschke/Weyl arguments. |
| `Subrep ρ` | `UnitaryRep.Subrep` | Bundled pair $(V, \texttt{hV})$. |
| `IsIrreducible` | `UnitaryRep.IsIrreducible` | `Nontrivial H` + only closed invariant subspaces are $\bot$ and $\top$. |
| `IsIntertwiner ρ σ` | `UnitaryRep.IsIntertwiner` | $T \circ \rho(g) = \sigma(g) \circ T$ for every $g$. |
| `Intertwiner ρ σ` | `UnitaryRep.Intertwiner` | The bundled subspace of $H \to_L K$. |
| `IsEquiv` / `Equiv` | `UnitaryRep.IsEquiv`, `UnitaryRep.Equiv` | Unitary equivalence between two representations. |

`orthCompl-invariant` (the orthogonal complement fact) is what makes finite-dimensional reps decompose into irreducibles in Ch. 8.

## The regular representations — where the sorries live

| Name | Lean | Status |
|---|---|---|
| $\lambda_g$ on $L^2$ | `PeterWeyl.leftTransL2` | sorry |
| $\lambda_g$ unitary | `PeterWeyl.leftTransL2_isUnitary` | sorry |
| $\lambda$ homomorphism | `PeterWeyl.leftTransL2_mulHom` | sorry |
| orbit map continuous | `PeterWeyl.leftTransL2_strongContinuous` | sorry |
| $\rho^L : \texttt{UnitaryRep G } L^2(G)$ | `PeterWeyl.leftReg` | sorry |
| Right-side analogues | `PeterWeyl.rightTransL2`, `PeterWeyl.rightReg` | sorry |
| $\rho^L$, $\rho^R$ commute | `PeterWeyl.leftReg_comm_rightReg` | sorry |

All 8 are blocked on the **same** lemma: extending left translation $\lambda_g : f \mapsto f(g^{-1}\cdot)$ from $C(G)$ to $L^2(G)$ via density (`thm:CG-dense-L2`) and the operator norm 1 estimate. Cluster issue: [`[Cluster] Ch.2 Regular representations`](https://github.com/JonCYeh/peter-weyl-lean/issues?q=is%3Aissue+chapter%3Arep).

The orbit-map continuity proof (`thm:leftTrans-strongCts`) sketched in the blueprint is the right template — it's the 3-step uniform-continuity / dense-approximation / triangle-inequality argument that recurs in Chs. 4 and 8.
