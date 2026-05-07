**Type:** atomic — single Lean declaration, single sorry to discharge.

| Field | Value |
|---|---|
| Blueprint label | `thm:isotypic-orthog` |
| Blueprint kind  | theorem |
| Lean target     | `PeterWeyl.isotypicComponent_orthogonal` |
| Source location | `PeterWeylComp/Isotypic.lean:222` |
| Chapter         | Isotypic Decomposition of $L^2(G)$ and Plancherel |

### Statement (verbatim from blueprint)

For $\xi_1 \neq \xi_2$ in $\widehat G$, $L^2(G)_{\xi_1} \perp L^2(G)_{\xi_2}$.

### Dependencies (`\uses{...}`)

`def:isotypic`, `thm:mc-orthog-distinct`, `thm:schur-distinct`

### Definition of done

- [ ] No `sorry` in `PeterWeyl.isotypicComponent_orthogonal` (or any helper introduced for it).
- [ ] Add `\leanok` to `thm:isotypic-orthog` in `blueprint/src/content_comp.tex`.
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
