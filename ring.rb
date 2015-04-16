require 'sinatra'
require 'haml'
require 'json'
get '/' do
	haml :index
end

post '/call' do
	message = params['message']

	queue_message the_json['message']

	'Your message will be sent...  Maybe?'
end

post '/call.json' do
	begin
		the_json = JSON.parse(request.body.read.to_s)
		output = Hash.new

		queue_message the_json['message']

		output['message'] = the_json['message']
		output['status'] = 'queued'
		output.to_json
	rescue
		'{"error":"That was not JSON!"}'
	end
end

def queue_message(msg)
	sfn = '/tmp/message_' + rand(1000-9999).to_s + '.txt'
	File.write(sfn, msg)
end
