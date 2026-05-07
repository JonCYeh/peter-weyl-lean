**Type:** atomic — single Lean declaration, single sorry to discharge.

| Field | Value |
|---|---|
| Blueprint label | `def:leftTransL2` |
| Blueprint kind  | definition |
| Lean target     | `PeterWeyl.leftTransL2` |
| Source location | `PeterWeylComp/Rep.lean:223` |
| Chapter         | Continuous Unitary Representations |

### Statement (verbatim from blueprint)

For $g \in G$, the left translation $\lambda_g : L^2(G) \to L^2(G)$
  is the unique continuous linear map sending the class of
  $f \in C(G)$ to the class of $h \mapsto f(g^{-1} h)$. Existence:
  on continuous functions left translation preserves the $L^2$-norm
  by left-invariance of $\mu_G$ (Theorem~\ref{thm:haar-leftInv}),
  hence extends uniquely by continuity to all of $L^2(G)$
  (Theorem~\ref{thm:CG-dense-L2}).

### Dependencies (`\uses{...}`)

`def:L2`, `thm:haar-leftInv`

### Definition of done

- [ ] No `sorry` in `PeterWeyl.leftTransL2` (or any helper introduced for it).
- [ ] Add `\leanok` to `def:leftTransL2` in `blueprint/src/content_comp.tex`.
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
