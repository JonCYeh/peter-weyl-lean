**Type:** atomic — single Lean declaration, single sorry to discharge.

| Field | Value |
|---|---|
| Blueprint label | `thm:rightReg-faithful` |
| Blueprint kind  | theorem |
| Lean target     | `PeterWeyl.rightReg_faithful` |
| Source location | `PeterWeylComp/Separating.lean:62` |
| Chapter         | Existence of Separating Finite-Dim Irreducibles |

### Statement (verbatim from blueprint)

For every $g_0 \in G$ with $g_0 \neq 1_G$, there exists $f \in L^2(G)$
  with $\rho^R(g_0) f \neq f$.

### Dependencies (`\uses{...}`)

`def:rightReg`, `thm:bump-exists`, `thm:bump-conv-tendsto`

### Definition of done

- [ ] No `sorry` in `PeterWeyl.rightReg_faithful` (or any helper introduced for it).
- [ ] Add `\leanok` to `thm:rightReg-faithful` in `blueprint/src/content_comp.tex`.
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
