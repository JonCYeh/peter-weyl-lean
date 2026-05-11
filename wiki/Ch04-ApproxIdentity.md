# Ch. 4 — Approximate Identities

- **Blueprint:** `\label{chap:approxId}`
- **Lean module:** [`PeterWeylComp/ApproxIdentity.lean`](https://github.com/JonCYeh/peter-weyl-lean/blob/main/PeterWeylComp/ApproxIdentity.lean)
- **Status:** 2 items, 2 sorries (existence + convergence of the bumps).

## What this chapter delivers

A family of symmetric continuous **bumps** $\{\phi_U\}_U$ indexed by open neighborhoods $U \ni 1_G$, such that:

- each $\phi_U \in C(G, \mathbb R)$ is non-negative, supported in $U$, symmetric ($\phi(g) = \phi(g^{-1})$), and normalized ($\int \phi\,d\mu_G = 1$);
- as $U$ shrinks to $\{1_G\}$, $T_{\phi_U}f \to f$ in $L^2$ for every $f$.

That's enough to make $T_{\phi_U}$ behave like an approximate identity for convolution.

## Key items

| Name | Lean | What |
|---|---|---|
| `IsBump U` | `PeterWeyl.IsBump` | The predicate above. |
| Existence | `PeterWeyl.exists_bump` | Urysohn $\to$ symmetrize $\to$ normalize. sorry. |
| Convergence | `PeterWeyl.convOp_bump_tendsto_id` | $T_{\phi_n}f \to f$ for $\phi_n$ bumps on $U_n \downarrow \{1_G\}$. sorry. |

## How `exists_bump` goes

1. Use Urysohn in the locally compact Hausdorff group $G$ to get $\psi \in C(G,\mathbb R)$ non-negative, $\psi(1_G) > 0$, $\mathrm{supp}\,\psi \subseteq U$.
2. Pick $V \ni 1_G$ open with $V \cup V^{-1} \subseteq U$ (continuity of inversion + Hausdorffness).
3. Symmetrize: $\psi^*(g) := \psi(g) + \psi(g^{-1})$.
4. Normalize: $\phi := \psi^* / \int \psi^* d\mu_G$. The denominator is positive because $\psi^*(1_G) > 0$ and $\psi^*$ is continuous non-negative on a nonempty open set, so $\int \psi^* > 0$ on any Haar-positive open set.

The Urysohn step is `Topology.UrysohnsLemma` or `Topology.UrysohnsLemma_locallyCompactSpace` in Mathlib.

## How `convOp_bump_tendsto_id` goes

The blueprint sketches a clean three-step proof:

1. **For continuous $f$:** uniform continuity of $f$ on the compact $G$ + support shrinking gives $\|T_{\phi_n}f - f\|_{L^\infty} \to 0$, hence $\|\cdot\|_{L^2} \to 0$ via `Lp_monotone`.
2. **Approximate $f \in L^2$ by $f' \in C(G)$** via `CG-dense-L2`.
3. **Triangle inequality + uniform $\|T_{\phi_n}\|_{L^2 \to L^2}$ bound.** The non-obvious bit: $\|\phi_n\|_{L^2}$ is **not** bounded in general (bumps concentrate), so the naive $\|T_{\phi_n}\|_\mathrm{op} \leq \|\phi_n\|_{L^2}$ bound is useless. The fix is Young's inequality: $\|T_{\phi_n}\|_{L^2 \to L^2} \leq \|\phi_n\|_{L^1} = 1$, using the normalization condition.

That Young's-inequality step is the subtle one to get right in Lean — Mathlib has Young's inequality for sequences, but the right `ConvolutionExistsAt` lemma on a compact group is the version you want.

## Why downstream cares

This chapter is the bottleneck for chapter 8: `rightReg_faithful` and `existsSepConv` both call `exists_bump`, and `bump-conv-tendsto` is what lets `existsSepConv` argue "$T_\phi$ doesn't kill $\rho^R(g_0)f - f$ for some $n$."

Cluster: [`chapter:approx-id`](https://github.com/JonCYeh/peter-weyl-lean/issues?q=is%3Aissue+chapter%3Aapprox-id).
