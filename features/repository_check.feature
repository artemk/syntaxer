@announce
Feature: Check git repository before commit

  In order to check syntax
  A user print "git commit"
  Commit have to be rejected in case of wrong syntax

  @repo
  Scenario: Run "git commit"
    Given git repository
    And some file with wrong syntax
    When run `git commit -m "some message"` interactively
    Then the syntaxer should stop commit
