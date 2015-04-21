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

	url = ep + '?firstName=' + person['fn'] + '&lastName=' + person['ln'] + '&escape=javascript&' + "exclude=\[explicit\]"

	joke = JSON.parse(Net::HTTP.get(URI.parse(url)))

	if joke['type'] == 'success'
		sfn = '/tmp/message_' + rand(1000-9999).to_s + '.txt'
        	joke_txt = joke['value']['joke']
		File.write(sfn, joke_txt)
		joke_txt
	else
		'error'
	end	
end
