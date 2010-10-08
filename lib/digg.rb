require 'open-uri'
require 'json/pure'

module Digg
  API_URL='http://services.digg.com/2.0/'  
  
  def self.get_topics()
    fetch("topic.getAll")[:topics]
  end
  
  def self.get_top_stories(topic=nil, limit=20)
    args=arg_string(:topic=>topic,:limit=>limit)
    fetch("story.getTopNews#{args}")[:stories]
  end    
  
  def self.fetch(uri)
    open("#{API_URL}#{uri}") do |f|
      JSON.parse(f.read, :symbolize_names => true)
    end
  end
  
  def self.arg_string(args)
    args=args.select{ |arg, value| value }.inject("") do |str, arg|
      "#{str}&#{arg.join('=')}"
    end    
    args="?#{args}" unless args.empty?
    args
  end

end