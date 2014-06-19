#!/usr/bin/env python
# encoding: utf-8
"""
ORMish eval() doodle inspired by
http://6.flowsnake.org/custom-namespace.html
"""


class Model(object):

    def __new__(cls, *args, **kwargs):
        if not hasattr(cls, '_pool'):
            cls._pool = []

        self = object.__new__(cls)
        cls._pool.append(self)

        return self

    def __getitem__(self, name):
        try:
            return getattr(self, name)
        except AttributeError:
            raise KeyError(name)

    @classmethod
    def objects(cls, expression):
        return [item for item in cls._pool if eval(expression, {}, item)]


class User(Model):

    def __init__(self, name, email, is_active):
        self.name = name
        self.email = email
        self.is_active = is_active

    def __repr__(self):
        return self.name


def _main():
    # create users
    User('Fry', 'fry@gmail.com', True)
    User('Leela', 'leela@gmail.com', True)
    User('Bender', 'bender@rodriguez.name', True)
    User('Zoidberg', 'zoidberg@gmail.com', False)

    # show list containing only Leela
    print User.objects('is_active and len(name) > 3 and "@gmail" in email')

if __name__ == '__main__':
    _main()
