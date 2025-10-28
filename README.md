# HCT Converter

## About

This library provides functionality for conversion between the RGB color space
and Google's [HCT color space](https://m3.material.io/blog/science-of-color-design) 
because Go support is not included in Google's [`material-color-utilities`](https://github.com/material-foundation/material-color-utilities)
repository.

## Setup

Since this library depends on a C++ library via `cgo`, there are some additional
setup steps beyong simply `go get`.

### Pre-Requisites
* This library is designed to work on Linux machines.
* You must have the `cmake` command available

### Downloading & Building

1. From within your Go project, fetch the module

```bash
$ go get github.com/jcc620/hct-converter-go@v0.0.1
```

2. Go to the installed package's directory

```bash
$ cd $GOPATH/pkg/mod/github.com/jcc620/hct-converter-go@v0.0.1/cpp
```

3. Build the C++ library

```
$ mkdir build
$ cmake -S . -B build
$ cmake --build build
```

## Usage

This module is used as follows:

```go
package main

import (
    "fmt"

    hctconv "github.com/jcc620/hct-converter-go"
)

func main() {
    hue, chroma, tone := hctconv.RGBToHCT(200, 35, 160)
    fmt.Printf("Hue: %d\nChroma: %d\nTone: %d\n", hue, chroma, tone)

    red, green, blue := hctconv.HCTToRGB(hue, chroma, tone)
    fmt.Printf("Red: %d\nGreen: %d\nBlue: %d\n", red, green, blue)
}
```

## Credit

* [`material-color-utilities`](https://github.com/material-foundation/material-color-utilities)
