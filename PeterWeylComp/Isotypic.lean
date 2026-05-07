/-
Copyright (c) 2026.  Released under Apache 2.0 license.
-/
import Mathlib.Analysis.InnerProductSpace.l2Space
import PeterWeylComp.Density
import PeterWeylComp.Orthogonality

/-!
# Peter–Weyl, Chapter 11: Isotypic Decomposition of `L²(G)` and Plancherel

This is the **final chapter** of the project.  We define the isotypic
component `L²(G)_ξ` for each irreducible class `ξ ∈ Ĝ`, prove the key
decomposition theorem `L²(G) = ⨁̂_ξ L²(G)_ξ` via Mathlib's
`IsHilbertSum`, and conclude Plancherel's identity.

## Mathlib survey

* `IsHilbertSum`
  (`Mathlib/Analysis/InnerProductSpace/l2Space.lean:262`): a structure
  asserting that a family `V : Π i, G i →ₗᵢ[𝕜] E` is an
  `OrthogonalFamily` whose induced `lp G 2 → E` map is surjective.
* `IsHilbertSum.mkInternal`
  (`Mathlib/Analysis/InnerProductSpace/l2Space.lean:284`): for a family
  of submodules `F : ι → Submodule 𝕜 E`, the input is
  `OrthogonalFamily 𝕜 (fun i => F i) (fun i => (F i).subtypeₗᵢ)` plus
  `⊤ ≤ (⨆ i, F i).topologicalClosure`.  This is exactly the
  composition of items 4 and 6 below.
* `OrthogonalFamily 𝕜 G V`
  (`Mathlib/Analysis/InnerProductSpace/l2Space.lean`): the predicate
  that the images of distinct `V i, V j` are orthogonal.  Item 4
  produces this for our isotypic components.
* `lp.norm_eq_tsum_rpow`: the `ℓ²` norm formula used by item 8.

## Indexing convention

The `IsHilbertSum` indexing requires distinct indices to give
orthogonal subspaces.  Our `IrreducibleClass G` (item 1) is *not*
quotiented by unitary equivalence: two distinct `ξ₁, ξ₂ : IrreducibleClass G`
with `ξ₁.rep.Equiv ξ₂.rep` would produce the same `isotypicComponent`,
violating `OrthogonalFamily`.  We therefore introduce a separate type
`IrrSkeleton G` (item 1.5) — the quotient of `IrreducibleClass G` by
the equivalence relation `Nonempty (ξ₁.rep.Equiv ξ₂.rep)` — and index
the Hilbert sum (items 6, 7, 8) over `IrrSkeleton G`.  `isotypicComponent`
is defined on `IrrSkeleton G` via `Quotient.lift`, with well-definedness
provided by `isotypicComponent_eq_of_equiv` (currently sorry'd).
-/

open scoped MeasureTheory ENNReal NNReal InnerProductSpace ComplexConjugate

universe u

namespace UnitaryRep

variable {G : Type u} [Group G] [TopologicalSpace G]

/-! ## Item 1: irreducible classes `Ĝ` -/

/-- (`def:c2-Ghat`) The dual `Ĝ`: a structure bundling a finite-dim
Hilbert space `V`, a continuous unitary representation `ρ : G → U(V)`,
and a proof that `ρ` is irreducible.  This is *not* yet quotiented by
unitary equivalence; for the equivalence-class type used in the
Hilbert-sum indexing, see `UnitaryRep.IrrSkeleton`. -/
structure IrreducibleClass (G : Type u) [Group G] [TopologicalSpace G] where
  /-- The underlying Hilbert space. -/
  V : Type u
  /-- Norm structure on `V`. -/
  [instNorm : NormedAddCommGroup V]
  /-- Inner product structure on `V`. -/
  [instInner : InnerProductSpace ℂ V]
  /-- Completeness of `V`. -/
  [instComplete : CompleteSpace V]
  /-- `V` is finite-dimensional. -/
  [instFD : FiniteDimensional ℂ V]
  /-- The representation `ρ : G → U(V)`. -/
  rep : UnitaryRep G V
  /-- `ρ` is irreducible. -/
  irreducible : rep.IsIrreducible

attribute [instance] IrreducibleClass.instNorm IrreducibleClass.instInner
  IrreducibleClass.instComplete IrreducibleClass.instFD

/-! ## Equivalence-relation API on `Equiv` (used by the setoid) -/

variable {H K : Type*}
  [NormedAddCommGroup H] [InnerProductSpace ℂ H] [CompleteSpace H]
  [NormedAddCommGroup K] [InnerProductSpace ℂ K] [CompleteSpace K]

/-- The unitary-equivalence relation `Equiv` is reflexive (the identity
operator is a unitary intertwiner from `ρ` to itself). -/
theorem Equiv.refl (ρ : UnitaryRep G H) : ρ.Equiv ρ := by
  refine ⟨ContinuousLinearMap.id ℂ H, fun g => ?_, ?_, ?_⟩
  · rw [ContinuousLinearMap.id_comp, ContinuousLinearMap.comp_id]
  · show (ContinuousLinearMap.id ℂ H).adjoint ∘L ContinuousLinearMap.id ℂ H = 1
    rw [ContinuousLinearMap.adjoint_id]; rfl
  · show ContinuousLinearMap.id ℂ H ∘L (ContinuousLinearMap.id ℂ H).adjoint = 1
    rw [ContinuousLinearMap.adjoint_id]; rfl

/-- Symmetry of `Equiv` — sorry'd.  The witness is `T.adjoint`; the
intertwiner property requires generalizing
`UnitaryRep.IsIntertwiner.adjoint` from `ρ → ρ` to `ρ → σ ⇒ σ → ρ`,
plus the fact that the adjoint of a `IsEquiv` is itself a unitary
equivalence.  Both are routine but not yet in scope. -/
theorem Equiv.symm {ρ : UnitaryRep G H} {σ : UnitaryRep G K}
    (_h : ρ.Equiv σ) : σ.Equiv ρ := by
  -- TODO: `T.adjoint` is the witness; intertwining via the two-rep
  -- generalization of `UnitaryRep.IsIntertwiner.adjoint`, IsEquiv via
  -- `adjoint_adjoint` swapping the two conjuncts.
  sorry

/-- Transitivity of `Equiv` — sorry'd.  The witness is `S ∘L T`; the
intertwiner property is composition, the IsEquiv property follows
from `(ST)†ST = T†(S†S)T = T†·1·T = 1` and similarly `(ST)(ST)† = 1`. -/
theorem Equiv.trans {L : Type*}
    [NormedAddCommGroup L] [InnerProductSpace ℂ L] [CompleteSpace L]
    {ρ : UnitaryRep G H} {σ : UnitaryRep G K} {τ : UnitaryRep G L}
    (_h₁ : ρ.Equiv σ) (_h₂ : σ.Equiv τ) : ρ.Equiv τ := by
  -- TODO: composition `S ∘L T` of intertwiners + IsEquiv computation.
  sorry

/-! ## The setoid on `IrreducibleClass G` and the skeleton type -/

/-- The setoid on `IrreducibleClass G` whose underlying relation is
`Nonempty (ξ₁.rep.Equiv ξ₂.rep)`.  Reflexivity, symmetry, transitivity
follow from `Equiv.refl`, `Equiv.symm`, `Equiv.trans` (the latter two
of which are currently sorry'd). -/
def IrreducibleClass.setoid (G : Type u) [Group G] [TopologicalSpace G] :
    Setoid (IrreducibleClass G) where
  r ξ₁ ξ₂ := Nonempty (ξ₁.rep.Equiv ξ₂.rep)
  iseqv :=
    { refl := fun ξ => ⟨Equiv.refl ξ.rep⟩
      symm := fun ⟨h⟩ => ⟨Equiv.symm h⟩
      trans := fun ⟨h₁⟩ ⟨h₂⟩ => ⟨Equiv.trans h₁ h₂⟩ }

/-- (`def:c2-Ghat`, skeleton form) The skeleton of `Ĝ`: equivalence
classes of finite-dim irreducible continuous unitary representations
under unitary equivalence.  This is the indexing type for the
Hilbert-sum decomposition (items 6, 7, 8).

`abbrev` so that `Quotient.liftOn`, `Quotient.inductionOn`, and the
`Quotient.mk` projection are visible without manual unfolding.
The type lives at `Type (u+1)` because `IrreducibleClass G` does
(it carries a field `V : Type u`). -/
abbrev IrrSkeleton (G : Type u) [Group G] [TopologicalSpace G] :=
  Quotient (IrreducibleClass.setoid G)

/-- The canonical projection from `IrreducibleClass G` to its skeleton. -/
def IrreducibleClass.toSkeleton {G : Type u} [Group G] [TopologicalSpace G]
    (ξ : IrreducibleClass G) : IrrSkeleton G :=
  Quotient.mk (IrreducibleClass.setoid G) ξ

end UnitaryRep

namespace PeterWeyl

variable {G : Type u} [Group G] [TopologicalSpace G] [IsTopologicalGroup G]
  [CompactSpace G] [T2Space G] [MeasurableSpace G] [BorelSpace G]

/-! ## Item 2: isotypic component (auxiliary on `IrreducibleClass`) -/

/-- Auxiliary: the isotypic component associated to a *specific*
irreducible class representative.  The user-facing definition
`isotypicComponent` (below) is descended through the quotient. -/
noncomputable def isotypicComponent_aux (ξ : UnitaryRep.IrreducibleClass G) :
    Submodule ℂ (L2 G) :=
  (⨆ (W : (rightReg G).Subrep) (_h_fd : FiniteDimensional ℂ W.toSubmodule)
        (_h_eq : letI : CompleteSpace W.toSubmodule :=
                   W.completeSpace_toSubmodule
                 W.restrict.Equiv ξ.rep),
      W.toSubmodule).topologicalClosure

/-- Well-definedness of `isotypicComponent_aux` under unitary
equivalence: equivalent representatives give the same isotypic
component.  The proof transports the indexing iSup along the
equivalence; sorry'd as effort. -/
theorem isotypicComponent_aux_eq_of_equiv
    {ξ₁ ξ₂ : UnitaryRep.IrreducibleClass G}
    (_h : ξ₁.rep.Equiv ξ₂.rep) :
    isotypicComponent_aux ξ₁ = isotypicComponent_aux ξ₂ := by
  -- TODO: the iSup ranges over `(rightReg G).Subrep` `W` such that
  -- `W.restrict.Equiv ξ.rep`; if `ξ₁.rep ≅ ξ₂.rep`, the predicate is
  -- transported by post-composition with the equivalence (using
  -- `Equiv.trans`), so the two iSups have identical index sets and
  -- hence are equal.
  sorry

/-- (`def:c2-isotypic`) The `ξ`-isotypic component of `L²(G)` for
`ξ : IrrSkeleton G`.  Defined via `Quotient.lift` from
`isotypicComponent_aux`, with well-definedness given by
`isotypicComponent_aux_eq_of_equiv`. -/
noncomputable def isotypicComponent (ξ : UnitaryRep.IrrSkeleton G) :
    Submodule ℂ (L2 G) :=
  Quotient.liftOn ξ isotypicComponent_aux fun _ _ ⟨h⟩ =>
    isotypicComponent_aux_eq_of_equiv h

/-! ## Item 3: isotypic component is `ρ^R`-invariant -/

/-- (`thm:c2-isotypic-invariant`) The isotypic component is
`ρ^R`-invariant. -/
theorem isotypicComponent_isInvariant
    (ξ : UnitaryRep.IrrSkeleton G) :
    (rightReg G).IsInvariant (isotypicComponent ξ) := by
  -- TODO (effort): the iSup of invariant submodules is invariant by
  -- bilinear extension; the topological closure of an invariant
  -- submodule is invariant since each `ρ^R(g)` is continuous.  Both
  -- pieces are basic but require the right Mathlib lemmas:
  -- `Submodule.iSup_invariant_of_forall_invariant` (does not exist
  -- under that name; needs to be proved or inlined) plus
  -- `Submodule.topologicalClosure_isInvariant` (similarly).  Sorry'd.
  sorry

/-! ## Item 4: isotypic components are mutually orthogonal -/

/-- (`thm:c2-isotypic-orthog`) Distinct skeleton elements give
orthogonal isotypic components.  This is the cornerstone of the
Hilbert-sum construction.

Inherits transitively from Chapter 10
(`UnitaryRep.matrixCoeff_inner_eq_zero_of_not_equiv`, ⚠ sorry) via the
projection-onto-irreducible-subspace argument: the orthogonal
projection `P : L²(G) → V₂` for `V₂ ≅ ξ₂.rep` is a compact intertwiner
between non-equivalent irreducibles, hence zero (Chapter 6 Schur). -/
theorem isotypicComponent_orthogonal
    {ξ₁ ξ₂ : UnitaryRep.IrrSkeleton G} (_h_neq : ξ₁ ≠ ξ₂) :
    ∀ x ∈ isotypicComponent ξ₁, ∀ y ∈ isotypicComponent ξ₂,
      ⟪x, y⟫_ℂ = 0 := by
  -- TODO: by bilinearity and continuity of the inner product, reduce
  -- to V₁ ⊥ V₂ for closed ρ^R-invariant subspaces V₁ ≅ ξ₁-rep,
  -- V₂ ≅ ξ₂-rep.  The orthogonal projection L² → V₂ is bounded
  -- (`Submodule.starProjection`) and ρ^R-equivariant (since V₂ is
  -- closed invariant), and finite-rank (V₂ FD), hence compact.
  -- Restricted to V₁, it's a compact intertwiner between non-equivalent
  -- irreducibles, hence zero by Chapter 6 item 7
  -- (`UnitaryRep.IsIrreducible.compact_intertwiner_eq_zero_of_not_equiv`,
  -- ⚠ sorry).  Inherits transitively.  The hypothesis `ξ₁ ≠ ξ₂`
  -- (as skeleton elements) corresponds to non-equivalence of
  -- representatives, exactly the hypothesis of Chapter 6 item 7.
  sorry

/-! ## Item 5: matrix coefficients live in their isotypic component -/

/-- (`thm:c2-mc-in-isotypic`) For `ξ : IrreducibleClass G` and
`u, v ∈ V_ξ`, the matrix coefficient `π_{u,v}^{ρ_ξ}` (as an element
of `L²(G)` via `continuousMapToL2`) lies in the isotypic component
of `ξ`'s skeleton image.

Effort sorry: requires constructing the equivariant linear map
`V_ξ → L²(G), u' ↦ π_{u', v}^{ρ_ξ}` (which is non-zero hence injective
by Schur), and identifying its image as a closed `ρ^R`-invariant
subspace of `L²(G)` equivalent to `ξ.rep`.  This subspace contains
`π_{u, v}^{ρ_ξ}`, so the matrix coefficient lies in the isotypic
component. ~30–50 lines. -/
theorem _root_.UnitaryRep.matrixCoeff_mem_isotypicComponent
    (ξ : UnitaryRep.IrreducibleClass G) (u v : ξ.V) :
    PeterWeyl.continuousMapToL2 G (ξ.rep.matrixCoeff_continuousMap u v)
      ∈ isotypicComponent ξ.toSkeleton := by
  sorry

/-! ## Item 6: closed sum of isotypic components is dense -/

/-- (`thm:c2-isotypic-spans`) The topological closure of the linear
span of all isotypic components is `⊤` (the whole `L²(G)`).

Composition: every matrix coefficient lies in some isotypic component
(item 5), hence the matrix-coefficient star-subalgebra is contained in
the sum of isotypic components, which is `L²`-dense by Chapter 9
`matrixCoeffSubalgebra_dense_L2`. -/
theorem isotypicComponents_topologicalClosure_eq_top :
    (⨆ ξ : UnitaryRep.IrrSkeleton G,
        isotypicComponent ξ).topologicalClosure = ⊤ := by
  -- TODO (effort): the structural argument is:
  --   (1) for each f ∈ matrixCoeffSubalgebra G, push to L² and observe
  --       it lies in some isotypicComponent (by item 5 plus the fact
  --       that matrixCoeffSubalgebra is the StarAlgebra.adjoin of
  --       matrixCoeffSet);
  --   (2) hence `continuousMapToL2 '' matrixCoeffSubalgebra ⊆ ⨆ ξ, isotypicComponent ξ`;
  --   (3) Chapter 9 says LHS is dense in L²(G);
  --   (4) so `⨆ ξ, isotypicComponent ξ` has dense closure, i.e. its
  --       topological closure is ⊤.
  -- Step (1) is non-trivial because matrixCoeffSubalgebra is closed
  -- under sums, products, conjugates beyond just matrixCoeffSet, and
  -- we need each of those operations to preserve isotypic membership.
  -- Sorry'd as effort.
  sorry

/-! ## Item 7: the Peter–Weyl Hilbert sum -/

/-- (`thm:c2-PW-HilbertSum`) The family `{L²(G)_ξ}_{ξ : IrrSkeleton G}`
is an `IsHilbertSum` decomposition of `L²(G)`.

Indexed over `IrrSkeleton G` so that distinct indices correspond to
non-equivalent irreducible classes (and hence orthogonal isotypic
components).  Composition of items 4 (orthogonality) and 6 (spanning).
Cites `IsHilbertSum.mkInternal` from Mathlib. -/
theorem isHilbertSum_isotypicComponents :
    IsHilbertSum ℂ (fun ξ : UnitaryRep.IrrSkeleton G =>
      (isotypicComponent ξ : Submodule ℂ (L2 G)))
      (fun ξ => (isotypicComponent ξ).subtypeₗᵢ) := by
  -- TODO: assemble via `IsHilbertSum.mkInternal`:
  -- 1.  OrthogonalFamily from item 4 (`isotypicComponent_orthogonal`).
  --     Mathlib's `OrthogonalFamily` predicate has shape
  --     `∀ ⦃i j⦄, i ≠ j → ∀ v w, ⟪V i v, V j w⟫ = 0`, which matches
  --     item 4's statement once we unfold `subtypeₗᵢ` to the inclusion.
  -- 2.  Total: `⊤ ≤ (⨆ ξ, isotypicComponent ξ).topologicalClosure`
  --     from item 6 (`isotypicComponents_topologicalClosure_eq_top`).
  -- 3.  CompleteSpace for each isotypic component: each is closed (it's
  --     a topologicalClosure), so complete.
  -- Sorry'd until items 4 and 6 are real.
  sorry

/-! ## Item 8: Plancherel's identity -/

/-- Each isotypic component is closed (it is a `topologicalClosure`),
hence has an orthogonal projection. -/
instance isotypicComponent_hasOrthogonalProjection
    (ξ : UnitaryRep.IrrSkeleton G) :
    (isotypicComponent ξ).HasOrthogonalProjection := by
  obtain ⟨ξ, rfl⟩ :=
    @Quotient.mk_surjective _ (UnitaryRep.IrreducibleClass.setoid G) ξ
  show (isotypicComponent_aux ξ).HasOrthogonalProjection
  haveI : CompleteSpace (isotypicComponent_aux ξ) :=
    (Submodule.isClosed_topologicalClosure _).completeSpace_coe
  exact inferInstance

/-- (`thm:c2-plancherel-isotypic`) Plancherel's identity, isotypic
form: for every `f ∈ L²(G)`,
`‖f‖² = ∑_ξ ‖P_ξ f‖²`, where `P_ξ` is the orthogonal projection onto
the `ξ`-isotypic component.

One-line consequence of item 7 plus the standard Mathlib
`IsHilbertSum.linearIsometryEquiv` norm-preservation chain
(`linearIsometryEquiv` is an isometry, so `‖f‖ = ‖equiv f‖`, and the
`lp` norm formula `lp.norm_eq_tsum_rpow` expresses the RHS as a
square-summable sum of component norms). -/
theorem norm_sq_eq_sum_isotypic_norm_sq (f : L2 G) :
    ‖f‖ ^ 2 = ∑' ξ : UnitaryRep.IrrSkeleton G,
      ‖((isotypicComponent ξ).starProjection f : L2 G)‖ ^ 2 := by
  -- TODO: blocked on item 7 (`isHilbertSum_isotypicComponents`).  The
  -- argument:  given `hHS : IsHilbertSum ℂ (fun ξ => isotypicComponent ξ) ...`,
  -- the linearIsometryEquiv `Φ : L²(G) ≃ₗᵢ ℓ²(ξ ↦ isotypicComponent ξ)`
  -- preserves norm, and the `ℓ²`-norm is `∑' ξ, ‖f_ξ‖²`.  The components
  -- `f_ξ` are the orthogonal projections `(isotypicComponent ξ).starProjection f`.
  sorry

end PeterWeyl
