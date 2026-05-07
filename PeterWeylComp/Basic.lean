/-
Copyright (c) 2026.  Released under Apache 2.0 license.
-/
import Mathlib.MeasureTheory.Measure.Haar.Basic
import Mathlib.MeasureTheory.Measure.Haar.Unique
import Mathlib.MeasureTheory.Group.Measure
import Mathlib.MeasureTheory.Function.L2Space
import Mathlib.MeasureTheory.Function.ContinuousMapDense
import Mathlib.MeasureTheory.Function.LpSpace.Complete
import Mathlib.MeasureTheory.Function.LpSeminorm.CompareExp
import Mathlib.Topology.ContinuousMap.Bounded.Basic

/-!
# Peter–Weyl, Chapter 1: Setup, Haar Measure, $L^2(G)$

This file scaffolds the 13 items of Chapter 1 of the compact Peter–Weyl
blueprint (`blueprint/src/content_comp.tex`).  It introduces the standing
hypotheses on a compact Hausdorff topological group `G`, fixes scalars to
`ℂ`, defines the Haar probability measure `PeterWeyl.haarProb`, and
records the basic facts about it together with the Hilbert space
`L²(G)`.

Most theorem bodies are `sorry`s; the file is intended to compile and
serve as a translation skeleton.
-/

/-!
## Items deferred to later chapters

Two items in this file carry deliberate `sorry`:

* `haarProb_isMulRightInvariant` (item 7)
* `haarProb_inv_eq_self` (item 8)

Both follow from `isMulInvariant_eq_smul_of_compactSpace`
(`Mathlib/MeasureTheory/Measure/Haar/Unique.lean:668`) plus the
probability normalization, but they are not needed until Chapter 3
(the convolution chapter), where right-invariance is used to show
that the convolution operator commutes with right translation.
Defer until then.
-/

open scoped MeasureTheory ENNReal NNReal

namespace PeterWeyl

/-! ## Standing hypotheses (`def:G`, `def:scalars`) -/

variable
  (G : Type*)
  [Group G] [TopologicalSpace G] [IsTopologicalGroup G]
  [CompactSpace G] [T2Space G] [MeasurableSpace G] [BorelSpace G]

/-! ## Haar probability measure (`def:haar-prob`) -/

/-- A fixed unnormalized left Haar measure on `G`, obtained as Mathlib's
`haarMeasure` applied to an arbitrary positive compact set. -/
noncomputable def haarBase : MeasureTheory.Measure G :=
  MeasureTheory.Measure.haarMeasure (default : TopologicalSpace.PositiveCompacts G)

instance haarBase_isHaarMeasure : (haarBase G).IsHaarMeasure :=
  MeasureTheory.Measure.isHaarMeasure_haarMeasure _

/-- The Haar probability measure on a compact Hausdorff topological group:
rescale `haarBase` by `1 / μ(univ)` so that the total mass is `1`. -/
noncomputable def haarProb : MeasureTheory.Measure G :=
  (haarBase G Set.univ)⁻¹ • haarBase G

omit [T2Space G] in
private lemma haarBase_univ_ne_top : haarBase G Set.univ ≠ ∞ :=
  MeasureTheory.measure_ne_top _ _

omit [T2Space G] in
private lemma haarBase_univ_ne_zero : haarBase G Set.univ ≠ 0 :=
  (MeasureTheory.Measure.measure_univ_ne_zero (μ := haarBase G)).mpr (NeZero.ne _)

omit [T2Space G] in
private lemma haarBase_univ_inv_ne_zero : (haarBase G Set.univ)⁻¹ ≠ 0 :=
  ENNReal.inv_ne_zero.mpr (haarBase_univ_ne_top G)

omit [T2Space G] in
private lemma haarBase_univ_inv_ne_top : (haarBase G Set.univ)⁻¹ ≠ ∞ :=
  ENNReal.inv_ne_top.mpr (haarBase_univ_ne_zero G)

/-! ## Properties of `haarProb` -/

/-- `haarProb G` is a Haar measure (`thm:haar-isHaar`). -/
instance haarProb_isHaarMeasure : (haarProb G).IsHaarMeasure :=
  MeasureTheory.Measure.IsHaarMeasure.smul (haarBase G)
    (haarBase_univ_inv_ne_zero G) (haarBase_univ_inv_ne_top G)

/-- `haarProb G` is a probability measure (`thm:haar-isProb`). -/
instance haarProb_isProbabilityMeasure :
    MeasureTheory.IsProbabilityMeasure (haarProb G) := by
  refine ⟨?_⟩
  show ((haarBase G Set.univ)⁻¹ • haarBase G : MeasureTheory.Measure G) Set.univ = 1
  rw [MeasureTheory.Measure.smul_apply, smul_eq_mul]
  exact ENNReal.inv_mul_cancel (haarBase_univ_ne_zero G) (haarBase_univ_ne_top G)

omit [T2Space G] in
/-- `haarProb G` is left-invariant (`thm:haar-leftInv`). -/
theorem haarProb_isMulLeftInvariant :
    (haarProb G).IsMulLeftInvariant := inferInstance

/-- `haarProb G` is right-invariant (`thm:haar-rightInv`). -/
instance haarProb_isMulRightInvariant :
    (haarProb G).IsMulRightInvariant := by
  refine ⟨fun g => ?_⟩
  -- The pushforward `(haarProb G).map (· * g)` is again a Haar measure
  -- (Mathlib instance `isHaarMeasure_map_mul_right`) and a probability
  -- measure (`Measure.isProbabilityMeasure_map`); uniqueness of Haar
  -- probability measures then forces it to equal `haarProb G`.
  haveI : ((haarProb G).map (· * g)).IsHaarMeasure :=
    MeasureTheory.Measure.isHaarMeasure_map_mul_right (haarProb G) g
  haveI : MeasureTheory.IsProbabilityMeasure ((haarProb G).map (· * g)) :=
    MeasureTheory.Measure.isProbabilityMeasure_map
      (measurable_mul_const g).aemeasurable
  exact MeasureTheory.Measure.isHaarMeasure_eq_of_isProbabilityMeasure _ _

/-- `haarProb G` is invariant under inversion as a typeclass: `μ_G.inv = μ_G` -/
instance haarProb_isInvInvariant :
    (haarProb G).IsInvInvariant := by
  refine ⟨?_⟩
  -- Mathlib supplies the three components of `IsHaarMeasure ((haarProb G).inv)`
  -- as separate instances; bundle them, add probability normalization, and
  -- conclude by uniqueness of the Haar probability measure.
  haveI : ((haarProb G).inv).IsHaarMeasure := { }
  haveI : MeasureTheory.IsProbabilityMeasure ((haarProb G).inv) := by
    refine ⟨?_⟩
    rw [MeasureTheory.Measure.inv_apply, Set.inv_univ]
    exact MeasureTheory.measure_univ
  exact MeasureTheory.Measure.isHaarMeasure_eq_of_isProbabilityMeasure _ _

/-- `haarProb G` is invariant under inversion (`thm:haar-inv`). -/
theorem haarProb_inv_eq_self :
    (haarProb G).inv = haarProb G :=
  MeasureTheory.Measure.inv_eq_self _

/-! ## The Hilbert space `L²(G)` -/

/-- The Hilbert space `L²(G)` of square-integrable complex-valued
functions on `G` against `haarProb G` (`def:L2`). -/
noncomputable abbrev L2 : Type _ := MeasureTheory.Lp ℂ 2 (haarProb G)

omit [T2Space G] in
/-- `L²(G)` is a complete space, i.e. a Hilbert space
(`thm:L2-Hilbert`). -/
theorem L2.completeSpace : CompleteSpace (L2 G) := inferInstance

/-- The continuous linear inclusion `C(G, ℂ) ↪ L²(G)`
(`thm:CG-into-L2`). -/
noncomputable def continuousMapToL2 : C(G, ℂ) →L[ℂ] L2 G :=
  ContinuousMap.toLp (E := ℂ) 2 (haarProb G) ℂ

omit [T2Space G] in
/-- The image of `continuousMapToL2` is dense in `L²(G)`
(`thm:CG-dense-L2`). -/
theorem continuousMapToL2_denseRange :
    DenseRange (continuousMapToL2 G) :=
  ContinuousMap.toLp_denseRange (E := ℂ) (μ := haarProb G) ℂ
    (by simp : (2 : ℝ≥0∞) ≠ ∞)

omit [T2Space G] in
/-- `‖f‖_{L²} ≤ ‖f‖_∞` for continuous `f : G → ℂ` (`thm:Lp-monotone`).
This is the operator-norm bound for `ContinuousMap.toLp` specialized to
the probability measure `haarProb G`, where the universal mass is `1`. -/
theorem L2_norm_le_Linfty_norm (f : C(G, ℂ)) :
    ‖continuousMapToL2 G f‖ ≤ ‖f‖ := by
  have hμ : MeasureTheory.measureUnivNNReal (haarProb G) = 1 := by
    have h : ((MeasureTheory.measureUnivNNReal (haarProb G) : ℝ≥0) : ℝ≥0∞) = 1 := by
      rw [MeasureTheory.coe_measureUnivNNReal]
      exact MeasureTheory.measure_univ
    exact_mod_cast h
  have h_op : ‖continuousMapToL2 G‖ ≤ 1 := by
    have := ContinuousMap.toLp_norm_le (E := ℂ) (μ := haarProb G) (p := 2) (𝕜 := ℂ)
    simpa [hμ] using this
  calc ‖continuousMapToL2 G f‖
      ≤ ‖continuousMapToL2 G‖ * ‖f‖ := (continuousMapToL2 G).le_opNorm f
    _ ≤ 1 * ‖f‖ := by gcongr
    _ = ‖f‖ := one_mul _

end PeterWeyl
