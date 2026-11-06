#!/usr/bin/env nu

def main [] {}

def "main bus" [model: string] {
  ddcutil detect
  | lines
  | split list ""
  | where ($in | any {|l| $l =~ $model})
  | each {|l| parse -r ".*i2c-(?<bus>.+)"}
  | first
  | get bus.0
}

def "main brightness" [bus: int] {
  ddcutil getvcp --bus $bus 10
  | parse -r ".*current value = *(?<value>\\d+)"
  | first
  | get value
}
