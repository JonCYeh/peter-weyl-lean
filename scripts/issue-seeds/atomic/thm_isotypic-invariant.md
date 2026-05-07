**Type:** atomic — single Lean declaration, single sorry to discharge.

| Field | Value |
|---|---|
| Blueprint label | `thm:isotypic-invariant` |
| Blueprint kind  | theorem |
| Lean target     | `PeterWeyl.isotypicComponent_isInvariant` |
| Source location | `PeterWeylComp/Isotypic.lean:199` |
| Chapter         | Isotypic Decomposition of $L^2(G)$ and Plancherel |

### Statement (verbatim from blueprint)

$\rho^R.\texttt{IsInvariant}\, L^2(G)_\xi$.

### Dependencies (`\uses{...}`)

`def:isotypic`

### Definition of done

- [ ] No `sorry` in `PeterWeyl.isotypicComponent_isInvariant` (or any helper introduced for it).
- [ ] Add `\leanok` to `thm:isotypic-invariant` in `blueprint/src/content_comp.tex`.
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
