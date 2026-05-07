**Type:** atomic — single Lean declaration, single sorry to discharge.

| Field | Value |
|---|---|
| Blueprint label | `thm:mc-mul` |
| Blueprint kind  | theorem |
| Lean target     | `UnitaryRep.matrixCoeff_mul_eq_tensor` |
| Source location | `PeterWeylComp/MatrixCoeff.lean:189` |
| Chapter         | Matrix Coefficients |

### Statement (verbatim from blueprint)

$\pi_{u_1, v_1}^{\rho_1}(g) \cdot \pi_{u_2, v_2}^{\rho_2}(g) =
   \pi_{u_1 \otimes u_2, v_1 \otimes v_2}^{\rho_1 \otimes \rho_2}(g)$.

### Dependencies (`\uses{...}`)

`def:matrixCoeff`, `def:tensor-rep`

### Definition of done

- [ ] No `sorry` in `UnitaryRep.matrixCoeff_mul_eq_tensor` (or any helper introduced for it).
- [ ] Add `\leanok` to `thm:mc-mul` in `blueprint/src/content_comp.tex`.
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
