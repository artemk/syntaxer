require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Syntaxer::UI do

  subject{Syntaxer::UI}

  context "print" do

    before(:each) do
      @stdout = double
      @stdout.stub(:print)
      subject.setup(Syntaxer::Runner::Options.new, @stdout)
    end

    it "shoud put after new line" do
      @stdout.should_receive(:print).with("test\n")
      subject.info("test")
    end

    it "should print in red color" do
      @stdout.should_receive(:print).with("\e[31mtest\n\e[0m")
      subject.info("test", {:color => :red})
    end

  end

end
