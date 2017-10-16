## Getting Started
- Make sure you have a [Github Account](https://github.com)
- Submit an issue for your problem, assuming one doesn't already exist
  - Clearly describe the issue including steps to reproduce when it's a bug.
  - Make sure to include the earliest version that you know has the issue
  (Because there haven't been and major/minor/patch releases, include the commit
  id for now)
  - Be sure to follow the guidelines set out in the [issue_template.md]() file
- Create a fork of the repository on Github

## Making changes
- Create a topic branch from where you want to base your work
  - This is usually the master branch
  - Only target release branches if you are absolutely certain your fix needs to be on that branch
  - To quickly create a topic branch based on master, run
  `git checkout -b fix/master/my_contribution`. Please avoid working directly on
  the master branch
- Check for unnecessary white space with `git diff --check` before committing
- Make sure your commit messages are in the proper format. Start the first line of the commit with the ClickUp task ID. This can be found in the issue that was created.

```
[#1234] <Your Commit message>

List changes:
1.
2.
3.

Explain the changes:
```
- Make sure that you've tested the code *at least once* to make sure nothing else was accidentally broken
- Keysign your commits please!

## Submitting Changes:
- Push your changes to a topic branch in *your* fork of the repository
- Submit a pull request to the repository.
  - When submitting a pull request be sure to follow the guidelines set out in
  the [pull_request.md]() file

## Additional resources
- [Style Guide]()
- [General GitHub documentation](https://help.github.com/)
- [GitHub pull request documentation](https://help.github.com/articles/creating-a-pull-request/)
