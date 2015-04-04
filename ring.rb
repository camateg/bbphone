require('sinatra')
require('haml')
require('espeak')

get '/' do
	haml :index
end

post '/call' do
	message = params['message']

	# speech = ESpeak::Speech.new(message)
	sfn = '/tmp/message_' + rand(1000-9999).to_s + '.txt'

	File.write(sfn, message)

	'Your message will be sent...  Maybe?'
end



