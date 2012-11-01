require 'spec_helper'

describe "AuthenticationPages" do
  
  subject { page }

  describe "Signin Page" do
    before { visit signin_path }

    it { should have_selector('h1',    text: 'Sign In') }
    it { should have_selector('title', text: 'Sign In') }
  end 

  describe "signin" do
    before { visit signin_path }

    describe "with invalid information" do
      before { click_button "Sign In" }

      it { should have_selector('title', text: 'Sign In') }
      it { should have_selector('div.alert.alert-error', text: 'Invalid') }

      describe "after visiting another page" do
        before { click_link "Home" }
        it { should_not have_selector('div.alert.alert-error') }
      end      
    end

    describe "with valid information" do
      let(:sample_user) { FactoryGirl.create(:sample_user) }
      before { sign_in sample_user }

      it { should have_selector('title', text: sample_user.name) }
      it { should have_link('Profile',  href: sample_user_path(sample_user)) }
      it { should have_link('Settings', href: edit_sample_user_path(sample_user)) }
      it { should have_link('Sign Out', href: signout_path) }
      it { should_not have_link('Sign In', href: signin_path) }

      describe "followed by signout" do
        before { click_link "Sign Out" }
        it { should have_link('Sign In') }
      end
    end    
  end

  describe "authorization" do

    describe "for non-signed-in users" do
      let(:sample_user) { FactoryGirl.create(:sample_user) }

      describe "when attempting to visit a protected page" do
        before do
          visit edit_sample_user_path(sample_user)
          fill_in "Email",    with: sample_user.email
          fill_in "Password", with: sample_user.password
          click_button "Sign In"
        end

        describe "after signing in" do
          it "should render the desired protected page" do
            page.should have_selector('title', text: "Edit User")
          end
        
          describe "when signing in again" do
            before do
              delete signout_path
              visit signin_path
              fill_in "Email",    with: sample_user.email
              fill_in "Password", with: sample_user.password
              click_button "Sign In"
            end

            it "should render the default (profile) page" do
              page.should have_selector('title', text: sample_user.name) 
            end
          end  
        end
      end

      describe "in the Users controller" do

        describe "visiting the edit page" do
          before { visit edit_sample_user_path(sample_user) }
          it { should have_selector('title', text: 'Sign In') }
        end

        describe "submitting to the update action" do
          before { put sample_user_path(sample_user) }
          specify { response.should redirect_to(signin_path) }
        end

        describe "visiting the user index" do
          before { visit sample_users_path }
          it { should have_selector('title', text: 'Sign In') }
        end  

        describe "visiting the following page" do
          before { visit following_sample_user_path(sample_user) }
          it { should have_selector('title', text: 'Sign In') }
        end

        describe "visiting the followers page" do
          before { visit followers_sample_user_path(sample_user) }
          it { should have_selector('title', text: 'Sign In') }
        end
      end

      describe "in the Microposts controller" do

        describe "submitting to the create action" do
          before { post microposts_path }
          specify { response.should redirect_to(signin_path) }
        end

        describe "submitting to the destroy action" do
          before { delete micropost_path(FactoryGirl.create(:micropost)) }
          specify { response.should redirect_to(signin_path) }
        end
      end    

      describe "in the Relationships controller" do
        describe "submitting to the create action" do
          before { post relationships_path }
          specify { response.should redirect_to(signin_path) }
        end

        describe "submitting to the destroy action" do
          before { delete relationship_path(1) }
          specify { response.should redirect_to(signin_path) }          
        end
      end        
    end        

    describe "as non-admin user" do
      let(:sample_user) { FactoryGirl.create(:sample_user) }
      let(:non_admin) { FactoryGirl.create(:sample_user) }

      before { sign_in non_admin }

      describe "submitting a DELETE request to the Users#destroy action" do
        before { delete sample_user_path(sample_user) }
        specify { response.should redirect_to(root_path) }        
      end
    end   

    describe "as wrong user" do
      let(:sample_user) { FactoryGirl.create(:sample_user) }
      let(:wrong_sample_user) { FactoryGirl.create(:sample_user, email: "wrong@example.com") }
      before { sign_in sample_user }

      describe "visiting Users#edit page" do
        before { visit edit_sample_user_path(wrong_sample_user) }
        it { should_not have_selector('title', text: full_title('Edit User')) }
      end
      
      describe "submitting a PUT request to the Users#update action" do
        before { put sample_user_path(wrong_sample_user) }
        specify { response.should redirect_to(root_path) }
      end      
     end	
  end
end
