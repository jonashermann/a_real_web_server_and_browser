require 'socket'

hostname = "localhost"
port = 2000
path = "/index.html"
request = "GET #{path} HTTP/1.1" 
socket = TCPSocket.open(hostname, port)
socket.print request
response = socket.read
puts response
socket.close