@announce
Feature: Check output of script

  In order to check outut of script
  A user who used gem
  Should to see errors in files

  @plain
  Scenario: Run checker with verbose mode
    Given a file named "wrong.rb" with:
      """
      class A
      """
    And a file named "correct.rb" with:
      """
      class B; end;
      """
    Then I run `syntaxer -l`
    And the output should contain:
      """
/home/ignar/Development/syntaxer/tmp/aruba/correct.rb OK
      """
