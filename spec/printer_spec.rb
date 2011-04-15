require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Syntaxer" do
  context "::Printer" do
    
    before(:each) do
    end

    subject{Syntaxer::Printer}

    it "should be quite if passed --quite option" do
      IO.should_not_receive(:print)
      IO.should_not_receive(:puts)

      subject.quite = true
      subject.print_progress true
      subject.print_result ['a','b']
    end
  end
end
