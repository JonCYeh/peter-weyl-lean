**Type:** atomic — single Lean declaration, single sorry to discharge.

| Field | Value |
|---|---|
| Blueprint label | `thm:Tphi-comm-rightReg` |
| Blueprint kind  | theorem |
| Lean target     | `PeterWeyl.convOp_comm_rightReg` |
| Source location | `PeterWeylComp/Convolution.lean:108` |
| Chapter         | Convolution as a Bounded Operator on $L^2(G)$ |

### Statement (verbatim from blueprint)

For all $g \in G$ and $\phi \in L^2(G)$,
  $T_\phi \circ_L \rho^R(g) = \rho^R(g) \circ_L T_\phi$.

### Dependencies (`\uses{...}`)

`def:Tphi`, `def:rightReg`

### Definition of done

- [ ] No `sorry` in `PeterWeyl.convOp_comm_rightReg` (or any helper introduced for it).
- [ ] Add `\leanok` to `thm:Tphi-comm-rightReg` in `blueprint/src/content_comp.tex`.
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
