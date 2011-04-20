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

Given /^I init empty repository$/ do
  run_simple(unescape("git init"), false)
end

Given /^I make first commit$/ do
  run_simple(unescape("git add ."), false)
  run_simple(unescape("git commit -m 'first commit'"), false)
end
