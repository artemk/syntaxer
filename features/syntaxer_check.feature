@announce
Feature: Test options

  In order to check syntax
  A user who used gem
  Should be able run command

  @plain
  Scenario: Run version checking
    When I run 'syntaxer -v'
    Then the exit status should be 0
    And the output should be the same as in "VERSION" file

  @plain
  Scenario: Run syntaxer with warning option and ruby files
    Given a file named "correct.rb" with:
     """
     Method /^I love ruby$/ do
     end
     """
    When I run 'syntaxer -w'
    Then the output should contain "warning: ambiguous first argument;"

  @plain
  Scenario: Run syntaxer with warning option and non ruby files
    Given a file named "correct.php" with:
      """
      <%php echo 1; %>
      """
    When I run 'syntaxer -w'
    Then the output should contain "Syntax OK"
