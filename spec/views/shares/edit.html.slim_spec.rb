require 'spec_helper'

describe "shares/edit" do
  before(:each) do
    @share = assign(:share, stub_model(Share,
      :url => "MyString",
      :ref_token => "MyString",
      :views => 1
    ))
  end

  it "renders the edit share form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", share_path(@share), "post" do
      assert_select "input#share_url[name=?]", "share[url]"
      assert_select "input#share_ref_token[name=?]", "share[ref_token]"
      assert_select "input#share_views[name=?]", "share[views]"
    end
  end
end
