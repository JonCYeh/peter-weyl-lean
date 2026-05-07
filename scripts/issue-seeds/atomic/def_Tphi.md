**Type:** atomic — single Lean declaration, single sorry to discharge.

| Field | Value |
|---|---|
| Blueprint label | `def:Tphi` |
| Blueprint kind  | definition |
| Lean target     | `PeterWeyl.convOp` |
| Source location | `PeterWeylComp/Convolution.lean:100` |
| Chapter         | Convolution as a Bounded Operator on $L^2(G)$ |

### Statement (verbatim from blueprint)

For $\phi \in L^2(G)$, define
  $T_\phi : L^2(G) \to_L L^2(G)$ as the unique continuous linear extension
  of the pointwise-convolution operation $f \mapsto f*\phi$ from
  the subspace where pointwise convolution is well-defined, with norm
  bound $\|T_\phi\|_{\mathrm{op}} \leq \|\phi\|_{L^2}$ from
  Theorem~\ref{thm:conv-L2bound}.

### Dependencies (`\uses{...}`)

`thm:conv-L2bound`, `def:L2`

### Definition of done

- [ ] No `sorry` in `PeterWeyl.convOp` (or any helper introduced for it).
- [ ] Add `\leanok` to `def:Tphi` in `blueprint/src/content_comp.tex`.
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
