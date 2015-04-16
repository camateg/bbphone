os = RUBY_PLATFORM

	case os
		when /darwin/
			$ptt_port = '/dev/tty.usbserial'
		when /linux/
			$ptt_port = '/dev/ttyUSB0'
		else
			abort 'unsupported platform'
		end
