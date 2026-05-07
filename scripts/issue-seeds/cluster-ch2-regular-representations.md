**Title:** [Cluster] Ch.2 Regular representations: dense extension of translation from C(G) to L²(G)

**Type:** cluster — coordinates a block of sorry-bodied atomic items that all
share the same technique blocker.

## Scope

Discharge all 8 sorries in [PeterWeylComp/Rep.lean](PeterWeylComp/Rep.lean)
that depend on extending an isometry from `C(G)` to `L²(G)`. From
[blueprint/src/status.tex](blueprint/src/status.tex) §"Cleanup-pass
priorities" item 1.

### Atomic items in this cluster

- [ ] `def:leftTransL2` — left translation as a map on L²
- [ ] `thm:leftTrans-unitary` — λ_g is unitary
- [ ] `thm:leftTrans-mulHom` — λ is a group homomorphism on L²
- [ ] `thm:leftTrans-strongCts` — orbit map is continuous
- [ ] `def:leftReg` — the left regular representation ρᴸ
- [ ] `def:rightTransL2` — right translation on L²
- [ ] `def:rightReg` — the right regular representation ρᴿ
- [ ] `thm:LR-commute` — ρᴸ and ρᴿ commute

## The technique

All eight items reduce to one move: define a bounded operator on L²(G) by
extending an isometry from the dense subspace `C(G)`. The pattern is:

1. Define the operator on `C(G)` as a continuous-linear map
   (well-defined because Haar measure is left/right-invariant; this is the
   hypothesis from `thm:haar-leftInv` / `thm:haar-rightInv` for
   left / right translation respectively).
2. Show it is an isometry of `(C(G), L²-norm)` into `L²(G)` —
   one line from invariance plus the inclusion `C(G) ↪ L²(G)`
   (`thm:CG-into-L2`).
3. Extend by continuity to `L²(G)` using the dense range of
   `continuousMapToL2` (`thm:CG-dense-L2`).
4. All algebraic identities (unitarity, multiplicativity, commutativity)
   transfer from the dense subspace by continuity.

## Mathlib API to reach for

- `DenseInducing.extend` / `UniformSpace.completion` for the bounded extension.
- `IsUnitary` / `LinearIsometryEquiv` for step 4.
- `ContinuousLinearMap.extend` for the bundled form, given an isometry on
  a dense subspace and a target Banach space.

A spike that gets one item — say `def:leftTransL2` — to `\leanok` end-to-end
will unlock the rest as ~one-line applications. **Recommend doing the spike
in a draft PR before opening the remaining 7 atomic issues for assignment.**

## Suggested order

1. `def:leftTransL2` (definition, the spike)
2. `thm:leftTrans-unitary`, `thm:leftTrans-mulHom`,
   `thm:leftTrans-strongCts` (the three properties; can be done in
   parallel once 1 lands)
3. `def:leftReg` (just bundles 1–4)
4. `def:rightTransL2`, `def:rightReg` (mirror of left side)
5. `thm:LR-commute` (uses both)

## Definition of done for the cluster

- [ ] All 8 atomic checkboxes above are checked.
- [ ] Cluster issue closed.
- [ ] `blueprint/src/status.tex` regenerated; Ch.2 row reads `0` sorries.

<!-- labels: type:cluster, chapter:rep, area:dense-extension, priority:p1 -->
