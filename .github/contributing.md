## Getting Started
- Make sure you have a [Github Account](https://github.com)
- Submit an issue for your problem, assuming one doesn't already exist
  - Clearly describe the issue including steps to reproduce when it's a bug.
  - Make sure to include the earliest version that you know has the issue
  (Because there haven't been and major/minor/patch releases, include the commit
  id for now)
  - Follow the checklist below!
- Create a fork of the repository on Github

### Submitting an issue
Things to check before submitting the issue:
- [ ] Cocoapods is installed and up-to-date on your machine
- [ ] All of the Pods needed for the project are installed
- [ ] Xcode is up-to-date

Things that should be included in your issue:
- [ ] The thing is broken
- [ ] The affected file(s)
- [ ] The crash log if one is generated
  - It should be included like this
  ```
  Crash log
  goes here
  ```
  - If you insist on including the *entire* log, please dump it into a log file
  and attach it to the issue instead
- [ ] Expected behavior
- [ ] Actual behavior
- [ ] Steps to reproduce

Things that should be included but are totally optional:
- [ ] Screenshots
- [ ] Code snippet
- [ ] Add a label to the issue!

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
  the [pull_request.md](https://github.com/samantharachelb/todolist/blob/master/.github/pull_request.md) file

## Additional resources
- [Style Guide]()
- [General GitHub documentation](https://help.github.com/)
- [GitHub pull request documentation](https://help.github.com/articles/creating-a-pull-request/)
