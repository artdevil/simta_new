require 'spec_helper'

describe "examiners/edit" do
  before(:each) do
    @examiner = assign(:examiner, stub_model(Examiner,
      :location => "MyString",
      :note => "MyText",
      :project_id => 1,
      :examiner_1 => 1,
      :examiner_2 => 1,
      :examiner_3 => 1
    ))
  end

  it "renders the edit examiner form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", examiner_path(@examiner), "post" do
      assert_select "input#examiner_location[name=?]", "examiner[location]"
      assert_select "textarea#examiner_note[name=?]", "examiner[note]"
      assert_select "input#examiner_project_id[name=?]", "examiner[project_id]"
      assert_select "input#examiner_examiner_1[name=?]", "examiner[examiner_1]"
      assert_select "input#examiner_examiner_2[name=?]", "examiner[examiner_2]"
      assert_select "input#examiner_examiner_3[name=?]", "examiner[examiner_3]"
    end
  end
end
