Given /^directory contains two files$/ do
  create_temp_plain_work_dir
end

When /^I cd to working directory$/ do
  cd(@tmp_dir)
end

