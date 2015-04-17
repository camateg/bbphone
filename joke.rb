require 'net/http'
require 'json'

def do_joke
	ep = 'http://api.icndb.com/jokes/random'

	people = [
		{
			'fn' => 'Seth',
			'ln' => 'Moore'
		},
		{
			'fn' => 'Norman',
			'ln' => 'Joyner'
		},
		{
			'fn' => 'Phil',
			'ln' => 'Dougherty'
		}
	]

	person = people[rand(0..people.length-1)]

	url = ep + '?firstName=' + person['fn'] + '&lastName=' + person['ln'] + '&escape=javascript'

	joke = JSON.parse(Net::HTTP.get(URI.parse(url)))

	if joke['type'] == 'success'
		sfn = '/tmp/message_' + rand(1000-9999).to_s + '.txt'
        	File.write(sfn, joke)
	end
	
end

do_joke
