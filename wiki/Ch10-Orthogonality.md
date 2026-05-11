# Ch. 10 — Schur Orthogonality

- **Blueprint:** `\label{chap:orthog}`
- **Lean module:** [`PeterWeylComp/Orthogonality.lean`](https://github.com/JonCYeh/peter-weyl-lean/blob/main/PeterWeylComp/Orthogonality.lean)
- **Status:** 2 items, 2 sorries (both blocked on Bochner integration scaffolding).

## Statement

Two orthogonality relations for matrix coefficients in $L^2(G)$:

1. **Across distinct irreducibles.** If $\rho, \sigma$ are finite-dim continuous unitary **inequivalent** irreducibles, then for any matrix entries,
   $$
   \langle \pi_{u_1, v_1}^\rho,\ \pi_{u_2, v_2}^\sigma \rangle_{L^2(G)} \;=\; 0.
   $$
2. **Within the same irreducible.** If $\rho$ is a finite-dim irreducible of dimension $d_\rho$,
   $$
   \langle \pi_{u_1, v_1}^\rho,\ \pi_{u_2, v_2}^\rho\rangle_{L^2(G)} \;=\; \frac{1}{d_\rho}\langle u_1, u_2\rangle\,\overline{\langle v_1, v_2\rangle}.
   $$

So matrix coefficients of inequivalent irreducibles are orthogonal in $L^2(G)$, and within one irreducible they're orthogonal up to the rank-1 inner-product factor.

## The proof, one paragraph

Both statements come from averaging an operator over the group: for any bounded operator $A : V \to W$ between two irreducibles, define
$$
A^\sharp := \int_G \sigma(g) A \rho(g)^{-1} d\mu_G(g)
$$
(a bounded operator $V \to W$, well-defined via Bochner integration). Then $A^\sharp$ is an intertwiner $\rho \to \sigma$ — so by Schur it's $0$ if $\rho \not\cong \sigma$, and a scalar $c \cdot \mathrm{Id}$ if $\rho = \sigma$. Compute $\langle A^\sharp u, w\rangle$ for $A$ the rank-1 operator $u \mapsto \langle u, v_2\rangle w_2$, and the two orthogonality formulas pop out. The scalar in the same-irreducible case comes out to $\frac{1}{d_\rho}$ by taking trace.

## Key items

| Name | Lean | Status |
|---|---|---|
| Across-distinct orthogonality | `PeterWeyl.matrixCoeff_orth_of_not_equiv` | sorry |
| Same-irreducible orthogonality | `PeterWeyl.matrixCoeff_orth_self` | sorry |

## Why both are blocked

Both proofs need Bochner integration of operator-valued functions on $G$, with `IsCompactOperator`/`IsHilbertSchmidt` reasoning. The Mathlib API for `∫ g, ContinuousLinearMap …` is there but the bridge to operator-valued Bochner integration on a compact group is ~80–100 lines per statement. This is the "Bochner integration scaffolding" cluster from `status.tex`.

Cluster: [`[Cluster] Ch.10 Bochner-orthogonality`](https://github.com/JonCYeh/peter-weyl-lean/issues?q=is%3Aissue+chapter%3Aorthog).

## What chapter 11 needs from here

The same-irreducible formula gives the $\frac{1}{d_\rho}$ factor in Plancherel; the across-distinct gives orthogonality of the isotypic components. Without Ch. 10, Ch. 11 is blocked on both directions of the Hilbert-sum claim.
