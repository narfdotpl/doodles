#!/usr/bin/env python
# encoding: utf-8
"""
Class decorator destined to fight in eternal combat against
unittest.TestCase's javaism.
"""

import re


__author__ = 'Maciej Konieczny <hello@narf.pl>'

_x = re.compile(r'_[a-z]')
_x2X = lambda _x: _x.group()[1].upper()


def not_your_camelcase_test_case(cls):
    'MEH HERD U LIEK DECORATURZ'

    def __getattr__(self, name):
        if not name.startswith('_'):
            name = re.sub(_x, _x2X, name)
        return getattr(super(self.__class__, self), name)

    cls.__getattr__ = __getattr__

    for proper, camelcase in [('setup', 'setUp'), ('teardown', 'tearDown')]:
        attr = getattr(cls, proper, None)
        if attr:
            setattr(cls, camelcase, attr)

    return cls
