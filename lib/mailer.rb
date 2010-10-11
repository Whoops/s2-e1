require 'mail'
require 'openssl'

module DiggBot
  class Mailer
    def initialize(config)
      Mail.defaults do
        retriever_method :pop3, config['pop3']
        delivery_method :smtp, config['smtp']
      end
    end
    
    #retrieves and deletes messages
    def get_messages()
      Mail.find_and_delete(:count=>:all)
    end
    
    def reply(message, reply)
      Mail.deliver do
        to message.from
        from message.to
        subject message.subject
        body reply
      end
    end
  end
end