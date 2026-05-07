**Type:** atomic — single Lean declaration, single sorry to discharge.

| Field | Value |
|---|---|
| Blueprint label | `thm:Tphi-adj` |
| Blueprint kind  | theorem |
| Lean target     | `PeterWeyl.convOp_adjoint` |
| Source location | `PeterWeylComp/Convolution.lean:128` |
| Chapter         | Convolution as a Bounded Operator on $L^2(G)$ |

### Statement (verbatim from blueprint)

For every $\phi \in L^2(G)$ and $f, h \in L^2(G)$,
  $\langle T_\phi f, h\rangle =
   \langle f, T_{\widetilde\phi} h\rangle$,
  where $\widetilde\phi(g) := \overline{\phi(g^{-1})}$.
  Equivalently, $(T_\phi)^* = T_{\widetilde\phi}$.

### Dependencies (`\uses{...}`)

`def:Tphi`, `thm:haar-inv`

### Definition of done

- [ ] No `sorry` in `PeterWeyl.convOp_adjoint` (or any helper introduced for it).
- [ ] Add `\leanok` to `thm:Tphi-adj` in `blueprint/src/content_comp.tex`.
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
