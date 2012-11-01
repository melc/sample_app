namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do                     #ensure that the Rake task has access to the local Rails env.,including the SampleUser model
    make_sample_users
    make_microposts
    make_relationships
  end      
end

def make_sample_users
  admin = SampleUser.create!(name: "Example User",
                 email: "example@railstutorial.org",
                 password: "foobar",
                 password_confirmation: "foobar")
  admin.toggle!(:admin)
  99.times do |n|
    name  = Faker::Name.name
    email = "example-#{n+1}@railstutorial.org"
    password  = "password"
    SampleUser.create!(name: name,
                   email: email,
                   password: password,
                   password_confirmation: password)
  end
end

def make_microposts
  sample_users = SampleUser.all(limit: 6)
  50.times do
    content = Faker::Lorem.sentence(5)
    sample_users.each { |sample_user| sample_user.microposts.create!(content: content) }
  end    
end

def make_relationships
  sample_users = SampleUser.all
  sample_user  = sample_users.first
  followed_sample_users = sample_users[2..50]
  followers      = sample_users[3..40]
  followed_sample_users.each { |followed| sample_user.follow!(followed) }
  followers.each      { |follower| follower.follow!(sample_user) }
end