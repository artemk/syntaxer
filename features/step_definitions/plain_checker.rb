Given /^I'am using a clean gemset test$/ do
  Aruba::Api::DEFAULT_TIMEOUT_SECONDS = 20
  use_clean_gemset("test") 
end

Given /^directory contains two files$/ do
  create_temp_plain_work_dir
end

When /^I run 'syntaxer'$/ do
  run_simple(unescape("#{File.join(File.dirname(__FILE__),'..','..','bin','syntaxer')}"), false)
end

Then /^I run 'syntaxer \-l'$/ do
  run_simple(unescape("#{File.join(File.dirname(__FILE__),'..','..','bin','syntaxer')} -l"), false)
end

Then /^I run 'syntaxer \-W'$/ do
  run_simple(unescape("#{File.join(File.dirname(__FILE__),'..','..','bin','syntaxer')} -W"), false)
end

Then /^I run 'syntaxer \-v'$/ do
  run_simple(unescape("#{File.join(File.dirname(__FILE__),'..','..','bin','syntaxer')} -v"), false)
end

When /^I cd to working directory$/ do
  cd(@tmp_dir)
end

Then /^the output should be the same as in "(.*)" file$/ do |f|
  content = IO.readlines(File.join(PlainHelpers::SYNTAXER_ROOT_PATH, f),'').first.to_s
  Then %{the output should contain exactly "#{content}\n"}
end
