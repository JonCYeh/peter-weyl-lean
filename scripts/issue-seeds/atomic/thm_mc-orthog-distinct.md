**Type:** atomic — single Lean declaration, single sorry to discharge.

| Field | Value |
|---|---|
| Blueprint label | `thm:mc-orthog-distinct` |
| Blueprint kind  | theorem |
| Lean target     | `UnitaryRep.matrixCoeff_inner_eq_zero_of_not_equiv` |
| Source location | `PeterWeylComp/Orthogonality.lean:94` |
| Chapter         | Schur Orthogonality |

### Statement (verbatim from blueprint)

Let $\rho_1 : \texttt{UnitaryRep G $V_1$}$,
  $\rho_2 : \texttt{UnitaryRep G $V_2$}$ both finite-dimensional and
  irreducible with $\rho_1 \not\cong \rho_2$. Then for all
  $u_1, w_1 \in V_1$ and $u_2, w_2 \in V_2$,
  \[
     \int_G \pi_{u_1, w_1}^{\rho_1}(g)\, \overline{\pi_{u_2, w_2}^{\rho_2}(g)}\, d\mu_G(g) = 0.
  \]

### Dependencies (`\uses{...}`)

`def:matrixCoeff`, `def:IsIrreducible`, `thm:schur-distinct`, `def:Equiv`

### Definition of done

- [ ] No `sorry` in `UnitaryRep.matrixCoeff_inner_eq_zero_of_not_equiv` (or any helper introduced for it).
- [ ] Add `\leanok` to `thm:mc-orthog-distinct` in `blueprint/src/content_comp.tex`.
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
