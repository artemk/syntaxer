@announce
Feature: Check output of script

  In order to check outut of script
  A user who used gem
  Should to see errors in files

  @plain @output
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
correct.rb OK
      """

  @plain @output
  Scenario: Run checker with non existent exec rules
    Given: I'am using a clean gemset "test"
    And a file named "correct.haml" with:
      """
      %p
        hello
      """
    And a file named "correct.rb" with:
      """
      class A; end
      """
    Then I run `syntaxer`
    And the output should contain:
      """
      exec_rule `haml` for language haml not exists. Skip
      """

  @repo @output
  Scenario: Run checker with non existent exec rules in git repo
    Given: I'am using a clean gemset "test"
    And a file named "readme" with:
      """
      """
    And I init empty repository
    And I make first commit
    And I run `syntaxer -i -r git`
    Given a file named "correct.haml" with:
      """
      %p
        hello
      """
    And a file named "correct.rb" with:
      """
      class A; end
      """
    And a directory named "subdir"
    And a file named "subdir/wrong.rb" with:
      """
      c A; end
      """
    Then I run `git add .`
    Then I run `git commit -m "second commit"`
    And the output should contain:
      """
      exec_rule `haml` for language haml not exists. Skip
      """
