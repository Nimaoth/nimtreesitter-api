# Package

version       = "0.1.21"
author        = "Nimaoth"
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

task nimgen, "Generate api using nimgen":
  if gorgeEx(cmd & "nimgen").exitCode != 0:
    withDir(".."):
      exec "nimble install nimgen -y"
  exec cmd & "nimgen " & name & ".cfg"
  cpFile "treesitter/lib/src/wasm/stdlib-symbols.txt", "treesitter/lib/src/stdlib-symbols.txt"

task setup, "Checkout and generate":
  nimgenTask()

task checkoutAndGenerate, "Checkout and generate":
  setupTask()

before install:
  setupTask()

task test, "Run tests":
  exec "nim c --" & cc & ".linkerexe:\"g++\" -r tests/t" & name & ".nim"
