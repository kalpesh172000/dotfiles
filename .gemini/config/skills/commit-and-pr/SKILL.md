---
name: commit-and-pr
description: >-
  Automates the process of committing files (strictly one commit per file), pushing each commit immediately to remote origin, and generating a clean pull request description markdown file in the repository root. Use this skill whenever the user asks to commit changes, push commits, or prepare a PR description following repository standards.
---

# Commit & PR Description Workflow

This skill guides the automated process of committing changes strictly one file at a time, pushing each commit immediately to the remote origin, and writing a standardized pull request description in the repository root.

---

## 1. Commit Rules & Standards

### Golden Rules
1. **One commit per file (Strict Rule)**: Every modified or newly created file must have its own separate commit.
2. **Combine files only if identical & tiny**: Combine two files into one commit *only* when the changes in both files are virtually identical and extremely small (e.g., matching one-line type renames).
3. **Push after every commit**: Always push each commit to the remote `origin` immediately before creating the next commit.
4. **Automated script execution**: Due to the high number of files and commits, generate and run a script (e.g. Node.js or shell script) that cycles through:
   - Staging the file (`git add <file>`)
   - Committing with a compliant message (`git commit -m "..."`)
   - Pushing to the remote (`git push origin <branch>`)
   All commits and pushes should execute sequentially in one automated run without prompting for manual verification per commit.

---

## 2. Commit Message Structure

### Format
```text
type(package_name): commit message in present tense explaining the change logic

- Optional bullet point explaining additional logical details if needed
- Another bullet point if multiple aspects changed in this file
```

### Package Name Guidelines
- **Strip prefixes**: Strip monorepo scope prefixes such as `@lithioev/`, `@yugo/nestjs-`, `@yugo/`, or `@revo/`.
  - Example: `@yugo/nestjs-cqrs` $\rightarrow$ `cqrs`
  - Example: `@yugo/nestjs-database` $\rightarrow$ `database`
  - Example: `@yugo/shared` $\rightarrow$ `shared`
  - Example: `apps/api` $\rightarrow$ `api`
  - Example: `apps/henchmen` $\rightarrow$ `henchmen`
- **CI/CD files**: Use `cicd` for CI/CD and deployment files:
  - `.drone.yml`, `docker-compose.yml`, `Dockerfile`, `build-and-push.sh`, etc.
- **Root/Workspace files**: Use `workspace` for general repository files that do not belong to a specific package:
  - `.prettierrc`, `yarn.lock`, migrations (`migrations/*`), root `package.json`, root `docs/`, etc.

### Message Content Guidelines
- **Tense**: Simple English sentence in present tense (e.g., `feat(api): add...`, `fix(cqrs): prevent...`).
- **Outcome-focused**: Describe what happens after this commit is merged.
- **Depth**: Not overly simple — target approximately 20 words for the main sentence to explain the code change logic.
- **Sub-bullet points**: If a single sentence cannot cover all changes in the file, add bullet points below the main message to summarize each logical change.

### Commit Types
- `feat`: Newly added feature, endpoint, command, entity, constant, or type that operates independently.
- `fix`: Bug fix that corrects faulty logic or restores intended behavior.
- `refactor`: Changes to existing code logic that neither fix a bug nor introduce a brand-new feature.
- `perf`: Code refactoring done specifically to improve performance.
- `chore`: Auto-generated or operational changes (e.g., generated migration files, lockfile updates, dependency bumps).
- `docs`: Non-executing documentation or comment changes.
- `typo`: Correction of spelling errors in code, comments, or documentation.

---

## 3. Sequential Commit & Push Automation

When executing commits across multiple files:

1. **Verify changed files**: Inspect `git status --porcelain` to identify all modified and untracked files.
2. **Order logically**: Sort files by dependency order:
   - Shared enums, types, and constants (`packages/shared/*`)
   - Database entities and migrations (`packages/nestjs/database/*`, `migrations/*`)
   - CQRS queries, commands, and handlers (`packages/nestjs/cqrs/*`)
   - Application controllers, modules, and DTOs (`apps/api/*`, `apps/henchmen/*`)
   - Config, CI/CD, and workspace files (`docker-compose.yml`, etc.)
3. **Generate runner script**: Create a runner script in the scratch directory (e.g. `scratch/execute-commits.mjs`) containing the ordered file list and commit messages.
4. **Execute**: Run the script to stage, commit, and push each file one by one:
   ```javascript
   for (const item of commitPlan) {
     execSync(`git add "${item.file}"`, { stdio: 'inherit' });
     execSync(`git commit -m "${item.msg}"`, { stdio: 'inherit' });
     execSync(`git push origin ${currentBranch}`, { stdio: 'inherit' });
   }
   ```
5. **Verify**: Ensure `git status` reports a clean working tree after execution.

---

## 4. PR Description Guidelines

Immediately after pushing all commits:

1. **File Location**: Write the PR description to an `.md` file in the repository root (e.g. `pr-description.md`).
2. **Never commit the description file**: Add the file to `.git/info/exclude` or verify it is not staged or tracked.
3. **Structure**: The markdown file must strictly contain:

   ```markdown
   ### title
   type(package_name): concise PR summary title

   # description
   High-level explanation of what this PR does in accessible, less technical language.

   ## Changes
   - Bullet point describing logical change 1 in clear, simple English
   - Bullet point describing logical change 2
   - Bullet point describing logical change 3
   ```

4. **PR Title (`### title`)**:
   - Follows the commit format: `type(package_name): description`.
   - For `package_name`, select the application from `apps/` that is most affected by the PR (e.g., `api`, `backoffice`, `app`).
5. **PR Description (`# description`)**:
   - Describe the purpose and functionality of the PR in a clear, non-technical or semi-technical manner suitable for all stakeholders.
6. **Logical Changes (`## Changes`)**:
   - Create a bulleted list of logical changes based on the actual code diffs, not merely restating commit messages.
   - Ignore purely administrative changes (e.g., re-exporting in `index.ts`).
   - Do NOT include commit hashes or raw commit messages.
