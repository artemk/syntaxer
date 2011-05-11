require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Syntaxer::Runner::CommandLine do
  subject{Syntaxer::Runner::CommandLine}
  
  context "run check syntax" do

    it "should run check syntax with no options" do
      subject.instance_variable_set(:@argv, [])
      Syntaxer::Runner.should_receive(:check_syntax)
      subject.run()
    end

  end

  context "wizzard" do

    it "should run" do
      subject.instance_variable_set(:@argv, ['--install'])
      Syntaxer::Runner.should_receive(:wizzard)
      subject.run()
    end

  end

  context "hook" do

    it "should run" do
      subject.instance_variable_set(:@argv, ['-g'])
      Syntaxer::Runner.should_receive(:make_hook)
      subject.run()
    end

  end
  

end
