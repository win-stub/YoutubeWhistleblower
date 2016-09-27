from subprocess import Popen, PIPE
p = Popen(["./test.sh","0","1","2","3","4","5","6","7","8","9","10","11"],stdout=None,stderr=None)
p.communicate()
#print(errors)
#print(output)  
