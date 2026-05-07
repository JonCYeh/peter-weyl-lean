/-
Copyright (c) 2026.  Released under Apache 2.0 license.
-/
import Mathlib.Analysis.InnerProductSpace.Adjoint
import Mathlib.Analysis.Normed.Operator.Compact
import PeterWeylComp.Rep

/-!
# Peter–Weyl, Chapter 3: Convolution as a Bounded Operator on `L²(G)`

This file scaffolds the items of Chapter 3 of the compact Peter–Weyl
blueprint (`blueprint/src/content_comp.tex`).  For `φ ∈ L²(G)` we define
the bounded linear operator `T_φ : L²(G) → L²(G)` by `T_φ f = f * φ`
(pointwise convolution against the Haar probability measure), and we
record:

* the pointwise Cauchy–Schwarz bound `|f * φ (x)| ≤ ‖f‖₂ ‖φ‖₂`,
* continuity of `f * φ` as a function on `G`,
* the `L²` norm bound `‖f * φ‖₂ ≤ ‖f‖₂ ‖φ‖₂`,
* the right-equivariance `T_φ ∘ ρ^R(g) = ρ^R(g) ∘ T_φ`,
* self-adjointness for symmetric kernels,
* compactness of `T_φ` via finite-rank approximation.

## Mathlib survey

We searched for existing infrastructure:

* `MeasureTheory.mconvolution` — does not exist.  Mathlib has
  `MeasureTheory.Measure.mconv` (convolution of *measures* on a
  multiplicative monoid) and `MeasureTheory.convolution` (functions on
  an additive group, requires `[Sub G]`).  Neither matches our setting
  (functions on a multiplicative non-abelian group), so we define
  `PeterWeyl.convPtwise` from scratch.
* `IsCompactOperator` (`Mathlib/Analysis/Normed/Operator/Compact.lean`)
  exists with the predicate we need; `isClosed_setOf_isCompactOperator`
  (line 412 of the same file) is the key tool for the finite-rank
  approximation route.
* `HilbertSchmidt` is not in Mathlib, so we use the finite-rank-limit
  approach for compactness rather than Hilbert–Schmidt theory.
* `IsSelfAdjoint` (for continuous linear maps) is in
  `Mathlib/Analysis/InnerProductSpace/Adjoint.lean`; we use it for
  item 10 below.

Most theorem bodies are `sorry`; the file is the Chapter 3 scaffold.
-/

open scoped MeasureTheory ENNReal NNReal InnerProductSpace

namespace PeterWeyl

variable {G : Type*} [Group G] [TopologicalSpace G] [IsTopologicalGroup G]
  [CompactSpace G] [T2Space G] [MeasurableSpace G] [BorelSpace G]

/-! ## Pointwise convolution -/

/-- Pointwise convolution `(f * φ)(x) := ∫ f(y) φ(y⁻¹ x) dμ_G(y)` -/
noncomputable def convPtwise (f φ : G → ℂ) (x : G) : ℂ :=
  ∫ y, f y * φ (y⁻¹ * x) ∂(haarProb G)

/-- Cauchy–Schwarz pointwise bound for `convPtwise` (`thm:conv-CS`) -/
theorem convPtwise_norm_le_L2_L2 (f φ : G → ℂ)
    (hf : MeasureTheory.MemLp f 2 (haarProb G))
    (hφ : MeasureTheory.MemLp φ 2 (haarProb G)) (x : G) :
    ‖convPtwise f φ x‖
      ≤ (MeasureTheory.eLpNorm f 2 (haarProb G)).toReal
        * (MeasureTheory.eLpNorm φ 2 (haarProb G)).toReal := by
  -- TODO: pointwise Cauchy–Schwarz `|∫ f y · φ (y⁻¹ x) dμ| ≤ ‖f‖₂ · ‖y ↦ φ(y⁻¹ x)‖₂`,
  -- then right- and inversion-invariance of `haarProb` (Chapter 1
  -- `haarProb_isMulRightInvariant`, `haarProb_inv_eq_self`) give
  -- `‖y ↦ φ(y⁻¹ x)‖₂ = ‖φ‖₂`.
  sorry

/-- For `f, φ ∈ L²(G)` the convolution `f * φ` is continuous on `G` -/
theorem convPtwise_continuous (f φ : G → ℂ)
    (hf : MeasureTheory.MemLp f 2 (haarProb G))
    (hφ : MeasureTheory.MemLp φ 2 (haarProb G)) :
    Continuous (convPtwise f φ) := by
  -- TODO: write `(f * φ)(x) = ⟨f, ψ_x⟩_{L²}` with
  -- `ψ_x(y) = (φ(y⁻¹ x))^*`, identify the map `x ↦ ψ_x` as the orbit
  -- of the conjugate-reflected `φ` under `leftTransL2`, and apply
  -- `leftTransL2_strongContinuous` (Chapter 2, item 17) plus continuity
  -- of the `L²` inner product.  Currently blocked on Chapter 2's sorry.
  sorry

/-- `L²` norm bound for convolution (`thm:conv-L2bound`) -/
theorem convPtwise_L2_norm_bound (f φ : G → ℂ)
    (hf : MeasureTheory.MemLp f 2 (haarProb G))
    (hφ : MeasureTheory.MemLp φ 2 (haarProb G)) :
    MeasureTheory.eLpNorm (convPtwise f φ) 2 (haarProb G)
      ≤ MeasureTheory.eLpNorm f 2 (haarProb G)
        * MeasureTheory.eLpNorm φ 2 (haarProb G) := by
  -- TODO: square the pointwise bound from `convPtwise_norm_le_L2_L2`,
  -- integrate, and use `(haarProb G) univ = 1` so the constant in the
  -- integration is `1`.
  sorry

/-! ## Convolution as a bounded linear operator -/

/-- The bounded linear convolution operator `T_φ : L²(G) →L[ℂ] L²(G)` -/
noncomputable def convOp (φ : L2 G) : L2 G →L[ℂ] L2 G := by
  -- TODO: define as the unique continuous linear extension of pointwise
  -- convolution from a dense subspace where it is well-defined; the
  -- norm bound `‖T_φ‖_op ≤ ‖φ‖₂` from `convPtwise_L2_norm_bound`
  -- justifies the extension.
  exact sorry

/-- `T_φ` commutes with right translation (`thm:Tphi-comm-rightReg`) -/
theorem convOp_comm_rightReg (φ : L2 G) (g : G) :
    (convOp φ) ∘L (rightReg G).toMonoidHom g
      = (rightReg G).toMonoidHom g ∘L (convOp φ) := by
  -- TODO: verify on the dense subspace `C(G, ℂ)` via the change of
  -- variables `z = y g` and right-invariance of `haarProb`
  -- (Chapter 1 `haarProb_isMulRightInvariant`); extend by continuity.
  sorry

/-- `T_φ` is an intertwiner from `ρ^R` to `ρ^R` (`cor:Tphi-intertwiner`) -/
theorem convOp_isIntertwiner (φ : L2 G) :
    UnitaryRep.IsIntertwiner (convOp φ) (rightReg G) (rightReg G) :=
  fun g => convOp_comm_rightReg φ g

/-! ## Self-adjointness for symmetric kernels -/

/-- A kernel `φ ∈ L²(G)` is symmetric if `φ(g) = conj φ(g⁻¹)` a.e. -/
def IsSymmetricKernel (φ : L2 G) : Prop :=
  ∀ᵐ g ∂(haarProb G), (φ : G → ℂ) g = star ((φ : G → ℂ) g⁻¹)

/-- Adjoint of `T_φ` is `T_(φ̃)` where `φ̃ g = conj φ g⁻¹` (`thm:Tphi-adj`) -/
theorem convOp_adjoint (φ : L2 G) :
    ∃ ψ : L2 G, (convOp φ).adjoint = convOp ψ
      ∧ (∀ᵐ g ∂(haarProb G), (ψ : G → ℂ) g = star ((φ : G → ℂ) g⁻¹)) := by
  -- TODO: Fubini + change of variables `x ↦ y x` (right-invariance,
  -- Chapter 1 `haarProb_isMulRightInvariant`) + `φ(z) = conj φ̃(z⁻¹)`
  -- with inversion-invariance (Chapter 1 `haarProb_inv_eq_self`).
  -- The Fubini step is technical; left as `sorry`.
  sorry

/-- `T_φ` is self-adjoint when `φ` is symmetric (`cor:Tphi-selfadj`) -/
theorem convOp_isSelfAdjoint (φ : L2 G) (hφ : IsSymmetricKernel φ) :
    IsSelfAdjoint (convOp φ) := by
  -- TODO: from `convOp_adjoint` choose `ψ` with `(convOp φ).adjoint = convOp ψ`
  -- and `ψ ≈ φ̃ a.e.`; symmetry says `φ ≈ φ̃ a.e.`, so the underlying L²
  -- classes of `ψ` and `φ` are equal, hence `convOp ψ = convOp φ`.
  sorry

/-! ## Compactness via finite-rank approximation -/

/-- `T_φ` is a compact operator on `L²(G)` (`thm:Tphi-compact`)

Proof route (ii) from the blueprint: finite-rank approximation via the
density of `C(G, ℂ)` in `L²(G)` and the closure of compact operators in
the operator-norm topology (`isClosed_setOf_isCompactOperator`).  Avoids
Hilbert–Schmidt theory, which is not in Mathlib at the time of writing.
-/
theorem convOp_isCompactOperator (φ : L2 G) :
    IsCompactOperator (convOp φ) := by
  -- TODO:
  -- (1) For `φ' ∈ C(G, ℂ)` (continuous), `convOp φ'` has finite rank
  --     after partition-of-unity approximation, hence is compact.
  -- (2) `φ ↦ convOp φ` is bounded with operator-norm bound `‖φ‖₂`
  --     (Definition `convOp` and theorem `convPtwise_L2_norm_bound`),
  --     so `convOp` is continuous as a map `L² → (L² →L L²)`.
  -- (3) `C(G, ℂ)` is dense in `L²(G)` via
  --     `continuousMapToL2_denseRange` (Chapter 1, item 12), so
  --     `convOp φ` is the operator-norm limit of compact operators.
  -- (4) `isClosed_setOf_isCompactOperator` closes the argument.
  sorry

end PeterWeyl
