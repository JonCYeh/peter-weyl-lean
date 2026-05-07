**Type:** atomic — single Lean declaration, single sorry to discharge.

| Field | Value |
|---|---|
| Blueprint label | `def:rightTransL2` |
| Blueprint kind  | definition |
| Lean target     | `PeterWeyl.rightTransL2` |
| Source location | `PeterWeylComp/Rep.lean:276` |
| Chapter         | Continuous Unitary Representations |

### Statement (verbatim from blueprint)

For $g \in G$, $\rho_g : L^2(G) \to L^2(G)$ is the unique continuous
  linear extension of $f \mapsto (h \mapsto f(hg))$ from $C(G)$.

### Dependencies (`\uses{...}`)

`def:L2`, `thm:haar-rightInv`

### Definition of done

- [ ] No `sorry` in `PeterWeyl.rightTransL2` (or any helper introduced for it).
- [ ] Add `\leanok` to `def:rightTransL2` in `blueprint/src/content_comp.tex`.
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
