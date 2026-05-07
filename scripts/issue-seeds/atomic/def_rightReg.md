**Type:** atomic — single Lean declaration, single sorry to discharge.

| Field | Value |
|---|---|
| Blueprint label | `def:rightReg` |
| Blueprint kind  | definition |
| Lean target     | `PeterWeyl.rightReg` |
| Source location | `PeterWeylComp/Rep.lean:287` |
| Chapter         | Continuous Unitary Representations |

### Statement (verbatim from blueprint)

Bundled in the same way as $\rho^L$, using
  Theorem~\ref{thm:haar-rightInv} (right-invariance) in place of
  Theorem~\ref{thm:haar-leftInv}.

### Dependencies (`\uses{...}`)

`def:rightTransL2`, `def:UnitaryRep`

### Definition of done

- [ ] No `sorry` in `PeterWeyl.rightReg` (or any helper introduced for it).
- [ ] Add `\leanok` to `def:rightReg` in `blueprint/src/content_comp.tex`.
- [ ] `lake build` passes locally and in CI (`build-project.yml`).
- [ ] Blueprint dep-graph builds without errors (`blueprint.yml`).

### Hints

- Each item in **Dependencies** that is itself sorry-bodied has its own
  atomic issue. Cross-link with “Blocked by #N” so the project board shows
  the unblock chain.
- If the proof needs technique-level scaffolding (Bochner integration,
  dense-extension of bounded operators, Fubini, Stone–Weierstrass), prefer
  to land that in the parent **cluster** issue first and reduce this issue
  to a one-line application.
