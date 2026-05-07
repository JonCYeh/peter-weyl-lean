/-
Copyright (c) 2026.  Released under Apache 2.0 license.
-/
import Mathlib.Analysis.InnerProductSpace.Adjoint
import PeterWeylComp.Basic

/-!
# Peter–Weyl, Chapter 2: Continuous Unitary Representations

This file scaffolds the items of Chapter 2 of the compact Peter–Weyl
blueprint (`blueprint/src/content_comp.tex`).  It introduces the bundled
type `UnitaryRep G H` of continuous unitary representations of a
topological group `G` on a complex Hilbert space `H`, along with
the sub-, quotient- and intertwiner API.

Everything in this chapter is `[NEW]` — there are no Mathlib lemmas to
cite as primary content.  Most theorem bodies are `sorry`s; the file is
intended to compile and serve as a translation skeleton.
-/

open scoped InnerProductSpace

/-
Design note: the `isUnitary` field encodes the one-sided condition
`T.adjoint ∘L T = 1` rather than the two-sided `T ∈ unitary (H →L[ℂ] H)`.
The two are equivalent here because the `MonoidHom` structure provides
`ρ(g⁻¹)` as the inverse, so left- and right-unitarity coincide.
Several downstream proofs (notably `IsInvariant.orthogonalComplement`)
rely on this implicitly via `apply_inv_apply`.  A future refactor toward
Mathlib's `unitary` submonoid would have to preserve this property.
-/

/-- A continuous unitary representation of a topological group `G` on a
complex Hilbert space `H`, bundling a group homomorphism into bounded
operators with a strong-continuity assumption and a one-sided unitarity
condition `T† * T = 1` (combined with the homomorphism property this
gives full unitarity). -/
structure UnitaryRep
    (G : Type*) [Group G] [TopologicalSpace G]
    (H : Type*) [NormedAddCommGroup H] [InnerProductSpace ℂ H] [CompleteSpace H] where
  /-- The underlying group homomorphism into the monoid of bounded
  operators. -/
  toMonoidHom : G →* (H →L[ℂ] H)
  /-- One-sided unitarity: `(ρ g)† ∘ (ρ g) = id`. -/
  isUnitary : ∀ g : G,
    (toMonoidHom g).adjoint ∘L (toMonoidHom g) = 1
  /-- Strong-operator continuity of the orbit map. -/
  strongContinuous : ∀ v : H, Continuous fun g : G => toMonoidHom g v

namespace UnitaryRep

variable {G : Type*} [Group G] [TopologicalSpace G]
variable {H : Type*} [NormedAddCommGroup H] [InnerProductSpace ℂ H] [CompleteSpace H]

/-- Allow `ρ g v` notation in place of `ρ.toMonoidHom g v`. -/
instance : CoeFun (UnitaryRep G H) (fun _ => G → (H →L[ℂ] H)) where
  coe ρ := ρ.toMonoidHom

/-- The trivial representation: every group element acts as the identity. -/
def trivial (G : Type*) [Group G] [TopologicalSpace G]
    (H : Type*) [NormedAddCommGroup H] [InnerProductSpace ℂ H] [CompleteSpace H] :
    UnitaryRep G H where
  toMonoidHom := 1
  isUnitary _ := by
    show (ContinuousLinearMap.id ℂ H).adjoint ∘L ContinuousLinearMap.id ℂ H = 1
    rw [ContinuousLinearMap.adjoint_id]; rfl

  strongContinuous _ := continuous_const

/-! ## Inner-product, norm and operator-norm of `ρ g` -/

variable (ρ : UnitaryRep G H)

/-- `ρ g` preserves the inner product (`thm:rho-inner`). -/
theorem inner_apply (g : G) (u v : H) : ⟪ρ g u, ρ g v⟫_ℂ = ⟪u, v⟫_ℂ :=
  ((ρ.toMonoidHom g).inner_map_map_iff_adjoint_comp_self.mpr (ρ.isUnitary g)) u v

/-- `ρ g` preserves the norm (`thm:rho-norm`). -/
theorem norm_apply (g : G) (v : H) : ‖ρ g v‖ = ‖v‖ :=
  ((ρ.toMonoidHom g).norm_map_iff_adjoint_comp_self.mpr (ρ.isUnitary g)) v

/-- The operator norm of `ρ g` is at most `1` (`thm:rho-opNorm`). -/
theorem opNorm_apply_le_one (g : G) : ‖ρ.toMonoidHom g‖ ≤ 1 :=
  ContinuousLinearMap.opNorm_le_bound _ zero_le_one fun v => by
    rw [one_mul]; exact (ρ.norm_apply g v).le

/-- Convenience lemma: `ρ g (ρ g⁻¹ v) = v`, i.e. `ρ g⁻¹` is the inverse
of `ρ g` (as continuous linear maps).  This follows from the
group-homomorphism property and is independent of unitarity. -/
theorem apply_inv_apply (g : G) (v : H) : ρ g (ρ g⁻¹ v) = v := by
  show (ρ.toMonoidHom g * ρ.toMonoidHom g⁻¹) v = v
  rw [← ρ.toMonoidHom.map_mul, mul_inv_cancel, ρ.toMonoidHom.map_one,
      ContinuousLinearMap.one_apply]

/-! ## Invariant subspaces and subrepresentations -/

/-- Predicate: a submodule `V ⊆ H` is invariant under the representation
`ρ` (`def:isInvariant`). -/
def IsInvariant (ρ : UnitaryRep G H) (V : Submodule ℂ H) : Prop :=
  ∀ g : G, ∀ v ∈ V, ρ g v ∈ V

/-- The orthogonal complement of an invariant subspace is invariant
(`thm:orthCompl-invariant`). -/
theorem IsInvariant.orthogonalComplement {V : Submodule ℂ H}
    (hV : ρ.IsInvariant V) : ρ.IsInvariant Vᗮ := by
  intro g w hw
  rw [Submodule.mem_orthogonal]
  intro v hv
  have hg_inv : ρ g⁻¹ v ∈ V := hV g⁻¹ v hv
  calc ⟪v, ρ g w⟫_ℂ
      = ⟪ρ g (ρ g⁻¹ v), ρ g w⟫_ℂ := by rw [ρ.apply_inv_apply]
    _ = ⟪ρ g⁻¹ v, w⟫_ℂ := ρ.inner_apply g _ _
    _ = 0 := (Submodule.mem_orthogonal _ _).mp hw _ hg_inv

/-- A subrepresentation: a closed invariant subspace of the underlying
Hilbert space (`def:Subrep`). -/
structure Subrep (ρ : UnitaryRep G H) where
  /-- The underlying linear subspace. -/
  toSubmodule : Submodule ℂ H
  /-- The subspace is closed in `H`. -/
  isClosed : IsClosed (toSubmodule : Set H)
  /-- The subspace is `ρ`-invariant. -/
  invariant : ρ.IsInvariant toSubmodule

namespace Subrep

variable {ρ}

/-- A closed subspace of a complete inner-product space is itself
complete; we expose this as a fact derivable from `W.isClosed`. -/
theorem completeSpace_toSubmodule (W : ρ.Subrep) :
    CompleteSpace W.toSubmodule :=
  W.isClosed.completeSpace_coe

/-- Restriction of `ρ` to a subrepresentation `W` -/
noncomputable def restrict (W : ρ.Subrep) :
    letI : CompleteSpace W.toSubmodule := W.completeSpace_toSubmodule
    UnitaryRep G W.toSubmodule :=
  letI : CompleteSpace W.toSubmodule := W.completeSpace_toSubmodule
  { toMonoidHom :=
      { toFun := fun g =>
          ((ρ.toMonoidHom g).comp W.toSubmodule.subtypeL).codRestrict
            W.toSubmodule (fun x => W.invariant g x x.2)
        map_one' := by
          ext x
          show (ρ.toMonoidHom 1) (x : H) = (x : H)
          rw [ρ.toMonoidHom.map_one]; rfl
        map_mul' := by
          intro g h
          ext x
          show (ρ.toMonoidHom (g * h)) (x : H)
            = (ρ.toMonoidHom g) ((ρ.toMonoidHom h) (x : H))
          rw [ρ.toMonoidHom.map_mul]; rfl }
    isUnitary := fun g => by
      refine ContinuousLinearMap.inner_map_map_iff_adjoint_comp_self _ |>.mp ?_
      intro x y
      show ⟪((ρ.toMonoidHom g) (x : H) : H), ((ρ.toMonoidHom g) (y : H) : H)⟫_ℂ
        = ⟪(x : H), (y : H)⟫_ℂ
      exact ρ.inner_apply g _ _
    strongContinuous := fun v =>
      (ρ.strongContinuous (v : H)).subtype_mk _ }

end Subrep

/-! ## Irreducibility -/

/-- A representation is irreducible if `H` is non-trivial and the only
closed invariant subspaces are `⊥` and `⊤` (`def:IsIrreducible`). -/
structure IsIrreducible (ρ : UnitaryRep G H) : Prop where
  /-- `H` is non-trivial, equivalently `H ≠ 0`. -/
  nontrivial : Nontrivial H
  /-- The only closed invariant subspaces are `⊥` and `⊤`. -/
  minimal : ∀ V : Submodule ℂ H,
    IsClosed (V : Set H) → ρ.IsInvariant V → V = ⊥ ∨ V = ⊤

/-! ## Intertwiners and equivalences -/

variable {K : Type*} [NormedAddCommGroup K] [InnerProductSpace ℂ K] [CompleteSpace K]

/-- Predicate: `T : H →L[ℂ] K` intertwines `ρ` and `σ`, i.e.
`T ∘L ρ g = σ g ∘L T` for every `g` (`def:isIntertwiner`). -/
def IsIntertwiner (T : H →L[ℂ] K) (ρ : UnitaryRep G H) (σ : UnitaryRep G K) : Prop :=
  ∀ g : G, T ∘L ρ.toMonoidHom g = σ.toMonoidHom g ∘L T

/-- The space of intertwiners between `ρ` and `σ`, bundled as a
submodule of `H →L[ℂ] K` (`def:Intertwiner`). -/
def Intertwiner (ρ : UnitaryRep G H) (σ : UnitaryRep G K) : Submodule ℂ (H →L[ℂ] K) where
  carrier := { T | IsIntertwiner T ρ σ }
  add_mem' {T U} hT hU g := by
    simp only [ContinuousLinearMap.add_comp, ContinuousLinearMap.comp_add,
      hT g, hU g]
  zero_mem' g := by
    simp [ContinuousLinearMap.zero_comp, ContinuousLinearMap.comp_zero]
  smul_mem' c T hT g := by
    simp only [ContinuousLinearMap.smul_comp, ContinuousLinearMap.comp_smul, hT g]

/-- Predicate: `T : H →L[ℂ] K` is a unitary equivalence: a bounded
surjective isometry, equivalently `T† * T = id_H` and `T * T† = id_K`
(`def:isEquiv`). -/
def IsEquiv (T : H →L[ℂ] K) : Prop :=
  T.adjoint ∘L T = 1 ∧ T ∘L T.adjoint = 1

/-- Two representations are unitarily equivalent if there exists a
continuous linear map `T : H →L[ℂ] K` that is simultaneously an
intertwiner and a unitary equivalence (`def:Equiv`). -/
def Equiv (ρ : UnitaryRep G H) (σ : UnitaryRep G K) : Prop :=
  ∃ T : H →L[ℂ] K, IsIntertwiner T ρ σ ∧ IsEquiv T

end UnitaryRep

/-! ## The left and right regular representations on `L²(G)` -/

namespace PeterWeyl

variable (G : Type*) [Group G] [TopologicalSpace G] [IsTopologicalGroup G]
  [CompactSpace G] [T2Space G] [MeasurableSpace G] [BorelSpace G]

/-- Left translation `λ_g : L²(G) → L²(G)` (`def:leftTransL2`).
On continuous functions `f`, it is `λ_g f = h ↦ f(g⁻¹ h)`; left
invariance of `haarProb` ensures this preserves the `L²` norm, and the
extension to `L²(G)` is unique by density of `C(G)` in `L²(G)`
(Theorem `continuousMapToL2_denseRange`). -/
noncomputable def leftTransL2 (g : G) : L2 G →L[ℂ] L2 G := by
  -- TODO: extend `f ↦ (h ↦ f (g⁻¹ * h))` from `C(G, ℂ)` to `L²(G)` via
  -- norm-preservation on the dense subspace; e.g. through
  -- `LinearIsometry.extend` or by hand using
  -- `continuousMapToL2_denseRange` and `haarProb_isMulLeftInvariant`.
  exact sorry

/-- For each `g`, `leftTransL2 g` is unitary
(`thm:leftTrans-unitary`). -/
theorem leftTransL2_isUnitary (g : G) :
    (leftTransL2 G g).adjoint ∘L (leftTransL2 G g) = 1 := by
  -- TODO: by construction `leftTransL2 g` is a surjective isometry on
  -- the dense subspace `C(G)` (left-invariance of `haarProb`); extends
  -- to a unitary on `L²(G)`.
  sorry

/-- Left translation gives a multiplicative structure:
`leftTransL2 (g * h) = leftTransL2 g ∘L leftTransL2 h` and
`leftTransL2 1 = id` (`thm:leftTrans-mulHom`). -/
theorem leftTransL2_mulHom (g h : G) :
    leftTransL2 G (g * h) = (leftTransL2 G g) ∘L (leftTransL2 G h) := by
  -- TODO: verify on the dense subspace `C(G)` using `f((g*h)⁻¹ x) =
  -- f(h⁻¹ g⁻¹ x) = (leftTransL2 h f)(g⁻¹ x)`, then extend by continuity.
  sorry

/-- Strong continuity of left translation (`thm:leftTrans-strongCts`). -/
theorem leftTransL2_strongContinuous (f : L2 G) :
    Continuous fun g : G => leftTransL2 G g f := by
  -- TODO: 3-step argument from the blueprint: (1) uniform continuity
  -- of continuous functions on the compact group, (2) `L²` convergence
  -- on the dense subspace `C(G)`, (3) extension via `continuousMapToL2_denseRange`
  -- and the operator norm bound `‖leftTransL2 g‖ = 1`.
  sorry

/-- The left regular representation `ρ^L : UnitaryRep G (L²(G))`
(`def:leftReg`). -/
noncomputable def leftReg : UnitaryRep G (L2 G) where
  toMonoidHom :=
    { toFun := leftTransL2 G
      map_one' := by
        -- Once `leftTransL2` has a real body, the proof is:
        -- show `leftTransL2 G 1 = 1` by `DenseRange.equalizer`
        -- (`Mathlib/Topology/DenseEmbedding.lean:381`) using
        -- `continuousMapToL2_denseRange`: both sides are continuous, and
        -- on `f ∈ C(G, ℂ)` they agree because `f(1⁻¹ * h) = f(h)`.
        -- Blocked on `leftTransL2`'s sorry: with the body abstract, we
        -- cannot compute its action on the dense subspace `C(G, ℂ)`.
        sorry
      map_mul' := fun g h => leftTransL2_mulHom G g h }
  isUnitary := leftTransL2_isUnitary G
  strongContinuous := leftTransL2_strongContinuous G

/-- Right translation `ρ_g : L²(G) → L²(G)` (`def:rightTransL2`). -/
noncomputable def rightTransL2 (g : G) : L2 G →L[ℂ] L2 G := by
  -- TODO: extend `f ↦ (h ↦ f (h * g))` from `C(G, ℂ)` to `L²(G)` using
  -- right-invariance of `haarProb` (Chapter 1 `haarProb_isMulRightInvariant`,
  -- now a real instance) plus density (`continuousMapToL2_denseRange`).
  -- Depends on item 14 construction pattern (`leftTransL2`): once that
  -- density-extension is in place, the right-translation version follows
  -- the same pattern with `(· * g)` in place of `(g⁻¹ * ·)`.
  exact sorry

/-- The right regular representation `ρ^R : UnitaryRep G (L²(G))`
(`def:rightReg`). -/
noncomputable def rightReg : UnitaryRep G (L2 G) where
  -- Depends on item 14 construction pattern (`leftTransL2`): the
  -- `MonoidHom` and `isUnitary`/`strongContinuous` proofs duplicate
  -- the structure of `leftReg`, so they wait on the same density
  -- extension.
  toMonoidHom :=
    { toFun := rightTransL2 G
      map_one' := by sorry
      map_mul' := by sorry }
  isUnitary := by sorry
  strongContinuous := by sorry

/-- The left and right regular representations commute
(`thm:LR-commute`). -/
theorem leftReg_comm_rightReg (g h : G) :
    (leftReg G).toMonoidHom g ∘L (rightReg G).toMonoidHom h
      = (rightReg G).toMonoidHom h ∘L (leftReg G).toMonoidHom g := by
  -- TODO: verify on the dense subspace `C(G)` using associativity:
  --   (ρ^L g (ρ^R h f))(x) = (ρ^R h f)(g⁻¹ x) = f(g⁻¹ x h)
  --                       = (ρ^L g f)(x h) = (ρ^R h (ρ^L g f))(x).
  -- Depends on item 14 construction pattern (`leftTransL2`).
  sorry

end PeterWeyl
