**Type:** atomic — single Lean declaration, single sorry to discharge.

| Field | Value |
|---|---|
| Blueprint label | `thm:leftTrans-unitary` |
| Blueprint kind  | theorem |
| Lean target     | `PeterWeyl.leftTransL2_isUnitary` |
| Source location | `PeterWeylComp/Rep.lean:232` |
| Chapter         | Continuous Unitary Representations |

### Statement (verbatim from blueprint)

For each $g \in G$, $\lambda_g$ is a unitary operator on $L^2(G)$.

### Dependencies (`\uses{...}`)

`def:leftTransL2`

### Definition of done

- [ ] No `sorry` in `PeterWeyl.leftTransL2_isUnitary` (or any helper introduced for it).
- [ ] Add `\leanok` to `thm:leftTrans-unitary` in `blueprint/src/content_comp.tex`.
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
