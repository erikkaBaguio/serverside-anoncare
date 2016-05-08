def outer_function(id, name):

    id = id
    name = name

    def inner_function(id, name):

        return id + ' ' + name

    inner = inner_function(id, name)



    return inner


outer = outer_function('Hello, ', 'Josiah')

print 'outer', outer