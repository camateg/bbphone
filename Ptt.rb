require 'serialport'

class Ptt
	def initialize(port)
		begin
			@@sp = SerialPort.new(port,9600)
			@@sp.rts = 0
			@@sp.dtr = 0
			@@state = 0
		rescue
			@@sp = nil
			@@state = -1
		end
	end

	def state
		@@state
	end
	
	def on
		begin
			@@sp.dtr = 1
			@@sp.rts = 1
			@@state = 1
		rescue
			@@state = -1	
		end
	end

	def off
		begin
			@@sp.dtr = 0
			@@sp.rts = 0
			@@state = 0
		rescue
			@@state = -1
		end
	end	
end

