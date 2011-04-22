Given /^rails project$/ do
  in_current_dir do
    FileUtils.mkdir("config")
    FileUtils.mkdir("app")
  end
  write_file('app/correct.rb','class C;end;')
  run_simple(unescape("git init"), false)
  run_simple(unescape("git add ."), false)
  run_simple(unescape("git commit -m'first commit'"), false)
end

Given /^some lib with wrong syntax$/ do
  write_file('lib/wrong.rb', "mod A;end")
  write_file('app/wrong.rb', "mod A;end")
  run_simple(unescape("git add ."), false)
end

Given /^installed hook in rails context$/ do
  run_simple('syntaxer -i -r git --hook --rails')
  in_current_dir do
    FileUtils.cp(File.join(File.dirname(__FILE__),'..','..',"syntaxer_rails_rules.dist.rb"),"config/syntaxer.rb")
  end
  run_simple('chmod 755 .git/hooks/pre-commit')
end

Then /^the syntaxer shoud stop commit$/ do
  @last_exit_status.should eql(1)
end

