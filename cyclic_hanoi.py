from functools import lru_cache

print("Starting calculating number of steps for Cyclic Hanoi")

@lru_cache(maxsize=None)
def cw(n):
	if n==0:
		return 0
	if n==1:
		return 1
	else:
		return 2*ccw(n-1) + 1

@lru_cache(maxsize=None)
def ccw(n):
	if n==0:
		return 0
	if n==1:
		return 2
	else:
		return 2*ccw(n-1) + cw(n-1) + 2

@lru_cache(maxsize=None)
def th(n):
	print(2*ccw(n-1) + 1)

th(5)
