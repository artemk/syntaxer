require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Syntaxer::Runner" do
  subject{Syntaxer::Runner}

  context "#check_syntax" do

    before(:each) do
      @opt = subject::Options.new
      @opt.config_file = syntaxer_rules_example_file
      Syntaxer::Printer.setup(@opt)

      checker = double
      checker.stub(:error_files){[]}
      Syntaxer::Checker.stub(:process){checker}
    end

    it "should invoke Checker#process" do
      Syntaxer::Reader::DSLReader.should_receive(:load)
      Syntaxer::Checker.should_receive(:process)
      Syntaxer::Printer.should_receive(:print_result)
      subject.check_syntax(@opt)
    end

  end

end
