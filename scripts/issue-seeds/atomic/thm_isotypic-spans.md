**Type:** atomic — single Lean declaration, single sorry to discharge.

| Field | Value |
|---|---|
| Blueprint label | `thm:isotypic-spans` |
| Blueprint kind  | theorem |
| Lean target     | `PeterWeyl.isotypicComponents_topologicalClosure_eq_top` |
| Source location | `PeterWeylComp/Isotypic.lean:267` |
| Chapter         | Isotypic Decomposition of $L^2(G)$ and Plancherel |

### Statement (verbatim from blueprint)

$\overline{\sum_{\xi \in \widehat G} L^2(G)_\xi} = L^2(G)$.

### Dependencies (`\uses{...}`)

`thm:mc-in-isotypic`, `cor:MCAlg-L2-dense`, `def:MCAlg`, `def:isotypic`

### Definition of done

- [ ] No `sorry` in `PeterWeyl.isotypicComponents_topologicalClosure_eq_top` (or any helper introduced for it).
- [ ] Add `\leanok` to `thm:isotypic-spans` in `blueprint/src/content_comp.tex`.
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
