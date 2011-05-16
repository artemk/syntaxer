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

Given /^rails project with js scripts$/ do
  in_current_dir do
    FileUtils.mkdir_p("public/scripts")
  end
  Given "rails project"
end


Given /^some lib with wrong syntax$/ do
  write_file('lib/wrong.rb', "mod A;end")
  write_file('app/wrong.rb', "mod A;end")
  run_simple(unescape("git add ."), false)
end

Given /^some js script$/ do
  write_file('public/javascripts/main.js', "var func = function(){")
  run_simple(unescape("git add ."), false)
end

Given /^installed hook in rails context$/ do
  run_simple("#{File.join(File.dirname(__FILE__),'..','..','bin','syntaxer')} -g -r --hook --rails")
  file = create_config_file('config', Syntaxer::Wizzard::FOLDERS_RAILS.to_a)
  run_simple('chmod 755 .git/hooks/pre-commit')
end

Given /^installed hook in rails context with jslint$/ do
  Given "installed hook in rails context"
  run_simple('chmod 755 .git/hooks/pre-commit')
end

Then /^the syntaxer shoud stop commit$/ do
  @last_exit_status.should eql(1)
end

