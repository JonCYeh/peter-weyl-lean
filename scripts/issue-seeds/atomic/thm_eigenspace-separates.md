**Type:** atomic — single Lean declaration, single sorry to discharge.

| Field | Value |
|---|---|
| Blueprint label | `thm:eigenspace-separates` |
| Blueprint kind  | theorem |
| Lean target     | `PeterWeyl.exists_eigenspace_separating` |
| Source location | `PeterWeylComp/Separating.lean:109` |
| Chapter         | Existence of Separating Finite-Dim Irreducibles |

### Statement (verbatim from blueprint)

For every $g_0 \neq 1_G$ in $G$, there exist $\phi \in C(G)$ symmetric,
  $\lambda \in \mathbb R \setminus \{0\}$, and a non-zero
  finite-dimensional closed subspace $W \leq L^2(G)$ such that:
  \begin{enumerate}
    \item $W = \ker(T_\phi - \lambda \cdot \mathrm{Id}) \neq 0$;
    \item $\dim W < \infty$;
    \item $\rho^R.\texttt{IsInvariant}\,W$;
    \item $\rho^R(g_0)|_W \neq \mathrm{Id}_W$.
  \end{enumerate}

### Dependencies (`\uses{...}`)

`thm:existsSepConv`, `thm:Tphi-compact`, `cor:Tphi-selfadj`, `thm:spectral-nonzero-eval`, `thm:eigenspace-invariant`, `def:rightReg`

### Definition of done

- [ ] No `sorry` in `PeterWeyl.exists_eigenspace_separating` (or any helper introduced for it).
- [ ] Add `\leanok` to `thm:eigenspace-separates` in `blueprint/src/content_comp.tex`.
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
