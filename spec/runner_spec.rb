require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Syntaxer::Runner" do
  subject{Syntaxer::Runner}
  
  context "default runner" do
    
    it "should return Syntaxer::Runner" do
      subject.default("ruby -c %filename%").should be_instance_of(Syntaxer::Runner)
    end

    it "should have run method" do
      subject.default("ruby -c %filename%").should respond_to(:run)
    end

    it "should invoke Open3#popen3" do
      Open3.should_receive(:popen3)
      subject.default("ruby -c %filename%").run('')
    end

  end

  context "javascript runner" do
    subject{Syntaxer::Runner.javascript}

    it "should return Proc" do
      subject.should be_instance_of(Proc)
    end

    it "Proc should return Syntaxer::Runner class instance" do
      subject.call.should be_instance_of(Syntaxer::Runner)
    end

    it "should invoke run of JSLint::Lint instance" do
      ins = double()
      ins.should_receive(:run)
      JSLint::Lint.should_receive(:new).and_return(ins)
      subject.call.run('', [])
    end
  end

end
