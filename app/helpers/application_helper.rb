module ApplicationHelper
  def avatar_url(user)
    if user.image
      #{}"http://graph.facebook.com/#{user.uid}/picture?type=large"
      #{}"https://graph.facebook.com/<userId>/?fields=picture&type=large&access_token=b52be08df38288f1480e3b0b9d189c2f"
      "https://graph.facebook.com/v2.12/#{user.uid}/picture?height=100&width=100&access_token=b52be08df38288f1480e3b0b9d189c2f"
    else
      gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
      gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?d=identical&s=150"
    end

  end
end
