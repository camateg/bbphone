os = RUBY_PLATFORM

	case os
		when /darwin/
			$ptt_port = '/dev/tty.usbserial'
			$platform = 'mac'
		when /linux/
			$ptt_port = '/dev/ttyUSB0'
			$platform = 'linux'
		else
			abort 'unsupported platform'
		end
