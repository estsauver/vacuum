require 'jeff'

module Vacuum
  # An Amazon Product Advertising API request.
  class Request
    include Jeff

    BadLocale  = Class.new(ArgumentError)
    MissingTag = Class.new(ArgumentError)

    # A list of Amazon Product Advertising API hosts.
    HOSTS = {
      'CA' => 'ecs.amazonaws.ca',
      'CN' => 'webservices.amazon.cn',
      'DE' => 'ecs.amazonaws.de',
      'ES' => 'webservices.amazon.es',
      'FR' => 'ecs.amazonaws.fr',
      'IT' => 'webservices.amazon.it',
      'JP' => 'ecs.amazonaws.jp',
      'UK' => 'ecs.amazonaws.co.uk',
      'US' => 'ecs.amazonaws.com'
    }.freeze

    params 'AssociateTag' => -> { tag },
           'Service'      => 'AWSECommerceService',
           'Version'      => '2011-08-01'

    # Create a new request for given locale.
    #
    # locale - The String Product Advertising API locale (default: US).
    #
    # Raises a Bad Locale error if locale is not valid.
    def initialize(locale = nil)
      host = HOSTS[locale || 'US'] or raise BadLocale
      self.endpoint = "http://#{host}/onca/xml"
      self.configure
    end

    # Configure the Amazon Product Advertising API request.
    #
    # credentials - The Hash credentials of the API endpoint.
    #               :key    - The String Amazon Web Services (AWS) key.
    #               :secret - The String AWS secret.
    #               :tag    - The String Associate Tag.
    #
    # Returns nothing.
    def configure(credentials)
      self.key= ENV["AMAZON_API_KEY"] 
      self.secret = ENV["AMAZON_API_SECRET"] 
      self.tag = ENV["AMAZONA_API_TAG"] 
      return self
    end

    # Get the String Associate Tag.
    #
    # Raises a Missing Tag error if Associate Tag is missing.
    def tag
      @tag or raise MissingTag
    end

    # Sets the String Associate Tag.
    attr_writer :tag

    # Build a URL.
    #
    # params - A Hash of Amazon Product Advertising query params.
    #
    # Returns the built URL String.
    def url(params)
      opts = {
        :method => :get,
        :query  => params
      }

      [endpoint, build_options(opts).fetch(:query)].join('?')
    end
  end
end
