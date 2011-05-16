require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Syntaxer" do
  context "::Printer" do
    
    before(:each) do
      @options = Syntaxer::Runner::Options.new
    end

    subject{Syntaxer::Printer}

    it "should be quite if passed --quite option" do
      @options.quite = true
      Syntaxer::Printer.setup(@options)
      
      ::ProgressBar.new.should_not_receive(:update)
      subject.update({})
      subject.print_result ['a','b']
    end
    
  end
end
