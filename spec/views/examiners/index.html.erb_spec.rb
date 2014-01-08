require 'spec_helper'

describe "examiners/index" do
  before(:each) do
    assign(:examiners, [
      stub_model(Examiner,
        :location => "Location",
        :note => "MyText",
        :project_id => 1,
        :examiner_1 => 2,
        :examiner_2 => 3,
        :examiner_3 => 4
      ),
      stub_model(Examiner,
        :location => "Location",
        :note => "MyText",
        :project_id => 1,
        :examiner_1 => 2,
        :examiner_2 => 3,
        :examiner_3 => 4
      )
    ])
  end

  it "renders a list of examiners" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Location".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => 4.to_s, :count => 2
  end
end
