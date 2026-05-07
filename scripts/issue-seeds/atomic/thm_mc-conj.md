**Type:** atomic — single Lean declaration, single sorry to discharge.

| Field | Value |
|---|---|
| Blueprint label | `thm:mc-conj` |
| Blueprint kind  | theorem |
| Lean target     | `UnitaryRep.matrixCoeff_conj_eq_contragredient` |
| Source location | `PeterWeylComp/MatrixCoeff.lean:230` |
| Chapter         | Matrix Coefficients |

### Statement (verbatim from blueprint)

$\overline{\pi_{u,v}^\rho(g)} = \pi_{v, u}^{\overline\rho}(g)$ (under
  the conjugate-Hilbert identification).

### Dependencies (`\uses{...}`)

`def:matrixCoeff`, `def:contragredient`

### Definition of done

- [ ] No `sorry` in `UnitaryRep.matrixCoeff_conj_eq_contragredient` (or any helper introduced for it).
- [ ] Add `\leanok` to `thm:mc-conj` in `blueprint/src/content_comp.tex`.
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
