**Type:** atomic — single Lean declaration, single sorry to discharge.

| Field | Value |
|---|---|
| Blueprint label | `def:leftReg` |
| Blueprint kind  | definition |
| Lean target     | `PeterWeyl.leftReg` |
| Source location | `PeterWeylComp/Rep.lean:259` |
| Chapter         | Continuous Unitary Representations |

### Statement (verbatim from blueprint)

The left regular representation
  $\rho^L : \texttt{UnitaryRep G $L^2(G)$}$ is the bundling of
  $g \mapsto \lambda_g$ together with
  Theorems~\ref{thm:leftTrans-unitary},
  \ref{thm:leftTrans-mulHom}, \ref{thm:leftTrans-strongCts}.

### Dependencies (`\uses{...}`)

`thm:leftTrans-unitary`, `thm:leftTrans-mulHom`, `thm:leftTrans-strongCts`, `def:UnitaryRep`

### Definition of done

- [ ] No `sorry` in `PeterWeyl.leftReg` (or any helper introduced for it).
- [ ] Add `\leanok` to `def:leftReg` in `blueprint/src/content_comp.tex`.
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
