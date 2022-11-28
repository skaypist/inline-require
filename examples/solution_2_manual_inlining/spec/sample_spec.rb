
describe "example" do
  let(:jumpy) { "colonel" }
  let(:jumpy_tiny) { "#{jumpy} tiny" }
  # let(:glidy) { 3 }
  it "should be successed." do
    # jumpy = 17
    itchy = "monacle"
    # puts "itchy: ( #{itchy.class} )"
    expect("#{jumpy_tiny} #{itchy}").to eq "colonel tiny monacle"
  end

  it "should be failed." do
    jumpy = "apple"
    expect(jumpy).to eq "banana"
  end

  describe "should be overridden" do
    let(:jumpy) { "captain" }

    it "uses the overridden" do
      itchy = "cups"
      expect("#{jumpy_tiny} #{itchy}").to eq "captain tiny cups"
    end
  end
end
