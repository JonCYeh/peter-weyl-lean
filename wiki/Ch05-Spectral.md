# Ch. 5 — The Compact Self-Adjoint Spectral Theorem (External)

- **Blueprint:** `\label{chap:spectral}`
- **Lean module:** [`PeterWeylComp/Schur.lean`](https://github.com/JonCYeh/peter-weyl-lean/blob/main/PeterWeylComp/Schur.lean) (the assumption is stated alongside its consumer)
- **Status:** 2 items, 1 intentional external assumption + 1 derived corollary.

## What this chapter is for

It quarantines **one** external assumption that the rest of the project freely uses. As of Mathlib's Jan 2026 state, the bundled compact self-adjoint spectral theorem is not formalized — the constituent pieces are in [`Mathlib/Analysis/InnerProductSpace/Spectrum.lean`](https://leanprover-community.github.io/mathlib4_docs/Mathlib/Analysis/InnerProductSpace/Spectrum.html) but not the combined statement. So this project assumes it and waits for upstream.

## The assumption

```
PeterWeyl.ContinuousLinearMap.IsCompactOperator
  .IsSelfAdjoint.spectralDecomposition
```

In symbols: for $T : H \to_L H$ compact and self-adjoint on a complex Hilbert space, there is an at-most-countable family $\{\lambda_i\}_{i \in I}$ of non-zero real eigenvalues and finite-dim eigenspaces $H_i = \ker(T - \lambda_i\mathrm{Id})$ such that

- each $H_i$ is finite-dim;
- the $H_i$ are mutually orthogonal;
- $|\lambda_i| \to 0$ if $I$ is infinite;
- $\overline{\bigoplus_i H_i} = (\ker T)^\perp$;
- equivalently, $H = \ker T \oplus \widehat{\bigoplus}_i H_i$ as a Hilbert sum.

## The one corollary used everywhere

```
PeterWeyl.ContinuousLinearMap.IsCompactOperator
  .IsSelfAdjoint.exists_eigenvalue
```

"If $T$ is compact, self-adjoint, and non-zero, then it has a non-zero real eigenvalue $\lambda$ with finite-dim eigenspace $H_\lambda$." This is `\leanok` (derivable from the assumption); it's the form invoked by chapters 6 and 8.

## What is NOT external

Many specific consequences of the spectral theorem are derivable on the fly from the bundled version above and are NOT external — they're proved in Lean against the assumption. The intent is: once Mathlib has `spectralDecomposition`, you swap the assumption for the Mathlib lemma in one place and everything downstream type-checks unchanged.

## The other external assumption (not in this chapter)

A **second** external assumption, **Schauder's theorem** ("the adjoint of a compact operator is compact"), is used internally by chapter 6's Schur proof but is not cited from `content_comp.tex`. It's tracked separately as [`[External] Adjoint of a compact operator is compact`](https://github.com/JonCYeh/peter-weyl-lean/issues/48).

## Policy

External assumptions stay external until Mathlib has them. **Don't try to prove them in this repo** — file an upstream PR. The project's job is Peter–Weyl, not closing Mathlib gaps that happen to come up.

Issues: [`external:mathlib-gap` label](https://github.com/JonCYeh/peter-weyl-lean/issues?q=is%3Aissue+label%3Aexternal%3Amathlib-gap).
