Given /^git repository$/ do
  create_temp_repo_work_dir
end

Given /^some file with wrong syntax$/ do
  in_current_dir do
    add_fixtures_files
  end
end

When /^run `git commit \-m \"some message\"` interactively$/ do 
  add_hook
end

Then /^the syntaxer should stop commit$/ do
  lambda{make_git_commit}.should raise_exception
end
