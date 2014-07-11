require 'spec_helper'

describe "shares/show" do
  before(:each) do
    @share = assign(:share, stub_model(Share,
      :url => "Url",
      :ref_token => "Ref Token",
      :views => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Url/)
    rendered.should match(/Ref Token/)
    rendered.should match(/1/)
  end
end
