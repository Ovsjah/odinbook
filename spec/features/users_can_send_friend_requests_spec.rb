require 'rails_helper'

RSpec.feature "UsersCanSendFriendRequests", type: :feature, js: true do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }

  before :each do
    visit new_user_session_path
    fill_in 'Email or username', with: user.username
    fill_in 'Password', with: user.password
    click_button 'Log in'
  end

  it { expect(current_path).to eq(root_path) }

  shared_examples 'there is no such a friend' do
    scenario "Another user denies/unfriends" do
      click_button 'Add a friend'
      click_link 'All friends'
      expect(page).not_to have_selector("#userId-#{user.id}")
    end
  end

  context "With friend request" do
    before :each do
      fill_in 'Find a friend', with: another_user.username
      click_button 'Search user'
      click_link 'Send a friend request'
      click_link 'Log out'
      visit new_user_session_path
      fill_in 'Email or username', with: another_user.username
      fill_in 'Password', with: another_user.password
      click_button 'Log in'
      click_button 'Add a friend'
    end

    context "With accepted friend request" do
      before :each do
        click_link "Accept #{user.username}"
        click_button 'Add a friend'
        click_link 'All friends'
      end

      scenario 'Another user accepts a friend request' do
        expect(find("#userId-#{user.id}")).to have_text(user.username).and(have_link('Unfriend'))
      end

      context "Another user unfriends a user" do
        before(:each) { within("#userId-#{user.id}") { click_link 'Unfriend' } }
        it_behaves_like 'there is no such a friend'
      end
    end

    context "Another user denies a friend request" do
      before(:each) { click_link "Deny #{user.username}" }
      it_behaves_like 'there is no such a friend'
    end
  end
end
