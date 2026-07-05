var o, p;
o = [
	Dictionary.prNew,  Array.prNew(128),  Array.prNew(8),  Array.prNew(7),  
	Array.prNew(3),  Array.prNew(3),  Array.prNew(3),  Array.prNew(3),  
	Array.prNew(3),  Array.prNew(3),  Array.prNew(3),  Array.prNew(10),  
	Array.prNew(3),  "cf",  Array.prNew(3),  "cf",  
	Array.prNew(3),  "cf",  Array.prNew(3),  "cf",  
	Array.prNew(3),  "cf",  Array.prNew(3),  "cf",  
	Array.prNew(3),  "cf",  Array.prNew(3),  "cf",  
	Array.prNew(3),  "cf",  Array.prNew(3),  "cf",  
	Array.prNew(2),  Array.prNew(3),  Array.prNew(3),  Array.prNew(1),  
	Array.prNew(3),  Array.prNew(6),  Array.prNew(3),  Array.prNew(3),  
	"llsp",  Array.prNew(3),  "llsp",  Array.prNew(3),  
	Array.prNew(3),  "llaf",  Array.prNew(3),  "llsp",  
	Array.prNew(4),  Array.prNew(3),  Array.prNew(3),  "cjncmf",  
	Array.prNew(3),  "cjncmf",  Array.prNew(3),  "cjndf",  
	Array.prNew(1),  Array.prNew(3),  "coro1",  Array.prNew(8),  
	"Clave",  "Cáscara",  "Shekere",  "----",  
	"----",  "Llamador",  "Cajon",  "CORO",  
	Array.prNew(8),  Array.prNew(8),  Array.prNew(8),  Array.prNew(11),  
	Array.prNew(11),  Array.prNew(11),  Array.prNew(11),  Array.prNew(11),  
	Array.prNew(11),  Array.prNew(11),  Array.prNew(11),  Array.prNew(8),  
	Array.prNew(8),  Array.prNew(8),  Array.prNew(8),  Array.prNew(8),  
	Array.prNew(8),  Array.prNew(8),  Array.prNew(8)
];
p = [
	// Dictionary
	0, [ array: o[1],  size: 17 ],  
	// Array
	1, [ nil,  nil,  nil,  nil,  
		nil,  nil,  nil,  nil,  
		'chorusRefBpm',  80,  nil,  nil,  
		nil,  nil,  nil,  nil,  
		'rhythms',  o[2],  nil,  nil,  
		nil,  nil,  nil,  nil,  
		'trackNames',  o[59],  nil,  nil,  
		nil,  nil,  nil,  nil,  
		'pitches',  o[68],  'temaBpm',  81.504702194357,  
		nil,  nil,  nil,  nil,  
		'seccion',  'tema',  nil,  nil,  
		nil,  nil,  nil,  nil,  
		nil,  nil,  'currentSongIdx',  1,  
		nil,  nil,  nil,  nil,  
		nil,  nil,  nil,  nil,  
		nil,  nil,  'solos',  o[69],  
		nil,  nil,  nil,  nil,  
		'eqParams',  o[70],  nil,  nil,  
		nil,  nil,  nil,  nil,  
		nil,  nil,  'mutes',  o[79],  
		nil,  nil,  nil,  nil,  
		'indices',  o[80],  nil,  nil,  
		nil,  nil,  'humAmp',  o[81],  
		nil,  nil,  nil,  nil,  
		nil,  nil,  'humTime',  o[82],  
		nil,  nil,  'volumes',  o[83],  
		nil,  nil,  nil,  nil,  
		'humPitch',  o[84],  nil,  nil,  
		'montunoIndices',  o[85],  'sampleIndices',  o[86],  
		nil,  nil,  nil,  nil,  
		nil,  nil,  nil,  nil,  
		nil,  nil,  nil,  nil ],  
	// Array
	2, [ o[3],  o[11],  o[32],  o[35],  
		o[35],  o[37],  o[48],  o[56] ],  
	// Array
	3, [ o[4],  o[5],  o[6],  o[7],  
		o[8],  o[9],  o[10] ],  
	// Array
	4, [ 0.75,  2,  1 ],  
	// Array
	5, [ 0.25,  2,  1 ],  
	// Array
	6, [ 0.75,  2,  1 ],  
	// Array
	7, [ 0.25,  2,  1 ],  
	// Array
	8, [ 0.5,  2,  1 ],  
	// Array
	9, [ 0.5,  2,  1 ],  
	// Array
	10, [ 1,  2,  1 ],  
	// Array
	11, [ o[12],  o[14],  o[16],  o[18],  
		o[20],  o[22],  o[24],  o[26],  
		o[28],  o[30] ],  
	// Array
	12, [ 0.5,  o[13],  1 ],  
	// Array
	14, [ 0.25,  o[15],  1 ],  
	// Array
	16, [ 0.5,  o[17],  1 ],  
	// Array
	18, [ 0.5,  o[19],  1 ],  
	// Array
	20, [ 0.25,  o[21],  1 ],  
	// Array
	22, [ 0.5,  o[23],  1 ],  
	// Array
	24, [ 0.5,  o[25],  1 ],  
	// Array
	26, [ 0.25,  o[27],  1 ],  
	// Array
	28, [ 0.5,  o[29],  1 ],  
	// Array
	30, [ 0.25,  o[31],  1 ],  
	// Array
	32, [ o[33],  o[34] ],  
	// Array
	33, [ 3.75,  7,  1 ],  
	// Array
	34, [ 0.25,  8,  1 ],  
	// Array
	35, [ o[36] ],  
	// Array
	36, [ 4,  0,  0 ],  
	// Array
	37, [ o[38],  o[39],  o[41],  o[43],  
		o[44],  o[46] ],  
	// Array
	38, [ 0.46875,  0,  0 ],  
	// Array
	39, [ 0.28125,  o[40],  1 ],  
	// Array
	41, [ 0.25,  o[42],  1 ],  
	// Array
	43, [ 0.46875,  0,  0 ],  
	// Array
	44, [ 0.28125,  o[45],  1 ],  
	// Array
	46, [ 0.25,  o[47],  1 ],  
	// Array
	48, [ o[49],  o[50],  o[52],  o[54] ],  
	// Array
	49, [ 0.75,  0,  0 ],  
	// Array
	50, [ 0.25,  o[51],  1 ],  
	// Array
	52, [ 0.5,  o[53],  1 ],  
	// Array
	54, [ 0.5,  o[55],  1 ],  
	// Array
	56, [ o[57] ],  
	// Array
	57, [ 88,  o[58],  1 ],  
	// Array
	59, [ o[60],  o[61],  o[62],  o[63],  
		o[64],  o[65],  o[66],  o[67] ],  
	// Array
	68, [ 47.0,  54.0,  59.0,  60,  
		59.0,  57.0,  55.0,  47.0 ],  
	// Array
	69, [ false,  false,  false,  false,  
		false,  false,  false,  false ],  
	// Array
	70, [ o[71],  o[72],  o[73],  o[74],  
		o[75],  o[76],  o[77],  o[78] ],  
	// Array
	71, [ 265.08772819178,  0,  5.1898010283689,  1089.6207143201,  
		6.4962071432007,  2.7394425152227,  3632.4532412149,  8.4313682755227,  
		7.9255406275383,  false,  2.4 ],  
	// Array
	72, [ 200,  0,  0.707,  1110.3448275862,  
		10.758620689655,  8.1763157894737,  14103.448275862,  24,  
		7.9157894736842,  false,  0 ],  
	// Array
	73, [ 200,  0,  0.707,  1000,  
		0,  0.707,  5000,  0,  
		0.707,  false,  0 ],  
	// Array
	74, [ 200,  0,  0.707,  1000,  
		0,  0.707,  5000,  0,  
		0.707,  false,  0 ],  
	// Array
	75, [ 200,  0,  0.707,  1000,  
		0,  0.707,  5000,  0,  
		0.707,  false,  0 ],  
	// Array
	76, [ 200,  0,  0.707,  664.57989548682,  
		6.763790240975,  6.9981960344416,  4603.4482758621,  19.862068965517,  
		4.2684210526316,  false,  0 ],  
	// Array
	77, [ 137.79144844185,  20.299183623335,  10,  2351.724137931,  
		6.6206896551724,  0.707,  12137.931034483,  15.724137931034,  
		10,  false,  3.1 ],  
	// Array
	78, [ 116.0,  22.740002615824,  8.6565715252332,  1000,  
		0,  0.707,  5000,  0,  
		0.707,  false,  0 ],  
	// Array
	79, [ false,  false,  false,  true,  
		true,  false,  false,  false ],  
	// Array
	80, [ 2,  6,  10,  0,  
		0,  25,  22,  0 ],  
	// Array
	81, [ 0,  0,  0,  0,  
		0,  0,  0,  0 ],  
	// Array
	82, [ 0.0088135593220339,  0.0088135593220339,  0.0088135593220339,  0.0088135593220339,  
		0.0088135593220339,  0.0088135593220339,  0.0088135593220339,  0.0088135593220339 ],  
	// Array
	83, [ 1.1057207257138,  1.1494678363437,  1.3648527477948,  1.3971321692305,  
		0.7,  1.1057207257138,  1.1057207257138,  1.4962356560944 ],  
	// Array
	84, [ 0.15254237288136,  0.15254237288136,  0.15254237288136,  0.15254237288136,  
		0.15254237288136,  0.15254237288136,  0.15254237288136,  0.15254237288136 ],  
	// Array
	85, [ 2,  6,  10,  0,  
		0,  25,  17,  1 ],  
	// Array
	86, [ 0,  1,  2,  3,  
		4,  5,  0,  0 ]
];
prUnarchive(o,p);
