Given /^directory contains two files$/ do
  create_temp_plain_work_dir
end

When /^I cd to working directory$/ do
  cd(@tmp_dir)
end

Then /^the output should be the same as in "(.*)" file$/ do |f|
  content = IO.readlines(File.join(SYNTAXER_ROOT_PATH, f),'').first.to_s
  Then %{the output should contain "#{content}"}  
end
