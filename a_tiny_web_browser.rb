require 'socket'
require 'json'

host = "localhost"
port = 3000

params = Hash.new {|hash, key| hash[key] = Hash.new}

#input validation: Require GET or POST
 input = ''
 while input != 'GET' && input != 'POST'
 	print 'What type of request do you want to submit [GET] or [POST]?'
 	input = gets.chomp
 end
 #Get inputs from user, save to params
 if input == 'POST'
 	print 'Enter name:'
 	name = gets.chomp
 	print "Enter e-mail:"
 	email = gets.chomp
 	params[:person][:name] = name
 	params[:person][:email] = email
 	body = params.to_json #serialize:ruby=>json with to_json method to send data to the server
#prepare request to send to the server 	
request = "POST /thanks.html HTTP1.0/\r\nContent-Length:#{params.to_json.length}\r\n\r\n#{body}"
 else
   request = "GET /index.html HTTP1.0/\r\n\r\n"
 end	
#\r\n\r\n == blank line(space which divide headers and body in HTTP request and response)
#Even from server and client(browser) 
socket = TCPSocket.open(host, port)  #Connect to server
socket.print(request)                #Send request
response = socket.read               #read complete response
headers, body = response.split("\r\n\r\n", 2)#Split response at first blank line into headers and body 
puts ''	
print body
socket.close