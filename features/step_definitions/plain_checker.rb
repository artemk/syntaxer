Given /^I'am using a clean gemset test$/ do
  Aruba::Api::DEFAULT_TIMEOUT_SECONDS = 20
  use_clean_gemset("test") 
end

Given /^directory contains two files$/ do
  create_temp_plain_work_dir
end

Then /^I run 'syntaxer([^']*)'$/ do |arg|
  run_simple(unescape("#{File.join(File.dirname(__FILE__),'..','..','bin','syntaxer')} #{arg}"), false)
end

When /^I run 'syntaxer \-\-jslint \.\/' and jslint should be invoked$/ do
  options = Syntaxer::Runner::Options.new
  options.restore = false
  # options.languages = :all
  options.jslint = './'
  options.config_file = Syntaxer::SYNTAXER_RULES_FILE
  options.root_path = '.'

  Syntaxer::Printer.stub(:print_result)

  reader = double
  reader.stub(:add_rule)
  Syntaxer::Reader::DSLReader.stub(:load){reader}

  checker = double
  checker.stub(:error_files){[]}
  Syntaxer::Runner.should_receive(:javascript).and_return(Proc.new{})
  Syntaxer::Checker.stub(:process){checker}
  
  Syntaxer::Runner.check_syntax(options)
end

When /^I cd to working directory$/ do
  cd(@tmp_dir)
end

Then /^the output should be the same as in "(.*)" file$/ do |f|
  content = Syntaxer::VERSION
  Then %{the output should contain exactly "#{content}\n"}
end
