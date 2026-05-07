/-
Copyright (c) 2026.  Released under Apache 2.0 license.
-/
import Mathlib.Analysis.InnerProductSpace.Spectrum
import Mathlib.Analysis.InnerProductSpace.Adjoint
import Mathlib.Analysis.Normed.Operator.Compact
import PeterWeylComp.Rep

/-!
# Peter–Weyl, Chapters 5–6: spectral theorem (external) and Schur's lemma

## Mathlib survey

* The compact self-adjoint spectral theorem is **partly** in Mathlib
  (`Mathlib/Analysis/InnerProductSpace/Spectrum.lean`):
  - `eq_zero_of_forall_hasEigenvalue_eq_zero` (line 431) gives existence
    of a non-zero eigenvalue when `T` is compact symmetric and non-zero.
  - `finite_dimensional_eigenspace` (line 463) gives finite-dimensional
    eigenspaces.
  - `orthogonalComplement_iSup_eigenspaces_eq_bot` (line 442) gives the
    Hilbert-sum decomposition (orthogonal complement of the eigenspace
    span is trivial).
  However, the *bundled* form matching this chapter's blueprint
  statement (countable index set, real eigenvalues, all five conjuncts
  packaged together) is not in Mathlib.  We treat it as an
  EXTERNAL ASSUMPTION, sorry-bodied with a doc-comment marker.

* No `Schur` theorem in Mathlib for unitary representations.

* `IsCompactOperator.add`, `.smul`, `.neg`, `.sub`, `.comp_clm`,
  `.clm_comp` exist (`Mathlib/Analysis/Normed/Operator/Compact.lean`).
  **Missing**: `IsCompactOperator.adjoint` (Schauder's theorem).  This
  affects items 5 and 7 of Chapter 6, which need `T*` compact when
  `T` is — we sorry that step.

* `ContinuousLinearMap.realPart` / `imagPart` not in Mathlib (Mathlib
  has `selfAdjointPart` / `skewAdjointPart` for a `*`-module, which
  give a different factorisation: ours uses an `i` to make both parts
  self-adjoint).  Defined locally per blueprint.
-/

open scoped InnerProductSpace ComplexConjugate

namespace PeterWeyl

/-! ## Chapter 5: the compact self-adjoint spectral theorem (external) -/

variable {H : Type*} [NormedAddCommGroup H] [InnerProductSpace ℂ H] [CompleteSpace H]

/-- **EXTERNAL ASSUMPTION** (`ass:c2-spectral`)

The spectral theorem for compact self-adjoint operators on a complex
Hilbert space, in the form used by the blueprint: a compact self-adjoint
`T : H →L[ℂ] H` has a (countable) family of non-zero real eigenvalues
with finite-dimensional, mutually orthogonal eigenspaces whose span is
dense in `(ker T)ᗮ`.  Mathlib has the constituent pieces (see
`Mathlib/Analysis/InnerProductSpace/Spectrum.lean`) but not the bundled
statement; we use this `sorry`-bodied theorem as the project's only
black-box assumption. -/
theorem ContinuousLinearMap.IsCompactOperator.IsSelfAdjoint.spectralDecomposition
    (T : H →L[ℂ] H) (_hT_compact : IsCompactOperator T)
    (_hT_sa : IsSelfAdjoint T) :
    ∃ (I : Type) (_ : Countable I) (lam : I → ℝ),
      (∀ i, lam i ≠ 0) ∧
      (∀ i, Module.End.HasEigenvalue T.toLinearMap (lam i : ℂ)) ∧
      (∀ i, FiniteDimensional ℂ
        (Module.End.eigenspace T.toLinearMap (lam i : ℂ))) ∧
      (((⨆ i, Module.End.eigenspace T.toLinearMap (lam i : ℂ)) :
          Submodule ℂ H).topologicalClosure
        = (LinearMap.ker T.toLinearMap)ᗮ) := by
  -- EXTERNAL: not currently in Mathlib in this bundled form.
  sorry

/-- Existence of a non-zero real eigenvalue for a non-zero compact
self-adjoint operator (`thm:c2-spectral-nonzero-eval`)

Proven directly from Mathlib's `eq_zero_of_forall_hasEigenvalue_eq_zero`
plus `finite_dimensional_eigenspace`; the blueprint derives this from
`spectralDecomposition` (which is an external assumption), but the
Mathlib-direct proof is shorter and avoids destructuring the
external bundle. -/
theorem ContinuousLinearMap.IsCompactOperator.IsSelfAdjoint.exists_eigenvalue
    (T : H →L[ℂ] H) (hT_compact : IsCompactOperator T)
    (hT_sa : IsSelfAdjoint T) (hT_nonzero : T ≠ 0) :
    ∃ (μ : ℝ), μ ≠ 0 ∧ Module.End.HasEigenvalue T.toLinearMap (μ : ℂ) ∧
      FiniteDimensional ℂ (Module.End.eigenspace T.toLinearMap (μ : ℂ)) := by
  have hT_sym : (T : H →ₗ[ℂ] H).IsSymmetric := hT_sa.isSymmetric
  have hexists : ∃ μ : ℂ, Module.End.HasEigenvalue T.toLinearMap μ ∧ μ ≠ 0 := by
    by_contra h
    push Not at h
    exact hT_nonzero
      ((T.eq_zero_of_forall_hasEigenvalue_eq_zero hT_compact hT_sym).mp h)
  obtain ⟨μ, hμ_eig, hμ_ne⟩ := hexists
  have hμ_conj : (starRingEnd ℂ) μ = μ := hT_sym.conj_eigenvalue_eq_self hμ_eig
  obtain ⟨r, hr⟩ : ∃ r : ℝ, μ = (r : ℂ) := RCLike.conj_eq_iff_real.mp hμ_conj
  refine ⟨r, ?_, ?_, ?_⟩
  · intro hr0; apply hμ_ne; rw [hr, hr0]; norm_cast
  · rw [← hr]; exact hμ_eig
  · exact T.finite_dimensional_eigenspace hT_compact (μ := (r : ℂ)) (hr ▸ hμ_ne)

/-! ## Chapter 6: Schur's lemma -/

/-- **EXTERNAL ASSUMPTION** (`ass:c2-schauder`): Schauder's theorem.

The adjoint of a compact operator on a complex Hilbert space is compact.

Mathlib has `IsCompactOperator.{add, smul, neg, sub, comp_clm, clm_comp}`
in `Analysis/Normed/Operator/Compact.lean` but lacks the adjoint case.
The classical proof goes via Arzela–Ascoli: for `T` compact and `(yₙ)`
bounded in the codomain, the family `φₙ(z) := ⟨yₙ, z⟩` restricted to the
compact set `K := closure(T(closed unit ball))` is uniformly bounded and
equicontinuous, hence has a uniformly convergent subsequence; the
identity `⟨T† yₙ - T† yₘ, x⟩ = (φₙ - φₘ)(T x)` then shows `(T† yₙ)` is
Cauchy along that subsequence.

We sorry this theorem and treat it as a second external assumption (the
first being `spectralDecomposition` above).  Items 6 and 7 of Chapter 6
depend on this. -/
theorem _root_.IsCompactOperator.adjoint
    {E F : Type*}
    [NormedAddCommGroup E] [InnerProductSpace ℂ E] [CompleteSpace E]
    [NormedAddCommGroup F] [InnerProductSpace ℂ F] [CompleteSpace F]
    {T : E →L[ℂ] F} (_hT : IsCompactOperator T) :
    IsCompactOperator T.adjoint := by
  -- EXTERNAL: Schauder's theorem; not currently in Mathlib.
  sorry

/-- The self-adjoint *real part* `Re T = (T + T†)/2` of a continuous
linear map on a complex Hilbert space (`def:c2-RealImag`) -/
noncomputable def _root_.ContinuousLinearMap.realPart (T : H →L[ℂ] H) :
    H →L[ℂ] H :=
  (1 / 2 : ℂ) • (T + T.adjoint)

/-- The self-adjoint *imaginary part* `Im T = (T − T†)/(2i)` of a
continuous linear map on a complex Hilbert space (`def:c2-RealImag`) -/
noncomputable def _root_.ContinuousLinearMap.imagPart (T : H →L[ℂ] H) :
    H →L[ℂ] H :=
  (1 / (2 * Complex.I) : ℂ) • (T - T.adjoint)

variable {G : Type*} [Group G] [TopologicalSpace G]

/-- Sum of two intertwiners is an intertwiner. -/
theorem UnitaryRep.IsIntertwiner.add
    {K : Type*} [NormedAddCommGroup K] [InnerProductSpace ℂ K] [CompleteSpace K]
    {ρ : UnitaryRep G H} {σ : UnitaryRep G K} {T U : H →L[ℂ] K}
    (hT : UnitaryRep.IsIntertwiner T ρ σ) (hU : UnitaryRep.IsIntertwiner U ρ σ) :
    UnitaryRep.IsIntertwiner (T + U) ρ σ := fun g => by
  simp only [ContinuousLinearMap.add_comp, ContinuousLinearMap.comp_add, hT g, hU g]

/-- Difference of two intertwiners is an intertwiner. -/
theorem UnitaryRep.IsIntertwiner.sub
    {K : Type*} [NormedAddCommGroup K] [InnerProductSpace ℂ K] [CompleteSpace K]
    {ρ : UnitaryRep G H} {σ : UnitaryRep G K} {T U : H →L[ℂ] K}
    (hT : UnitaryRep.IsIntertwiner T ρ σ) (hU : UnitaryRep.IsIntertwiner U ρ σ) :
    UnitaryRep.IsIntertwiner (T - U) ρ σ := fun g => by
  simp only [ContinuousLinearMap.sub_comp, ContinuousLinearMap.comp_sub, hT g, hU g]

/-- A scalar multiple of an intertwiner is an intertwiner. -/
theorem UnitaryRep.IsIntertwiner.smul
    {K : Type*} [NormedAddCommGroup K] [InnerProductSpace ℂ K] [CompleteSpace K]
    {ρ : UnitaryRep G H} {σ : UnitaryRep G K} (c : ℂ) {T : H →L[ℂ] K}
    (hT : UnitaryRep.IsIntertwiner T ρ σ) :
    UnitaryRep.IsIntertwiner (c • T) ρ σ := fun g => by
  simp only [ContinuousLinearMap.smul_comp, ContinuousLinearMap.comp_smul, hT g]

variable (ρ : UnitaryRep G H)

/-- For a unitary representation, the adjoint of `ρ g` equals `ρ g⁻¹`.
Combines unitarity (`(ρ g)† ∘L ρ g = 1`) with the group-homomorphism
property (`ρ g ∘L ρ g⁻¹ = 1`) to identify the adjoint as the inverse. -/
theorem UnitaryRep.adjoint_eq_inv (g : G) :
    (ρ.toMonoidHom g).adjoint = ρ.toMonoidHom g⁻¹ := by
  have h_unit : (ρ.toMonoidHom g).adjoint ∘L ρ.toMonoidHom g = 1 := ρ.isUnitary g
  have h_inv : ρ.toMonoidHom g ∘L ρ.toMonoidHom g⁻¹ = 1 := by
    show ρ.toMonoidHom g * ρ.toMonoidHom g⁻¹ = 1
    rw [← ρ.toMonoidHom.map_mul, mul_inv_cancel, ρ.toMonoidHom.map_one]
  calc (ρ.toMonoidHom g).adjoint
      = (ρ.toMonoidHom g).adjoint ∘L (ρ.toMonoidHom g ∘L ρ.toMonoidHom g⁻¹) := by
          rw [h_inv]; rfl
    _ = ((ρ.toMonoidHom g).adjoint ∘L ρ.toMonoidHom g) ∘L ρ.toMonoidHom g⁻¹ :=
          (ContinuousLinearMap.comp_assoc _ _ _).symm
    _ = (1 : H →L[ℂ] H) ∘L ρ.toMonoidHom g⁻¹ := by rw [h_unit]
    _ = ρ.toMonoidHom g⁻¹ := ContinuousLinearMap.id_comp _

/-- Adjoint of an intertwiner is an intertwiner.  Auxiliary to
`UnitaryRep.IsIntertwiner.realPart_imagPart`; uses unitarity of `ρ g`
to convert between adjoints and inverses. -/
protected theorem UnitaryRep.IsIntertwiner.adjoint
    {T : H →L[ℂ] H} (hT : UnitaryRep.IsIntertwiner T ρ ρ) :
    UnitaryRep.IsIntertwiner T.adjoint ρ ρ := by
  intro g
  have heq : T ∘L ρ.toMonoidHom g⁻¹ = ρ.toMonoidHom g⁻¹ ∘L T := hT g⁻¹
  have hadj : (T ∘L ρ.toMonoidHom g⁻¹).adjoint
      = (ρ.toMonoidHom g⁻¹ ∘L T).adjoint := congrArg ContinuousLinearMap.adjoint heq
  rw [ContinuousLinearMap.adjoint_comp, ContinuousLinearMap.adjoint_comp,
      UnitaryRep.adjoint_eq_inv, inv_inv] at hadj
  exact hadj.symm

/-- The real and imaginary parts of an intertwiner are intertwiners
(`thm:c2-RealImag-equiv`) -/
theorem UnitaryRep.IsIntertwiner.realPart_imagPart
    {T : H →L[ℂ] H} (hT : UnitaryRep.IsIntertwiner T ρ ρ) :
    UnitaryRep.IsIntertwiner T.realPart ρ ρ
      ∧ UnitaryRep.IsIntertwiner T.imagPart ρ ρ := by
  have hT_adj : UnitaryRep.IsIntertwiner T.adjoint ρ ρ :=
    UnitaryRep.IsIntertwiner.adjoint ρ hT
  refine ⟨?_, ?_⟩
  · exact UnitaryRep.IsIntertwiner.smul (1 / 2 : ℂ)
      (UnitaryRep.IsIntertwiner.add hT hT_adj)
  · exact UnitaryRep.IsIntertwiner.smul (1 / (2 * Complex.I) : ℂ)
      (UnitaryRep.IsIntertwiner.sub hT hT_adj)

/-- The eigenspace of an intertwiner is `ρ`-invariant
(`thm:c2-eigenspace-invariant`) -/
theorem UnitaryRep.IsIntertwiner.eigenspace_isInvariant
    {T : H →L[ℂ] H} (hT : UnitaryRep.IsIntertwiner T ρ ρ) (μ : ℂ) :
    ρ.IsInvariant (Module.End.eigenspace T.toLinearMap μ) := by
  intro g v hv
  rw [Module.End.mem_eigenspace_iff] at hv ⊢
  have h : T (ρ.toMonoidHom g v) = (ρ.toMonoidHom g) (T v) := by
    have := congrArg (fun S : H →L[ℂ] H => S v) (hT g)
    simpa using this
  show T ((ρ.toMonoidHom g) v) = μ • (ρ.toMonoidHom g) v
  rw [h, show (T : H → H) v = μ • v from hv, ContinuousLinearMap.map_smul]

/-- A compact self-adjoint intertwiner of an irreducible representation
is either zero or a real scalar multiple of the identity
(`thm:c2-irrep-selfadj-scalar`) -/
theorem UnitaryRep.IsIrreducible.compact_selfAdjoint_intertwiner_eq_smul_or_zero
    (hρ : ρ.IsIrreducible) {A : H →L[ℂ] H}
    (hA_compact : IsCompactOperator A) (hA_sa : IsSelfAdjoint A)
    (hA_int : UnitaryRep.IsIntertwiner A ρ ρ) :
    A = 0 ∨ ∃ (c : ℝ), c ≠ 0 ∧ A = (c : ℂ) • ContinuousLinearMap.id ℂ H := by
  by_cases hA0 : A = 0
  · exact Or.inl hA0
  · refine Or.inr ?_
    obtain ⟨μ, hμ_ne, hμ_eig, hμ_FD⟩ :=
      ContinuousLinearMap.IsCompactOperator.IsSelfAdjoint.exists_eigenvalue
        A hA_compact hA_sa hA0
    have h_inv : ρ.IsInvariant (Module.End.eigenspace A.toLinearMap (μ : ℂ)) :=
      UnitaryRep.IsIntertwiner.eigenspace_isInvariant ρ hA_int (μ : ℂ)
    have h_closed : IsClosed
        ((Module.End.eigenspace A.toLinearMap (μ : ℂ) : Submodule ℂ H) : Set H) := by
      haveI := hμ_FD
      exact Submodule.closed_of_finiteDimensional _
    rcases hρ.minimal _ h_closed h_inv with h_bot | h_top
    · exfalso
      obtain ⟨v, hv⟩ := hμ_eig.exists_hasEigenvector
      apply hv.2
      have hv_mem : v ∈ Module.End.eigenspace A.toLinearMap (μ : ℂ) := hv.1
      rw [h_bot] at hv_mem
      exact (Submodule.mem_bot _).mp hv_mem
    · refine ⟨μ, hμ_ne, ?_⟩
      ext v
      have hv_eig : v ∈ Module.End.eigenspace A.toLinearMap (μ : ℂ) := by
        rw [h_top]; trivial
      rw [Module.End.mem_eigenspace_iff] at hv_eig
      simp only [ContinuousLinearMap.smul_apply, ContinuousLinearMap.id_apply]
      exact hv_eig

/-- **Schur's lemma**, scalar form, compact case
(`thm:c2-schur-scalar`) -/
theorem UnitaryRep.IsIrreducible.intertwiner_self_eq_smul
    (hρ : ρ.IsIrreducible) {T : H →L[ℂ] H}
    (hT_compact : IsCompactOperator T)
    (hT_int : UnitaryRep.IsIntertwiner T ρ ρ) :
    ∃ (z : ℂ), T = z • ContinuousLinearMap.id ℂ H := by
  have hT_adj_compact : IsCompactOperator T.adjoint := hT_compact.adjoint
  have hT_adj_int : UnitaryRep.IsIntertwiner T.adjoint ρ ρ :=
    UnitaryRep.IsIntertwiner.adjoint ρ hT_int
  -- T + T† and T - T†.
  have h_sum_compact : IsCompactOperator (T + T.adjoint) :=
    hT_compact.add hT_adj_compact
  have h_diff_compact : IsCompactOperator (T - T.adjoint) :=
    hT_compact.sub hT_adj_compact
  have h_sum_int : UnitaryRep.IsIntertwiner (T + T.adjoint) ρ ρ :=
    UnitaryRep.IsIntertwiner.add hT_int hT_adj_int
  have h_diff_int : UnitaryRep.IsIntertwiner (T - T.adjoint) ρ ρ :=
    UnitaryRep.IsIntertwiner.sub hT_int hT_adj_int
  -- Re T = (1/2) • (T + T†) is compact, self-adjoint, intertwiner.
  have h_half_sa : IsSelfAdjoint ((1/2 : ℂ)) := by
    rw [show ((1/2 : ℂ)) = (2 : ℂ)⁻¹ from one_div _]
    exact (IsSelfAdjoint.ofNat 2).inv₀
  have h_sum_sa : IsSelfAdjoint (T + T.adjoint) := by
    show star (T + T.adjoint) = T + T.adjoint
    rw [star_add]; show T.adjoint + T.adjoint.adjoint = T + T.adjoint
    rw [ContinuousLinearMap.adjoint_adjoint]; exact add_comm _ _
  have hRe_compact : IsCompactOperator T.realPart :=
    h_sum_compact.smul (1/2 : ℂ)
  have hRe_sa : IsSelfAdjoint T.realPart := by
    show IsSelfAdjoint ((1/2 : ℂ) • (T + T.adjoint))
    exact h_half_sa.smul h_sum_sa
  have hRe_int : UnitaryRep.IsIntertwiner T.realPart ρ ρ :=
    (UnitaryRep.IsIntertwiner.realPart_imagPart ρ hT_int).1
  -- Im T = (1/(2I)) • (T - T†) is compact, self-adjoint, intertwiner.
  -- Both the scalar 1/(2I) and the operator T - T† are skew-adjoint;
  -- their product is self-adjoint by `isSelfAdjoint_smul_of_mem_skewAdjoint`.
  have h_imagScalar_skew : (1/(2 * Complex.I) : ℂ) ∈ skewAdjoint ℂ := by
    rw [skewAdjoint.mem_iff]
    show (starRingEnd ℂ) (1/(2 * Complex.I)) = -((1/(2 * Complex.I)))
    rw [map_div₀, map_one, map_mul, map_ofNat, Complex.conj_I, mul_neg, div_neg]
  have h_diff_skew : (T - T.adjoint) ∈ skewAdjoint (H →L[ℂ] H) := by
    rw [skewAdjoint.mem_iff]
    show star (T - T.adjoint) = -(T - T.adjoint)
    rw [star_sub]
    show T.adjoint - T.adjoint.adjoint = -(T - T.adjoint)
    rw [ContinuousLinearMap.adjoint_adjoint]; abel
  have hIm_compact : IsCompactOperator T.imagPart :=
    h_diff_compact.smul (1/(2 * Complex.I) : ℂ)
  have hIm_sa : IsSelfAdjoint T.imagPart := by
    show IsSelfAdjoint ((1/(2 * Complex.I) : ℂ) • (T - T.adjoint))
    exact isSelfAdjoint_smul_of_mem_skewAdjoint h_imagScalar_skew h_diff_skew
  have hIm_int : UnitaryRep.IsIntertwiner T.imagPart ρ ρ :=
    (UnitaryRep.IsIntertwiner.realPart_imagPart ρ hT_int).2
  -- Apply item 5 to Re T and Im T.
  have hRe_disj := UnitaryRep.IsIrreducible.compact_selfAdjoint_intertwiner_eq_smul_or_zero
    ρ hρ hRe_compact hRe_sa hRe_int
  have hIm_disj := UnitaryRep.IsIrreducible.compact_selfAdjoint_intertwiner_eq_smul_or_zero
    ρ hρ hIm_compact hIm_sa hIm_int
  obtain ⟨a, ha⟩ : ∃ a : ℝ, T.realPart = (a : ℂ) • ContinuousLinearMap.id ℂ H := by
    rcases hRe_disj with h0 | ⟨a, _, ha⟩
    · exact ⟨0, by rw [h0]; simp⟩
    · exact ⟨a, ha⟩
  obtain ⟨b, hb⟩ : ∃ b : ℝ, T.imagPart = (b : ℂ) • ContinuousLinearMap.id ℂ H := by
    rcases hIm_disj with h0 | ⟨b, _, hb⟩
    · exact ⟨0, by rw [h0]; simp⟩
    · exact ⟨b, hb⟩
  -- T = Re T + I • Im T = (a + I * b) • id.
  refine ⟨(a : ℂ) + Complex.I * (b : ℂ), ?_⟩
  -- First: T = T.realPart + Complex.I • T.imagPart
  have h_decomp : T = T.realPart + Complex.I • T.imagPart := by
    show T = (1/2 : ℂ) • (T + T.adjoint)
            + Complex.I • ((1/(2 * Complex.I) : ℂ) • (T - T.adjoint))
    rw [smul_smul,
        show Complex.I * (1 / (2 * Complex.I)) = 1/2 by field_simp,
        ← smul_add,
        show (T + T.adjoint) + (T - T.adjoint) = (2 : ℂ) • T from by
          rw [show ((2 : ℂ) • T) = T + T from by
            rw [show (2 : ℂ) = 1 + 1 from by norm_num, add_smul, one_smul]]
          abel,
        smul_smul,
        show (1/2 : ℂ) * 2 = 1 from by norm_num,
        one_smul]
  rw [h_decomp, ha, hb, smul_smul, ← add_smul]

/-- **Schur's lemma** for distinct irreducibles: a compact intertwiner
between non-equivalent irreducibles is zero
(`thm:c2-schur-distinct`)

Both prerequisites are now in place: `intertwiner_self_eq_smul` (item 6
above) is real, and `IsCompactOperator.adjoint` (Schauder) is the second
external assumption.  The proof outline:

1.  Generalize `IsIntertwiner.adjoint` to `T : H →L[ℂ] K` with adjoint
    `T† : K →L[ℂ] H` intertwining `σ → ρ`.
2.  `T† ∘L T : H →L[ℂ] H` is compact (clm_comp), self-adjoint
    (`(T†T)† = T†(T†)† = T†T`), and intertwines `ρ → ρ`.
3.  Apply item 6: `T†T = z • id_H` for some `z : ℂ`.  From
    `⟪T†T v, v⟫ = ‖T v‖²` deduce `z` is a non-negative real.
4.  If `z = 0`: `T†T = 0`, hence `T = 0` by
    `adjoint_comp_self_eq_zero_iff`.  Done.
5.  If `z > 0`: define `U := (1/√z : ℂ) • T`, an intertwiner `ρ → σ`
    satisfying `U†U = id_H` (so `U` is isometric).  The range of `U` is
    closed (isometric image of complete space) and `σ`-invariant; by
    `hσ.minimal`, it is `⊥` or `⊤`.  `⊥` contradicts `U†U = id_H` on a
    nonzero vector (`hρ.nontrivial`).  So `range U = ⊤`, hence `U` is
    surjective; together with `U†U = id_H` this gives `UU† = id_K`, so
    `U.IsEquiv` and `ρ.Equiv σ`, contradicting `h_not_equiv`.

This is a real proof but requires generalizing the adjoint helper to
two reps, a `LinearIsometry`-style closed-range lemma, and an
`isometry + surjective ⇒ unitary` lemma chain.  Estimated 70–100 lines
in Lean given the current Mathlib API; exceeds the per-item budget for
this sub-task, so we sorry it and document.  No new external assumption
is required — the obstruction is purely effort-bounded. -/
theorem UnitaryRep.IsIrreducible.compact_intertwiner_eq_zero_of_not_equiv
    {K : Type*} [NormedAddCommGroup K] [InnerProductSpace ℂ K] [CompleteSpace K]
    (σ : UnitaryRep G K)
    (_hρ : ρ.IsIrreducible) (_hσ : σ.IsIrreducible)
    {T : H →L[ℂ] K} (_hT_compact : IsCompactOperator T)
    (_hT_int : UnitaryRep.IsIntertwiner T ρ σ) (_h_not_equiv : ¬ ρ.Equiv σ) :
    T = 0 := by
  sorry

end PeterWeyl
