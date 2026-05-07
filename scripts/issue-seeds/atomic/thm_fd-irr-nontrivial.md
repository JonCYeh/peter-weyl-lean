**Type:** atomic — single Lean declaration, single sorry to discharge.

| Field | Value |
|---|---|
| Blueprint label | `thm:fd-irr-nontrivial` |
| Blueprint kind  | theorem |
| Lean target     | `PeterWeyl.UnitaryRep.exists_irreducible_subspace_acting_nontrivially` |
| Source location | `_(declaration not found — verify Lean name)_` |
| Chapter         | Existence of Separating Finite-Dim Irreducibles |

### Statement (verbatim from blueprint)

Let $W$ be a finite-dim non-zero closed $\rho$-invariant subspace, and
  $g_0 \in G$ such that $\rho(g_0)|_W \neq \mathrm{Id}_W$. Then there
  exists a non-zero closed $\rho$-invariant subspace $W' \subseteq W$
  with $\rho|_{W'}$ irreducible and $\rho(g_0)|_{W'} \neq \mathrm{Id}_{W'}$.

### Dependencies (`\uses{...}`)

`thm:fd-contains-irr`, `thm:orthCompl-invariant`, `def:IsIrreducible`

### Definition of done

- [ ] No `sorry` in `PeterWeyl.UnitaryRep.exists_irreducible_subspace_acting_nontrivially` (or any helper introduced for it).
- [ ] Add `\leanok` to `thm:fd-irr-nontrivial` in `blueprint/src/content_comp.tex`.
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
