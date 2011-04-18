@announce
Feature: Test options

  In order to check syntax
  A user who used gem
  Should be able run command

  @plain
  Scenario: Run version checking
    When I run `syntaxer -v` interactively
    Then the exit status should not be 0
    And the output should be the same as in "VERSION" file
