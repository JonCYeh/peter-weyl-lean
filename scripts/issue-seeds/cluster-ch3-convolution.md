**Title:** [Cluster] Ch.3 Convolution: Fubini and change-of-variables on L²(G)

**Type:** cluster — coordinates the 8 sorries in
[PeterWeylComp/Convolution.lean](PeterWeylComp/Convolution.lean) that
share a common technique blocker.

## Scope

Discharge all 8 sorries in
[PeterWeylComp/Convolution.lean](PeterWeylComp/Convolution.lean) (Ch.3 of
the blueprint). From
[blueprint/src/status.tex](blueprint/src/status.tex) §"Cleanup-pass
priorities" item 2.

### Atomic items in this cluster

- [ ] `thm:conv-CS` — Cauchy–Schwarz bound for pointwise convolution
- [ ] `thm:conv-cts` — `f * φ` is continuous when `f, φ ∈ L²`
- [ ] `thm:conv-L2bound` — L² norm bound for convolution
- [ ] `def:Tphi` — bounded operator `T_φ`
- [ ] `thm:Tphi-comm-rightReg` — `T_φ` commutes with right translation
- [ ] `thm:Tphi-adj` — adjoint of `T_φ`
- [ ] `cor:Tphi-selfadj` — `T_φ` self-adjoint when `φ` is symmetric
- [ ] `thm:Tphi-compact` — `T_φ` is a compact operator

## The technique

Almost every Ch.3 sorry reduces to one of two moves on the integral
`(f * φ)(x) = ∫ f(y) φ(y⁻¹ x) dμ(y)`:

1. **Fubini on G × G** (the underlying measurable rectangle is
   `G × G` with product Haar measure). Used to swap the order of
   integration in the pointwise–to–operator-norm Cauchy–Schwarz bound,
   the L² bound, and (with a third integral) the adjoint identity.
2. **Right-invariance change of variables** `y ↦ yh`. Used in
   `thm:Tphi-comm-rightReg` and in the proof of `thm:Tphi-adj`.

Compactness of `T_φ` (`thm:Tphi-compact`) reduces (after a Stone–
Weierstrass-style approximation by trigonometric kernels) to "compact
limit of finite-rank operators", and depends on the L² bound landing
first.

## Mathlib API to reach for

- `MeasureTheory.integral_integral_swap` (Fubini for L¹ functions on a
  product space).
- `MeasureTheory.MeasurePreserving` for right-invariance of Haar — the
  change-of-variable lemma is `MeasurePreserving.integral_comp`.
- `ContinuousLinearMap.compactOperator` and the limit-of-finite-rank
  characterisation for `thm:Tphi-compact`.
- We may need a small helper "convolution-by-an-L²-kernel is
  Hilbert–Schmidt" for the compactness proof; this is the Mathlib gap to
  watch.

## Why it's a cluster, not 8 atomic issues

All eight items want the same Fubini-on-G×G + change-of-variables
plumbing wired up *once*. Two of them additionally want a separate
"limit of finite-rank" argument; that's the only piece that diverges.
A spike PR landing
`thm:conv-CS` end-to-end will set the convention (which Fubini
variant, what hypothesis on the integrand) that the rest mechanically
inherit.

## Suggested order

1. `thm:conv-CS` (the spike — simplest Fubini application).
2. `thm:conv-L2bound` and `thm:conv-cts` in parallel; both reuse
   the spike's setup.
3. `def:Tphi` (purely a packaging step once the L² bound exists).
4. `thm:Tphi-comm-rightReg` — the change-of-variables case.
5. `thm:Tphi-adj`, then `cor:Tphi-selfadj` falls out as a
   one-liner.
6. `thm:Tphi-compact` last — independent technique; do not block the
   above on it.

## Definition of done for the cluster

- [ ] All 8 atomic checkboxes above are checked.
- [ ] [blueprint/src/status.tex](blueprint/src/status.tex) regenerated;
      Ch.3 row reads `0` sorries.
- [ ] Cluster issue closed.

<!-- labels: type:cluster, chapter:conv, area:fubini, priority:p1 -->
