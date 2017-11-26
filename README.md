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
	uint32_t r2 = 13;
	uint32_t m = 5;
	uint32_t n = 0xe6546b64;
	uint32_t h = 0;
	uint32_t k = 0;
	uint8_t* d = (uint8_t *) key; // 32 bit extract from `key'
	const uint32_t *chunks = NULL;
	const uint8_t *tail = NULL; // tail - last 8 bytes
	int i = 0;
	int l = len / 4; // chunk length

	h = seed;

	chunks = (const uint32_t*) (d + l * 4); // body
	tail = (const uint8_t*) (d + l * 4); // last 8 byte chunk of `key'

	// for each 4 byte chunk of `key'
	for (i = -l; i != 0; ++i)
	{
		// next 4 byte chunk of `key'
		k = chunks[i];

		// encode next 4 byte chunk of `key'
		k *= c1;
		k = (k << r1) | (k >> (32 - r1));
		k *= c2;

		// append to hash
		h ^= k;
		h = (h << r2) | (h >> (32 - r2));
		h = h * m + n;
	}

	k = 0;

	// remainder
	switch (len & 3)
	{ // `len % 4'
		case 3:
			k ^= (tail[2] << 16);
```

##### Same in JavaScript (taken from WebGL build)
```JavaScript```
function _murmurhash(i2, i5, i1) {
 i2 = i2 | 0;
 i5 = i5 | 0;
 i1 = i1 | 0;
 var i3 = 0, i4 = 0, i6 = 0;
 i3 = i5 >>> 2;
 i4 = i2 + (i3 << 2) | 0;
 if (!i3) i2 = i1; else {
  i2 = 0 - i3 | 0;
  do {
   i3 = HEAP32[i4 + (i2 << 2) >> 2] | 0;
   i1 = (Math_imul((Math_imul(i3, -862048943) | 0) >>> 17 | (Math_imul(i3, 380141568) | 0), 461845907) | 0) ^ i1;
   i1 = ((i1 << 13 | i1 >>> 19) * 5 | 0) + -430675100 | 0;
   i2 = i2 + 1 | 0;
  } while ((i2 | 0) != 0);
  i2 = i1;
 }
 switch (i5 & 3) {
 case 3:
  {
```

