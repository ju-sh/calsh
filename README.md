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

| Key | Effect           |
| --- | ------           |
| j   | Next month       |
| k   | Previous month   |
| l   | Next year        |
| h   | Previous year    |
| L   | Next decade      |
| H   | Previous decade  |
| C-f | Next century     |
| C-b | Previous century |

This can be changed by changing the variables in the beginning of the script.

## Examples

    calsh

Starts `calsh` with the current month and year.

---

    calsh 2020

Starts `calsh` with the current month of the year 2020.

---

    calsh Jun 2010

Starts `calsh` with the month June of the year 2010.
