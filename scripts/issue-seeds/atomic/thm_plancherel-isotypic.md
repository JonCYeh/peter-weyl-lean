**Type:** atomic — single Lean declaration, single sorry to discharge.

| Field | Value |
|---|---|
| Blueprint label | `thm:plancherel-isotypic` |
| Blueprint kind  | theorem |
| Lean target     | `PeterWeyl.norm_sq_eq_sum_isotypic_norm_sq` |
| Source location | `PeterWeylComp/Isotypic.lean:334` |
| Chapter         | Isotypic Decomposition of $L^2(G)$ and Plancherel |

### Statement (verbatim from blueprint)

For every $f \in L^2(G)$,
  $\|f\|_{L^2}^2 = \sum_{\xi \in \widehat G}\|P_\xi f\|_{L^2}^2$,
  where $P_\xi : L^2(G) \to L^2(G)_\xi$ is the orthogonal projection.

### Dependencies (`\uses{...}`)

`thm:PW-HilbertSum`

### Definition of done

- [ ] No `sorry` in `PeterWeyl.norm_sq_eq_sum_isotypic_norm_sq` (or any helper introduced for it).
- [ ] Add `\leanok` to `thm:plancherel-isotypic` in `blueprint/src/content_comp.tex`.
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
