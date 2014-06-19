#!/usr/bin/env python3
# encoding: utf-8
"""
Multi-predicate filter().
"""


def mfilter(*args):
    *predicates, iterable = args
    for item in iterable:
        for predicate in predicates:
            if not predicate(item):
                break
        else:  # if no break
            yield item


def _main():
    paths = ['.', '..', 'dotfiles/', 'pgadmin.log', '.vim/']
    isdir = lambda string: string.endswith('/')

    # ugly way
    normal_dirs = [path for path in paths
                   if isdir(path) and not path.startswith('.')]
    print(normal_dirs)

    # functional way
    doesnt = lambda func: lambda *args, **kwargs: not func(*args, **kwargs)
    startswith = lambda prefix: lambda string: string.startswith(prefix)
    normal_dirs = list(mfilter(isdir, doesnt(startswith('.')), paths))
    print(normal_dirs)

if __name__ == '__main__':
    _main()
