# Ch. 3 — Convolution as a Bounded Operator on $L^2(G)$

- **Blueprint:** `\label{chap:conv}`
- **Lean module:** [`PeterWeylComp/Convolution.lean`](https://github.com/JonCYeh/peter-weyl-lean/blob/main/PeterWeylComp/Convolution.lean)
- **Status:** 12 items, 8 sorries (cluster: pointwise + $L^2$ machinery, Fubini, change-of-variables).

## Goal

For each $\phi \in L^2(G)$, build a bounded linear operator
$$
T_\phi : L^2(G) \to_L L^2(G), \qquad T_\phi f = f * \phi
$$
where $(f * \phi)(x) = \int_G f(y)\,\phi(y^{-1}x)\,d\mu_G(y)$, and prove three properties of $T_\phi$:

1. **Compactness** — Hilbert–Schmidt kernel argument, via approximation by finite-rank operators using density of $C(G \times G)$ in $L^2(G \times G)$.
2. **Self-adjointness** — when $\phi$ is **symmetric**, meaning $\phi(g) = \overline{\phi(g^{-1})}$ a.e.
3. **Right-equivariance** — $T_\phi$ commutes with $\rho^R(g)$, so $T_\phi$ is an intertwiner $\rho^R \to \rho^R$. This is the property that makes the spectral decomposition of $T_\phi$ give us $\rho^R$-invariant subspaces in Ch. 8.

## Key objects

| Name | Lean | What |
|---|---|---|
| Pointwise convolution | `PeterWeyl.convPtwise` | Wraps `MeasureTheory.mconvolution`. |
| Cauchy–Schwarz pointwise bound | `PeterWeyl.convPtwise_norm_le_L2_L2` | $|(f*\phi)(x)| \leq \|f\|_{L^2}\|\phi\|_{L^2}$. |
| Convolution is continuous | `PeterWeyl.convPtwise_continuous` | $f*\phi \in C(G)$ when $f, \phi \in L^2$. |
| $L^2$ norm bound | `PeterWeyl.convPtwise_L2_norm_bound` | $\|f*\phi\|_{L^2} \leq \|f\|_{L^2}\|\phi\|_{L^2}$, uses $\mu_G(G) = 1$. |
| **$T_\phi$** | `PeterWeyl.convOp` | The bounded operator $L^2 \to_L L^2$. |
| Right-equivariance | `PeterWeyl.convOp_comm_rightReg` | $T_\phi \rho^R(g) = \rho^R(g) T_\phi$. |
| Intertwiner upgrade | `PeterWeyl.convOp_isIntertwiner` | Just the bundling. |
| Symmetric kernel predicate | `PeterWeyl.IsSymmetricKernel` | $\phi(g) = \overline{\phi(g^{-1})}$ a.e. |
| Adjoint formula | `PeterWeyl.convOp_adjoint` | $(T_\phi)^* = T_{\widetilde\phi}$, $\widetilde\phi(g) = \overline{\phi(g^{-1})}$. |
| Self-adjoint when symmetric | `PeterWeyl.convOp_isSelfAdjoint` | Immediate corollary. |
| Compact | `PeterWeyl.convOp_isCompactOperator` | Approximation by finite-rank. |

## What's blocked, why

The 8 sorries are all in the same family: they need Fubini and change-of-variables on the $L^2$ side, which is doable but heavy-lifting-against-Mathlib. The compactness proof (`convOp_isCompactOperator`) is sketched as **approach (ii)** in the blueprint — approximation by finite-rank via density of $C(G \times G)$ in $L^2(G \times G)$ — because going through a full Hilbert–Schmidt theory would require more Mathlib than is currently there.

Cluster issue: [`[Cluster] Ch.3 Convolution`](https://github.com/JonCYeh/peter-weyl-lean/issues?q=is%3Aissue+chapter%3Aconv) — `area:fubini` label.

## Why this matters downstream

Chapter 8's whole argument is: pick a non-zero $g_0$, find a symmetric bump $\phi$ such that $T_\phi$ doesn't kill the cocycle $\rho^R(g_0)f - f$, then **the spectral theorem applied to $T_\phi$** gives a finite-dim non-zero eigenspace on which $\rho^R(g_0)$ still acts non-trivially. Every adjective on $T_\phi$ — compact, self-adjoint, $\rho^R$-equivariant — is used there.
