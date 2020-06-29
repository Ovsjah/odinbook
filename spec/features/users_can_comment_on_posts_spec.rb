require 'rails_helper'

RSpec.feature "UsersCanCommentOnPosts", type: :feature, js: true do
  let(:user) { create(:user_with_a_friend) }
  let!(:post) { create(:post, author: user.friends.take) }

  scenario "User can comment on his friend's post" do
    sign_in user
    visit root_path
    within('.card', text: user.friends.take.username) do
      click_button('Comment')
      within 'form' do
        fill_in "comment_content_post_id_#{post.id}", with: "Hello Comment"
        click_button("Comment")
      end
    end
    expect(page.find('.list-group-item', text: user.username)).to have_text('Hello Comment')
  end
end
