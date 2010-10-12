$LOAD_PATH << File.dirname(__FILE__)
require 'mailer'
require 'digg'
require 'yaml'

module DiggBot
  
  class BadParameterError < RuntimeError
  end
  
  def self.run()
    config_path=File.join(File.expand_path(File.dirname(__FILE__)),'..','config')
    config=YAML.load_file(File.join(config_path,'config.yml'))
    
    instructions=File.read(File.join(config_path, 'instructions'))
    Mailer.config(config['mail'])
    
    Mailer.get_messages.each do |message|
      case (message.subject.downcase)
      when 'topics' then
        Mailer.reply(message,topics())
      when 'articles' then
        begin
          Mailer.reply(message,articles(message.body))
        rescue BadParameterError
          Mailer.reply(message,"Invalid Format")
        end
      else
        Mailer.reply(message,instructions)
      end
    end
  end
  
  def self.articles(body)
    args=get_args(body.raw_source)
    "Articles:\n"+Digg.get_articles(args['topic'],args['limit'])
  end
  
  def self.get_args(text)
    args={}
    text.each_line do |line|
      arg,value=line.strip.split(': ')
      raise BadParameterError if value.nil?
      args[arg]=value
    end
    args
  end
  
  def self.topics()
    "Available Topics:\n"+Digg.get_topics
  end
  
end
