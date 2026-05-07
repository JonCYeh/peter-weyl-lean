**Type:** atomic — single Lean declaration, single sorry to discharge.

| Field | Value |
|---|---|
| Blueprint label | `thm:leftTrans-strongCts` |
| Blueprint kind  | theorem |
| Lean target     | `PeterWeyl.leftTransL2_strongContinuous` |
| Source location | `PeterWeylComp/Rep.lean:249` |
| Chapter         | Continuous Unitary Representations |

### Statement (verbatim from blueprint)

For every $f \in L^2(G)$, the map
  $g \mapsto \lambda_g f$ is continuous from $G$ to $L^2(G)$.

### Dependencies (`\uses{...}`)

`def:leftTransL2`, `thm:leftTrans-unitary`, `thm:CG-dense-L2`

### Definition of done

- [ ] No `sorry` in `PeterWeyl.leftTransL2_strongContinuous` (or any helper introduced for it).
- [ ] Add `\leanok` to `thm:leftTrans-strongCts` in `blueprint/src/content_comp.tex`.
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
