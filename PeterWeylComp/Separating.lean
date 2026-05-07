/-
Copyright (c) 2026.  Released under Apache 2.0 license.
-/
import Mathlib.LinearAlgebra.FiniteDimensional.Lemmas
import PeterWeylComp.Schur
import PeterWeylComp.ApproxIdentity

/-!
# Peter–Weyl, Chapter 8: Existence of Separating Finite-Dim Irreducibles

This file scaffolds Chapter 8 of the compact Peter–Weyl blueprint
(`blueprint/src/content_comp.tex`).  For every `g₀ ≠ 1_G`, we build a
finite-dimensional continuous unitary irreducible representation on
which `g₀` acts non-trivially.  This is the technical heart of the
analytic side of Tao's proof.

## Dependency graph

The chapter is largely about *composing* lemmas from earlier chapters,
so most items here remain `sorry`-bodied — they inherit upstream
sorries.  Recording the dependency chain explicitly:

| # | Lean name | Depends on |
|---|---|---|
| 1 | `rightReg_faithful` | `rightReg` (Ch 2 ⚠), `exists_bump` (Ch 4 ⚠), `continuousMapToL2` (Ch 1 ✓), Hausdorffness |
| 2 | `exists_symmetric_bump_separating` | item 1, `exists_bump` (Ch 4 ⚠), `convOp_bump_tendsto_id` (Ch 4 ⚠), `IsSymmetricKernel` (Ch 3 ✓) |
| 3 | `exists_eigenspace_separating` | item 2, `convOp_isCompactOperator` (Ch 3 ⚠), `convOp_isSelfAdjoint` (Ch 3 ⚠), `convOp_isIntertwiner` (Ch 3 ✓), `exists_eigenvalue` (Ch 5 ✓), `IsIntertwiner.eigenspace_isInvariant` (Ch 6 ✓), `spectralDecomposition` (Ch 5 ⚠ external) |
| 4 | `UnitaryRep.exists_irreducible_subspace_of_finiteDim` | `IsInvariant.orthogonalComplement` (Ch 2 ✓), `IsIrreducible` (Ch 2 ✓), `Submodule.finrank_lt_finrank_of_lt` (Mathlib) |
| 5 | `UnitaryRep.exists_irreducible_subspace_acting_nontrivially` | item 4, `IsInvariant.orthogonalComplement` (Ch 2 ✓) |
| 6 | `exists_separating_irreducible` | item 3 + item 5 |

Items 4 and 5 *should* be writable as real proofs (they only depend on
finished earlier-chapter API).  Items 1, 2, 3, 6 inherit transitively
from upstream sorries.

## Mathlib survey

Chapter 8 is largely composition of project-internal lemmas; few
Mathlib lookups are relevant beyond `Submodule.finrank_lt_finrank_of_lt`
(`Mathlib/LinearAlgebra/FiniteDimensional/Lemmas.lean:235`) for the
strict-submodule dimension drop in items 4 and 5.
-/

open scoped MeasureTheory ENNReal NNReal InnerProductSpace

namespace PeterWeyl

variable {G : Type*} [Group G] [TopologicalSpace G] [IsTopologicalGroup G]
  [CompactSpace G] [T2Space G] [MeasurableSpace G] [BorelSpace G]

/-! ## Setup and key intermediate lemmas -/

/-- (`thm:rightReg-faithful`) The right regular representation is
faithful: for every `g₀ ≠ 1_G`, there exists `f ∈ L²(G)` with
`ρ^R(g₀) f ≠ f`.

Proof outline (blueprint): pick disjoint open neighbourhoods `U ∋ 1_G`
and `V ∋ g₀` (Hausdorffness), a continuous bump `φ` supported in `U`
(`exists_bump`, Ch 4), and let `f := continuousMapToL2 φ`.  Then
`ρ^R(g₀) f` is the class of `h ↦ φ(h g₀)`, supported in `U g₀⁻¹`,
which can be made disjoint from `U`; so `ρ^R(g₀) f ≠ f`. -/
theorem rightReg_faithful (g₀ : G) (hg : g₀ ≠ 1) :
    ∃ f : L2 G, (rightReg G).toMonoidHom g₀ f ≠ f := by
  -- TODO (inherits Ch 2 ⚠ rightReg, Ch 4 ⚠ exists_bump):
  -- 1.  By Hausdorffness, get disjoint opens U ∋ 1, V ∋ g₀.
  -- 2.  Apply `exists_bump` on (U ∩ U⁻¹) ∋ 1 to get a bump φ.
  -- 3.  Set f := continuousMapToL2 G ⟨↑φ, φ.continuous⟩ (cast ℝ → ℂ).
  -- 4.  Show ρ^R(g₀) f and f have disjoint essential supports, hence
  --     differ as L² classes.  Currently blocked on `rightReg`'s
  --     concrete body (Rep.lean:287 sorry) — without it we cannot
  --     compute `ρ^R(g₀) f` pointwise.
  sorry

/-- (`thm:existsSepConv`) Existence of a symmetric bump whose
convolution operator is non-zero and separates `g₀ ≠ 1_G`.

The blueprint conclusions:
1.  `φ` is symmetric (here recorded as `IsSymmetricKernel`);
2.  `convOp φ ≠ 0`;
3.  there exists `f ∈ L²(G)` with `convOp φ (ρ^R(g₀) f - f) ≠ 0`. -/
theorem exists_symmetric_bump_separating (g₀ : G) (hg : g₀ ≠ 1) :
    ∃ φ : L2 G, IsSymmetricKernel φ ∧ convOp φ ≠ 0 ∧
      ∃ f : L2 G, convOp φ ((rightReg G).toMonoidHom g₀ f - f) ≠ 0 := by
  -- Architectural composition (have-chain):
  have hfaithful := rightReg_faithful (G := G) g₀ hg
  obtain ⟨f, hf_ne⟩ := hfaithful
  -- The "separator" vector f' := ρ^R(g₀) f - f is non-zero.
  have hf'_ne : (rightReg G).toMonoidHom g₀ f - f ≠ 0 :=
    sub_ne_zero.mpr hf_ne
  -- TODO (inherits Ch 4 ⚠ exists_bump, ⚠ convOp_bump_tendsto_id):
  -- 1.  Construct a sequence of symmetric bumps φₙ on shrinking
  --     neighbourhoods of 1_G via `exists_bump` (the symmetry coming
  --     from the symmetrization step).
  -- 2.  Cast bumps to L² via `continuousMapToL2` ∘ `ofReal`, obtaining
  --     `φₙL2 : ℕ → L2 G` with each `IsSymmetricKernel (φₙL2 n)`.
  -- 3.  By `convOp_bump_tendsto_id`, `convOp (φₙL2 n) f' → f' ≠ 0`,
  --     so for some `n`, `convOp (φₙL2 n) f' ≠ 0`.  Take `φ := φₙL2 n`.
  --     This same `φ` satisfies `convOp φ ≠ 0` (since its action on
  --     f' is non-zero).
  -- Currently blocked on the upstream sorries.
  sorry

/-! ## From convolution to a finite-dim invariant subspace -/

/-- (`thm:eigenspace-separates`) For every `g₀ ≠ 1_G`, there exists
a non-zero finite-dimensional closed `ρ^R`-invariant eigenspace
`W = ker(T_φ - λ·Id)` for some symmetric bump `φ` and `λ ∈ ℝ \ {0}`,
on which `ρ^R(g₀)` acts non-trivially. -/
theorem exists_eigenspace_separating (g₀ : G) (hg : g₀ ≠ 1) :
    ∃ (φ : L2 G) (lam : ℝ),
      lam ≠ 0 ∧
      let W : Submodule ℂ (L2 G) :=
        Module.End.eigenspace (convOp φ).toLinearMap (lam : ℂ)
      W ≠ ⊥ ∧
      FiniteDimensional ℂ W ∧
      (rightReg G).IsInvariant W ∧
      (∃ v ∈ W, (rightReg G).toMonoidHom g₀ v ≠ v) := by
  -- Architectural composition (have-chain):
  obtain ⟨φ, hφ_sym, hT_ne, f, hTf'_ne⟩ :=
    exists_symmetric_bump_separating (G := G) g₀ hg
  -- T_φ is compact, self-adjoint, and a ρ^R-intertwiner.
  have hT_compact : IsCompactOperator (convOp φ) :=
    convOp_isCompactOperator φ
  have hT_sa : IsSelfAdjoint (convOp φ) :=
    convOp_isSelfAdjoint φ hφ_sym
  have hT_int : UnitaryRep.IsIntertwiner (convOp φ) (rightReg G) (rightReg G) :=
    convOp_isIntertwiner φ
  -- Apply Ch 5 item 2 (real ✓) to get a non-zero real eigenvalue with
  -- finite-dim eigenspace.
  obtain ⟨lam, hlam_ne, hlam_eig, hlam_FD⟩ :=
    ContinuousLinearMap.IsCompactOperator.IsSelfAdjoint.exists_eigenvalue
      (convOp φ) hT_compact hT_sa hT_ne
  -- The eigenspace is ρ^R-invariant by Ch 6 item 3 (real ✓).
  have hW_inv : (rightReg G).IsInvariant
      (Module.End.eigenspace (convOp φ).toLinearMap (lam : ℂ)) :=
    UnitaryRep.IsIntertwiner.eigenspace_isInvariant (rightReg G) hT_int (lam : ℂ)
  -- The eigenspace is non-zero (HasEigenvalue ⟹ eigenspace ≠ ⊥).
  have hW_ne : Module.End.eigenspace (convOp φ).toLinearMap (lam : ℂ) ≠ ⊥ :=
    hlam_eig
  refine ⟨φ, lam, hlam_ne, hW_ne, hlam_FD, hW_inv, ?_⟩
  -- The non-trivial-action witness (item 4 of the blueprint statement)
  -- TODO (inherits Ch 5 ⚠ external `spectralDecomposition`):
  -- The full spectral decomposition gives
  -- `L²(G) = ker T_φ ⊕ ⊕̂ᵢ Hλᵢ`.  Since `convOp φ (ρ^R(g₀) f - f) ≠ 0`
  -- (item 3 of `exists_symmetric_bump_separating`), the projection of
  -- `ρ^R(g₀) f - f` onto `(ker T_φ)ᗮ` is non-zero, so some
  -- eigencomponent `Hλᵢ` of that vector is non-zero, witnessing the
  -- non-triviality of `ρ^R(g₀)` on `Hλᵢ`.  Replacing `lam` by that
  -- `λᵢ` is the content of the existential; the bookkeeping requires
  -- the bundled `spectralDecomposition` (Ch 5 ⚠).
  sorry

/-! ## From finite-dim invariant to finite-dim irreducible

These items depend only on finished earlier-chapter API
(`IsInvariant.orthogonalComplement`, `IsIrreducible`, and Mathlib's
`Submodule.finrank_lt_finrank_of_lt`).  Both proofs proceed by strong
induction on the dimension of the invariant subspace `W`. -/

omit [IsTopologicalGroup G] [CompactSpace G] [T2Space G]
  [MeasurableSpace G] [BorelSpace G] in
/-- (`thm:fd-contains-irr`) Every non-zero finite-dimensional closed
`ρ`-invariant subspace contains a non-zero closed `ρ`-invariant
subspace on which `ρ` is irreducible (in the intrinsic sense: any
closed `ρ`-invariant submodule of `W'` is `⊥` or `W'`). -/
theorem UnitaryRep.exists_irreducible_subspace_of_finiteDim
    {H : Type*} [NormedAddCommGroup H] [InnerProductSpace ℂ H] [CompleteSpace H]
    (ρ : UnitaryRep G H) {W : Submodule ℂ H}
    (hW_closed : IsClosed (W : Set H)) (hW_inv : ρ.IsInvariant W)
    (hW_fd : FiniteDimensional ℂ W) (hW_ne : W ≠ ⊥) :
    ∃ W' : Submodule ℂ H, W' ≤ W ∧ W' ≠ ⊥ ∧
      IsClosed (W' : Set H) ∧ ρ.IsInvariant W' ∧
      (∀ V : Submodule ℂ H, V ≤ W' → IsClosed (V : Set H) → ρ.IsInvariant V →
        V = ⊥ ∨ V = W') := by
  -- Strong induction on `Module.finrank ℂ W`.
  -- Generalize to "for all W with finrank ≤ n".
  suffices h : ∀ n : ℕ, ∀ {W : Submodule ℂ H},
      IsClosed (W : Set H) → ρ.IsInvariant W →
      FiniteDimensional ℂ W → Module.finrank ℂ W ≤ n → W ≠ ⊥ →
      ∃ W' : Submodule ℂ H, W' ≤ W ∧ W' ≠ ⊥ ∧
        IsClosed (W' : Set H) ∧ ρ.IsInvariant W' ∧
        (∀ V : Submodule ℂ H, V ≤ W' → IsClosed (V : Set H) → ρ.IsInvariant V →
          V = ⊥ ∨ V = W') by
    exact h (Module.finrank ℂ W) hW_closed hW_inv hW_fd le_rfl hW_ne
  intro n
  induction n with
  | zero =>
    intro W _ _ hWfd hle hne
    -- finrank 0 ⟹ W = ⊥, contradicting hne.
    exfalso; apply hne
    exact Submodule.finrank_eq_zero.mp (Nat.le_zero.mp hle)
  | succ n ih =>
    intro W hWc hWi hWfd hle hne
    -- Case split: does W have a proper non-trivial closed invariant
    -- subspace?
    by_cases hsplit :
      ∃ W₁ : Submodule ℂ H, W₁ < W ∧ W₁ ≠ ⊥ ∧
        IsClosed (W₁ : Set H) ∧ ρ.IsInvariant W₁
    · -- Yes: W₁ is a proper non-trivial closed invariant subspace of W.
      obtain ⟨W₁, hW₁_lt, hW₁_ne, hW₁_closed, hW₁_inv⟩ := hsplit
      -- finrank W₁ < finrank W ≤ n + 1, so finrank W₁ ≤ n.
      have hfd_W₁ : FiniteDimensional ℂ W₁ :=
        Submodule.finiteDimensional_of_le hW₁_lt.le
      have hlt : Module.finrank ℂ W₁ < Module.finrank ℂ W :=
        Submodule.finrank_lt_finrank_of_lt hW₁_lt
      have hle_W₁ : Module.finrank ℂ W₁ ≤ n := by omega
      obtain ⟨W', hW'_le, hW'_ne, hW'_closed, hW'_inv, hW'_irr⟩ :=
        ih hW₁_closed hW₁_inv hfd_W₁ hle_W₁ hW₁_ne
      exact ⟨W', hW'_le.trans hW₁_lt.le, hW'_ne, hW'_closed, hW'_inv, hW'_irr⟩
    · -- No: W itself is irreducible.
      push Not at hsplit
      refine ⟨W, le_refl W, hne, hWc, hWi, ?_⟩
      intro V hV_le hV_closed hV_inv
      by_cases hV_bot : V = ⊥
      · exact Or.inl hV_bot
      · refine Or.inr ?_
        by_contra hVW
        -- V is a proper non-trivial closed invariant subspace of W:
        -- contradiction with hsplit.
        exact (hsplit V (lt_of_le_of_ne hV_le hVW) hV_bot hV_closed hV_inv)

omit [IsTopologicalGroup G] [CompactSpace G] [T2Space G]
  [MeasurableSpace G] [BorelSpace G] in
/-- (`thm:fd-irr-nontrivial`) If `W` is finite-dim closed
`ρ`-invariant and `ρ(g₀)` acts non-trivially on `W`, then `W` contains
a non-zero closed `ρ`-invariant subspace `W'` on which `ρ` is
irreducible AND `ρ(g₀)` still acts non-trivially. -/
theorem UnitaryRep.exists_irreducible_subspace_acting_nontrivially
    {H : Type*} [NormedAddCommGroup H] [InnerProductSpace ℂ H] [CompleteSpace H]
    (ρ : UnitaryRep G H) {W : Submodule ℂ H}
    (hW_closed : IsClosed (W : Set H)) (hW_inv : ρ.IsInvariant W)
    (hW_fd : FiniteDimensional ℂ W)
    {g₀ : G} (h_act : ∃ v ∈ W, ρ g₀ v ≠ v) :
    ∃ W' : Submodule ℂ H, W' ≤ W ∧ W' ≠ ⊥ ∧
      IsClosed (W' : Set H) ∧ ρ.IsInvariant W' ∧
      (∀ V : Submodule ℂ H, V ≤ W' → IsClosed (V : Set H) → ρ.IsInvariant V →
        V = ⊥ ∨ V = W') ∧
      (∃ v ∈ W', ρ g₀ v ≠ v) := by
  -- Architectural sketch (blueprint):
  -- Strong induction on `finrank ℂ W` exactly as in item 4, but at
  -- each split step pick the side `W₁` or `W₁ᗮ ∩ W` on which `ρ(g₀)`
  -- still acts non-trivially.  At least one side has the property: if
  -- `ρ(g₀) = id` on both sides of the orthogonal decomposition
  -- `W = W₁ ⊕ (W₁ᗮ ∩ W)`, it is `id` on all of `W`, contradicting
  -- `h_act`.
  -- This requires the orthogonal-complement decomposition lemma
  -- specialized to closed invariant FD subspaces, plus the
  -- step-preservation of "non-trivial action".  ~30+ lines beyond
  -- item 4's induction; sorry'd as a TODO.  Note: this is NOT
  -- transitively a sorry from earlier chapters — the prerequisites
  -- (`IsInvariant.orthogonalComplement`, item 4) are all real.  This
  -- is an *introduced new sorry* in this file.
  sorry

/-! ## The separation theorem -/

/-- (`thm:separating-irr`) Existence of a non-zero finite-dim closed
`ρ^R`-invariant subspace of `L²(G)` on which `ρ^R` is irreducible and
`ρ^R(g₀)` acts non-trivially.  This is the existence-of-separating
finite-dim irreducible representation theorem.

Proof: apply `exists_eigenspace_separating` to obtain a finite-dim
invariant `W ⊆ L²(G)` with `ρ^R(g₀)|_W ≠ Id`, then apply
`exists_irreducible_subspace_acting_nontrivially`. -/
theorem exists_separating_irreducible (g₀ : G) (hg : g₀ ≠ 1) :
    ∃ W' : Submodule ℂ (L2 G), W' ≠ ⊥ ∧
      IsClosed (W' : Set (L2 G)) ∧ FiniteDimensional ℂ W' ∧
      (rightReg G).IsInvariant W' ∧
      (∀ V : Submodule ℂ (L2 G), V ≤ W' → IsClosed (V : Set (L2 G)) →
        (rightReg G).IsInvariant V → V = ⊥ ∨ V = W') ∧
      (∃ v ∈ W', (rightReg G).toMonoidHom g₀ v ≠ v) := by
  -- Architectural composition (have-chain):
  obtain ⟨φ, lam, _hlam_ne, hW_ne, hW_fd, hW_inv, hW_act⟩ :=
    exists_eigenspace_separating (G := G) g₀ hg
  -- W := the eigenspace.
  set W : Submodule ℂ (L2 G) :=
    Module.End.eigenspace (convOp φ).toLinearMap (lam : ℂ) with hW_def
  -- W is closed: finite-dim ⟹ closed in a complete space.
  have hW_closed : IsClosed (W : Set (L2 G)) := by
    haveI : FiniteDimensional ℂ W := hW_fd
    exact Submodule.closed_of_finiteDimensional W
  -- Apply item 5.
  obtain ⟨W', hW'_le, hW'_ne, hW'_closed, hW'_inv, hW'_irr, hW'_act⟩ :=
    UnitaryRep.exists_irreducible_subspace_acting_nontrivially
      (rightReg G) hW_closed hW_inv hW_fd hW_act
  -- W' inherits finite-dimensionality from W.
  have hW'_fd : FiniteDimensional ℂ W' :=
    Submodule.finiteDimensional_of_le hW'_le
  exact ⟨W', hW'_ne, hW'_closed, hW'_fd, hW'_inv, hW'_irr, hW'_act⟩

end PeterWeyl
