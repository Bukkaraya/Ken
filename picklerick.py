#This code will save humanity
import random
import time

letters = list('bcdfghjklmnpqrstvwxyz')

while(True):
	rand_letters = []

	for i in range(4):
	    rand_letters.append(letters[random.randint(0, 20)])

	print(f'{rand_letters[0]}ubba {rand_letters[2]}ubba {rand_letters[3]}ub {rand_letters[3]}ub')
	time.sleep(1)
