##
# It loads a file into a memory address
# It can set the file size in EAX
#  
# Inaki Rodriguez (irodriguez at virtualminds.es)

import idaapi
import os

def main():

	if not idaapi.is_debugger_on():
		print "Please run the process first!"
		return
	
	
		
	filename = AskFile(0,'*','Choose file to load')

	if filename:
		address = AskAddr(GetRegValue('esp'), 'Memory address')
		f = loader_input_t()
		fsize = os.path.getsize(filename)
		if f.open(filename):
			buffer = f.read(fsize)
			idaapi.dbg_write_memory(address, buffer)
			refresh_debugger_memory()
			f.close()
			if AskYN(1,"Load file size in EAX? (Size: %d)" % (fsize)) == 1:
				SetRegValue(fsize, 'EAX')
			
main()
