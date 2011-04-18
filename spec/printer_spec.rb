require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Syntaxer" do
  context "::Printer" do
    
    before(:each) do
    end

    subject{Syntaxer::Printer}

    it "should be quite if passed --quite option" do
      ProgressBar.new.should_not_receive(:update)
      subject.quite = true
      subject.update true
      subject.print_result ['a','b']
    end
  end
end
