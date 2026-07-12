var o, p;
o = [
	Dictionary.prNew,  Array.prNew(128),  Array.prNew(9),  Array.prNew(5),  
	Array.prNew(3),  Array.prNew(3),  Array.prNew(3),  Array.prNew(3),  
	Array.prNew(3),  Array.prNew(3),  Array.prNew(3),  Array.prNew(3),  
	Array.prNew(3),  Array.prNew(2),  Array.prNew(3),  Array.prNew(3),  
	Array.prNew(1),  Array.prNew(3),  Array.prNew(3),  Array.prNew(3),  
	"llaf",  Array.prNew(3),  "llsmp",  Array.prNew(3),  
	"llsmp",  Array.prNew(4),  Array.prNew(3),  Array.prNew(3),  
	"lltp",  Array.prNew(3),  Array.prNew(3),  "llaf",  
	Array.prNew(1),  Array.prNew(3),  "coro1",  Array.prNew(1),  
	Array.prNew(3),  "coro4",  Array.prNew(9),  "Campana",  
	"",  "Shekere",  "",  "",  
	"Llamador",  "Golpe",  "CORO 1",  "CORO 2",  
	Array.prNew(9),  Array.prNew(9),  Array.prNew(9),  Array.prNew(11),  
	Array.prNew(11),  Array.prNew(11),  Array.prNew(11),  Array.prNew(11),  
	Array.prNew(11),  Array.prNew(11),  Array.prNew(11),  Array.prNew(11),  
	Array.prNew(9),  Array.prNew(9),  Array.prNew(9),  Array.prNew(9),  
	Array.prNew(9),  Array.prNew(9),  Array.prNew(9),  Array.prNew(9)
];
p = [
	// Dictionary
	0, [ array: o[1],  size: 19 ],  
	// Array
	1, [ nil,  nil,  nil,  nil,  
		nil,  nil,  nil,  nil,  
		'chorusRefBpm',  105,  nil,  nil,  
		'choirSetIdx2',  0,  nil,  nil,  
		'rhythms',  o[2],  nil,  nil,  
		'choirSetIdx',  2,  nil,  nil,  
		'trackNames',  o[38],  nil,  nil,  
		nil,  nil,  nil,  nil,  
		'pitches',  o[48],  'temaBpm',  105.1065830721,  
		nil,  nil,  nil,  nil,  
		'seccion',  'tema',  nil,  nil,  
		nil,  nil,  nil,  nil,  
		nil,  nil,  'currentSongIdx',  0,  
		nil,  nil,  nil,  nil,  
		nil,  nil,  nil,  nil,  
		nil,  nil,  'solos',  o[49],  
		nil,  nil,  nil,  nil,  
		'eqParams',  o[50],  nil,  nil,  
		nil,  nil,  nil,  nil,  
		nil,  nil,  'mutes',  o[60],  
		nil,  nil,  nil,  nil,  
		'indices',  o[61],  nil,  nil,  
		nil,  nil,  'humAmp',  o[62],  
		nil,  nil,  nil,  nil,  
		nil,  nil,  'humTime',  o[63],  
		nil,  nil,  'volumes',  o[64],  
		nil,  nil,  nil,  nil,  
		'humPitch',  o[65],  nil,  nil,  
		'montunoIndices',  o[66],  'sampleIndices',  o[67],  
		nil,  nil,  nil,  nil,  
		nil,  nil,  nil,  nil,  
		nil,  nil,  nil,  nil ],  
	// Array
	2, [ o[3],  o[9],  o[13],  o[16],  
		o[16],  o[18],  o[25],  o[32],  
		o[35] ],  
	// Array
	3, [ o[4],  o[5],  o[6],  o[7],  
		o[8] ],  
	// Array
	4, [ 0.66666666666667,  4,  1 ],  
	// Array
	5, [ 1.0,  4,  1 ],  
	// Array
	6, [ 0.66666666666667,  4,  1 ],  
	// Array
	7, [ 0.66666666666667,  4,  1 ],  
	// Array
	8, [ 1.0,  4,  1 ],  
	// Array
	9, [ o[10],  o[11],  o[12] ],  
	// Array
	10, [ 0.75,  0,  1 ],  
	// Array
	11, [ 0.25,  0,  1 ],  
	// Array
	12, [ -1,  0,  0 ],  
	// Array
	13, [ o[14],  o[15] ],  
	// Array
	14, [ 0.66666666666667,  7,  1 ],  
	// Array
	15, [ 0.33333333333333,  8,  1 ],  
	// Array
	16, [ o[17] ],  
	// Array
	17, [ 4,  0,  0 ],  
	// Array
	18, [ o[19],  o[21],  o[23] ],  
	// Array
	19, [ 0.66666666666667,  o[20],  1.5 ],  
	// Array
	21, [ 0.33333333333333,  o[22],  1 ],  
	// Array
	23, [ 1,  o[24],  1 ],  
	// Array
	25, [ o[26],  o[27],  o[29],  o[30] ],  
	// Array
	26, [ 0.33333333333333,  1,  0 ],  
	// Array
	27, [ 0.66666666666667,  o[28],  1 ],  
	// Array
	29, [ 0.33333333333333,  9,  0 ],  
	// Array
	30, [ 0.66666666666667,  o[31],  1.5 ],  
	// Array
	32, [ o[33] ],  
	// Array
	33, [ 64,  o[34],  1 ],  
	// Array
	35, [ o[36] ],  
	// Array
	36, [ 16,  o[37],  1 ],  
	// Array
	38, [ o[39],  o[40],  o[41],  o[42],  
		o[43],  o[44],  o[45],  o[46],  
		o[47] ],  
	// Array
	48, [ 59.0,  54.0,  54.0,  60,  
		54.0,  61.0,  58.0,  59.0,  
		59.0 ],  
	// Array
	49, [ false,  false,  false,  false,  
		false,  false,  false,  false,  
		false ],  
	// Array
	50, [ o[51],  o[52],  o[53],  o[54],  
		o[55],  o[56],  o[57],  o[58],  
		o[59] ],  
	// Array
	51, [ 265.08772819178,  0,  5.1898010283689,  1089.6207143201,  
		6.4962071432007,  2.7394425152227,  3632.4532412149,  8.4313682755227,  
		7.9255406275383,  false,  0.0 ],  
	// Array
	52, [ 200,  0,  0.707,  1110.3448275862,  
		10.758620689655,  8.1763157894737,  14103.448275862,  24,  
		7.9157894736842,  false,  0 ],  
	// Array
	53, [ 200,  0,  0.707,  1000,  
		0,  0.707,  5000,  0,  
		0.707,  false,  0 ],  
	// Array
	54, [ 200,  0,  0.707,  1000,  
		0,  0.707,  5000,  0,  
		0.707,  false,  0 ],  
	// Array
	55, [ 200,  0,  0.707,  1000,  
		0,  0.707,  5000,  0,  
		0.707,  false,  0 ],  
	// Array
	56, [ 200,  0,  0.707,  2848.275862069,  
		0,  4.7894736842105,  4603.4482758621,  19.862068965517,  
		4.2684210526316,  false,  0 ],  
	// Array
	57, [ 193.38633706149,  24,  10,  2351.724137931,  
		6.6206896551724,  0.707,  12137.931034483,  15.724137931034,  
		10,  false,  0.0 ],  
	// Array
	58, [ 200,  0.0,  4.1733533111564,  1000,  
		0,  0.707,  5000,  0,  
		0.707,  false,  8.1 ],  
	// Array
	59, [ 265.08772819178,  0,  5.1898010283689,  1089.6207143201,  
		6.4962071432007,  2.7394425152227,  3632.4532412149,  8.4313682755227,  
		7.9255406275383,  false,  0.0 ],  
	// Array
	60, [ false,  true,  false,  false,  
		false,  false,  false,  false,  
		false ],  
	// Array
	61, [ 3,  14,  13,  0,  
		0,  27,  18,  0,  
		3 ],  
	// Array
	62, [ 0,  0,  0,  0,  
		0,  0,  0,  0,  
		0 ],  
	// Array
	63, [ 0,  0,  0,  0,  
		0,  0,  0,  0,  
		0 ],  
	// Array
	64, [ 0.95258224244061,  1.4962356560944,  0.92596587739714,  1.4962356560944,  
		0.71496983465007,  1.006947583806,  0.97957614457689,  0.37480891402361,  
		0.43592273092306 ],  
	// Array
	65, [ 0.18181818181818,  0,  0.5,  0,  
		0,  0,  0,  0.18181818181818,  
		0.18181818181818 ],  
	// Array
	66, [ 4,  27,  13,  0,  
		0,  27,  18,  7,  
		7 ],  
	// Array
	67, [ 0,  1,  2,  3,  
		4,  5,  0,  0,  
		0 ]
];
prUnarchive(o,p);
