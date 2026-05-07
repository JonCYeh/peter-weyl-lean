**Title:** [Cluster] Ch.11 Isotypic decomposition + Plancherel

**Type:** cluster — 9 sorries in
[PeterWeylComp/Isotypic.lean](PeterWeylComp/Isotypic.lean) split across
two distinct technique buckets.

## Scope

Discharge the 9 sorries in
[PeterWeylComp/Isotypic.lean](PeterWeylComp/Isotypic.lean). From
[blueprint/src/status.tex](blueprint/src/status.tex) §"Cleanup-pass
priorities" item 4: "blocked on Chapter 10 plus the orthogonal-projection
/ `OrthogonalFamily` bridge."

### Atomic items in this cluster, by bucket

**Bucket A — `IrreducibleClass` setoid plumbing (3 sorries, internal).**

These items are not blueprint-cited; they are helpers that
`UnitaryRep.IrrSkeleton` is built from.

- [ ] `UnitaryRep.Equiv.symm`
  ([PeterWeylComp/Isotypic.lean:108](PeterWeylComp/Isotypic.lean#L108)) —
  witness `T.adjoint`
- [ ] `UnitaryRep.Equiv.trans`
  ([PeterWeylComp/Isotypic.lean:118](PeterWeylComp/Isotypic.lean#L118)) —
  witness `S ∘L T`
- [ ] `isotypicComponent_aux_eq_of_equiv`
  ([PeterWeylComp/Isotypic.lean:184](PeterWeylComp/Isotypic.lean#L184)) —
  invariance of the isotypic component under choice of representative

**Bucket B — Hilbert sum / Plancherel (6 sorries, blueprint-cited).**

- [ ] `thm:isotypic-rho-invariant` — `L²(G)_ξ` is `ρᴿ`-invariant
- [ ] `thm:isotypic-orthog` — distinct isotypic components are
  orthogonal *(blocked on Ch.10 cluster `thm:orth-distinct`)*
- [ ] `thm:mc-in-isotypic` — matrix coefficients of `ρ_ξ` live in
  `L²(G)_ξ`
- [ ] `thm:isotypic-spans` — closed sum of isotypic components is
  dense in `L²(G)`
- [ ] `thm:PW-HilbertSum` — `L²(G)` is the Hilbert sum of isotypic
  components
- [ ] `thm:plancherel-isotypic` — Plancherel: per-isotypic norm sum

## The technique

**Bucket A** is straightforward: each sorry has a one-line witness
already noted in the Lean source comment. They are listed as sorries
only because the file was scaffolded top-down. Likely a single
afternoon's PR.

**Bucket B** has two distinct blockers:

1. *Distinct-component orthogonality* (`thm:isotypic-orthog`)
   reduces to `thm:orth-distinct` in the **Ch.10 Bochner cluster**.
   Wait for that cluster to close; this becomes a one-liner.
2. *Hilbert-sum identification* (`thm:PW-HilbertSum`,
   `thm:plancherel-isotypic`) wants Mathlib's `IsHilbertSum` /
   `OrthogonalFamily` API and a constructor that takes:
   - a family of mutually orthogonal closed subspaces (from the
     orthogonality theorem),
   - a denseness witness for their closed sum (from
     `thm:isotypic-spans`, which itself uses
     `cor:A-L2-dense` from Ch.9 — already real),
   and produces an `IsHilbertSum`. The Mathlib name is roughly
   `IsHilbertSum.mk` / `DirectSum.IsInternal.collectedBasis`-style;
   we'll likely need a small bridge lemma if our `IrrSkeleton` indexing
   doesn't line up with the expected `Submodule`-indexed form.

`thm:mc-in-isotypic` and `thm:isotypic-rho-invariant` are
self-contained: they're about a single matrix-coefficient lying in a
single subspace, no Bochner needed.

## Mathlib API to reach for

- `OrthogonalFamily` and `IsHilbertSum` in
  `Mathlib.Analysis.InnerProductSpace.l2Space`.
- `OrthogonalFamily.isHilbertSum_of_dense` (if available — verify the
  current name); otherwise the direct constructor.
- `Submodule.topologicalClosure` and the closed-subspace API.

## Why it's a cluster, not 9 atomic issues

The 9 sorries split *cleanly* into two work units:

- Bucket A: one PR closes all three. Picking these up as 3 atomic
  issues forces 3 reviews on essentially the same change.
- Bucket B: 4 of 6 unblock as soon as the Ch.10 Bochner cluster lands;
  the other 2 (`isotypic-rho-invariant`, `mc-in-isotypic`) are
  unrelated and can be picked up at any time.

## Suggested order

1. Bucket A as one PR. **No blueprint dependency**; do it now.
2. Bucket B, self-contained pair: `thm:isotypic-rho-invariant` and
   `thm:mc-in-isotypic` (independent of Ch.10).
3. **Wait** for Ch.10 Bochner cluster. Then in order:
   `thm:isotypic-orthog` → `thm:isotypic-spans` →
   `thm:PW-HilbertSum` → `thm:plancherel-isotypic`.

## Definition of done for the cluster

- [ ] All 9 atomic checkboxes above are checked.
- [ ] [blueprint/src/status.tex](blueprint/src/status.tex) regenerated;
      Ch.11 row reads `0` sorries.
- [ ] Ch.10 Bochner cluster also closed (sister cluster).

<!-- labels: type:cluster, chapter:isotypic, area:bochner, area:hilbert-sum, priority:p1 -->
