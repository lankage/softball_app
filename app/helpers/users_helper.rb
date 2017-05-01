module UsersHelper

  # Returns the Gravatar for the given user.
  def gravatar_for(user, options = { size: 80 })
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    size = options[:size]
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end
  def user_icon_for(user)
  	nameParts = user.name.split(" ")
  	firstName = nameParts[0]
  	lastName = "$"
  	if nameParts.length > 1
  		lastName = nameParts[1]
  	end
  	displayName = firstName[0,1] + "" +  lastName[0,1]
  	#html << "<ul class=\"#{name}-list\">"
  	digest = Digest::MD5.digest(user.name)
  	values = digest.unpack('SSS')
  	rgb = values.map { |i| i * 201 / 0x10000 }
  	r = rgb[0]
  	g = rgb[1]
  	b = rgb[2]

  	html = ''
  	html << "<span style='background-color: rgb(#{r},#{g},#{b});height:42px;width: 65px;font-size: 32px;text-align:center;color: white;'>#{displayName}</span>"

  	return html.html_safe
  end

end