print("Starting calculating number of steps for Cyclic Hanoi")


x2 = 0


x19 = []
x20 = []
x21 = []











def cw(n):
	if n==0:
		return 0
	if n==1:
		return 1
	else:
		return 2*ccw(n-1) + 1

def ccw(n):
	if n==0:
		return 0
	if n==1:
		return 2
	else:
		return 2*ccw(n-1) + cw(n-1) + 2

def th(n):
	print(2*ccw(n-1) + 1)


th(5)


