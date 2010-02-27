class System::Net::WebRequest

  include IronNails::Logging::ClassLogger

  def prepare_for_post(parameters = {})

    params = parameters.to_post_parameters

    self.method = "POST"
    self.content_type = "application/x-www-form-urlencoded"
    self.content_length = params.length

    using (stream = StreamWriter.new(self.get_request_stream, System::Text::Encoding.ASCII)) do
      stream.write params
    end

    params
  end

  def prepare_for_async_post(parameters = {}, &callback)
    self.method = "POST"
    self.content_type = "application/x-www-form-urlencoded"
    self.content_length = parameters.to_post_parameters.length

    self.begin_get_request_stream(AsyncCallback.new {|ar| callback.call(ar) }, nil)
  end

  def perform_post( params, parse_response=nil)
    logger.debug("IronNails: WebRequest: Performing POST to #{request_uri.to_string}")
    self.prepare_for_post(params)
    begin
      res = self.get_response # we get a real HttpWebResponse back instead of the WebResponse for the C# and VB.NET users. yay for duck typing
      unless parse_response.nil?
        using(rdr = StreamReader.new(res.get_response_stream)) do
          return parse_response.call(rdr)
        end
      else
        return res.status_code == HttpStatusCode.OK
      end
    rescue WebException => e
      handle_exception e
    end
    false
  end

  def perform_async_post( params, parse_response=nil, &callback)
    logger.debug("IronNails: WebRequest: Performing asynchronous POST to #{request_uri.to_string}")
    self.prepare_for_async_post params do |async_result|
      using(post_stream = self.end_get_request_stream(async_result)) do
        pars = parameters.to_post_parameters
        post_stream.write pars.convert_to_bytes, 0, pars.size
      end

      self.begin_get_response(AsyncCallback.new { |response|
        res = self.end_get_response response
        using(rdr = StreamReader.new(res.get_response_stream)) do
          parse_response.call(rdr)
        end unless parse_response.nil?
        callback.call res.status_code == HttpStatusCode.OK if block_given?
      }, nil);
    end
  end


  def perform_get( parse_response=nil)
    logger.debug("IronNails: WebRequest: Performing GET to #{request_uri.to_string}")
    begin
      response = self.get_response
      using(rdr = StreamReader.new(response.get_response_stream)) do
        parse_response.call(rdr)
      end unless parse_response.nil?
    rescue WebException => e
      handle_exception e
    end
  end

  def perform_async_get( parse_response=nil, &callback)
    logger.debug("IronNails: WebRequest: Performing asynchronous GET to #{request_uri.to_string}")
    self.begin_get_response AsyncCallback.new{ |response|
      begin
        res = self.end_get_response(response)
        using(rdr = StreamReader.new(res.get_response_stream)) do
          obj = parse_response.call(rdr)
          callback.call(obj) if block_given?
        end if parse_response
      rescue WebException => e
        handle_exception e
      end
    }, nil
  end

  def handle_exception(e)
    logger.error("ERROR: IronNails: WebRequest (#{request_uri.to_string}):\nThere was an error while executing the web request: #{e.message}")
    status = e.status;
    if status == WebExceptionStatus.protocol_error
      httpResponse = e.response

      case httpResponse.status_code
        when HttpStatusCode.NotModified: # 304 Not modified = no new tweets so ignore error.
          break;
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