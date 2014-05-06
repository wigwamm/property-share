require 'spec_helper'

describe "shares/index" do
  before(:each) do
    assign(:shares, [
      stub_model(Share,
        :url => "Url",
        :ref_token => "Ref Token",
        :views => 1
      ),
      stub_model(Share,
        :url => "Url",
        :ref_token => "Ref Token",
        :views => 1
      )
    ])
  end

  it "renders a list of shares" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Url".to_s, :count => 2
    assert_select "tr>td", :text => "Ref Token".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
