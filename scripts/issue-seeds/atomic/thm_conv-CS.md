**Type:** atomic — single Lean declaration, single sorry to discharge.

| Field | Value |
|---|---|
| Blueprint label | `thm:conv-CS` |
| Blueprint kind  | theorem |
| Lean target     | `PeterWeyl.convPtwise_norm_le_L2_L2` |
| Source location | `PeterWeylComp/Convolution.lean:61` |
| Chapter         | Convolution as a Bounded Operator on $L^2(G)$ |

### Statement (verbatim from blueprint)

For $f, \phi \in L^2(G)$ and $x \in G$,
  $|(f*\phi)(x)| \leq \|f\|_{L^2}\|\phi\|_{L^2}$.

### Dependencies (`\uses{...}`)

`def:conv-ptwise`, `def:L2`

### Definition of done

- [ ] No `sorry` in `PeterWeyl.convPtwise_norm_le_L2_L2` (or any helper introduced for it).
- [ ] Add `\leanok` to `thm:conv-CS` in `blueprint/src/content_comp.tex`.
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
