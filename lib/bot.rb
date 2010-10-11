$LOAD_PATH << File.dirname(__FILE__)
require 'mailer'
require 'digg'
require 'yaml'

config_path=File.join(File.expand_path(File.dirname(__FILE__)),'..','config')
config=YAML.load_file(File.join(config_path,'config.yml'))

instructions=File.read(File.join(config_path, 'instructions'))


def topics()  
  topics=DiggBot::Digg.get_topics
  topics.inject("Available Topics:\n") do |str, topic|
    "#{str}#{topic[:name]} (#{topic[:short_name]})\n"
  end
end


mailer=DiggBot::Mailer.new(config['mail'])

mailer.get_messages.each do |message|
  case (message.subject.downcase)
  when 'topics' then
    mailer.reply(message,topics())
  else
    mailer.reply(message,instructions)
  end
end