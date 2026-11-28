package main

import (
	"fmt"
	"github.com/material-foundation/material-color-utilities/go/blend"
	"github.com/material-foundation/material-color-utilities/go/cam"
)

func main() {
	fmt.Println("=== Debug Blend HctHue ===")

	from := uint32(0xffff0000)
	to := uint32(0xff0000ff)
	amount := 0.8

	fmt.Printf("From: 0x%08x\n", from)
	fmt.Printf("To: 0x%08x\n", to)
	fmt.Printf("Amount: %f\n", amount)

	// Step 1: UCS blend
	ucs := blend.Cam16Ucs(from, to, amount)
	fmt.Printf("UCS result: 0x%08x\n", ucs)

	// Step 2: Get HCT from UCS
	ucsHct := cam.HctFromInt(ucs)
	fmt.Printf("UCS HCT - H:%f C:%f T:%f\n", ucsHct.Hue, ucsHct.Chroma, ucsHct.Tone)

	// Step 3: Get HCT from original
	fromHct := cam.HctFromInt(from)
	fmt.Printf("From HCT - H:%f C:%f T:%f\n", fromHct.Hue, fromHct.Chroma, fromHct.Tone)

	// Step 4: Use SetHue approach (C++ approach)
	fromHct.SetHue(ucsHct.Hue)
	fmt.Printf("Final HCT - H:%f C:%f T:%f\n", fromHct.Hue, fromHct.Chroma, fromHct.Tone)

	result := fromHct.ToInt()
	fmt.Printf("Final result: 0x%08x\n", result)
	fmt.Printf("Expected: 0x%08x\n", uint32(0xff905eff))

	// Check each component
	rActual := (result >> 16) & 0xFF
	gActual := (result >> 8) & 0xFF
	bActual := result & 0xFF

	rExpected := uint32(0x90)
	gExpected := uint32(0x5e)
	bExpected := uint32(0xef)

	fmt.Printf("RGB Actual: R=%02x G=%02x B=%02x\n", rActual, gActual, bActual)
	fmt.Printf("RGB Expected: R=%02x G=%02x B=%02x\n", rExpected, gExpected, bExpected)
	fmt.Printf("Differences: R=%d G=%d B=%d\n",
		int(rActual)-int(rExpected),
		int(gActual)-int(gExpected),
		int(bActual)-int(bExpected))
}
