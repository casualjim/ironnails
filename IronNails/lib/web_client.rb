module IronNails
  
  module Core
    
    # A wrapper around webrequests to facilitate the
    # creation of asynchronous gets and posts
    # This can probably be replaced at a later stage when gems are working
    class WebClient
      
      # The url for the webrequest
      attr_reader :url
      
      # The credentials for the request
      attr_reader :credentials
      
      # The request object
      attr_accessor :web_request      
      
      def initialize(url, credentials)
        @url = url
        @credentials = credentials
        @web_request = System::Net::WebRequest.create url
      end
      
      # Performs a GET request and executes a parsing routine, when a block is given
      # it will perform an asynchronous GET request and execute the parsing routine
      def get_and_return(parse_response, async=false, &callback)
        raise ArgumentError.new("You need to provide me with parsing algorithm") if parse_response.nil?
        
        web_request.credentials = credentials.to_network_credentials
        web_request.method = "GET"
        if block_given? || async
          web_request.perform_async_get parse_response, &callback
        else
          web_request.perform_get parse_response
        end
      end 
      
      def get(&callback)
        raise ArgumentError.new("You need to provide me with parsing algorithm") if parse_response.nil?
        
        web_request.credentials = credentials.to_network_credentials
        web_request.method = "GET"
        if block_given? 
          web_request.perform_async_get &callback
        else
          web_request.perform_get
        end
      end
      
      # Performs a POST request with the specified parameters. It returns true or false to indicate success
      # when a block is given it will perfom the post async and return the boolean indicating success to the callback
      def post_and_return(params = {}, parse_response=nil, &callback)
        web_request.credentials = credentials.to_network_credentials
        
        if block_given?
          web_request.perform_async_post params, parse_response, &callback
        else
          web_request.perform_post params, parse_response
        end  
      end
      
      protected
      
      def handle_exception(e)
        status = e.status;
        if status == WebExceptionStatus.protocol_error
          httpResponse = e.response
          
          case httpResponse.status_code        
          when HttpStatusCode.NotModified: # 304 Not modified = no new tweets so ignore error.
            break;
          when HttpStatusCode.BadRequest: # rate limit exceeded
            raise RequestLimitException.new;
          when HttpStatusCode.Unauthorized: # unauthorized
            raise SecurityException.new("Not Authorized.");
          else
            raise
          end
        else
          raise
        end
      end 
      
    end 
    
    class RequestLimitException < System::Exception
      
      def initialize(message = "You've made too many requests. Twitter only allows 100 requests/hour.")
        super(message)
      end 
    end
    
  end
  
  
end