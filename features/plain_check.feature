@announce
Feature: Check syntax in plain mode

  In order to check syntax
  A user who used gem
  Should be abble run command

  @plain
  Scenario: Run checker in directory
    Given directory containt two files
    When I run `syntaxer` interactively
    Then the exit status should not be 0
    And the output should not contain "Syntax OK"

