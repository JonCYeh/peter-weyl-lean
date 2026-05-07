**Type:** atomic — single Lean declaration, single sorry to discharge.

| Field | Value |
|---|---|
| Blueprint label | `thm:bump-exists` |
| Blueprint kind  | theorem |
| Lean target     | `PeterWeyl.exists_bump` |
| Source location | `PeterWeylComp/ApproxIdentity.lean:67` |
| Chapter         | Approximate Identities |

### Statement (verbatim from blueprint)

For every open $U \ni 1_G$, there exists $\phi : G \to \mathbb R$ that
  is a bump on $U$.

### Dependencies (`\uses{...}`)

`def:bump`, `def:G`

### Definition of done

- [ ] No `sorry` in `PeterWeyl.exists_bump` (or any helper introduced for it).
- [ ] Add `\leanok` to `thm:bump-exists` in `blueprint/src/content_comp.tex`.
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
