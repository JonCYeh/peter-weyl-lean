**Type:** atomic — single Lean declaration, single sorry to discharge.

| Field | Value |
|---|---|
| Blueprint label | `thm:mc-in-isotypic` |
| Blueprint kind  | theorem |
| Lean target     | `UnitaryRep.matrixCoeff_mem_isotypicComponent` |
| Source location | `_(declaration not found — verify Lean name)_` |
| Chapter         | Isotypic Decomposition of $L^2(G)$ and Plancherel |

### Statement (verbatim from blueprint)

For each $\xi \in \widehat G$ and $u, v \in V_\xi$, the matrix
  coefficient $\pi_{u, v}^{\rho_\xi} \in L^2(G)$ lies in $L^2(G)_\xi$.

### Dependencies (`\uses{...}`)

`def:isotypic`, `def:matrixCoeff`, `def:Ghat`

### Definition of done

- [ ] No `sorry` in `UnitaryRep.matrixCoeff_mem_isotypicComponent` (or any helper introduced for it).
- [ ] Add `\leanok` to `thm:mc-in-isotypic` in `blueprint/src/content_comp.tex`.
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
