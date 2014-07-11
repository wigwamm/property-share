require 'spec_helper'

describe "shares/new" do
  before(:each) do
    assign(:share, stub_model(Share,
      :url => "MyString",
      :ref_token => "MyString",
      :views => 1
    ).as_new_record)
  end

  it "renders new share form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", shares_path, "post" do
      assert_select "input#share_url[name=?]", "share[url]"
      assert_select "input#share_ref_token[name=?]", "share[ref_token]"
      assert_select "input#share_views[name=?]", "share[views]"
    end
  end
end
