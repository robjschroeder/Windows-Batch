@echo off

Set /P computername=Please enter a computer name:

gpedit.msc /gpcomputer: %computername%