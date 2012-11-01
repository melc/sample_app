require 'spec_helper'

describe "StaticPages" do
  subject {page}

  describe "Home page" do
    before {visit root_path}
#    it { should have_selector('h1', text: "TwinPets.com") }
    it { should have_selector('title', text: "TwinPets.com Twitter Alike Demo")  }
    it { should_not have_selector('title', text: '| Home')  }
  
    describe "for signed-in users" do
      let(:sample_user) { FactoryGirl.create(:sample_user) }
      before do
        FactoryGirl.create(:micropost, sample_user: sample_user, content: "Lorem ipsum")
        FactoryGirl.create(:micropost, sample_user: sample_user, content: "Dolor sit amet")
        sign_in sample_user
        visit root_path
      end

      it "should render the user's feed" do
        sample_user.feed.each do |item|
          page.should have_selector("li##{item.id}", text: item.content)
        end
      end

      describe "follower/following counts" do
        let(:other_sample_user) { FactoryGirl.create(:sample_user) }
        before do
          other_sample_user.follow!(sample_user)
          visit root_path
        end

        it { should have_link("0 following", href: following_sample_user_path(sample_user)) }
        it { should have_link("1 followers", href: followers_sample_user_path(sample_user)) }
      end
    end
  end
  
  describe "Help page" do
    before {visit help_path}
    it { should have_selector('h1', text: "Help") }
    it { should have_selector('title', text: "TwinPets.com Twitter Alike Demo") }
    it { should_not have_selector('title', text: '| Help')  }
  end

  describe "About Us page" do
    before {visit about_path}
    it { should have_selector('h1', text: "About Us") }
    it { should have_selector('title', text: "TwinPets.com Twitter Alike Demo") }
    it { should_not have_selector('title', text: '| About Us') }
  end
  
  describe "Contact Us page" do
    before {visit contact_path}
    it { should have_selector('h1', text: "Contact Us") }
    it { should have_selector('title', text: "TwinPets.com Twitter Alike Demo") }
    it { should_not have_selector('title', text: '| Contact Us') }
  end
end
