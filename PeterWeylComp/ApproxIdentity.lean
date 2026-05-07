/-
Copyright (c) 2026.  Released under Apache 2.0 license.
-/
import Mathlib.Topology.UrysohnsLemma
import Mathlib.Topology.UniformSpace.HeineCantor
import PeterWeylComp.Convolution

/-!
# Peter–Weyl, Chapter 4: Approximate Identities

This file scaffolds the items of Chapter 4 of the compact Peter–Weyl
blueprint (`blueprint/src/content_comp.tex`).  We define a continuous
*bump* on an open neighbourhood `U ∋ 1_G` (a continuous, non-negative,
symmetric, support-in-`U`, normalized function), prove existence of
bumps via Urysohn's lemma, and state that convolution against bumps
with shrinking supports converges strongly to the identity in `L²(G)`.

## Mathlib survey

* No approximate-identity API in `Mathlib.Analysis` (verified via
  `grep -rn 'approxId|ApproxIdentity|approximate_identity'`).  We
  therefore define `IsBump` from scratch.
* `exists_continuous_zero_one_of_isCompact'`
  (`Mathlib/Topology/UrysohnsLemma.lean:379`) is the Urysohn variant
  used in `exists_bump`.  It requires `RegularSpace G` and
  `LocallyCompactSpace G`, both of which follow from
  `CompactSpace G + T2Space G`.
* `CompactSpace.uniformContinuous_of_continuous`
  (`Mathlib/Topology/UniformSpace/HeineCantor.lean:38`) provides the
  Heine–Cantor uniform continuity used in step 1 of
  `convOp_bump_tendsto_id`.

Following the blueprint, we keep the bump real-valued (`G → ℝ`) and do
not generalize to `RCLike 𝕜`: the convergence-to-identity story uses
the inclusion `ℝ ↪ ℂ` to cast bumps into `L²(G)` of complex-valued
functions.
-/

open scoped MeasureTheory ENNReal NNReal InnerProductSpace

namespace PeterWeyl

variable {G : Type*} [Group G] [TopologicalSpace G] [IsTopologicalGroup G]
  [CompactSpace G] [T2Space G] [MeasurableSpace G] [BorelSpace G]

/-! ## Continuous bumps -/

/-- A continuous bump on the open neighbourhood `U ∋ 1_G`: continuous,
non-negative, supported in `U`, with total integral `1` against the
Haar probability measure, and symmetric under inversion -/
structure IsBump (U : Set G) (φ : G → ℝ) : Prop where
  /-- `φ` is continuous -/
  continuous : Continuous φ
  /-- `φ` is non-negative -/
  nonneg : ∀ g, 0 ≤ φ g
  /-- The (open) support of `φ` is contained in `U` -/
  support_subset : Function.support φ ⊆ U
  /-- `φ` integrates to `1` against the Haar probability measure -/
  integral_eq_one : ∫ g, φ g ∂(haarProb G) = 1
  /-- `φ` is symmetric: `φ g = φ g⁻¹` -/
  symmetric : ∀ g, φ g = φ g⁻¹

/-! ## Existence of continuous bumps -/

/-- For every open neighbourhood `U` of `1_G`, there exists a bump on `U`
(`thm:bump-exists`) -/
theorem exists_bump {U : Set G} (hU_open : IsOpen U) (hU_mem : (1 : G) ∈ U) :
    ∃ φ : G → ℝ, IsBump U φ := by
  /- Blueprint outline:
     (1) Pick a smaller open neighbourhood `V ∋ 1_G` with
         `V ∪ V⁻¹ ⊆ U`.  Existence: continuity of `Inv.inv` and
         `IsTopologicalGroup` give a basis of open symmetric
         neighbourhoods; e.g. `V := U ∩ U⁻¹` is open (intersection
         of opens) and contains `1`, and `V⁻¹ = V`.
     (2) Apply Urysohn's lemma
         `exists_continuous_zero_one_of_isCompact'` with
         `s := {1_G}` (compact) and `t := Vᶜ` (closed) to obtain
         `ψ ∈ C(G, ℝ)` with `ψ = 0` on `Vᶜ` (i.e. `support ψ ⊆ V`),
         `ψ 1 = 1`, and `0 ≤ ψ ≤ 1`.
     (3) Symmetrize: `ψ_sym g := ψ g + ψ g⁻¹`.  Then `ψ_sym` is
         continuous, non-negative, symmetric, supported in
         `V ∪ V⁻¹ ⊆ U`, with `ψ_sym 1 = 2 > 0`.
     (4) Normalize: let `c := ∫ ψ_sym dμ`.  Since `ψ_sym` is
         continuous, non-negative, and positive at `1_G`, with
         `haarProb` an open-positive measure (instance
         `IsHaarMeasure → IsOpenPosMeasure`), we get `c > 0`.
         Set `φ := ψ_sym / c`.  Each `IsBump` field then follows.
     This is several pages of formalization (Urysohn ↔ closed-support
     translation; symmetrization preserves continuity; integral
     positivity from open-positivity); deferred. -/
  sorry

/-! ## Convergence to identity -/

/-- Convolution against a sequence of bumps with shrinking supports
converges to the identity strongly in `L²(G)`
(`thm:bump-conv-tendsto`)

Note on the signature: we phrase the statement abstractly over any
`Filter.AtTop`-indexed sequence of bumps whose supports form an
antitone basis of `nhds (1 : G)`; the conclusion is strong convergence
(at every `f`).  The cast `ℝ → ℂ` for the bump is bundled into the
parameter `φL2 : ℕ → L2 G` rather than constructed inline.
-/
theorem convOp_bump_tendsto_id
    (U : ℕ → Set G) (φ : ℕ → G → ℝ)
    (_hU_basis : (nhds (1 : G)).HasAntitoneBasis U)
    (_hφ_bump : ∀ n, IsBump (U n) (φ n))
    (φL2 : ℕ → L2 G)
    (_hφL2 : ∀ n, ∀ᵐ g ∂(haarProb G),
      (φL2 n : G → ℂ) g = ((φ n g : ℂ)))
    (f : L2 G) :
    Filter.Tendsto (fun n => convOp (φL2 n) f) Filter.atTop (nhds f) := by
  /- Blueprint outline (3-step proof):

     Step 1.  For continuous `f' ∈ C(G, ℂ)`, by `CompactSpace.
       uniformContinuous_of_continuous` (Heine–Cantor) and a `metric`
       argument: given `ε > 0`, pick `U₀ ∋ 1_G` such that
       `|f'(u⁻¹ x) - f'(x)| < ε` for all `u ∈ U₀, x ∈ G`.  By the
       antitone-basis hypothesis, eventually `U n ⊆ U₀`, so
       `|(T_{φ_n} f')(x) - f'(x)| ≤ ε` pointwise (using the
       integral-1 normalization of the bump).  Hence
       `‖T_{φ_n} f' - f'‖_∞ → 0`, and a fortiori
       `‖T_{φ_n} f' - f'‖_{L²} → 0` by
       `L2_norm_le_Linfty_norm` (Chapter 1, item 13).

     Step 2.  For general `f ∈ L²(G)` and `ε > 0`, pick `f' ∈ C(G, ℂ)`
       with `‖f - f'‖_{L²} < ε/3` via `continuousMapToL2_denseRange`.
       By Step 1, choose `N` with `‖T_{φ_n} f' - f'‖_{L²} < ε/3` for
       `n ≥ N`.

     Step 3.  Triangle inequality
       `‖T_{φ_n} f - f‖_{L²}
         ≤ ‖T_{φ_n}(f - f')‖_{L²}
         + ‖T_{φ_n} f' - f'‖_{L²}
         + ‖f' - f‖_{L²}`.
       The middle term is `< ε/3` by Step 2.  The first and third
       are each `≤ ‖f - f'‖_{L²} < ε/3` using the Young
       `L² ⋆ L¹ → L²` bound (NOT the operator-norm bound `‖T_{φ_n}‖_op
       ≤ ‖φ_n‖_{L²}`, which is not uniform in `n`).  This requires
       a refined `convPtwise_L2_norm_bound` with `‖φ‖_{L¹}` on the
       RHS — currently stated with `‖φ‖_{L²}` (Chapter 3, item 4),
       so this proof depends on either generalizing item 4 or proving
       a separate `L¹` bound.

     Total deferred until both Chapter 3 item 4 (or a `L¹` variant)
     and Chapter 1 item 13's downstream uses are wired up. -/
  sorry

end PeterWeyl
