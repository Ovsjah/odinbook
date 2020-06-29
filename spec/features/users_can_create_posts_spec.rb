require 'rails_helper'

RSpec.feature "UsersCanCreatePosts", type: :feature, js: true do
  let(:user) { create(:user_with_a_friend) }

  before :each do
    sign_in user
    visit root_path
    click_button "What's on your mind, #{user.username}?"
    fill_in 'post_content', with: 'Hello World'
    click_button 'Create post'
  end

  scenario "User creates a post and could manage it" do
    expect(page.find('div.card', text: 'Hello World')).to have_button("Edit post").and(have_link('Delete post'))
  end

  scenario "A friend could see a post in his feed but can't manage it" do
    sign_out user
    sign_in user.friends.take
    visit root_path
    expect(page.find('div.card', text: user.username)).to have_no_button("Edit post").and(have_no_link('Delete post'))
  end
end
