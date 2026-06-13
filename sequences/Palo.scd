var o, p;
o = [
	Dictionary.prNew,  Array.prNew(64),  Array.prNew(7),  Array.prNew(7),  
	Array.prNew(5),  Array.prNew(3),  Array.prNew(3),  Array.prNew(3),  
	Array.prNew(3),  Array.prNew(3),  Array.prNew(2),  Array.prNew(3),  
	Array.prNew(3),  Array.prNew(2),  Array.prNew(3),  Array.prNew(3),  
	Array.prNew(2),  Array.prNew(3),  Array.prNew(3),  Array.prNew(2),  
	Array.prNew(3),  Array.prNew(3),  Array.prNew(3),  Array.prNew(3),  
	"llaf",  Array.prNew(3),  "llsmp",  Array.prNew(3),  
	"llsmp",  Array.prNew(4),  Array.prNew(3),  Array.prNew(3),  
	"lltmp",  Array.prNew(3),  Array.prNew(3),  "llaf",  
	Array.prNew(7),  Array.prNew(7),  "Track 0",  "Track 1",  
	"Track 2",  "Track 3",  "Track 4",  "Track 5",  
	"Track 6",  Array.prNew(7),  Array.prNew(7),  Array.prNew(7),  
	Array.prNew(7),  Array.prNew(7),  Array.prNew(7)
];
p = [
	// Dictionary
	0, [ array: o[1],  size: 11 ],  
	// Array
	1, [ nil,  nil,  nil,  nil,  
		nil,  nil,  nil,  nil,  
		nil,  nil,  nil,  nil,  
		nil,  nil,  'mutes',  o[2],  
		'rhythms',  o[3],  nil,  nil,  
		'bpm',  127.36677115987,  'indices',  o[36],  
		'trackNames',  o[37],  'humAmp',  o[45],  
		nil,  nil,  nil,  nil,  
		'pitches',  o[46],  'humTime',  o[47],  
		nil,  nil,  'volumes',  o[48],  
		nil,  nil,  nil,  nil,  
		'humPitch',  o[49],  nil,  nil,  
		nil,  nil,  'sampleIndices',  o[50],  
		nil,  nil,  nil,  nil,  
		nil,  nil,  nil,  nil,  
		nil,  nil,  nil,  nil ],  
	// Array
	2, [ false,  true,  false,  true,  
		true,  false,  false ],  
	// Array
	3, [ o[4],  o[10],  o[13],  o[16],  
		o[19],  o[22],  o[29] ],  
	// Array
	4, [ o[5],  o[6],  o[7],  o[8],  
		o[9] ],  
	// Array
	5, [ 0.66666666666667,  4,  1 ],  
	// Array
	6, [ 1.0,  4,  1 ],  
	// Array
	7, [ 0.66666666666667,  4,  1 ],  
	// Array
	8, [ 0.66666666666667,  4,  1 ],  
	// Array
	9, [ 1.0,  4,  1 ],  
	// Array
	10, [ o[11],  o[12] ],  
	// Array
	11, [ 1,  0,  1 ],  
	// Array
	12, [ 1,  0,  1 ],  
	// Array
	13, [ o[14],  o[15] ],  
	// Array
	14, [ 0.66666666666667,  7,  1 ],  
	// Array
	15, [ 0.33333333333333,  8,  1 ],  
	// Array
	16, [ o[17],  o[18] ],  
	// Array
	17, [ 0.5,  0,  1 ],  
	// Array
	18, [ 0.5,  0,  1 ],  
	// Array
	19, [ o[20],  o[21] ],  
	// Array
	20, [ 0.66666666666667,  7,  1 ],  
	// Array
	21, [ 0.33333333333333,  8,  1 ],  
	// Array
	22, [ o[23],  o[25],  o[27] ],  
	// Array
	23, [ 0.66666666666667,  o[24],  1.5 ],  
	// Array
	25, [ 0.33333333333333,  o[26],  1 ],  
	// Array
	27, [ 1,  o[28],  1 ],  
	// Array
	29, [ o[30],  o[31],  o[33],  o[34] ],  
	// Array
	30, [ 0.33333333333333,  1,  0 ],  
	// Array
	31, [ 0.66666666666667,  o[32],  1 ],  
	// Array
	33, [ 0.33333333333333,  9,  0 ],  
	// Array
	34, [ 0.66666666666667,  o[35],  1.5 ],  
	// Array
	36, [ 3,  27,  13,  0,  
		18,  23,  18 ],  
	// Array
	37, [ o[38],  o[39],  o[40],  o[41],  
		o[42],  o[43],  o[44] ],  
	// Array
	45, [ 0,  0,  0,  0,  
		0,  0,  0 ],  
	// Array
	46, [ 59.0,  54.0,  54.0,  60,  
		54.0,  61.0,  58.0 ],  
	// Array
	47, [ 0.012203389830508,  0.012203389830508,  0.012203389830508,  0.012203389830508,  
		0.012203389830508,  0.012203389830508,  0.012203389830508 ],  
	// Array
	48, [ 0.95258224244061,  1.4962356560944,  0.92596587739714,  1.4962356560944,  
		0.71496983465007,  1.006947583806,  0.97957614457689 ],  
	// Array
	49, [ 0.18181818181818,  0,  0.5,  0,  
		0,  0,  0 ],  
	// Array
	50, [ 0,  1,  2,  3,  
		4,  5,  0 ]
];
prUnarchive(o,p);
