require 'espeak'
require 'fileutils'
require 'net/http'
require 'json'
require './Ptt.rb'
require './serial.rb'

def poll_hook
        res = Net::HTTP.get(URI.parse('http://localhost:3000/hook'))
        resJson = JSON.parse(res)
        if resJson['status'] == 1
		return true
	else
		return false
	end
end

def ring_phone
	puts 'The phone would be ringing now...'

	hook = false
	while !hook
		hook = poll_hook
		$sp.on
		sleep 0.5 
		$sp.off
		sleep 1
		hook = poll_hook
	end
	
	puts 'Someone picked up the phone...'

end

$sp = Ptt.new($ptt_port)

while 1 do
	begin
		Dir.glob('/tmp/message_*').each do |f|
			message = File.read(f)
			
			ring_phone
			
			sleep 2.5 

			if $platform == 'mac'
				%x(say #{message})	
			else
				speech = ESpeak::Speech.new(message)
				speech.speak
			end
			FileUtils.rm f

			sleep 30
		end
	rescue
		puts 'Something bad happened...'
	end
end
