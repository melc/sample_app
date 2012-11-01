module SampleUsersHelper

  # Returns the Gravatar (http://gravatar.com/) for the given user.
  def gravatar_for(sample_user, options = { size: 50 })
    gravatar_id = Digest::MD5::hexdigest(sample_user.email.downcase)
    size = options[:size]
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}"
    image_tag(gravatar_url, alt: sample_user.name, class: "gravatar")
  end

end
