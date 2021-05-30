# calsh

A bash script to have a limited interactive version of the `cal` command to view the calendar.

<p align="center"><img src="https://github.com/ju-sh/calsh/blob/master/screenshots/screenshot.gif?raw=true"/></p>

## Usage

    calsh [[month] year]

where

    month: a valid month name or number in a format that `date` command accepts. Like June, Jun, 06, 6, etc.
    year: a valid year in the range 1..9999

## Navigation

The default key configuration is:

| Key                          | Effect           |
| ---                          | ------           |
| <kbd>l</kbd>                 | Next month       |
| <kbd>h</kbd>                 | Previous month   |
| <kbd>j</kbd>                 | Next year        |
| <kbd>k</kbd>                 | Previous year    |
| <kbd>J</kbd>                 | Next decade      |
| <kbd>K</kbd>                 | Previous decade  |
| <kbd>Ctrl</kbd>-<kbd>f</kbd> | Next century     |
| <kbd>Ctrl</kbd>-<kbd>b</kbd> | Previous century |

This can be changed by changing the variables in the beginning of the script.

Press <kbd>Esc</kbd> or <kbd>q</kbd> to quit.

## Examples

    calsh

Starts `calsh` with the current month and year.

---

    calsh 2020

Starts `calsh` with the current month of the year 2020.

---

    calsh Jun 2010

Starts `calsh` with the month June of the year 2010.
