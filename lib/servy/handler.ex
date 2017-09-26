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
    %{ method: method, path: path, resp_body: "", status: nil }
  end

  def route(%{method: "GET", path: "/wildthings"} = conv) do
    %{ conv | resp_body: "Bears, Lions, Tigers", status: 200 }
  end

  def route(%{method: "GET", path: "/bears"} = conv) do
    %{ conv | resp_body: "Teddy, Smokey, Paddington", status: 200 }
  end

  def route(%{method: "GET", path: "/bears/" <> _id} = conv) do
    %{ conv | resp_body: "Bears, Lions, Tigers", status: 200 }
  end

  def route(%{method: "DELETE", path: "/bears/" <> _id} = conv) do
    %{ conv | resp_body: "Success", status: 200 }
  end

  def route(conv) do
    %{ conv | resp_body: "No #{conv.path} here!", status: 404 }
  end

  def format_response(conv) do
    """
    HTTP/1.1 #{conv.status} #{status_reason(conv.status)}
    Content-Type: text/html
    Content-Length: #{conv.resp_body |> byte_size}
  
    #{conv.resp_body}
    """
  end

  defp status_reason(code) do
    codes = %{ 200 => "OK", 404 => "Not Found"}
    codes[code]
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

request = """
GET /bears/1 HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""
IO.puts Servy.Handler.handle(request)

request = """
DELETE /bears/1 HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""
IO.puts Servy.Handler.handle(request)
