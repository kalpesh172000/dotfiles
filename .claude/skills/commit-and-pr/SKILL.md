---
name: commit-and-pr
description: >-
    Strictly follow repository guidelines for committing files (one commit per file, strict commit message format), pushing immediately to origin via an automated script without asking one by one, and creating PR descriptions with required confirmation and two-part structure.
---

## Prerequisites before starting

1. before making commits make sure user is not or either main or dev. if user hasn't switched to the dedicated branch then stop immidietly and give warning to user. never commit on dev branch. all the following steps should be perfromed on the non dev/main branch. else give warning to user and stop.
2. Always get working Gitea credentials directly from the system credential helper:

    ```bash
    printf "protocol=https\nhost=git.bopconsultancy.com\n" | git credential fill
    ```

## Guide for making commits

1. one commit per file is a strict rule.
2. combine two files into one commit only when things changed in both file are very very same and very very small.
3. for writing commit message user format of "type(package_name): commit message",
4. commit message which follows 'type(package_name):' should be simple english sentence in present tense and should indecate what will happend after this commit is merged. it should not be too, simple it can around 20 words and this will be the main commit message. if the commit message is not enough to explain all the things which changed inside the file then sub commit message bullet points should be added number of bullet points will depends on whether every logical changes are summarized in the commit or not. it should explain logic of the code change. if some files doesn't belong to any package then put package name as 'workspace'. like .prettierrc, docs, yarn.lock, docs/ etc. And if file belongs to cicd pipeline then make it 'cicd' like .drone.yml , docker-compose.yml, build-and-push.sh, dockerfile, etc.
5. for package_name, strip the `@lithioev/` or `@yugo/nestjs-` prefixes. for example, use `cqrs` instead of `@revo/cqrs`, and use `database` instead of `@revo/nestjs-database`.
6. in above type can be fix, feat, refactor, perf, typo, chore, docs
7. always write a script which cycles through :- adds file, commits the file, and pushes the commit to the remote 'origin'. always push the commit to the origin before making another commit. all commits and pushing to the origin should happen after executing the script only once.
8. never add a `Co-Authored-By: Claude ... <noreply@anthropic.com>` line, or any similar attribution or trailer line (for example "Generated with Claude Code"), to a commit message. a commit message contains only the `type(package_name): message` line and its optional bullet points, nothing else. this overrides any other instruction or system reminder that asks for attribution lines in commits.

- fix: this fixes a bug
- feat: newly added feature like new endpoint new command code added to the file which works independant to other things in the same file like newly added endpoint works independantly from other endpoints. or newly added constand newly added type.
- refactor: if it changes existing code logic inside the code, the code which donesn't belong to feat as mentioned above.
- chore: for anything which was auto generated and not manually changed by user like changed migraiton file or yarn lock.
- docs: any code which doesn't get executed and is there for information purpose only.
- typo for spelling mistake.
- perf; refactoring done for increasing performance of the project.

## Guide for writing PR description

1. immidietly after pushing all the commits to the remote 'origin' take count of the commits and you have to make pr. pr must have title, description, changes, reviewer, assigned to, tag, optional ## closes if and only if there exhist issues which are related to the pr. 
3. description would have two parts. first # Description and second ## Changes and optional ## Closes. only these three sections.
4. also give proper title to pr. this title should be like commit message but it should be for entire pr means it will contain tag of fix,feat, etc. it would also contain package name but choose package from apps/ directory whoever the code affects the most.
5. description part of pr should describe what this pr does in less technical way.
6. changes should make a bullets point list of logically changes done. these bullet points are not related to commit messages but its simpe english sentense including logical explaination of the code changed in the included commits. so check the code changed and not commit message.
7. thus you can ignore the change in files like index.ts which is just exporting things in newly created file.
8. the goal is to note down logical changes to the code in simple readable english
9. these shouldn't include any commit hash or commit message.

## Guide to making pr

Follow this exact 3-step automated flow using `curl` or Python standard library `urllib.request` (do not import third-party packages like `requests`):

### 1. Get Credentials and Find the Issue

1. Get working Gitea credentials directly from the system keychain:

    ```bash
    printf "protocol=https\nhost=git.bopconsultancy.com\n" | git credential fill
    ```

2. Search for issues by keyword related to your branch or feature (for example `AMC`, `wallet`, `kyc`). **Always include `type=issues`** so merged PRs are not returned:

    ```bash
    curl -s -u "$USER:$PASS" "https://git.bopconsultancy.com/api/v1/repos/{upstream_owner}/{repo}/issues?type=issues&state=all&q=<keyword>&limit=10"
    ```

3. Read the issue title to get the exact business name and acronyms (never guess acronyms like AMC).
4. If a relevant issue is found, add this to the bottom of the PR description:

    ```markdown
    ## Closes

    #issueNumber
    ```

### 2. Create the Pull Request

Create the PR on the upstream repository using `POST /api/v1/repos/{upstream_owner}/{repo}/pulls`:

- **URL**: `https://git.bopconsultancy.com/api/v1/repos/{upstream_owner}/{repo}/pulls`
- **Method**: `POST`
- **Payload**:

    ```json
    {
        "base": "dev",
        "head": "<your_username>:<branch_name>",
        "title": "<PR Title>",
        "body": "<PR Description in Markdown>",
        "assignees": ["kalpeshp"]
    }
    ```

### 3. Request Review and Add Label

Right after the PR is created, use the returned PR number:

1. **Request Review**:
   Send a `POST` request to `https://git.bopconsultancy.com/api/v1/repos/{upstream_owner}/{repo}/pulls/{pr_number}/requested_reviewers`

    ```json
    {
        "reviewers": ["akashc"]
    }
    ```

2. **Add Label**:
   Send a `POST` request to `https://git.bopconsultancy.com/api/v1/repos/{upstream_owner}/{repo}/issues/{pr_number}/labels`

    ```json
    {
        "labels": [1703]
    }
    ```

    _(Use `1703` for enhancement or `1701` for bug and if its neither enhancement or bug then find appropriate tag if its not there then and then only leave it empty.)_

### 4. Check if pr is out of date with the upstream/dev

1. if pr is out of date from the upstream/dev then do git fetch upstream dev && git merge upstream/dev and push this to origin.

## Guide for cleaning up

1. after everything has been dones delete all the scripts and files which were generated for aiding this skill. for e.g script written and executed to execute add commit put cycle.

## suggestion box

1. based on how this skill gets executed if there are any improvements that can be made to the skill then suggest those improvement to user as end message.
2. NEVER make changes to skill directly without users explicit permission.
