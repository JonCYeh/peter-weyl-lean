**Title:** [External] Compact self-adjoint spectral theorem (Mathlib gap)

**Type:** external assumption — **not** to be proved inside this
repository in its current form. Tracks a known Mathlib gap and our
local handling of it.

## What we assume

Statement (`ass:spectral`, Ch.5 of `blueprint/src/content_comp.tex`):
for a compact self-adjoint operator `T : H →L[ℂ] H` on a complex Hilbert
space `H`, there exists a countable family of real eigenvalues
`{λ_n}_{n∈ℕ}` (with `λ_n → 0` if infinite) and finite-dimensional
mutually orthogonal eigenspaces `{E_n}` such that the closed linear span
of `⋃ E_n` equals `(ker T)^⊥`.

Lean side: we cite `PeterWeyl.spectralDecomposition` (or whatever current
name we settle on) as an axiom-shaped `theorem ... := sorry` that other
proofs in [PeterWeylComp/Schur.lean](PeterWeylComp/Schur.lean) consume.

## Why we don't prove it here

[blueprint/src/status.tex](blueprint/src/status.tex) §"Architectural fixes
during formalization" → "Two external assumptions" notes that Mathlib has
the *constituent pieces* in
[`Mathlib/Analysis/InnerProductSpace/Spectrum.lean`](https://leanprover-community.github.io/mathlib4_docs/Mathlib/Analysis/InnerProductSpace/Spectrum.html)
but **not the bundled statement we need**. Specifically:

- Mathlib has `LinearMap.IsSymmetric.eigenvectorBasis` and the spectral
  theorem for self-adjoint operators on a finite-dimensional inner
  product space.
- Mathlib has the spectral theorem for compact operators in the language
  of `IsHilbertSum`, but the bundled "countable eigenvalue family with
  FD eigenspaces and dense span on `(ker T)^⊥`" form we want is
  scattered across files.

Reproving this inside `PeterWeyl/` would be hundreds of lines that
properly belong upstream.

## Plan

1. **Short term (now):** keep the assumption as an explicit named
   `theorem ... := sorry` in `PeterWeylComp/Schur.lean`. Document each
   downstream consumer at its call site (`-- consumes ass:spectral`).
   Add the corresponding `\leanok`-equivalent comment in the blueprint
   so the dep-graph reflects "intentional assumption, not pending
   formalization."
2. **Medium term:** open a Mathlib PR that bundles
   `Mathlib.Analysis.InnerProductSpace.Spectrum`'s pieces into the form
   we need. Likely lemma names:
   - `IsSelfAdjoint.IsCompactOperator.spectralDecomposition`
   - or a `…toHilbertSumOfEigenspaces` constructor in the existing
     `Spectrum` namespace.
   Track the upstream PR # here once filed.
3. **Long term:** when the Mathlib lemma lands, replace our `sorry` with
   `Mathlib...`, mark `\leanok`, close this issue.

## What this issue is for (vs. an atomic)

This issue's job is **not** to chase a `\leanok`. It exists to:

- be the canonical pointer for "where does the compact-self-adjoint
  spectral theorem come from in this repo";
- track the Mathlib upstream PR (paste the PR # in the description when
  filed);
- record the call-site count so we can spot if usage grows
  (currently: `PeterWeylComp/Schur.lean` only, one call site).

## Definition of done

- [ ] Mathlib PR filed and merged (link here).
- [ ] Local `theorem spectralDecomposition := sorry` replaced with a
      Mathlib reference.
- [ ] `\leanok` added to `ass:spectral` in
      `blueprint/src/content_comp.tex`.
- [ ] [blueprint/src/status.tex](blueprint/src/status.tex) regenerated
      so it no longer lists this as an external assumption.

<!-- labels: external:mathlib-gap, chapter:spectral -->
