if (Rails.env.staging? || Rails.env.vagrant?)
  options = {
    forward_emails_to: Class.new do
      def self.to_ary
        Class.new do
          def self.flatten
            Class.new do
              def self.uniq
                Setting[:mail_interceptors].split(/[\s,;]/).reject(&:blank?)
              end
            end
          end
        end
      end
    end
  }

  interceptor = MailInterceptor::Interceptor.new(options)

  ActionMailer::Base.register_interceptor(interceptor)
end
