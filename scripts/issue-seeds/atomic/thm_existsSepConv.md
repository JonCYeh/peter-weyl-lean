**Type:** atomic — single Lean declaration, single sorry to discharge.

| Field | Value |
|---|---|
| Blueprint label | `thm:existsSepConv` |
| Blueprint kind  | theorem |
| Lean target     | `PeterWeyl.exists_symmetric_bump_separating` |
| Source location | `PeterWeylComp/Separating.lean:81` |
| Chapter         | Existence of Separating Finite-Dim Irreducibles |

### Statement (verbatim from blueprint)

For every $g_0 \in G$ with $g_0 \neq 1_G$, there exists a symmetric
  bump $\phi \in C(G)$ such that:
  \begin{enumerate}
    \item $\phi$ is symmetric (Definition~\ref{def:symmetric});
    \item $T_\phi$ is non-zero;
    \item $T_\phi$ does not commute with $\rho^R(g_0)$ in the sense:
      there exists $f \in L^2(G)$ with $T_\phi(\rho^R(g_0) f - f) \neq 0$.
  \end{enumerate}

### Dependencies (`\uses{...}`)

`thm:rightReg-faithful`, `thm:bump-exists`, `thm:bump-conv-tendsto`, `def:rightReg`, `def:symmetric`, `def:Tphi`

### Definition of done

- [ ] No `sorry` in `PeterWeyl.exists_symmetric_bump_separating` (or any helper introduced for it).
- [ ] Add `\leanok` to `thm:existsSepConv` in `blueprint/src/content_comp.tex`.
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
