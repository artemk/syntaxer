Given /^I'am using a clean gemset test$/ do
  Aruba::Api::DEFAULT_TIMEOUT_SECONDS = 20
  use_clean_gemset("test") 
end

Given /^directory contains two files$/ do
  create_temp_plain_work_dir
end

Then /^I run 'syntaxer([^']*)'/ do |arg|
  run_simple(unescape("#{File.join(File.dirname(__FILE__),'..','..','bin','syntaxer')} #{arg}"), false)
end

When /^I cd to working directory$/ do
  cd(@tmp_dir)
end

Then /^the output should be the same as in "(.*)" file$/ do |f|
  content = IO.readlines(File.join(PlainHelpers::SYNTAXER_ROOT_PATH, f),'').first.to_s
  Then %{the output should contain exactly "#{content}\n"}
end
