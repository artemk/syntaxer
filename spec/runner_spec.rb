require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Syntaxer::Runner" do
  subject{Syntaxer::Runner}

  context "#check_syntax" do

    before(:each) do
      @opt = subject::Options.new
      @opt.config_file = syntaxer_rules_example_file
    end

    it "should invoke Checker#process" do
      Syntaxer::Reader::DSLReader.stub(:load)
      Syntaxer::Checker.should_receive(:process)
      subject.check_syntax(@opt)
    end

  end

end
