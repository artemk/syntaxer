@announce
Feature: Check syntax in plain mode

  In order to check syntax
  A user who used gem
  Should be able run command

  @plain
  Scenario: Run checker in directory
    Given directory contains two files
    When I run 'syntaxer'
    Then the exit status should not be 0
    And the output should not contain "Syntax OK"

  @plain @jslint
  Scenario: Run checker in directory with jslint and wrong rubies
    Given a file named "correct.rb" with:
      """
      class A;end
      """
    And a file named "wrong.rb" with:
      """
      class B
      """
    And a file named "javascripts/correct.js" with:
      """
      var func = function(){};
      """
    And a file named "javascripts/wrong.js" with:
      """
      var func = function(){
      """
    When I run 'syntaxer --jslint ./' and jslint should be invoked
#    Then the exit status should be 1
#    And the output should contain "jslint checking failed"
#    And the output should contain "Errors:"

#  @plain @jslint
#  Scenario: Run checker in directory with jslint whitout rubies
#    And a file named "javascripts/correct.js" with:
#      """
#      var func = function(){};
#      """
#    And a file named "javascripts/wrong.js" with:
#      """
#      var func = function(){
#      """
#    When I run 'syntaxer --jslint ./'
#    Then the exit status should be 1
#    And the output should contain "jslint checking failed"
#    And the output should contain "Errors:"

