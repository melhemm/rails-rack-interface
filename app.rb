require 'rack'
require_relative 'dateformat'

class App

  def call(env)
    request = Rack::Request.new(env)
    request_valid?(request) ? operate_request(request) : response_bad_request
  end

  private

  def operate_request(request)
    params_string = request.params['format']
    @date_format = DateFormat.new(params_string)
    @date_format.check_format
    @date_format.success? ? response_success : response_unknown_formats
  end

  def request_valid?(request)
    request.get?
    request.path == '/time'
    request.params['format']
  end

  def response(status, body)
    Rack::Response.new(body, status, {'Content-Type' => 'text/plain'}).finish
  end

  def response_bad_request
    response(404, 'not found')
  end

  def response_success
    response(200, @date_format.convert_format)
  end

  def response_unknown_formats
    response(400,"unknown time format #{@date_format.rejected_params}")
  end

end
