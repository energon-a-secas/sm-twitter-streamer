require 'notify-energon'

# Module to concentrate all updates to multiple chats
module Announcement
  def chat_groups(text, name = 'PersiaBot', image = 'https://i.imgur.com/AlqxGdT.png', channel = 'hq-g-scl-offers')
    n = NotifyEnergon.new(slack_enabled: true, name: name, image: image)
    n.discord_event(text)
    n.send_message(text, channel)
  end
end
