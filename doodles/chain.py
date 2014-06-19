#!/usr/bin/env python
# encoding: utf-8
"""
Function chaining experiment.
"""

from collections import namedtuple


User = namedtuple('User', 'name email is_active')


def chain_recursive(seq):
    def cocoon(xs):
        def caterpillar(f=None, *args):
            if f:
                return cocoon(f(*(list(args) + [xs])))
            else:
                return xs

        return caterpillar

    return cocoon(seq)


def chain_iterative(seq, *args):
    for a in args:
        if isinstance(a, tuple):
            f = lambda xs: a[0](*(list(a[1:]) + [xs]))
        else:
            f = a

        seq = f(seq)

    return seq


def _main():
    # Get email domains of active users ("gmail.com" and "rodriguez.name").
    # Try different approaches.

    users = [
        User("Fry", "fry@gmail.com", True),
        User("Leela", "leela@gmail.com", True),
        User("Bender", "bender@rodriguez.name", True),
        User("Zoidberg", "john@zoidberg.name", False),
    ]

    # 1. Idiomatic
    print set(x.email.split('@')[-1] for x in users if x.is_active)

    # 2. Functional, hard to read
    print set(map(lambda x: x.email.split('@')[-1],
                  filter(lambda x: x.is_active, users)))

    # 3. Functional with unpythonic formatting, easy(?) to read backwards
    print set(
          map(   lambda x: x.email.split('@')[-1],
          filter(lambda x: x.is_active,
          users)))

    # 4. Functional, easy to read forward, chained using recursive
    #    implementation
    print chain_recursive(users) \
        (filter, lambda x: x.is_active) \
        (map,    lambda x: x.email.split('@')[-1]) \
        (set) \
        ()

    # 5. Functional, easy to read forward, chained using iterative
    #    implementation
    print chain_iterative(users,
        (filter, lambda x: x.is_active),
        (map,    lambda x: x.email.split('@')[-1]),
        set)

if __name__ == '__main__':
    _main()
