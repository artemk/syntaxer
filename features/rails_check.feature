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
    And the output should contain "EE"
