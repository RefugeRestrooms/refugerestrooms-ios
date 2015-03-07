Refuge Restrooms for iOS - Contributors Guide
============================================

#### Getting Started

* If there isn't an Issue filed for what you're working on, first [create a new Issue](https://github.com/RefugeRestrooms/refuge-ios/issues/new)
* Fork the repository
* Create a branch specific to the work you're going to do [See: #branch-naming-conventions](#branch-naming-conventions)
* When finished with changes, create a Pull Request against the `development` branch of the `refuge-ios` repository

#### What to Work On

Check out the [list of open issues](https://github.com/RefugeRestrooms/refuge-ios/issues) for ideas of what to work on. The most pressing issues can be found in the [most current milestone](https://github.com/RefugeRestrooms/refuge-ios/milestones) that does not end in `x`. i.e. If there is a milestone named `Launch v1.1.1` and a milestone named `Launch v1.1.x`, the issues in `Launch v1.1.1` are more pressing.

If you are working on something that is not listed, first [make a new Issue](https://github.com/RefugeRestrooms/refuge-ios/issues/new) so your effort can be tracked.

#### Branch naming conventions

Make a new branch for each individual thing you are addressing. If you are working on an Issue with multiple bug fixes, there should be a new branch for each bug fix.

You should either name the branch after the issue number (e.g. `issue111`) or descriptively. If opting to name your branch descriptively, prefix it with the type of issue it is addressing, from the following list:

* `bugfix` - This branch is addressing a bug
* `design` - This branch is introducing new design work (if fixing previous design work, use `bugfix`)
* `feature` - This branch is creating a new feature
* `pod` - This branch is being used to udpdate Pods or Frameworks
* `refactor` - This branch is used solely to refactor exisiting work

For example, if I wanted to work on addressing a bug - say I'm updating an expired API key - then I might name that branch `bugfix/update_expired_api_key`

Once done fixing that specific issue, make a pull request for that branch. If going on to work on another issue, do not work off of that branch, but rather branch off of the version of `refuge-ios` you originally forked.

#### Commit message conventions

Try and make your commit messages descritive. Two- to three-word commit messages are usually not descriptive enough.

If your commit is addressing a specific Issue, you can reference that issue in your commit message and a link to that commit will automatically be placed in the Issue. This is good for tracking purposes. You can see an example of this here: https://github.com/RefugeRestrooms/refuge-ios/issues/111
