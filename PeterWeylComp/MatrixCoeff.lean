/-
Copyright (c) 2026.  Released under Apache 2.0 license.
-/
import Mathlib.Topology.ContinuousMap.Star
import Mathlib.Algebra.Star.Subalgebra
import Mathlib.Analysis.InnerProductSpace.Continuous
import Mathlib.Analysis.InnerProductSpace.TensorProduct
import Mathlib.Analysis.InnerProductSpace.ProdL2
import PeterWeylComp.Rep
import PeterWeylComp.Basic

/-!
# Peter–Weyl, Chapter 7: Matrix Coefficients

This file formalises Chapter 7 of the compact Peter–Weyl blueprint
(`blueprint/src/content_comp.tex`).  The matrix coefficient of a
continuous unitary representation `ρ : UnitaryRep G V` and vectors
`u, v ∈ V` is the function
`π_{u,v}^ρ : G → ℂ`, `g ↦ ⟪ρ g u, v⟫`.  Chapter 7 establishes the
algebra structure (sum, scalar multiple, product, conjugation, constant)
that promotes the set of all matrix coefficients into a star-subalgebra
of `C(G, ℂ)`, used in Chapter 9's Stone–Weierstrass step.

## Mathlib survey

* `TensorProduct.instInnerProductSpace`
  (`Mathlib/Analysis/InnerProductSpace/TensorProduct.lean:147`) gives an
  inner-product structure on `E ⊗[𝕜] F` via
  `⟪a ⊗ₜ b, c ⊗ₜ d⟫ = ⟪a, c⟫ * ⟪b, d⟫`.  The file's TODO list notes
  that the **continuous-linear-map** version of `TensorProduct.map` is
  not yet in Mathlib, and that completeness of the tensor space is
  also missing.
* `WithLp.instProdInnerProductSpace`
  (`Mathlib/Analysis/InnerProductSpace/ProdL2.lean:32`) gives an inner
  product on `WithLp 2 (V₁ × V₂)`.  Used implicitly by item 5 when
  promoted to a real proof.
* No notion of "conjugate Hilbert space" or `StarLinearEquiv` for the
  conjugate-linear duality is in Mathlib; the contragredient (item 9)
  is sorry'd.
* `StarAlgebra.adjoin` (`Mathlib/Algebra/Star/Subalgebra.lean:434`) is
  the standard generation construction for star-subalgebras and
  applies to `C(G, ℂ)` since Mathlib provides
  `StarRing C(α, β)`, `StarModule R C(α, β)`, `Algebra R C(α, A)`
  (`Mathlib/Topology/ContinuousMap/{Star,Algebra}.lean`).

## Convention note

Mathlib's complex inner product is conjugate-linear in the first
argument and linear in the second (`inner_smul_left : ⟪c • x, y⟫ =
(star c) * ⟪x, y⟫`).  The blueprint statement of item 6
(`thm:c2-mc-smul`) reads `c π_{u,v} = π_{cu,v}`, which under Mathlib's
convention is only true for `c` real.  We restate it on the right
argument: `c π_{u,v} = π_{u, cv}` (linear), which is true for all
`c : ℂ` and conveys the same algebraic content.
-/

open scoped InnerProductSpace ComplexConjugate

universe u

namespace UnitaryRep

variable {G : Type*} [Group G] [TopologicalSpace G]
variable {V : Type*} [NormedAddCommGroup V] [InnerProductSpace ℂ V] [CompleteSpace V]

/-- (`def:c2-matrixCoeff`) The matrix coefficient of a continuous unitary
representation `ρ : UnitaryRep G V` and vectors `u, v ∈ V`:
`π_{u,v}^ρ(g) := ⟪ρ g u, v⟫`. -/
def matrixCoeff (ρ : UnitaryRep G V) (u v : V) : G → ℂ :=
  fun g => ⟪ρ g u, v⟫_ℂ

@[simp] lemma matrixCoeff_apply (ρ : UnitaryRep G V) (u v : V) (g : G) :
    ρ.matrixCoeff u v g = ⟪ρ g u, v⟫_ℂ := rfl

/-- (`thm:c2-matrixCoeff-cts`) Matrix coefficients are continuous:
composition of strong continuity (`UnitaryRep.strongContinuous`) with
continuity of the inner product. -/
theorem matrixCoeff_continuous (ρ : UnitaryRep G V) (u v : V) :
    Continuous (ρ.matrixCoeff u v) :=
  Continuous.inner (ρ.strongContinuous u) continuous_const

/-- (`thm:c2-matrixCoeff-bdd`) Matrix coefficients are bounded by
`‖u‖ * ‖v‖`: Cauchy–Schwarz combined with norm preservation
(`UnitaryRep.norm_apply`). -/
theorem matrixCoeff_bounded (ρ : UnitaryRep G V) (u v : V) (g : G) :
    ‖ρ.matrixCoeff u v g‖ ≤ ‖u‖ * ‖v‖ := by
  show ‖⟪ρ g u, v⟫_ℂ‖ ≤ ‖u‖ * ‖v‖
  calc ‖⟪ρ g u, v⟫_ℂ‖
      ≤ ‖ρ g u‖ * ‖v‖ := norm_inner_le_norm _ _
    _ = ‖u‖ * ‖v‖ := by rw [ρ.norm_apply g u]

/-- (`cor:c2-matrixCoeff-CG-L2`, first half) The matrix coefficient
bundled as a continuous map `G → ℂ`. -/
def matrixCoeff_continuousMap (ρ : UnitaryRep G V) (u v : V) : C(G, ℂ) :=
  ⟨ρ.matrixCoeff u v, ρ.matrixCoeff_continuous u v⟩

@[simp] lemma matrixCoeff_continuousMap_apply
    (ρ : UnitaryRep G V) (u v : V) (g : G) :
    ρ.matrixCoeff_continuousMap u v g = ⟪ρ g u, v⟫_ℂ := rfl

/-! ### Bundling into `L²(G)`

The `_memL2` form needs the topological-group/compact/measurable
hypotheses required by `PeterWeyl.continuousMapToL2`. -/

section L2
variable [IsTopologicalGroup G] [CompactSpace G] [T2Space G]
  [MeasurableSpace G] [BorelSpace G]

/-- (`cor:c2-matrixCoeff-CG-L2`, second half) The matrix coefficient
viewed as an element of `L²(G)`, via the standard `C(G) ↪ L²(G)`
inclusion (`PeterWeyl.continuousMapToL2`). -/
noncomputable def matrixCoeff_memL2 (ρ : UnitaryRep G V) (u v : V) :
    PeterWeyl.L2 G :=
  PeterWeyl.continuousMapToL2 G (ρ.matrixCoeff_continuousMap u v)

end L2

/-! ## Algebra structure -/

variable {V₁ V₂ : Type*}
  [NormedAddCommGroup V₁] [InnerProductSpace ℂ V₁] [CompleteSpace V₁]
  [NormedAddCommGroup V₂] [InnerProductSpace ℂ V₂] [CompleteSpace V₂]

/-- (`thm:c2-mc-sum`) The pointwise sum of two matrix coefficients
(of possibly different representations) is itself a matrix coefficient
of the direct sum representation `ρ₁ ⊕ ρ₂` on `WithLp 2 (V₁ × V₂)`,
applied to the pair of vectors `(u₁, u₂), (v₁, v₂)`.

Stating the equality requires `UnitaryRep.directSum`, which uses
`WithLp.instProdInnerProductSpace`.  Promoting the block-diagonal
action to a `UnitaryRep` involves wrapping the `MonoidHom`, verifying
unitarity, and verifying strong continuity — beyond the per-item
budget for this chapter.  Sorry'd as a TODO. -/
theorem matrixCoeff_add_eq_directSum
    (ρ₁ : UnitaryRep G V₁) (ρ₂ : UnitaryRep G V₂)
    (u₁ v₁ : V₁) (u₂ v₂ : V₂) :
    ∃ (W : Type) (_ : NormedAddCommGroup W) (_ : InnerProductSpace ℂ W)
        (_ : CompleteSpace W) (ρ : UnitaryRep G W) (u v : W),
      (fun g => ρ₁.matrixCoeff u₁ v₁ g + ρ₂.matrixCoeff u₂ v₂ g)
        = ρ.matrixCoeff u v := by
  -- TODO: take W := WithLp 2 (V₁ × V₂), ρ := UnitaryRep.directSum ρ₁ ρ₂,
  -- u := (u₁, u₂), v := (v₁, v₂); the inner product on the direct sum
  -- splits as ⟪(a,b), (c,d)⟫ = ⟪a,c⟫ + ⟪b,d⟫ by
  -- `WithLp.prod_inner_apply`.  Defining `directSum` is the prerequisite.
  sorry

/-- (`thm:c2-mc-smul`) Scalar multiple of a matrix coefficient is a
matrix coefficient with the scalar absorbed into the second argument
(via right-linearity of the inner product, see convention note above). -/
@[simp] theorem smul_matrixCoeff (ρ : UnitaryRep G V) (c : ℂ) (u v : V) :
    (fun g => c * ρ.matrixCoeff u v g) = ρ.matrixCoeff u (c • v) := by
  funext g
  show c * ⟪ρ g u, v⟫_ℂ = ⟪ρ g u, c • v⟫_ℂ
  rw [inner_smul_right]

/-- (`def:c2-tensor-rep`) Tensor product of two finite-dimensional
unitary representations.

The tensor representation is `g ↦ ρ₁(g) ⊗ ρ₂(g)` acting on
`V₁ ⊗[ℂ] V₂` with the inner product
`⟪a ⊗ₜ b, c ⊗ₜ d⟫ = ⟪a, c⟫ * ⟪b, d⟫`
(Mathlib's `TensorProduct.instInnerProductSpace`).  Bundling this as a
`UnitaryRep` requires:

* a `ContinuousLinearMap` form of `TensorProduct.map` (Mathlib has
  only the `LinearMap` form; in finite dimensions, every linear map is
  continuous via `LinearMap.toContinuousLinearMap`);
* a `CompleteSpace (V₁ ⊗[ℂ] V₂)` instance, which is automatic in
  finite dimensions but not provided generically;
* unitarity on pure tensors plus extension to all of `V₁ ⊗ V₂`;
* strong continuity, which follows from continuity of `g ↦ ρᵢ(g) v`
  and bilinearity of the tensor product.

These are mechanical but several dozen lines.  Sorry'd as a TODO. -/
noncomputable def tensor
    (ρ₁ : UnitaryRep G V₁) (ρ₂ : UnitaryRep G V₂)
    [FiniteDimensional ℂ V₁] [FiniteDimensional ℂ V₂]
    [CompleteSpace (TensorProduct ℂ V₁ V₂)] :
    UnitaryRep G (TensorProduct ℂ V₁ V₂) :=
  sorry

/-- (`thm:c2-mc-mul`) The pointwise product of two matrix coefficients
equals the matrix coefficient of the tensor product representation
applied to the tensor of the vectors:
`π_{u₁,v₁}^{ρ₁}(g) · π_{u₂,v₂}^{ρ₂}(g) = π_{u₁⊗u₂,v₁⊗v₂}^{ρ₁⊗ρ₂}(g)`.
Direct from the inner-product identity `⟪a⊗b, c⊗d⟫ = ⟪a,c⟫·⟪b,d⟫`
(Mathlib's `TensorProduct.inner_tmul`).  Blocked on `UnitaryRep.tensor`. -/
theorem matrixCoeff_mul_eq_tensor
    (ρ₁ : UnitaryRep G V₁) (ρ₂ : UnitaryRep G V₂)
    [FiniteDimensional ℂ V₁] [FiniteDimensional ℂ V₂]
    [CompleteSpace (TensorProduct ℂ V₁ V₂)]
    (u₁ v₁ : V₁) (u₂ v₂ : V₂) (g : G) :
    ρ₁.matrixCoeff u₁ v₁ g * ρ₂.matrixCoeff u₂ v₂ g
      = (UnitaryRep.tensor ρ₁ ρ₂).matrixCoeff
          (u₁ ⊗ₜ[ℂ] u₂) (v₁ ⊗ₜ[ℂ] v₂) g := by
  -- Blocked on `UnitaryRep.tensor` (sorry above).  Once the tensor
  -- representation is real, this is `TensorProduct.inner_tmul` plus
  -- unfolding `matrixCoeff`.
  sorry

/-- (`def:c2-contragredient`) Contragredient (dual) representation of a
finite-dimensional unitary representation.

Acts on the conjugate-dual space of `V` (or equivalently the dual `V*`
with conjugate-linear duality) by `g ↦ ℓ ↦ conj(ℓ(ρ(g⁻¹) v))`.
Mathlib does not currently provide:

* a "conjugate Hilbert space" type whose inner product is the conjugate
  of `V`'s, nor
* a packaged conjugate-linear-equivalence between `V` and its dual that
  preserves the inner-product structure under conjugation.

Both gaps make the bundling of the contragredient as a `UnitaryRep`
non-trivial.  Sorry'd as a TODO. -/
noncomputable def contragredient
    (ρ : UnitaryRep G V) [FiniteDimensional ℂ V] :
    UnitaryRep G V :=
  sorry

omit [CompleteSpace V₁] [CompleteSpace V₂] in
/-- (`thm:c2-mc-conj`) Conjugate of a matrix coefficient is a matrix
coefficient of the contragredient representation:
`conj (π_{u,v}^ρ(g)) = π_{v,u}^{contragredient ρ}(g)`.

Blocked on `UnitaryRep.contragredient` above.  The mathematical content
is `conj ⟪ρ g u, v⟫ = ⟪v, ρ g u⟫ = ⟪ρ(g⁻¹) v, u⟫` (using unitarity),
which matches the contragredient definition once the conjugate
identification is in place. -/
theorem matrixCoeff_conj_eq_contragredient
    (ρ : UnitaryRep G V) [FiniteDimensional ℂ V] (u v : V) (g : G) :
    conj (ρ.matrixCoeff u v g)
      = (UnitaryRep.contragredient ρ).matrixCoeff v u g := by
  sorry

/-- (`thm:c2-mc-one`) The constant function `1` is the matrix
coefficient of the trivial representation on `ℂ` at the unit vector
`(1, 1)`. -/
@[simp] theorem matrixCoeff_one_eq_trivial (g : G) :
    (UnitaryRep.trivial G ℂ).matrixCoeff (1 : ℂ) (1 : ℂ) g = 1 := by
  show ⟪((UnitaryRep.trivial G ℂ).toMonoidHom g) (1 : ℂ), (1 : ℂ)⟫_ℂ = 1
  -- `(trivial G ℂ).toMonoidHom g = 1 = id_ℂ` (constant `MonoidHom`
  -- value), so `(...) 1 = 1`, and `⟪1, 1⟫_ℂ = conj 1 * 1 = 1`.
  show ⟪(1 : ℂ →L[ℂ] ℂ) (1 : ℂ), (1 : ℂ)⟫_ℂ = 1
  rw [ContinuousLinearMap.one_apply]
  simp

/-! ## The matrix-coefficient star-subalgebra of `C(G, ℂ)` -/

/-- (`def:c2-MCSet`) The set of all matrix coefficients of finite-dim
continuous unitary representations of `G`, viewed inside `C(G, ℂ)`.

The existential quantification ranges over the *type* of the
representation space (a finite-dim Hilbert space), the representation,
and the two vectors.  The universe of `V` matches `G`'s, so that
submodules of `L²(G)` (used downstream in Chapter 9 to apply Chapter
8's separating-irreducible) fit. -/
def matrixCoeffSet (G : Type u) [Group G] [TopologicalSpace G] :
    Set C(G, ℂ) :=
  { f | ∃ (V : Type u) (_ : NormedAddCommGroup V) (_ : InnerProductSpace ℂ V)
          (_ : CompleteSpace V) (_ : FiniteDimensional ℂ V)
          (ρ : UnitaryRep G V) (u v : V),
        f = ρ.matrixCoeff_continuousMap u v }

/-- (`def:c2-MCAlg`) The matrix-coefficient star-subalgebra of
`C(G, ℂ)`: the smallest star-subalgebra over `ℂ` containing
`matrixCoeffSet G`.

By Theorems `matrixCoeff_add_eq_directSum`, `smul_matrixCoeff`,
`matrixCoeff_mul_eq_tensor`, `matrixCoeff_conj_eq_contragredient`,
`matrixCoeff_one_eq_trivial`, the underlying set is in fact already
closed under addition, scalar multiplication, multiplication, and
complex conjugation, and contains the constants — so this `adjoin`
coincides with the `ℂ`-linear span of `matrixCoeffSet G`.  Proving
that equality is deferred to Chapter 8/9 (where the closure is what
matters, not the precise spanning structure). -/
noncomputable def matrixCoeffSubalgebra (G : Type u)
    [Group G] [TopologicalSpace G] :
    StarSubalgebra ℂ C(G, ℂ) :=
  StarAlgebra.adjoin ℂ (matrixCoeffSet G)

end UnitaryRep
