**Type:** atomic — single Lean declaration, single sorry to discharge.

| Field | Value |
|---|---|
| Blueprint label | `thm:LR-commute` |
| Blueprint kind  | theorem |
| Lean target     | `PeterWeyl.leftReg_comm_rightReg` |
| Source location | `PeterWeylComp/Rep.lean:301` |
| Chapter         | Continuous Unitary Representations |

### Statement (verbatim from blueprint)

For all $g, h \in G$, $\rho^L(g) \circ_L \rho^R(h) = \rho^R(h) \circ_L \rho^L(g)$.

### Dependencies (`\uses{...}`)

`def:leftReg`, `def:rightReg`

### Definition of done

- [ ] No `sorry` in `PeterWeyl.leftReg_comm_rightReg` (or any helper introduced for it).
- [ ] Add `\leanok` to `thm:LR-commute` in `blueprint/src/content_comp.tex`.
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
