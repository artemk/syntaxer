@announce
Feature: Check git repository before commit
  
  @repo @rails
  Scenario: Installation hook in rails environment
    Given rails project
    And some lib with wrong syntax
    And installed hook in rails context
    When I run `git commit -m "some message"`
    Then the syntaxer shoud stop commit
    And the output should contain "Errors:"

  @repo @rails @jslint
  Scenario: Installation hook in rails environment with jslint feature
    Given rails project with js scripts
    And some lib with wrong syntax
    And some js script
    And installed hook in rails context with jslint
    When I run `git commit -m "some message"`
    Then the syntaxer shoud stop commit
    And the output should contain "Running JSLint:"
    And the output should contain "jslint checking failed"
    And the output should contain "Errors:"
    And the output should contain "EE"
