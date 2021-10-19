require 'rails_helper'

RSpec.describe "pages/contact.html.erb", type: :view do
  it 'should have the right title' do
    render
    expect(rendered).to match /Ruby on Rails Tutorial Sample App | Contact/
  end
end
