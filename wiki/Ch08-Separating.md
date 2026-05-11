# Ch. 8 — Existence of Separating Finite-Dim Irreducibles

- **Blueprint:** `\label{chap:separating}`
- **Lean module:** [`PeterWeylComp/Separating.lean`](https://github.com/JonCYeh/peter-weyl-lean/blob/main/PeterWeylComp/Separating.lean)
- **Status:** 6 items, 4 sorries — this is the technical core of Tao's proof, depending on chapters 2/3/4/5/6.

## The headline

For every $g_0 \in G$ with $g_0 \neq 1_G$, there exists a finite-dim continuous unitary irreducible representation $(\rho, V)$ of $G$ on which $\rho(g_0) \neq \mathrm{Id}_V$.

That's the **separation** statement: distinct group elements are separated by some finite-dim irrep. Plug that into Stone–Weierstrass in chapter 9 and you get density of matrix coefficients in $C(G)$.

## The strategy

1. `thm:rightReg-faithful` — the right regular rep on $L^2(G)$ separates $1_G$ from $g_0$: there exists $f \in L^2$ with $\rho^R(g_0)f \neq f$. (Proof: take a bump $\phi$ supported in a small $U \ni 1_G$, disjoint from a small neighborhood $V$ of $g_0$; then $\rho^R(g_0)\phi$ has support in $Ug_0^{-1}$ which is disjoint from $\mathrm{supp}\,\phi$.)
2. `thm:existsSepConv` — there exists a **symmetric** bump $\phi$ such that $T_\phi$ is non-zero and $T_\phi(\rho^R(g_0)f - f) \neq 0$ for some $f$. (Proof: take $f$ from step 1, set $f' := \rho^R(g_0)f - f \neq 0$, apply `thm:bump-conv-tendsto` to a sequence of symmetric bumps $\phi_n$ to get $T_{\phi_n}f' \to f' \neq 0$, hence $T_{\phi_n}f' \neq 0$ for some $n$.)
3. `thm:eigenspace-separates` — $T_\phi$ is compact, self-adjoint, $\rho^R$-equivariant ⟹ its spectral decomposition yields a finite-dim non-zero eigenspace $W = \ker(T_\phi - \lambda\,\mathrm{Id})$ which is $\rho^R$-invariant, and the spectral decomposition forces $\rho^R(g_0)$ to act non-trivially on some such eigenspace. (Proof: use $L^2(G) = \ker T_\phi \oplus \widehat{\bigoplus}_i H_{\lambda_i}$ from the spectral theorem; the cocycle $\rho^R(g_0)f - f$ has non-zero projection on $(\ker T_\phi)^\perp$ by step 2, hence non-zero component in some $H_{\lambda_i}$.)
4. `thm:fd-contains-irr` — every finite-dim non-zero invariant subspace contains an irreducible. (Proof: induction on dimension using `orthCompl-invariant` from Ch. 2.)
5. `thm:fd-irr-nontrivial` — and we can choose it so $\rho^R(g_0)$ still acts non-trivially.
6. **Headline** `thm:separating-irr` — packaging steps 1–5.

Steps 1, 2, 3, 5, 6 are sorries; step 4 is real (`\leanok`).

## Key items

| Name | Lean | Status |
|---|---|---|
| right reg faithful | `PeterWeyl.rightReg_faithful` | sorry |
| symmetric bump separates | `PeterWeyl.exists_symmetric_bump_separating` | sorry |
| eigenspace separates $g_0$ | `PeterWeyl.exists_eigenspace_separating` | sorry |
| FD invariant contains irreducible | `PeterWeyl.UnitaryRep.exists_irreducible_subspace_of_finiteDim` | `\leanok` |
| FD irreducible with nontrivial $g_0$-action | `PeterWeyl.UnitaryRep.exists_irreducible_subspace_acting_nontrivially` | sorry |
| **Separation theorem** | `PeterWeyl.UnitaryRep.exists_finiteDim_irreducible_separating` | sorry |

## Why this chapter is the bottleneck

It depends on essentially everything before it:

- Ch. 2 invariant-subspace toolkit (`orthCompl-invariant`)
- Ch. 3 convolution $T_\phi$: compactness, self-adjointness, equivariance
- Ch. 4 existence of symmetric bumps + their convergence
- Ch. 5 spectral theorem (the external assumption)
- Ch. 6 eigenspace-of-intertwiner-is-invariant (well, that's actually Ch. 6 but used here)

So when the prerequisites land, this chapter is mostly transcription. The atomic issues are small.

Cluster: [`[Cluster] Ch.8 Separating irreducibles`](https://github.com/JonCYeh/peter-weyl-lean/issues?q=is%3Aissue+chapter%3Aseparating).
