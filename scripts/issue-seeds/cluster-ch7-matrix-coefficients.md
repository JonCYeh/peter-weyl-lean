**Title:** [Cluster] Ch.7 Matrix coefficients: tensor and contragredient representations

**Type:** cluster — coordinates the 5 sorries in
[PeterWeylComp/MatrixCoeff.lean](PeterWeylComp/MatrixCoeff.lean) that
all flow from two missing constructions on `UnitaryRep`.

## Scope

Discharge the 5 sorries in
[PeterWeylComp/MatrixCoeff.lean](PeterWeylComp/MatrixCoeff.lean). From
[blueprint/src/status.tex](blueprint/src/status.tex): "sorry: tensor,
contragredient, related".

### Atomic items in this cluster

- [ ] `thm:mc-add` — sum of matrix coefficients is a matrix coefficient
- [ ] `def:tensor-rep` — tensor product of unitary reps
- [ ] `thm:mc-product` — product of matrix coefficients is a matrix
  coefficient (of the tensor product)
- [ ] `def:contragredient` — contragredient (dual) representation
- [ ] `thm:mc-conj` — conjugate of a matrix coefficient is a matrix
  coefficient (of the contragredient)

## The technique

Two reusable constructions are missing on our `UnitaryRep` type, and
each unblocks two atomic items:

1. **Tensor product** `ρ ⊗ σ : UnitaryRep G (V ⊗[ℂ] W)`:
   - underlying space: completion of `V ⊗[ℂ] W` to a Hilbert tensor
     product;
   - action: `(ρ ⊗ σ)(g) := ρ(g) ⊗L σ(g)`;
   - unitarity, multiplicativity, and strong continuity all transfer
     coordinatewise from `ρ` and `σ`.
   Once defined, `thm:mc-product` is a one-liner: matrix-coefficient
   pairing on `V ⊗ W` evaluated on a pure tensor `(u₁ ⊗ u₂, v₁ ⊗ v₂)`
   factors as the product of matrix coefficients.

2. **Contragredient** `ρ* : UnitaryRep G V*` where `V*` is the
   conjugate-dual Hilbert space:
   - action: `ρ*(g) := (ρ(g⁻¹))*` (adjoint, which on a Hilbert space
     equals conjugate-transpose);
   - unitarity is `(ρ(g⁻¹))** = ρ(g⁻¹)` plus the unitarity of `ρ`.
   Once defined, `thm:mc-conj` is `π_{u,v}^{ρ}(g) ̅ = π_{v',u'}^{ρ*}(g)`
   for the canonical conjugate-linear iso `V → V*`.

`thm:mc-add` (the addition lemma) is independent of both
constructions and is a one-liner from linearity of the inner product;
it's grouped here only because the file reorganization that lands
tensor/contragredient is the natural moment to clean up the linearity
lemmas.

## Mathlib API to reach for

- `TensorProduct` and `TensorProduct.AlgebraTensorModule` for the
  algebraic tensor product; `Submodule.HilbertTensorProduct` (if it
  exists by that name in the current Mathlib) for the Hilbert
  completion. **Verify this is in Mathlib at the toolchain we use** —
  if not, scope a small upstreamable lemma rather than reinventing.
- `LinearMap.adjoint` for the adjoint used in the contragredient
  action.
- `InnerProductSpace.toDual` (or its conjugate-linear sibling) for the
  identification `V ≃ V*`.

If the Hilbert tensor product is not yet in Mathlib for our toolchain,
flag it on the cluster issue and consider an external assumption rather
than reinventing several hundred lines of analysis.

## Why it's a cluster, not 5 atomic issues

Splitting tensor + product-of-matrix-coefficients across two
contributors will cause one to redo the other's tensor-product setup.
Same for contragredient + conjugate. Land each construction in its own
PR (no blueprint citation), then open a follow-up that closes the two
dependent atomic items.

## Suggested order

1. `thm:mc-add` (independent; warmup).
2. `def:tensor-rep` spike PR. Then open `thm:mc-product` for
   pickup.
3. `def:contragredient` spike PR. Then open `thm:mc-conj` for
   pickup.

## Definition of done for the cluster

- [ ] All 5 atomic checkboxes above are checked.
- [ ] [blueprint/src/status.tex](blueprint/src/status.tex) regenerated;
      Ch.7 row reads `0` sorries.

<!-- labels: type:cluster, chapter:matrix, area:tensor, priority:p2 -->
