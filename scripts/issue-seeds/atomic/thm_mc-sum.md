**Type:** atomic — single Lean declaration, single sorry to discharge.

| Field | Value |
|---|---|
| Blueprint label | `thm:mc-sum` |
| Blueprint kind  | theorem |
| Lean target     | `UnitaryRep.matrixCoeff_add_eq_directSum` |
| Source location | `PeterWeylComp/MatrixCoeff.lean:135` |
| Chapter         | Matrix Coefficients |

### Statement (verbatim from blueprint)

Let $V_1, V_2$ be finite-dim Hilbert spaces with reps $\rho_1, \rho_2$.
  For $u_i, v_i \in V_i$, the function
  $g \mapsto \pi_{u_1, v_1}^{\rho_1}(g) + \pi_{u_2, v_2}^{\rho_2}(g)$
  equals $\pi_{u_1 \oplus u_2, v_1 \oplus v_2}^{\rho_1 \oplus \rho_2}$
  on $V_1 \oplus V_2$.

### Dependencies (`\uses{...}`)

`def:matrixCoeff`

### Definition of done

- [ ] No `sorry` in `UnitaryRep.matrixCoeff_add_eq_directSum` (or any helper introduced for it).
- [ ] Add `\leanok` to `thm:mc-sum` in `blueprint/src/content_comp.tex`.
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
