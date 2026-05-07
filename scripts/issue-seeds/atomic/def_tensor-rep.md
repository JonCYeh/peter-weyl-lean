**Type:** atomic — single Lean declaration, single sorry to discharge.

| Field | Value |
|---|---|
| Blueprint label | `def:tensor-rep` |
| Blueprint kind  | definition |
| Lean target     | `UnitaryRep.tensor` |
| Source location | `PeterWeylComp/MatrixCoeff.lean:176` |
| Chapter         | Matrix Coefficients |

### Statement (verbatim from blueprint)

Given $\rho_i : \texttt{UnitaryRep G $V_i$}$ for $i = 1, 2$ with $V_i$
  finite-dimensional, $\rho_1 \otimes \rho_2 : \texttt{UnitaryRep G ($V_1 \otimes V_2$)}$
  is the homomorphism $g \mapsto \rho_1(g) \otimes \rho_2(g)$ on the
  algebraic (= Hilbert, in finite dim) tensor product, with the inner
  product $\langle u_1\otimes u_2, v_1 \otimes v_2\rangle :=
  \langle u_1, v_1\rangle\langle u_2, v_2\rangle$ extended linearly.

### Dependencies (`\uses{...}`)

`def:UnitaryRep`

### Definition of done

- [ ] No `sorry` in `UnitaryRep.tensor` (or any helper introduced for it).
- [ ] Add `\leanok` to `def:tensor-rep` in `blueprint/src/content_comp.tex`.
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
