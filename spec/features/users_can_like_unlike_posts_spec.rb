require 'rails_helper'

RSpec.feature "UsersCanLikeUnlikePosts", type: :feature, js: true do
  let(:user) { create(:user_with_a_friend) }
  let!(:post) { create(:post, author: user.friends.take) }

  before(:each) { sign_in_like_unlike_sign_out }

  shared_examples 'liked/unliked post' do |expectation|
    scenario "Post was liked/unliked by friend" do
      sign_in user.friends.take
      visit root_path
      expect(page.find('.card', text: user.friends.take.username).find_button('Like/unlike')).to have_text(expectation)
    end
  end

  context "When a friend likes a post" do
    it_behaves_like 'liked/unliked post', 1
  end

  context "When a friend unlikes a post" do
    before(:each) { sign_in_like_unlike_sign_out }
    it_behaves_like 'liked/unliked post', 0
  end

  def sign_in_like_unlike_sign_out
    sign_in user
    visit root_path
    within('.card', text: user.friends.take.username) { click_button('Like/unlike') }
    sign_out user
  end
end
