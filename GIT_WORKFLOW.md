# Git Development Workflow

This repository uses a simple branch workflow.

## Branches

- `main`: stable submitted version.
- `develop`: integrated development version.
- `feature/*`: one feature or module per branch.

## Normal Development

Start new work from `develop`:

```powershell
git switch develop
git switch -c feature/packet-detect
```

After finishing one module:

```powershell
git status --short
git add <files>
git commit -m "feat: implement packet detection"
```

Merge back to `develop` after MATLAB verification:

```powershell
git switch develop
git merge --no-ff feature/packet-detect
```

When all experiment requirements are complete:

```powershell
git switch main
git merge --no-ff develop
```

## Commit Message Style

- `feat:` add a module or experiment function
- `fix:` correct a bug
- `test:` add or update verification scripts
- `docs:` update documentation
- `chore:` maintenance changes

## Development Order

1. `feature/packet-detect`
2. `feature/frequency-sync`
3. `feature/fine-time-sync`
4. `feature/channel-estimation`
5. `feature/channel-equalization`
6. `feature/phase-compensation`
7. `feature/module-sims`
8. `feature/integration-sims`
9. `feature/complete-ofdm`

Each feature branch should keep changes focused on one experiment module or one simulation stage.

