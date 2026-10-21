// Copyright 2021 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

package cam

import (
	"math"

	"github.com/material-foundation/material-color-utilities/go/utils"
)

// Conversion matrices and constants for HCT solving
var (
	scaledDiscountFromLinrgb = [][]float64{
		{0.001200833568784504, 0.002389694492170889, 0.0002795742885861124},
		{0.0005891086651375999, 0.0029785502573438758, 0.0003270666104008398},
		{0.00010146692491640572, 0.0005364214359186694, 0.0032979401770712076},
	}

	linrgbFromScaledDiscount = [][]float64{
		{1373.2198709594231, -1100.4251190754821, -7.278681089101213},
		{-271.815969077903, 559.6580465940733, -32.46047482791194},
		{1.9622899599665666, -57.173814538844006, 308.7233197812385},
	}

	yFromLinrgb = []float64{0.2126, 0.7152, 0.0722}

	criticalPlanes = []float64{
		0.015176349177441876,
		0.045529047532325624,
		0.07588174588720938,
		0.10623444424209313,
		0.13658714259697685,
		0.16693984095186062,
		0.19729253930674434,
		0.2276452376616281,
		0.2579979360165119,
		0.28835063437139563,
		0.3188300904430532,
		0.350925934958123,
		0.3848314933096426,
		0.42057480301049466,
		0.458183274052838,
		0.4976837250274023,
		0.5391024159806381,
		0.5824650784040898,
		0.6277969426914107,
		0.6751227633498623,
		0.7244668422128921,
		0.775853049866786,
		0.829304845476233,
		0.8848452951698498,
		0.942497089126609,
		1.0022825574869039,
		1.0642236851973577,
		1.1283421258858297,
		1.1946592148522128,
		1.2631959812511864,
		1.3339731595349034,
		1.407011200216447,
		1.4823302800086415,
		1.5599503113873272,
		1.6398909516233677,
		1.7221716113234105,
		1.8068114625156377,
		1.8938294463134073,
		1.9832442801866852,
		2.075074464868551,
		2.1693382909216234,
		2.2660538449872063,
		2.36523901573795,
		2.4669114995532007,
		2.5710888059345764,
		2.6777882626779785,
		2.7870270208169257,
		2.898822059350997,
		3.0131901897720907,
		3.1301480604002863,
		3.2497121605402226,
		3.3718988244681087,
		3.4967242352587946,
		3.624204428461639,
		3.754355295633311,
		3.887192587735158,
		4.022731918402185,
		4.160988767090289,
		4.301978482107941,
		4.445716283538092,
		4.592217266055746,
		4.741496401646282,
		4.893568542229298,
		5.048448422192488,
		5.20615066083972,
		5.3666897647573375,
		5.5300801301023865,
		5.696336044816294,
		5.865471690767354,
		6.037501145825082,
		6.212438385869475,
		6.390297286737924,
		6.571091626112461,
		6.7548350853498045,
		6.941541251256611,
		7.131223617812143,
		7.323895587840543,
		7.5195704746346665,
		7.7182615035334345,
		7.919981813454504,
		8.124744458384042,
		8.332562408825165,
		8.543448553206703,
		8.757415699253682,
		8.974476575321063,
		9.194643831691977,
		9.417930041841839,
		9.644347703669503,
		9.873909240696694,
		10.106627003236781,
		10.342513269534024,
		10.58158024687427,
		10.8238400726681,
		11.069304815507364,
		11.317986476196008,
		11.569896988756009,
		11.825048221409341,
		12.083451977536606,
		12.345119996613247,
		12.610063955123938,
		12.878295467455942,
		13.149826086772048,
		13.42466730586372,
		13.702830557985108,
		13.984327217668513,
		14.269168601521828,
		14.55736596900856,
		14.848930523210871,
		15.143873411576273,
		15.44220572664832,
		15.743938506781891,
		16.04908273684337,
		16.35764934889634,
		16.66964922287304,
		16.985093187232053,
		17.30399201960269,
		17.62635644741625,
		17.95219714852476,
		18.281524751807332,
		18.614349837764564,
		18.95068293910138,
		19.290534541298456,
		19.633915083172692,
		19.98083495742689,
		20.331304511189067,
		20.685334046541502,
		21.042933821039977,
		21.404114048223256,
		21.76888489811322,
		22.137256497705877,
		22.50923893145328,
		22.884842241736916,
		23.264076429332462,
		23.6469514538663,
		24.033477234264016,
		24.42366364919083,
		24.817520537484558,
		25.21505769858089,
		25.61628489293138,
		26.021211842414342,
		26.429848230738664,
		26.842203703840827,
		27.258287870275353,
		27.678110301598522,
		28.10168053274597,
		28.529008062403893,
		28.96010235337422,
		29.39497283293396,
		29.83362889318845,
		30.276079891419332,
		30.722335150426627,
		31.172403958865512,
		31.62629557157785,
		32.08401920991837,
		32.54558406207592,
		33.010999283389665,
		33.4802739966603,
		33.953417292456834,
		34.430438229418264,
		34.911345834551085,
		35.39614910352207,
		35.88485700094671,
		36.37747846067349,
		36.87402238606382,
		37.37449765026789,
		37.87891309649659,
		38.38727753828926,
		38.89959975977785,
		39.41588851594697,
		39.93615253289054,
		40.460400508064545,
		40.98864111053629,
		41.520882981230194,
		42.05713473317016,
		42.597404951718396,
		43.141702194811224,
		43.6900349931913,
		44.24241185063697,
		44.798841244188324,
		45.35933162437017,
		45.92389141541209,
		46.49252901546552,
		47.065252796817916,
		47.64207110610409,
		48.22299226451468,
		48.808024568002054,
		49.3971762874833,
		49.9904556690408,
		50.587870934119984,
		51.189430279724725,
		51.79514187861014,
		52.40501387947288,
		53.0190544071392,
		53.637271562750364,
		54.259673423945976,
		54.88626804504493,
		55.517063457223934,
		56.15206766869424,
		56.79128866487574,
		57.43473440856916,
		58.08241284012621,
		58.734331877617365,
		59.39049941699807,
		60.05092333227251,
		60.715611475655585,
		61.38457167773311,
		62.057811747619894,
		62.7353394731159,
		63.417162620860914,
		64.10328893648692,
		64.79372614476921,
		65.48848194977529,
		66.18756403501224,
		66.89098006357258,
		67.59873767827808,
		68.31084450182222,
		69.02730813691093,
		69.74813616640164,
		70.47333615344107,
		71.20291564160104,
		71.93688215501312,
		72.67524319850172,
		73.41800625771542,
		74.16517879925733,
		74.9167682708136,
		75.67278210128072,
		76.43322770089146,
		77.1981124613393,
		77.96744375590167,
		78.74122893956174,
		79.51947534912904,
		80.30219030335869,
		81.08938110306934,
		81.88105503125999,
		82.67721935322541,
		83.4778813166706,
		84.28304815182372,
		85.09272707154808,
		85.90692527145302,
		86.72564993000343,
		87.54890820862819,
		88.3767072518277,
		89.2090541872801,
		90.04595612594655,
		90.88742016217518,
		91.73345337380438,
		92.58406282226491,
		93.43925555268066,
		94.29903859396902,
		95.16341895893969,
		96.03240364439274,
		96.9059996312159,
		97.78421388448044,
		98.6670533535366,
		99.55452497210776,
	}
)

// SolveToInt solves for the ARGB representation of a color with the given HCT values.
func SolveToInt(hueDegrees, chroma, tone float64) uint32 {
	if chroma < 0.0001 || tone < 0.0001 || tone > 99.9999 {
		return utils.ArgbFromLstar(tone)
	}

	hueDegrees = utils.SanitizeDegreesDouble(hueDegrees)
	hueRadians := hueDegrees / 180 * math.Pi
	y := utils.YFromLstar(tone)
	exactAnswer := findResultByJ(hueRadians, chroma, y)

	if exactAnswer != 0 {
		return exactAnswer
	}

	linrgb := bisectToLimit(y, hueRadians)
	return utils.ArgbFromLinrgb(linrgb)
}

// findResultByJ attempts to find a solution by binary searching on J (lightness).
func findResultByJ(hueRadians, chroma, y float64) uint32 {
	j := math.Sqrt(y) * 11.0
	viewingConditions := DefaultViewingConditions
	tInnerCoeff := 1 / math.Pow(1.64-math.Pow(0.29, viewingConditions.N), 0.73)
	eHue := 0.25 * (math.Cos(hueRadians+2.0) + 3.8)
	p1 := eHue * (50000.0 / 13.0) * viewingConditions.Nc * viewingConditions.Ncb
	hSin := math.Sin(hueRadians)
	hCos := math.Cos(hueRadians)

	for iterationRound := 0; iterationRound < 5; iterationRound++ {
		jNormalized := j / 100.0
		var alpha float64
		if chroma == 0.0 || j == 0.0 {
			alpha = 0.0
		} else {
			alpha = chroma / math.Sqrt(jNormalized)
		}
		t := math.Pow(alpha*tInnerCoeff, 1.0/0.9)
		ac := viewingConditions.Aw * math.Pow(jNormalized, 1.0/viewingConditions.C/viewingConditions.Z)
		p2 := ac / viewingConditions.Nbb
		gamma := 23.0 * (p2 + 0.305) * t / (23.0*p1 + 11*t*hCos + 108.0*t*hSin)
		a := gamma * hCos
		b := gamma * hSin
		rA := (460.0*p2 + 451.0*a + 288.0*b) / 1403.0
		gA := (460.0*p2 - 891.0*a - 261.0*b) / 1403.0
		bA := (460.0*p2 - 220.0*a - 6300.0*b) / 1403.0

		rCScaled := inverseChromaticAdaptation(rA)
		gCScaled := inverseChromaticAdaptation(gA)
		bCScaled := inverseChromaticAdaptation(bA)

		linrgb := utils.MatrixMultiply(
			[]float64{rCScaled, gCScaled, bCScaled},
			linrgbFromScaledDiscount,
		)

		if linrgb[0] < 0 || linrgb[1] < 0 || linrgb[2] < 0 {
			return 0
		}

		kR := yFromLinrgb[0]
		kG := yFromLinrgb[1]
		kB := yFromLinrgb[2]
		fnj := kR*linrgb[0] + kG*linrgb[1] + kB*linrgb[2]
		if fnj <= 0 {
			return 0
		}

		if iterationRound == 4 || math.Abs(fnj-y) < 0.002 {
			if linrgb[0] > 100.01 || linrgb[1] > 100.01 || linrgb[2] > 100.01 {
				return 0
			}
			return utils.ArgbFromLinrgb(linrgb)
		}

		j = j - (fnj-y)*j/(2*fnj)
	}

	return 0
}

// bisectToLimit uses bisection to approach the maximum chroma.
func bisectToLimit(y, targetHue float64) []float64 {
	segment := bisectToSegment(y, targetHue)
	left := segment[0]
	leftHue := hueOf(left)
	right := segment[1]

	for axis := 0; axis < 3; axis++ {
		if left[axis] != right[axis] {
			lPlane := -1
			rPlane := 255
			if left[axis] < right[axis] {
				lPlane = criticalPlaneBelow(trueDelinearized(left[axis]))
				rPlane = criticalPlaneAbove(trueDelinearized(right[axis]))
			} else {
				lPlane = criticalPlaneAbove(trueDelinearized(left[axis]))
				rPlane = criticalPlaneBelow(trueDelinearized(right[axis]))
			}
			for i := 0; i < 8; i++ {
				if math.Abs(float64(rPlane-lPlane)) <= 1 {
					break
				} else {
					mPlane := int(math.Floor(float64(lPlane+rPlane) / 2.0))
					midPlaneCoordinate := criticalPlanes[mPlane]
					mid := setCoordinate(left, midPlaneCoordinate, right, axis)
					midHue := hueOf(mid)
					if areInCyclicOrder(leftHue, targetHue, midHue) {
						right = mid
						rPlane = mPlane
					} else {
						left = mid
						leftHue = midHue
						lPlane = mPlane
					}
				}
			}
		}
	}
	return midpoint(left, right)
}

// bisectToSegment finds the segment containing the desired color.
func bisectToSegment(y, targetHue float64) [][]float64 {
	left := []float64{-1.0, -1.0, -1.0}
	right := left
	leftHue := 0.0
	rightHue := 0.0
	initialized := false
	uncut := true

	for n := 0; n < 12; n++ {
		mid := nthVertex(y, n)
		if mid[0] < 0 {
			continue
		}
		midHue := hueOf(mid)
		if !initialized {
			left = mid
			right = mid
			leftHue = midHue
			rightHue = midHue
			initialized = true
			continue
		}
		if uncut || areInCyclicOrder(leftHue, midHue, rightHue) {
			uncut = false
			if areInCyclicOrder(leftHue, targetHue, midHue) {
				right = mid
				rightHue = midHue
			} else {
				left = mid
				leftHue = midHue
			}
		}
	}
	return [][]float64{left, right}
}

// nthVertex finds the nth vertex of the RGB cube.
func nthVertex(y float64, n int) []float64 {
	kR := yFromLinrgb[0]
	kG := yFromLinrgb[1]
	kB := yFromLinrgb[2]
	var coordA, coordB float64
	if n%4 <= 1 {
		coordA = 0.0
	} else {
		coordA = 100.0
	}
	if n%2 == 0 {
		coordB = 0.0
	} else {
		coordB = 100.0
	}

	if n < 4 {
		g := coordA
		b := coordB
		r := (y - g*kG - b*kB) / kR
		if isBounded(r) {
			return []float64{r, g, b}
		} else {
			return []float64{-1.0, -1.0, -1.0}
		}
	} else if n < 8 {
		b := coordA
		r := coordB
		g := (y - r*kR - b*kB) / kG
		if isBounded(g) {
			return []float64{r, g, b}
		} else {
			return []float64{-1.0, -1.0, -1.0}
		}
	} else {
		r := coordA
		g := coordB
		b := (y - r*kR - g*kG) / kB
		if isBounded(b) {
			return []float64{r, g, b}
		} else {
			return []float64{-1.0, -1.0, -1.0}
		}
	}
}

// Helper functions
func inverseChromaticAdaptation(adapted float64) float64 {
	adaptedAbs := math.Abs(adapted)
	base := math.Max(0, 27.13*adaptedAbs/(400.0-adaptedAbs))
	return utils.Signum(adapted) * math.Pow(base, 1.0/0.42)
}

func chromaticAdaptation(component float64) float64 {
	af := math.Pow(math.Abs(component), 0.42)
	return utils.Signum(component) * 400.0 * af / (af + 27.13)
}

func hueOf(linrgb []float64) float64 {
	scaledDiscount := utils.MatrixMultiply(linrgb, scaledDiscountFromLinrgb)
	rA := chromaticAdaptation(scaledDiscount[0])
	gA := chromaticAdaptation(scaledDiscount[1])
	bA := chromaticAdaptation(scaledDiscount[2])
	// redness-greenness
	a := (11.0*rA + (-12.0)*gA + bA) / 11.0
	// yellowness-blueness
	b := (rA + gA - 2.0*bA) / 9.0
	return math.Atan2(b, a)
}

func sanitizeRadians(angle float64) float64 {
	return math.Mod(angle+math.Pi*8, math.Pi*2)
}

func areInCyclicOrder(a, b, c float64) bool {
	deltaAB := sanitizeRadians(b - a)
	deltaAC := sanitizeRadians(c - a)
	return deltaAB < deltaAC
}

func midpoint(a, b []float64) []float64 {
	return []float64{(a[0] + b[0]) / 2, (a[1] + b[1]) / 2, (a[2] + b[2]) / 2}
}

func criticalPlaneBelow(x float64) int {
	return int(math.Floor(x - 0.5))
}

func criticalPlaneAbove(x float64) int {
	return int(math.Ceil(x - 0.5))
}

func trueDelinearized(rgbComponent float64) float64 {
	normalized := rgbComponent / 100.0
	var delinearized float64
	if normalized <= 0.0031308 {
		delinearized = normalized * 12.92
	} else {
		delinearized = 1.055*math.Pow(normalized, 1.0/2.4) - 0.055
	}
	return delinearized * 255.0
}

func setCoordinate(source []float64, coordinate float64, target []float64, axis int) []float64 {
	t := (coordinate - source[axis]) / (target[axis] - source[axis])
	result := make([]float64, len(source))
	for i := range result {
		result[i] = source[i] + t*(target[i]-source[i])
	}
	return result
}

func isBounded(value float64) bool {
	return value >= 0.0 && value <= 100.0
}
