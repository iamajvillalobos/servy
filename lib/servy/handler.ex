defmodule Servy.Handler do
  def handle(request) do
    request
    |> parse
    |> log
    |> route
    |> format_response
  end

  def log(conv), do: IO.inspect conv

  def parse(request) do
    [method, path, _version] = 
      request
      |> String.split("\n")
      |> List.first
      |> String.split(" ")
    %{ method: method, path: path, resp_body: "" }
  end

  # def route(conv) do
  #   route(conv, conv.method, conv.path)
  # end

  def route(%{method: "GET", path: "/wildthings"} = conv) do
    %{ conv | resp_body: "Bears, Lions, Tigers" }
  end

  def route(%{method: "GET", path: "/bears"} = conv) do
    %{ conv | resp_body: "Teddy, Smokey, Paddington" }
  end

  def format_response(conv) do
    """
    HTTP/1.1 200 OK
    Content-Type: text/html
    Content-Length: #{conv.resp_body |> byte_size}
  
    #{conv.resp_body}
    """
  end
end

request = """
GET /wildthings HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""
IO.puts Servy.Handler.handle(request)

request = """
GET /bears HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""
IO.puts Servy.Handler.handle(request)

request = """
GET /bigfoot HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""
IO.puts Servy.Handler.handle(request)
