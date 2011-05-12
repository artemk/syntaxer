require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Syntaxer::Runner::Options" do
  subject{Syntaxer::Runner::Options}

  context "flag options" do

    before(:each) do
      subject.class_eval do
        flag_opt :test
        flag_opt :test_def, true
      end
      @opt = subject.new
    end

    it "should respond to {flag_name}? method" do
      @opt.test = false
      @opt.should respond_to(:test?)
    end

    it "{flag_name}? method should return correct value" do
      @opt.test = true
      @opt.test?.should be_true
    end

    it "should initialize options with default value" do
      @opt.test_def?.should be_true
    end

    it "shoud raise error if pass wrong param" do
      expect{@opt.test_def = 'asdf'}.to raise_error(ArgumentError)
    end

  end

  context "data options" do

    before(:each) do
      subject.class_eval do
        data_opt :test do |v|
          v.kind_of?(Numeric)
        end
      end
      @opt = subject.new
    end

    it "should respond to option" do
      @opt.should respond_to(:test)
    end

    it "should set default value" do
      subject.class_eval do
        data_opt :test_m, 8 do |v|
          v.kind_of?(Numeric)
        end
      end
      @opt = subject.new
      @opt.test_m.should eql(8)
    end

    it "should set default value if no block given" do
      subject.class_eval do
        data_opt :test_m, 8
      end
      @opt = subject.new
      @opt.test_m.should eql(8)
    end

    it "should return correct value" do
      @opt.test = 3
      @opt.test.should eql(3)
    end

    it "should raise error if value not correct" do
      expect{@opt.test = 'a'}.to raise_error(ArgumentError)
    end

    it "should return true if options is not set" do
      subject.class_eval do
        data_opt :blank_opt
      end
      @opt.blank_opt?.should eql(false)
    end

  end

  context "action options" do

    before(:each) do
      subject.class_eval do
        action_opt :test_action
      end
      @opt = subject.new
    end

    it "should respond to {flag_name}=" do
      @opt.should respond_to(:test_action=)
    end

    it "should save value" do
      @opt.test_action = true
      @opt.run_test_action?.should be_true
    end

    it "should save default value" do
      @opt.run_test_action?.should be_false
    end

  end

end
