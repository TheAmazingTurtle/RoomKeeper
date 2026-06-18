# AGENTS.md

## Project Overview

RoomKeeper is an Android-first Flutter app for locally tracking a boarding room:
inventory, food stock, payments, reminders, tasks, backups, and a simple room
layout. It is local-first with no backend or account system.

## Key Paths

- `lib/main.dart` starts the app with a Riverpod `ProviderScope`.
- `lib/src/app.dart` defines the Material app and routing.
- `lib/src/data/database.dart` contains Drift table definitions.
- `lib/src/data/database.g.dart` is generated Drift code; regenerate it after
  changing `database.dart`.
- `lib/src/data/roomkeeper_repository.dart` owns persistence workflows.
- `lib/src/services/` contains backup, image storage, notification, and reminder
  services.
- `test/` contains repository, service, and widget tests.

## Setup

```sh
flutter pub get
```

After changing Drift schema or queries:

```sh
dart run build_runner build
```

If generated files conflict during active development, use:

```sh
dart run build_runner build --delete-conflicting-outputs
```

## Run

Run on a connected Android device or emulator:

```sh
flutter run
```

Build a debug APK:

```sh
flutter build apk --debug
```

The debug APK is written to `build/app/outputs/flutter-apk/app-debug.apk`.

## Test, Lint, and Verify

Static analysis:

```sh
flutter analyze
```

Tests:

```sh
flutter test -r expanded --concurrency=1
```

Keep the test run serial on Windows; SQLite native asset preparation can race
when tests run concurrently.

Before handing off changes, run:

```sh
flutter analyze
flutter test -r expanded --concurrency=1
```

For UI/navigation changes, also smoke-test with `flutter run` on Android or an
emulator. For database changes, regenerate Drift code and include the generated
`database.g.dart` changes.

## Codex Operating Workflow

When Codex works in this repository:

1. Inspect the worktree first with `git status --short` and avoid overwriting
   unrelated user changes.
2. Read the relevant files before editing; prefer existing patterns over new
   abstractions.
3. For issue work, create or switch to a dedicated branch before making code
   changes.
4. Keep changes focused on the requested issue or task.
5. When the user asks Codex to commit changes, commit incrementally as coherent
   units of work instead of packaging all changes into one large commit.
6. Add or update tests when behavior changes, especially repository, backup,
   reminder, or widget behavior.
7. Run the verification commands before handoff whenever possible:

```sh
flutter analyze
flutter test -r expanded --concurrency=1
```

8. If verification cannot be run, note why in the handoff.
9. Summarize changed files, tests run, and any follow-up risks.

Do not commit, push, open a PR, or merge unless the user explicitly asks for
that action.

## GitHub Issue Creation Workflow

When adding a GitHub issue:

1. Confirm the user wants a GitHub issue created, not just a local task note.
2. Write a concise issue title that names the user-visible problem or outcome.
3. Include a practical body with:
   - Problem or goal
   - Expected behavior
   - Relevant context, files, screenshots, or logs
   - Acceptance criteria or verification steps
4. Add the appropriate GitHub labels/tags for the issue type and area, following
   repo conventions when they are clear; otherwise use a sensible label such as
   `bug`, `enhancement`, `documentation`, or `test`.
5. Add assignees, milestone, or project fields only when the user asks or the
   repo convention is clear.
6. Create the issue with the GitHub app or `gh issue create` when available.
7. Report the issue number and URL back to the user.

Do not create branches, commits, or PRs from a new issue unless the user also
asks Codex to start implementation.

## GitHub Issue Workflow

When handling a GitHub issue:

1. Start from an up-to-date `main` branch.
2. Create a focused branch named with the issue number when available, such as
   `fix/123-reminder-crash` or `feature/123-backup-import`.
3. Check that the issue has appropriate labels/tags, adding them when missing
   and the correct repo convention is clear.
4. Implement the issue on that branch with focused, incremental commits as work
   is completed.
5. Run verification before pushing:

```sh
flutter analyze
flutter test -r expanded --concurrency=1
```

6. Push the branch and open a pull request targeting `main`.
7. Link the PR to the issue in the PR description with `Closes #123`,
   `Fixes #123`, or `Resolves #123`.
8. Wait for checks and review, address feedback, then merge the PR into `main`.
9. After merge, update local `main` and delete the completed feature branch.

Prefer linking the issue to the pull request, because GitHub will close the
issue automatically when the PR merges.

## Coding Notes

- Follow the existing Material 3, Riverpod, GoRouter, Drift, and repository
  patterns.
- Keep app data local; do not introduce network, account, or sync behavior
  unless explicitly requested.
- Store money as integer cents, matching the current payment model.
- Preserve Asia/Manila timezone assumptions for reminders.
- Use provider overrides and in-memory databases in tests, following the current
  test helpers.
- Keep `build/`, `.dart_tool/`, and other generated cache directories out of
  source control.
