shared_examples_for MassiveRecord::ORM::Proxy do
  %w(owner target metadata).each do |method|
    it "should respond to #{method}" do
      should respond_to method
    end
  end

  describe "#loaded" do
    it "should be true when loaded" do
      subject.instance_variable_set :@loaded, true
      should be_loaded
    end

    it "should be false when not loaded" do
      subject.instance_variable_set :@loaded, false
      should_not be_loaded
    end

    it "should be loaded when loaded! is called" do
      subject.instance_variable_set :@loaded, false
      subject.loaded!
      should be_loaded
    end
  end


  describe "#reset" do
    it "should not be loaded after reset" do
      subject.loaded!
      subject.reset
      should_not be_loaded
    end

    it "should reset the target" do
      subject.target = "foo"
      subject.reset
      subject.target.should be_nil
    end
  end


  describe "forward method calls to target" do
    let(:target) { mock(Object, :target_method => "return value") }

    before do
      subject.target = target
    end
    

    describe "#respond_to?" do
      it "should check proxy to see if it responds to something" do
        should respond_to :target
      end
      
      it "should respond to target_method" do
        should respond_to :target_method
      end

      it "should not respond to a dummy method" do
        should_not respond_to :dummy_method_which_does_not_exists 
      end
    end


    describe "#method_missing" do
      it "should call proxy's method if exists in proxy" do
        subject.should_receive(:loaded?).once
        subject.loaded?
      end

      it "should call target's method if it responds to it" do
        target.should_receive(:target_method).and_return("foo")
        subject.target_method.should == "foo"
      end

      it "should rause no method error if no one responds to it" do
        lambda { subject.dummy_method_which_does_not_exists }.should raise_error NoMethodError
      end
    end
  end
end
