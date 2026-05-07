**Type:** atomic — single Lean declaration, single sorry to discharge.

| Field | Value |
|---|---|
| Blueprint label | `def:contragredient` |
| Blueprint kind  | definition |
| Lean target     | `UnitaryRep.contragredient` |
| Source location | `PeterWeylComp/MatrixCoeff.lean:216` |
| Chapter         | Matrix Coefficients |

### Statement (verbatim from blueprint)

Given $\rho : \texttt{UnitaryRep G V}$ with $V$ finite-dimensional,
  $\overline\rho : \texttt{UnitaryRep G $V^*$}$ is the homomorphism
  $g \mapsto (\rho(g)^{-1})^* = \rho(g^{-1})^* = \rho(g)$ acting on the
  conjugate-dual space $V^*$ via
  $(\overline\rho(g) \ell)(v) := \overline{\ell(\rho(g)^{-1} v)}$;
  equivalently we identify $V^*$ with the conjugate Hilbert space $\overline V$
  (same underlying set, scalar multiplication conjugated).

### Dependencies (`\uses{...}`)

`def:UnitaryRep`

### Definition of done

- [ ] No `sorry` in `UnitaryRep.contragredient` (or any helper introduced for it).
- [ ] Add `\leanok` to `def:contragredient` in `blueprint/src/content_comp.tex`.
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
