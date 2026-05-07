**Title:** [External] Adjoint of a compact operator is compact (Schauder, Mathlib gap)

**Type:** external assumption — **not** to be proved inside this
repository. Tracks a Mathlib gap and our local handling of it.

## What we assume

Statement (Schauder's theorem on adjoints): for `T : H →L[ℂ] H` on a
complex Hilbert space, if `T` is compact (i.e.
`IsCompactOperator T`), then so is its adjoint `T†`.

Lean side: we cite this as `IsCompactOperator.adjoint` (current
working name) — an axiom-shaped sorry consumed inside the local Schur
proof and the proof that `T_φ` is compact (Ch.3, currently still
sorry-bodied).

## Why we don't prove it here

[blueprint/src/status.tex](blueprint/src/status.tex) §"Architectural
fixes during formalization" notes: *"Schauder's theorem (T† compact
when T is): not in Mathlib at any name we could find. Treated as the
second external assumption."*

Schauder's theorem is a routine but non-trivial functional-analysis
fact: it requires showing the adjoint maps the closed unit ball of the
codomain into a relatively compact subset, typically via Arzelà–
Ascoli on the family `{T†ξ : ‖ξ‖ ≤ 1}` viewed as functions on the
compact image of `T` restricted to the unit ball. Several hundred
lines, properly upstream.

## Difference from `ass:spectral`

Unlike the compact self-adjoint spectral theorem, this assumption is
**not directly cited** from `blueprint/src/content_comp.tex`. It lives
purely on the Lean side, internal to the Schur proof and to
`thm:Tphi-compact`. So there is no `\leanok` to add when it lands;
the only artifact is the local sorry replacement.

## Plan

1. **Short term:** keep the assumption as a single named
   `theorem IsCompactOperator.adjoint := sorry` (or `axiom`, if we
   prefer to make the assumption explicit) in a new file, e.g.
   `PeterWeylComp/CompactAux.lean`. Document call sites with
   `-- consumes IsCompactOperator.adjoint`.
2. **Medium term:** open a Mathlib PR adding this lemma. Likely
   placement: alongside the compact-operator API in
   `Mathlib.Analysis.NormedSpace.CompactOperator`. Suggested name:
   `IsCompactOperator.adjoint` (mirroring our local one) or
   `ContinuousLinearMap.IsCompactOperator.adjoint`.
3. **Long term:** when the upstream lemma lands, replace our local
   stub with the Mathlib name and close this issue.

## Call sites (audit before closing)

To verify we know all the consumers, grep:
```sh
grep -rn 'IsCompactOperator\.adjoint\|consumes IsCompactOperator' PeterWeylComp/
```

Currently expected:
- `PeterWeylComp/Schur.lean` — inside the proof of
  `thm:schur-equivariant-scalar` (the self-adjoint reduction
  branches on adjoint compactness).
- `PeterWeylComp/Convolution.lean` — inside `thm:Tphi-compact`,
  if the proof structure ends up needing it (depends on which
  formalization route we take for compactness; flag as we land
  Ch.3 cluster).

## Definition of done

- [ ] Mathlib PR filed and merged (link here).
- [ ] Local stub replaced with the Mathlib reference at every call
      site.
- [ ] [blueprint/src/status.tex](blueprint/src/status.tex)
      regenerated so it no longer lists this as an external assumption.

<!-- labels: external:mathlib-gap, chapter:schur, chapter:conv -->
