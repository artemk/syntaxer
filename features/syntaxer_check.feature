@announce
Feature: Test options

  In order to check syntax
  A user who used gem
  Should be able run command

  @plain
  Scenario: Run version checking
    When I run `syntaxer -v`
    Then the exit status should be 0
    Then the output should be the same as in "VERSION" file

