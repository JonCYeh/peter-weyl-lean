**Type:** atomic — single Lean declaration, single sorry to discharge.

| Field | Value |
|---|---|
| Blueprint label | `def:RealImag` |
| Blueprint kind  | definition |
| Lean target     | `ContinuousLinearMap.realPart, ContinuousLinearMap.imagPart` |
| Source location | `_(declaration not found — verify Lean name)_` |
| Chapter         | Schur's Lemma for Continuous Unitary Irreducibles |

### Statement (verbatim from blueprint)

For $T : H \to_L H$ on a complex Hilbert space, define
  $\mathrm{Re}(T) := (T + T^*)/2$ and $\mathrm{Im}(T) := (T - T^*)/(2i)$,
  both self-adjoint, with $T = \mathrm{Re}(T) + i\,\mathrm{Im}(T)$.

### Dependencies (`\uses{...}`)

`def:UnitaryRep`

### Definition of done

- [ ] No `sorry` in `ContinuousLinearMap.realPart, ContinuousLinearMap.imagPart` (or any helper introduced for it).
- [ ] Add `\leanok` to `def:RealImag` in `blueprint/src/content_comp.tex`.
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
