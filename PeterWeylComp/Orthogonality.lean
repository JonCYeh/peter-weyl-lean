/-
Copyright (c) 2026.  Released under Apache 2.0 license.
-/
import Mathlib.MeasureTheory.Function.L2Space
import Mathlib.RepresentationTheory.FDRep
import PeterWeylComp.MatrixCoeff
import PeterWeylComp.Schur

/-!
# Peter–Weyl, Chapter 10: Schur Orthogonality

This file formalises Chapter 10 of the compact Peter–Weyl blueprint
(`blueprint/src/content_comp.tex`).  The two Schur orthogonality
relations:

* matrix coefficients of non-equivalent finite-dim irreducibles are
  `L²(G)`-orthogonal (item 1);
* matrix coefficients of the same finite-dim irreducible satisfy the
  explicit `1/d` inner-product formula (item 2).

Both follow from Schur's lemma applied to specific equivariant operators
built via Bochner integration over `G`:
`T u := ∫_G π_{u, w₁}^{ρ₁}(g) · ρ₂(g)⁻¹ w₂ dμ_G(g)`.

## Mathlib survey

* `FDRep.finrank_hom_simple_simple`
  (`Mathlib/RepresentationTheory/FDRep.lean:160`): finite-dim Schur
  for the categorical `FDRep k G` type.  Bridging our `UnitaryRep`
  to `FDRep` would be a non-trivial structural transformation
  (different bundling: `FDRep` uses `ModuleCat` over a category, our
  `UnitaryRep` carries a Hilbert-space topology + unitarity), so we
  route through our own Chapter 6 Schur lemmas instead.
* `integral_inner` (`Mathlib/MeasureTheory/Function/L2Space.lean:89`):
  for `f : α → E` integrable, `⟪∫ x, f x ∂μ, c⟫ = ∫ x, ⟪f x, c⟫ ∂μ`.
  Used to expand `⟪T u, w⟫` into the integral identity.
* Continuous functions on compact spaces with finite measure are
  integrable; the matrix coefficients `π_{u,v}^ρ` are continuous
  (Chapter 7 `matrixCoeff_continuous`), so integrability is automatic.
* Bochner integration into a finite-dim Hilbert target works via
  Mathlib's `MeasureTheory.integral` for Banach-space-valued functions.

## Status

Both items are `sorry`-bodied with structured TODOs.  Item 1's full
proof requires defining the equivariant operator `T` via Bochner
integration, verifying intertwining via change-of-variables (using
`haarProb_isMulRightInvariant` from Chapter 1), then routing through
Chapter 6 item 7 (`compact_intertwiner_eq_zero_of_not_equiv`, ⚠ sorry)
to conclude `T = 0`.  Item 2's full proof requires the same `T`
construction, then applies Chapter 6 item 6
(`intertwiner_self_eq_smul`, ✓ real) to get `T = c • id`, followed by
a trace computation to extract the explicit `1/d` factor.  Estimated
~80–100 lines per item beyond the Bochner-integration scaffolding,
exceeding the per-item budget.
-/

open scoped MeasureTheory ENNReal NNReal InnerProductSpace ComplexConjugate

universe u

namespace UnitaryRep

variable {G : Type u} [Group G] [TopologicalSpace G] [IsTopologicalGroup G]
  [CompactSpace G] [T2Space G] [MeasurableSpace G] [BorelSpace G]

/-! ## Item 1: Orthogonality across non-equivalent irreducibles -/

/-- (`thm:c2-mc-orthog-distinct`) Matrix coefficients of non-equivalent
finite-dimensional irreducible representations are `L²(G)`-orthogonal.

Proof outline:

1.  Define `T : V₁ →L[ℂ] V₂` by Bochner integration:
    `T u := ∫_G π_{u, w₁}^{ρ₁}(g) • ρ₂(g)⁻¹ w₂ dμ_G(g)`.
    Bounded automatically (finite-dim codomain) and finite-rank, hence
    compact.

2.  `T` is an intertwiner `ρ₁ → ρ₂`: for any `g₀ ∈ G`,
    `T (ρ₁(g₀) u) = ∫_G π_{ρ₁(g₀) u, w₁}(g) • ρ₂(g)⁻¹ w₂ dμ`
    `= ∫_G π_{u, w₁}(g g₀) • ρ₂(g)⁻¹ w₂ dμ`
    `= ∫_G π_{u, w₁}(g') • ρ₂(g₀ g'⁻¹)⁻¹⁻¹ w₂ dμ`  (change vars `g' = g g₀`,
      using `haarProb_isMulRightInvariant`)
    `= ρ₂(g₀) (T u)`.

3.  By Chapter 6 item 7 (`compact_intertwiner_eq_zero_of_not_equiv`,
    ⚠ sorry), `T = 0`.

4.  Compute `⟪T u₁, u₂⟫_{V₂} = 0` and identify with the integral via
    `integral_inner`.

Both the Bochner-integration scaffolding (~40 lines) and the
intertwiner change-of-variables proof (~30 lines) are deferred. -/
theorem matrixCoeff_inner_eq_zero_of_not_equiv
    {V₁ V₂ : Type u}
    [NormedAddCommGroup V₁] [InnerProductSpace ℂ V₁] [CompleteSpace V₁]
    [NormedAddCommGroup V₂] [InnerProductSpace ℂ V₂] [CompleteSpace V₂]
    (ρ₁ : UnitaryRep G V₁) (ρ₂ : UnitaryRep G V₂)
    [FiniteDimensional ℂ V₁] [FiniteDimensional ℂ V₂]
    (_hρ₁ : ρ₁.IsIrreducible) (_hρ₂ : ρ₂.IsIrreducible)
    (_h_not_equiv : ¬ ρ₁.Equiv ρ₂)
    (u₁ w₁ : V₁) (u₂ w₂ : V₂) :
    ∫ g, ρ₁.matrixCoeff u₁ w₁ g * conj (ρ₂.matrixCoeff u₂ w₂ g)
        ∂(PeterWeyl.haarProb G) = 0 := by
  -- TODO: full proof requires:
  -- 1.  Define `T : V₁ →L[ℂ] V₂` via Bochner integration.  In finite
  --     dimensions, define on a basis: pick orthonormal basis
  --     `{e_i}` of V₂; then for each i, `⟪T u, e_i⟫ = ∫ π_{u,w₁}(g) ·
  --     ⟪ρ₂(g)⁻¹ w₂, e_i⟫ dμ = ∫ π_{u,w₁}(g) · conj ⟪w₂, ρ₂(g) e_i⟫ dμ`.
  --     Bundle as a CLM via `LinearMap.toContinuousLinearMap` (FD).
  -- 2.  Show `T` is an intertwiner `ρ₁ → ρ₂`.  Requires the matrix-
  --     coefficient translation identity (proved inline in Density.lean
  --     as `matrixCoeff_left_translate`, generalized) plus the right-
  --     invariance of `haarProb` (Chapter 1 `haarProb_isMulRightInvariant`,
  --     real ✓).
  -- 3.  T is finite-rank, hence compact (Mathlib's
  --     `IsCompactOperator` of `LinearMap.toContinuousLinearMap` for FD).
  -- 4.  Apply Chapter 6 item 7 (`compact_intertwiner_eq_zero_of_not_equiv`,
  --     ⚠ sorry) to conclude `T = 0`.
  -- 5.  Compute `⟪T u₁, u₂⟫_{V₂} = 0`; identify via `integral_inner`
  --     with the stated integral.
  sorry

/-! ## Item 2: Same-irreducible orthogonality with explicit `1/d` -/

/-- (`thm:c2-mc-orthog-same`) Schur orthogonality, same-irreducible
form.  For a finite-dim irreducible `ρ : UnitaryRep G V` of dimension
`d := dim V`,
`∫_G π_{u₁,v₁}^ρ(g) · conj π_{u₂,v₂}^ρ(g) dμ_G(g) =
   (1/d) · ⟪u₁, u₂⟫ · conj ⟪v₁, v₂⟫`.

Proof outline:

1.  Define `T : V →L[ℂ] V` by `T u := ∫_G π_{u, v₁}^ρ(g) • ρ(g)⁻¹ v₂ dμ_G(g)`
    (Bochner; same as item 1 with `V₁ = V₂ = V`).

2.  `T` is a compact intertwiner `ρ → ρ` (same argument as item 1).
    By Chapter 6 item 6 (`intertwiner_self_eq_smul`, ✓ real),
    `T = c • id` for some `c : ℂ`.

3.  Take traces: `LinearMap.trace ℂ V T = c · d`.  On the other hand,
    by linearity of trace and integration,
    `LinearMap.trace ℂ V T = ∫ π_{u,v₁}(g) · trace(ρ(g)⁻¹ ⟨·, v₂⟩ · v₂) dμ`
    after the rank-one operator identification, and after using unitarity
    `ρ(g)⁻¹ = ρ(g⁻¹)` and the inversion-invariance of `haarProb`
    (`haarProb_inv_eq_self`, real ✓), this evaluates to
    `⟪v₁, v₂⟫_conj · ⟪u₁, u₂⟫`.

4.  Solving `c · d = ⟪v₁, v₂⟫_conj · ⟪u₁, u₂⟫` gives the formula.

5.  The original integral is recovered via
    `⟪T u₁, u₂⟫ = ∫ π_{u₁, v₁}(g) · ⟪ρ(g)⁻¹ v₂, u₂⟫ dμ`, and
    `⟪ρ(g)⁻¹ v₂, u₂⟫ = ⟪v₂, ρ(g) u₂⟫ = conj ⟪ρ(g) u₂, v₂⟫
       = conj π_{u₂, v₂}(g)`.

Total estimated 100+ lines of Lean given the trace computation and
Bochner-integral manipulations; sorry'd as effort-bounded.  Note that
unlike item 1, item 2 does *not* depend transitively on Chapter 6
item 7 (the distinct-irrep Schur) — only on item 6
(`intertwiner_self_eq_smul`, real ✓).  The remaining obstruction is
the Bochner-integration scaffolding plus the trace computation. -/
theorem matrixCoeff_inner_eq
    {V : Type u}
    [NormedAddCommGroup V] [InnerProductSpace ℂ V] [CompleteSpace V]
    (ρ : UnitaryRep G V) [FiniteDimensional ℂ V]
    (_hρ : ρ.IsIrreducible)
    (u₁ u₂ v₁ v₂ : V) :
    ∫ g, ρ.matrixCoeff u₁ v₁ g * conj (ρ.matrixCoeff u₂ v₂ g)
        ∂(PeterWeyl.haarProb G)
      = (1 / (Module.finrank ℂ V : ℂ))
        * ⟪u₁, u₂⟫_ℂ * conj ⟪v₁, v₂⟫_ℂ := by
  -- TODO: full proof requires the Bochner-integration `T : V →L[ℂ] V`
  -- construction (same as item 1, V₁ = V₂ = V), plus the trace
  -- computation outlined in the docstring.  Estimated 100+ lines.
  sorry

end UnitaryRep
