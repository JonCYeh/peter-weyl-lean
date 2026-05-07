**Type:** atomic — single Lean declaration, single sorry to discharge.

| Field | Value |
|---|---|
| Blueprint label | `cor:Tphi-selfadj` |
| Blueprint kind  | corollary |
| Lean target     | `PeterWeyl.convOp_isSelfAdjoint` |
| Source location | `PeterWeylComp/Convolution.lean:138` |
| Chapter         | Convolution as a Bounded Operator on $L^2(G)$ |

### Statement (verbatim from blueprint)

If $\phi$ is symmetric (Definition~\ref{def:symmetric}), then
  $T_\phi$ is self-adjoint, i.e.\
  $T_\phi^* = T_\phi$.

### Dependencies (`\uses{...}`)

`thm:Tphi-adj`, `def:symmetric`

### Definition of done

- [ ] No `sorry` in `PeterWeyl.convOp_isSelfAdjoint` (or any helper introduced for it).
- [ ] Add `\leanok` to `cor:Tphi-selfadj` in `blueprint/src/content_comp.tex`.
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
