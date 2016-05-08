def test(*args):
    length = len(args)

    for a in args:
        if a is not '' or a is not None:
            print 'a', a
            pass
        else:
            return True


first = 'first'
second = None
third = ''
fourth = 'fourth'

print test(first, second, third, fourth)
