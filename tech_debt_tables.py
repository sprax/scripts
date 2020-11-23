#!/usr/bin/env python3
'''
@file: tech_debt_tables.py
@auth: Sprax Lines
@date: 2019.10.06
Written for Python 3.7.4

Convert size/name pairs, such as from uniq -c, into a table with percentages

EXAMPLE USAGE:
    tech-debt-counts.sh | tech_debt_tables.py
    tech-debt-counts.sh > td.log && tech_debt_table.py < td.log
'''

# from __future__ import print_function
import fileinput

def sum_percent(beg=0, end=1):
    ''' Tokenize lines of the form: COUNT  NAME
        Reckon percentages of total count, divided into @tags and marker groups.
        Output table showing breakdowns.
        Adds percentage column after number & name columns.
    '''
    total_tags, total_debt = 0, 0
    auths, debts = [], []
    for line in fileinput.input():
        tokens = line.split()
        if len(tokens) > end:
            try:
                size = int(tokens[beg])
                name = tokens[end]
                if name[0] == '@':
                    total_tags += size
                    auths.append([size, name])
                elif name in ['FIXME', 'TODO']:
                    total_debt += size
                    debts.append([size, name])
            except ValueError:
                pass

    print("%12s %7s  % 7s" % ("MARKER", "Count", "Percent"))
    for tokens in debts:
        size, name = tokens[0:2]
        percent = size * 100 / total_debt
        print("%12s %7d  % 7.1f" % (name, size, percent))

    print("%12s %7s  % 7s" % ("OWNER", "-----", "-------"))
    for tokens in auths:
        size, name = tokens[0:2]
        percent = size * 100 / total_debt
        print("%12s %7d  % 7.1f" % (name, size, percent))

    size    = total_debt - total_tags
    percent = size * 100 / total_debt
    print("%12s %7d  % 7.1f" % ("[Unowned]", size, percent))

    print("%12s %7d  % 7.1f" % ("TOTALS", total_debt, 100.0))


if __name__ == '__main__':
    sum_percent()
