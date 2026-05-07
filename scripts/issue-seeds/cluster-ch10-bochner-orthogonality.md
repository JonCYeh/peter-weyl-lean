**Title:** [Cluster] Ch.10 Schur orthogonality: Bochner integration scaffolding

**Type:** cluster — Bochner-integration plumbing that blocks two atomic
sorries in Ch.10 plus a further block in Ch.11.

## Scope

Discharge the 2 sorries in
[PeterWeylComp/Orthogonality.lean](PeterWeylComp/Orthogonality.lean) and
unblock 2 of the 9 sorries in
[PeterWeylComp/Isotypic.lean](PeterWeylComp/Isotypic.lean) that depend on
the same Bochner machinery. From
[blueprint/src/status.tex](blueprint/src/status.tex) §"Cleanup-pass
priorities" item 3 (and partially item 4).

### Atomic items in this cluster

- [ ] `thm:orth-distinct` — inner product of matrix coefficients across
  distinct irreducibles
- [ ] `thm:orth-same` — inner product of matrix coefficients of the same
  irreducible
- [ ] (Ch.11) `thm:isotypic-orth-distinct` — distinct isotypic components
  are orthogonal (depends on `thm:orth-distinct`)
- [ ] (Ch.11) `thm:isotypic-rho-invariant` — L²(G)_ξ is ρᴿ-invariant

## The technique

Both Ch.10 statements compute an integral of an operator-valued function
over G against Haar probability and want to identify the result as the
projector onto an invariant subspace. The Lean obstruction is that
Mathlib's Bochner-integral API for operator-valued integrands is thin and
the lemmas we need (e.g. `∫ ρ(g) T ρ(g)⁻¹ dμ` is an intertwiner) require
hand-rolled scaffolding.

Concretely we need three reusable lemmas, none of which currently exist
in our codebase:

1. **`bochner_integral_intertwines`**: for `T : V →L[ℂ] V` and a unitary
   `ρ`, the integral `S := ∫ ρ(g) T ρ(g⁻¹) dμ(g)` is an intertwiner of
   `ρ` (i.e. commutes with every `ρ(h)`).
2. **`schur_average_finrank`**: for a finite-dim irreducible `ρ`, this
   `S` equals `(tr T / dim V) • id` (Schur scalar form, this case).
3. **`matrix_coeff_inner_via_bochner`**: rewrite
   `⟪π_{u,v}, π_{u',v'}⟫_{L²(G)}` as
   `⟨v, ∫ ρ(g) (u' ⊗ u) ρ(g⁻¹) dμ ⋅ v'⟩`, then apply (1)–(2).

## Mathlib API to reach for

- `MeasureTheory.Bochner.integral` over an operator-valued integrand.
- `ContinuousLinearMap.integral_apply` (commuting `∫` past linear evaluation).
- `IsHaarMeasure.integral_eq_…` invariance lemmas.
- We may need to **upstream** a small lemma about `∫ T(g) v dμ(g)` agreeing
  with the strong/weak operator integral; flag if so.

## Why it's a cluster, not 2 atomic issues

Both atomic items want exactly the same three lemmas. Doing them as
isolated atomic issues will cause two contributors to redo the
80–100-line scaffolding. Lemma 1 alone is a multi-day formalization; once
it lands, lemmas 2 and 3 are short, and both `thm:orth-*` collapse.

## Suggested order

1. Land `bochner_integral_intertwines` in
   `PeterWeylComp/Orthogonality.lean` (or a new
   `PeterWeylComp/BochnerAux.lean` if it grows). Spike PR with no
   blueprint-cited statement; just the helper.
2. Land `schur_average_finrank` reusing existing Schur (Ch.6).
3. Open the two atomic issues, each citing the helper.
4. After both land, revisit the Ch.11 atomic issues that share this
   blocker — they should drop from "blocked" to "ready".

## Definition of done for the cluster

- [ ] Helpers (1)–(3) above land in `PeterWeylComp/`.
- [ ] Both atomic checkboxes for Ch.10 are checked.
- [ ] The Ch.11 atomic issues that named "Bochner orthogonality" as
      blocker are unblocked (i.e. their `Blocked by #(this)` line is
      removed).
- [ ] `blueprint/src/status.tex` regenerated; Ch.10 row reads `0`.

<!-- labels: type:cluster, chapter:orthog, area:bochner, priority:p1 -->
