**Type:** atomic — single Lean declaration, single sorry to discharge.

| Field | Value |
|---|---|
| Blueprint label | `thm:mc-orthog-same` |
| Blueprint kind  | theorem |
| Lean target     | `UnitaryRep.matrixCoeff_inner_eq` |
| Source location | `PeterWeylComp/Orthogonality.lean:162` |
| Chapter         | Schur Orthogonality |

### Statement (verbatim from blueprint)

Let $\rho : \texttt{UnitaryRep G V}$ be finite-dimensional and
  irreducible, $d := \dim V$. Then for all $u_1, u_2, v_1, v_2 \in V$,
  \[
     \int_G \pi_{u_1, v_1}^{\rho}(g)\, \overline{\pi_{u_2, v_2}^{\rho}(g)}\, d\mu_G(g)
     = \frac{1}{d}\,\langle u_1, u_2\rangle\,\overline{\langle v_1, v_2\rangle}.
  \]

### Dependencies (`\uses{...}`)

`def:matrixCoeff`, `def:IsIrreducible`, `thm:schur-scalar`

### Definition of done

- [ ] No `sorry` in `UnitaryRep.matrixCoeff_inner_eq` (or any helper introduced for it).
- [ ] Add `\leanok` to `thm:mc-orthog-same` in `blueprint/src/content_comp.tex`.
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
