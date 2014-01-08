require 'spec_helper'

describe "examiners/show" do
  before(:each) do
    @examiner = assign(:examiner, stub_model(Examiner,
      :location => "Location",
      :note => "MyText",
      :project_id => 1,
      :examiner_1 => 2,
      :examiner_2 => 3,
      :examiner_3 => 4
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Location/)
    rendered.should match(/MyText/)
    rendered.should match(/1/)
    rendered.should match(/2/)
    rendered.should match(/3/)
    rendered.should match(/4/)
  end
end
