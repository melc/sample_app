require 'spec_helper'

describe "SampleUsersPages" do
  subject { page }

  describe "index" do

    let(:sample_user) { FactoryGirl.create(:sample_user) }

    before(:each) do
      sign_in sample_user
      visit sample_users_path
    end

    it { should have_selector('title', text: 'All Users') }
    it { should have_selector('h1',    text: 'All Users') }

    describe "pagination" do

      before(:all) { 30.times { FactoryGirl.create(:sample_user) } }
      after(:all)  { SampleUser.delete_all }

      it { should have_selector('div.pagination') }

      it "should list each user" do
        SampleUser.paginate(page: 1).each do |sample_user|
          page.should have_selector('li', text: sample_user.name)
        end
      end
    end 

    describe "delete links" do

      it { should_not have_link('delete') }

      describe "as an admin user" do
        let(:admin) { FactoryGirl.create(:admin) }
        before do
          sign_in admin
          visit sample_users_path
        end

        it { should have_link('delete', href: sample_user_path(SampleUser.first)) }
        it "should be able to delete another user" do
          expect { click_link('delete') }.to change(SampleUser, :count).by(-1)
        end
        it { should_not have_link('delete', href: sample_user_path(admin)) }
      end
    end   
  end

  describe "SignUp Page" do
  	before { visit signup_path }

  	let(:submit) { "Create my account" }

  	describe "with invalid information" do
  		it "should not create a user" do
  			expect { click_button submit }.not_to change(SampleUser, :count)
  		end	

      describe "after submission" do
        before { click_button submit }

        it { should have_selector('title', text: 'Sign Up') }
        it { should have_content('error') }
      end
  	end

  	describe "with valid information" do
  		before do
  		  fill_in "Name", with: "Example User"
        fill_in "Email",with: "user@example.com"
        fill_in "Password", with: "foobar"
        fill_in "Confirmation", with: "foobar"
  		end

      describe "after saving the user" do
        before { click_button submit }
        let(:sample_user) { SampleUser.find_by_email('mhartl@example.com') }
        it { should have_selector('div.alert.alert-success', text: 'Welcome') }
        it { should have_link('Sign Out')}
      end

  		it "should create a user" do
  			expect { click_button submit }.to change(SampleUser, :count).by(1)
  		end	
  	end
  end

	describe "Profile Page" do
		let(:sample_user) { FactoryGirl.create(:sample_user) }
    let!(:m1) { FactoryGirl.create(:micropost, sample_user: sample_user, content: "Foo") }
    let!(:m2) { FactoryGirl.create(:micropost, sample_user: sample_user, content: "Bar") }

    before { visit sample_user_path(sample_user) }    

		it { should have_selector('h1',  text: sample_user.name) }
		it { should have_selector('title',  text: sample_user.name) }

    describe "microposts" do
      it { should have_content(m1.content) }
      it { should have_content(m2.content) }
      it { should have_content(sample_user.microposts.count) }
    end    
    
    describe "follow/unfollow buttons" do
      let(:other_sample_user) { FactoryGirl.create(:sample_user) }
      before { sign_in sample_user }

      describe "following a user" do
        before { visit sample_user_path(other_sample_user) }

        it "should increment the followed user count" do
          expect do
            click_button "Follow"
          end.to change(sample_user.followed_sample_users, :count).by(1)
        end

        it "should increment the other user's followers count" do
          expect do
            click_button "Follow"
          end.to change(other_sample_user.followers, :count).by(1)
        end

        describe "toggling the button" do
          before { click_button "Follow" }
          it { should have_selector('input', value: 'Unfollow') }
        end
      end

      describe "unfollowing a user" do
        before do
          sample_user.follow!(other_sample_user)
          visit sample_user_path(other_sample_user)
        end

        it "should decrement the followed user count" do
          expect do
            click_button "Unfollow"
          end.to change(sample_user.followed_sample_users, :count).by(-1)
        end

        it "should decrement the other user's followers count" do
          expect do
            click_button "Unfollow"
          end.to change(other_sample_user.followers, :count).by(-1)
        end

        describe "toggling the button" do
          before { click_button "Unfollow" }
          it { should have_selector('input', value: 'Follow') }
        end
      end
    end  
  end

  describe "edit" do
    let(:sample_user) { FactoryGirl.create(:sample_user) }
    
    before do
      sign_in sample_user
      visit edit_sample_user_path(sample_user)
    end

    describe "page" do
      it { should have_selector('h1',    text: "Update your profile") }
      it { should have_selector('title', text: "Edit User") }
      it { should have_link('change', href: 'http://gravatar.com/emails') }
    end

    describe "with invalid information" do
      before { click_button "Save Changes" }

      it { should have_content('error') }
    end

    describe "with valid information" do
      let(:new_name)  { "New Name" }
      let(:new_email) { "new@example.com" }
      
      before do
        fill_in "Name",             with: new_name
        fill_in "Email",            with: new_email
        fill_in "Password",         with: sample_user.password
        fill_in "Confirm Password", with: sample_user.password
        click_button "Save Changes"
      end

      it { should have_selector('title', text: new_name) }
      it { should have_selector('div.alert.alert-success') }
      it { should have_link('Sign Out', href: signout_path) }
      specify { sample_user.reload.name.should  == new_name }
      specify { sample_user.reload.email.should == new_email }
    end
  end	

  describe "following/followers" do
    let(:sample_user) { FactoryGirl.create(:sample_user) }
    let(:other_sample_user) { FactoryGirl.create(:sample_user) }
    before { sample_user.follow!(other_sample_user) }

    describe "followed users" do
      before do
        sign_in sample_user
        visit following_sample_user_path(sample_user)
      end

      it { should have_selector('title', text: full_title('Following')) }
      it { should have_selector('h3', text: 'Following') }
      it { should have_link(other_sample_user.name, href: sample_user_path(other_sample_user)) }
    end

    describe "followers" do
      before do
        sign_in other_sample_user
        visit followers_sample_user_path(other_sample_user)
      end

      it { should have_selector('title', text: full_title('Followers')) }
      it { should have_selector('h3', text: 'Followers') }
      it { should have_link(sample_user.name, href: sample_user_path(sample_user)) }
    end
  end  
end
