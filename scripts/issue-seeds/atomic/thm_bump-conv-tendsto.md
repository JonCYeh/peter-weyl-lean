**Type:** atomic — single Lean declaration, single sorry to discharge.

| Field | Value |
|---|---|
| Blueprint label | `thm:bump-conv-tendsto` |
| Blueprint kind  | theorem |
| Lean target     | `PeterWeyl.convOp_bump_tendsto_id` |
| Source location | `PeterWeylComp/ApproxIdentity.lean:105` |
| Chapter         | Approximate Identities |

### Statement (verbatim from blueprint)

Let $\{U_n\}$ be a countable neighbourhood basis at $1_G$ shrinking to
  $\{1_G\}$, and $\phi_n$ a bump on $U_n$ for each $n$. Then for every
  $f \in L^2(G)$, $T_{\phi_n} f \to f$ in $L^2$ as $n \to \infty$.

### Dependencies (`\uses{...}`)

`def:bump`, `def:Tphi`, `thm:leftTrans-strongCts`

### Definition of done

- [ ] No `sorry` in `PeterWeyl.convOp_bump_tendsto_id` (or any helper introduced for it).
- [ ] Add `\leanok` to `thm:bump-conv-tendsto` in `blueprint/src/content_comp.tex`.
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
