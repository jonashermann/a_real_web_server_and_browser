require 'socket'
require 'json'

server = TCPServer.open(3000)

loop{
	Thread.start(server.accept)do |client|
#REVIEW: short-term fix solution
#for reading request from client
#research others solutions.	
#read_nonblock(256)?	
      request = client.read_nonblock(256)
      request_headers, request_body = request.split("\r\n\r\n", 2)#Parse the Http request
      path = request_headers.split[1][1..-1]
      method = request_headers.split[0] 
      if File.exist?(path)
      	response_body = File.read(path)
      	client.puts "HTTP/1.0 200 OK\r\nContent-type:text/html\r\n\r\n"
      	client.puts"size: #{File.size(response_body)} KO\r\n\r\n"
          if method == "GET"
          	client.puts response_body
          elsif method == "POST"
               params = JSON.parse(response_body)#deserialize:json=>ruby with JSON.parse method 
               user_data = "<li>name: #{params["person"]["name"]}</li><li>email: #{params["person"]["email"]}</li>" 
               client.puts response_body.gsub("<%=yield%>", user_data)       
          end
       else   	
            client.puts"HTTP/1.0 404 Not found \r\n\r\n"
            client.puts "404 Error File Could not be Found"
      end
      client.close
    end  

}
