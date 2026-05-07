**Type:** atomic — single Lean declaration, single sorry to discharge.

| Field | Value |
|---|---|
| Blueprint label | `thm:conv-cts` |
| Blueprint kind  | theorem |
| Lean target     | `PeterWeyl.convPtwise_continuous` |
| Source location | `PeterWeylComp/Convolution.lean:74` |
| Chapter         | Convolution as a Bounded Operator on $L^2(G)$ |

### Statement (verbatim from blueprint)

For $f, \phi \in L^2(G)$, the function $x \mapsto (f*\phi)(x)$ is
  continuous on $G$.

### Dependencies (`\uses{...}`)

`thm:conv-CS`, `thm:leftTrans-strongCts`

### Definition of done

- [ ] No `sorry` in `PeterWeyl.convPtwise_continuous` (or any helper introduced for it).
- [ ] Add `\leanok` to `thm:conv-cts` in `blueprint/src/content_comp.tex`.
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
