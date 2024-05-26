#!/usr/bin/env python
import sys

from colorama import Fore, Style


def print_color(color, *args, end='\n'):
    print(color, end='')

    print(*args, end=Style.RESET_ALL + end)


def print_tagged(tag, content):
    if tag == "(A)":
        tag_color = Fore.RED
    elif tag == "(B)":
        tag_color = Fore.MAGENTA
    else:
        tag_color = Fore.LIGHTBLACK_EX
    print_color(tag_color, tag, end='')
    print(content)


def print_subtask(content):
    if content.strip().startswith('x '):
        print_color(Fore.LIGHTBLACK_EX, content)
    else:
        print(content)


with open(sys.argv[1]) as f:
    lines = [l.rstrip() for l in f.readlines()]
    i = 0
    completed = []
    while i < len(lines):
        l = lines[i]
        subtasks = 0
        j = i + 1
        while j < len(lines) and lines[j].startswith(' '):
            subtasks += 1
            j += 1

        if l.startswith('x'):
            completed.append((i, subtasks))
        else:
            if l.startswith('('):
                tag = l[:3]
                l = l[3:]
                print_tagged(tag, l)
            else:
                print(l)
            for j in range(i + 1, i + subtasks + 1):
                print_subtask(lines[j])
        i += subtasks + 1

    for task, subtasks in completed:
        print_color(Fore.LIGHTBLACK_EX, lines[task])
        if len(sys.argv) > 2:
            for j in range(task + 1, task + subtasks + 1):
                print_color(Fore.LIGHTBLACK_EX, lines[j])
