**Type:** atomic — single Lean declaration, single sorry to discharge.

| Field | Value |
|---|---|
| Blueprint label | `thm:schur-distinct` |
| Blueprint kind  | theorem |
| Lean target     | `PeterWeyl.UnitaryRep.IsIrreducible.compact_intertwiner_eq_zero_of_not_equiv` |
| Source location | `_(declaration not found — verify Lean name)_` |
| Chapter         | Schur's Lemma for Continuous Unitary Irreducibles |

### Statement (verbatim from blueprint)

Let $\rho : \texttt{UnitaryRep G H}$, $\sigma : \texttt{UnitaryRep G K}$
  both irreducible, and $T : H \to_L K$ compact with
  $T.\texttt{IsIntertwiner $\rho$ $\sigma$}$. If $\rho \not\cong \sigma$
  (no unitary equivalence between $\rho$ and $\sigma$), then $T = 0$.

### Dependencies (`\uses{...}`)

`thm:schur-scalar`, `def:Equiv`, `thm:orthCompl-invariant`

### Definition of done

- [ ] No `sorry` in `PeterWeyl.UnitaryRep.IsIrreducible.compact_intertwiner_eq_zero_of_not_equiv` (or any helper introduced for it).
- [ ] Add `\leanok` to `thm:schur-distinct` in `blueprint/src/content_comp.tex`.
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
