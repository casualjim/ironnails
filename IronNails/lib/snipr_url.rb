module IronNails

  module Core

    class SniprUrl

      include IronNails::Logging::ClassLogger

      attr_reader :url

      def initialize(url)
        @url = url
      end

      # ensures that our url starts with http at least
      def ensure_http
        url.ensure_http
      end

      # builds the url for the request to the snipr website
      def build_request_url
        "http://snipr.com/site/snip?r=simple&link=#{ensure_http}"
      end

      # create a webrequest, primary reason is so that we can mock it out
      # during unit testing.
      def request
        WebRequest.create(build_request_url)
      end

      # shorten the url ie. fetch the url from the snipr website.
      def shorten
        result = url

        begin
          if url.size > 18 && !/http:\/\/snipr.com.*/.match(url)
            using(rdr = StreamReader.new(request.get_response.get_response_stream)) {
              result = rdr.read_to_end.to_s
            }
          end
        rescue Exception => e
          #catch all errors and just return the regular url
        end

        res = ((result.size >= url.size || result.empty?) ? url.ensure_http : result).to_s
        logger.debug("*** SniprUrl: Shortened url from: #{url} to #{res}")
        res
      end

    end
  end
end