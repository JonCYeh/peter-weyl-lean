**Type:** atomic — single Lean declaration, single sorry to discharge.

| Field | Value |
|---|---|
| Blueprint label | `thm:PW-HilbertSum` |
| Blueprint kind  | theorem |
| Lean target     | `PeterWeyl.isHilbertSum_isotypicComponents` |
| Source location | `PeterWeylComp/Isotypic.lean:294` |
| Chapter         | Isotypic Decomposition of $L^2(G)$ and Plancherel |

### Statement (verbatim from blueprint)

The family $\{L^2(G)_\xi\}_{\xi \in \widehat G}$ is an
  \texttt{IsHilbertSum} structure on $L^2(G)$:
  \begin{itemize}
    \item it is an orthogonal family (Theorem~\ref{thm:isotypic-orthog});
    \item the closure of the linear span of all components is $\top$
      (Theorem~\ref{thm:isotypic-spans}).
  \end{itemize}

### Dependencies (`\uses{...}`)

`thm:isotypic-orthog`, `thm:isotypic-spans`, `def:isotypic`

### Definition of done

- [ ] No `sorry` in `PeterWeyl.isHilbertSum_isotypicComponents` (or any helper introduced for it).
- [ ] Add `\leanok` to `thm:PW-HilbertSum` in `blueprint/src/content_comp.tex`.
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
