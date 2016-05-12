import random
import string

characters = string.letters + string.digits + string.punctuation
pwd_size = 20

new_password = ''.join((random.choice(characters)) for x in range(pwd_size))

print "characters", characters
print "new_password", new_password