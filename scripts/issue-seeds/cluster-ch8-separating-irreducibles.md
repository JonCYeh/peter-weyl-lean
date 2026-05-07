**Title:** [Cluster] Ch.8 Separating irreducibles: downstream wiring of Chs. 2/3/4

**Type:** cluster — 4 sorries in
[PeterWeylComp/Separating.lean](PeterWeylComp/Separating.lean), three of
which inherit from upstream chapters and one which is a genuinely new
formalization step.

## Scope

Discharge the 4 sorries in
[PeterWeylComp/Separating.lean](PeterWeylComp/Separating.lean). From
[blueprint/src/status.tex](blueprint/src/status.tex): "sorry: 4 of 6
(item 4 real)".

### Atomic items in this cluster

- [ ] `thm:rightReg-faithful` — the right regular action is faithful
  (`rightReg_faithful`,
  [PeterWeylComp/Separating.lean:62](PeterWeylComp/Separating.lean#L62))
- [ ] `thm:conv-separating-exists` — existence of a separating
  symmetric self-adjoint convolution operator
  (`exists_symmetric_bump_separating`,
  [PeterWeylComp/Separating.lean:81](PeterWeylComp/Separating.lean#L81))
- [ ] `thm:eigenspace-separating-exists` — `T_φ` has a non-zero
  finite-dim eigenspace separating `g₀` from `1`
  (`exists_eigenspace_separating`,
  [PeterWeylComp/Separating.lean:109](PeterWeylComp/Separating.lean#L109))
- [ ] `thm:irr-action-nontrivial` — finite-dim invariant non-trivial
  action splits to non-trivial irreducible action
  (`exists_irreducible_subspace_acting_nontrivially`,
  [PeterWeylComp/Separating.lean:228](PeterWeylComp/Separating.lean#L228))

## The technique (mostly: be patient)

Three of the four sorries are *transitive* — they will close almost
mechanically once their upstream cluster lands:

| Atomic | Inherits from |
|---|---|
| `thm:rightReg-faithful` | `def:leftTransL2` / `def:rightTransL2` (Ch.2 cluster, dense extension) |
| `thm:conv-separating-exists` | `def:Tphi`, `cor:Tphi-selfadj` (Ch.3 cluster, Fubini) plus `thm:bump-exists` (Ch.4 atomic, Urysohn) |
| `thm:eigenspace-separating-exists` | the previous two + `ass:spectral` (already an external) |

The fourth, `thm:irr-action-nontrivial`, is **not transitive** — it
introduces a new sorry that has no upstream blocker. The Lean comment
at [PeterWeylComp/Separating.lean:249](PeterWeylComp/Separating.lean#L249)
already flags this: *"this is NOT transitively a sorry from earlier
chapters — the prerequisites are real; what's missing is item 4's
induction; sorry'd as a TODO. Note: this is an introduced new sorry in
this file."* That induction is finite-dim Maschke-style: any
finite-dim invariant subspace on which `ρ` acts non-trivially contains
an irreducible subspace on which `ρ` also acts non-trivially.

## Mathlib API to reach for

- For the three transitive items: nothing new — they should follow from
  `Continuous.dense_extend`-style applications already wired up in the
  Ch.2/3 clusters.
- For `thm:irr-action-nontrivial`: the Maschke / semisimplicity API
  in `Mathlib.RepresentationTheory` (`isSemisimple`, `IsSimpleModule`)
  for the finite-dim case. Note we are working with `UnitaryRep`, not
  Mathlib's `Representation`, so a thin bridge from
  `UnitaryRep.IsIrreducible` to `IsSimpleModule (k[G]) V` may be
  required as a helper.

## Why it's a cluster, not 4 atomic issues

The three transitive items should be picked up *after* their upstream
clusters close — they're trivial unblocks, not standalone work. The
fourth needs its own non-trivial proof. Tracking them in one cluster
keeps the "wait → unblock" choreography legible: when Ch.2 / Ch.3
clusters close, mark their checkboxes here and open the corresponding
atomic issues for assignment.

## Suggested order

1. **Wait** for Ch.2 cluster (dense extension) to close.
   Then `thm:rightReg-faithful` opens up as a one-line application.
2. **Wait** for Ch.3 cluster (Fubini) and Ch.4 atomic
   `thm:bump-exists`. Then `thm:conv-separating-exists` falls out.
3. Compose 1 + 2 + the external `ass:spectral` for
   `thm:eigenspace-separating-exists`.
4. **Independently** of all of the above, prove
   `thm:irr-action-nontrivial`. This is the actual work in this
   chapter and can be assigned now.

## Definition of done for the cluster

- [ ] All 4 atomic checkboxes above are checked.
- [ ] [blueprint/src/status.tex](blueprint/src/status.tex) regenerated;
      Ch.8 row reads `0` sorries.

<!-- labels: type:cluster, chapter:separating, priority:p3 -->
