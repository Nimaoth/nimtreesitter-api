# Package

version       = "0.1.4"
author        = "genotrance"
description   = "tree-sitter wrapper for Nim"
license       = "MIT"

skipDirs = @["tests"]

# Dependencies

requires "https://github.com/Nimaoth/nimgen >= 0.5.4"

var
  name = "treesitter"
  cmd = when defined(Windows): "cmd /c " else: ""
  cc = when defined(MacOSX): "clang" else: "gcc"

if fileExists(name & ".nimble"):
  mkDir(name)

task setup, "Checkout and generate":
  if gorgeEx(cmd & "nimgen").exitCode != 0:
    withDir(".."):
      exec "nimble install nimgen -y"
  exec cmd & "nimgen " & name & ".cfg"

before install:
  setupTask()

task test, "Run tests":
  exec "nim c --" & cc & ".linkerexe:\"g++\" -r tests/t" & name & ".nim"
