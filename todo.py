#!/usr/bin/env python
import os
import sys
from dataclasses import dataclass
from typing import Self

from colorama import Fore, Style


def print_color(color, *args, end="\n"):
    print(color, end="")

    print(*args, end=Style.RESET_ALL + end)


def print_tagged(tag, content):
    if tag == "(A)":
        tag_color = Fore.RED
    elif tag == "(B)":
        tag_color = Fore.MAGENTA
    else:
        tag_color = Fore.LIGHTBLACK_EX
    print_color(tag_color, tag, end="")
    print(content)


@dataclass
class Task:
    content: str
    subtasks: list[Self]

    @property
    def completed(self) -> bool:
        return self.content.startswith("x ")

    def print(self, indent: str = ""):
        print(indent, end="")
        if self.completed:
            print_color(Fore.LIGHTBLACK_EX, self.content)
        else:
            if self.content.startswith("("):
                tag = self.content[:3]
                content = self.content[3:]
                print_tagged(tag, content)
            else:
                print(self.content)
            for subtask in self.subtasks:
                subtask.print(indent=indent + "  ")


@dataclass
class TaskList:
    heading: str | None
    tasks: list[Task]

    def print(self):
        if self.heading:
            print_color(Style.BRIGHT, self.heading)
        for task in self.tasks:
            task.print()


lists: list[TaskList] = [TaskList(None, [])]


def at_school():
    ip = os.environ.get("SSH_CLIENT", "foo bar baz").split()[0]
    return ip.startswith("128.62.")


hide_if_heading = {"# Wedding": at_school}


with open(sys.argv[1]) as f:
    lines = [line.rstrip() for line in f.readlines()]
    for line in lines:
        if line.startswith("#"):
            list_ = TaskList(line, [])
            lists.append(list_)
        else:
            list_ = lists[-1]
            if line.startswith(" ") and list_.tasks:
                list_.tasks[-1].subtasks.append(Task(line.strip(), []))
            else:
                list_.tasks.append(Task(line, []))

    for list_ in lists:
        if list_.heading and (f := hide_if_heading.get(list_.heading)):
            if f():
                continue
        list_.print()
