# Unity native plugin boilerplate
Shows how natively compiled C/C++ code can be included into Unity project for PC and WebGL builds.

### This project lacks of
- mobile platforms support
- shared library support for native plugin

## Prerequisites
- Unity Editor
- Unity build platforms installed:
  - macOS
  - Windows
  - WebGL
- compilers for building native code library on macOS to the following platforms:
  - macOS: `cc` compiler available in PATH (XCode command line utils installed)
  - Windows: `x86_64-w64-mingw32-gcc` compiler available in PATH (on macOS can be installed via `brew` package)
- `make`
- `xcodebuild` for rebuilding macOS bundle

##### For running WebGL demo
- `docker`
- `Google Chrome`

## Build
`make`, build targets available: `macos`, `win`, `webgl`

### macOS bundle

macOS `.bundle` is already built and placed as a plugin to Unity project directory. To rebuild it there is a `plugin_macos_bundle` target for that

## Run demo
`make demo` for running PC builds

`make demo_webgl` for running WebGL build

### Unity project specifics
Unity requires native code packaged for every corresponding platform:
- macOS: compiled into macOS `.bundle`
- Windows: compiled into `.dll`
- WebGL: C/C++ source code doesn't need compilation as Unity uses `emscripten` internally to compile it to LLVM and after that to JavaScript

## Native code
- `NativeSource/NaPlContent.c`

It's being copied to 2 more places:
- Unity project to be a plugin for WebGL (to `UnitySrc/Assets/NaPl/Plugins`)
- Xcode project when bundle target is used (to `Xcode`)

##### Code extract
```C
#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>

int add_numbers(int x, int y) { return x + y; } // for testing purposes
const char* get_str_constant() { return "d41d8cd98f00b204e9800998ecf8427e"; } // string literal constant

// copy-paste from https://github.com/jwerle/murmurhash.c
uint32_t murmurhash(const char *key, uint32_t len, uint32_t seed)
{
	uint32_t c1 = 0xcc9e2d51;
	uint32_t c2 = 0x1b873593;
	uint32_t r1 = 15;
```

