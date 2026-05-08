var o, p;
o = [
	Dictionary.prNew,  Array.prNew(64),  Array.prNew(6),  Array.prNew(6),  
	Array.prNew(5),  Array.prNew(3),  Array.prNew(3),  Array.prNew(3),  
	Array.prNew(3),  Array.prNew(3),  Array.prNew(1),  Array.prNew(3),  
	Array.prNew(11),  Array.prNew(3),  Array.prNew(3),  Array.prNew(3),  
	Array.prNew(3),  Array.prNew(3),  Array.prNew(3),  Array.prNew(3),  
	Array.prNew(3),  Array.prNew(3),  Array.prNew(3),  Array.prNew(3),  
	Array.prNew(2),  Array.prNew(3),  Array.prNew(3),  Array.prNew(1),  
	Array.prNew(3),  Array.prNew(6),  Array.prNew(3),  Array.prNew(3),  
	Array.prNew(3),  Array.prNew(3),  Array.prNew(3),  Array.prNew(3),  
	Array.prNew(6),  Array.prNew(6),  Array.prNew(6),  Array.prNew(6),  
	Array.prNew(6),  Array.prNew(6),  Array.prNew(6)
];
p = [
	// Dictionary
	0, [ array: o[1],  size: 10 ],  
	// Array
	1, [ nil,  nil,  nil,  nil,  
		nil,  nil,  nil,  nil,  
		nil,  nil,  nil,  nil,  
		nil,  nil,  'mutes',  o[2],  
		'rhythms',  o[3],  nil,  nil,  
		'bpm',  120.0,  'indices',  o[36],  
		nil,  nil,  'humAmp',  o[37],  
		nil,  nil,  nil,  nil,  
		'pitches',  o[38],  'humTime',  o[39],  
		nil,  nil,  'volumes',  o[40],  
		nil,  nil,  nil,  nil,  
		'humPitch',  o[41],  nil,  nil,  
		nil,  nil,  'sampleIndices',  o[42],  
		nil,  nil,  nil,  nil,  
		nil,  nil,  nil,  nil,  
		nil,  nil,  nil,  nil ],  
	// Array
	2, [ false,  true,  false,  false,  
		false,  false ],  
	// Array
	3, [ o[4],  o[10],  o[12],  o[24],  
		o[27],  o[29] ],  
	// Array
	4, [ o[5],  o[6],  o[7],  o[8],  
		o[9] ],  
	// Array
	5, [ 0.75,  0,  1 ],  
	// Array
	6, [ 1,  0,  1 ],  
	// Array
	7, [ 0.7,  0,  1 ],  
	// Array
	8, [ 0.55,  0,  1 ],  
	// Array
	9, [ 1,  0,  1 ],  
	// Array
	10, [ o[11] ],  
	// Array
	11, [ 0.5,  0,  1 ],  
	// Array
	12, [ o[13],  o[14],  o[15],  o[16],  
		o[17],  o[18],  o[19],  o[20],  
		o[21],  o[22],  o[23] ],  
	// Array
	13, [ 0.25,  0,  1 ],  
	// Array
	14, [ 0.5,  0,  1 ],  
	// Array
	15, [ 0.25,  0,  1 ],  
	// Array
	16, [ 0.25,  0,  1 ],  
	// Array
	17, [ 0.5,  0,  1 ],  
	// Array
	18, [ 0.25,  0,  1 ],  
	// Array
	19, [ 0.5,  0,  1 ],  
	// Array
	20, [ 0.5,  0,  1 ],  
	// Array
	21, [ 0.25,  0,  1 ],  
	// Array
	22, [ 0.5,  0,  1 ],  
	// Array
	23, [ 0.25,  0,  1 ],  
	// Array
	24, [ o[25],  o[26] ],  
	// Array
	25, [ -1.75,  0,  1 ],  
	// Array
	26, [ 0.25,  0,  1 ],  
	// Array
	27, [ o[28] ],  
	// Array
	28, [ 2,  0,  1 ],  
	// Array
	29, [ o[30],  o[31],  o[32],  o[33],  
		o[34],  o[35] ],  
	// Array
	30, [ -1,  0,  1 ],  
	// Array
	31, [ -0.5,  0,  1 ],  
	// Array
	32, [ 0.5,  0,  1 ],  
	// Array
	33, [ -1,  0,  1 ],  
	// Array
	34, [ -0.5,  0,  1 ],  
	// Array
	35, [ 0.5,  0,  1 ],  
	// Array
	36, [ 0,  15,  4,  13,  
		12,  8 ],  
	// Array
	37, [ 0.0,  0.0,  0.0,  0.0,  
		0.0,  0.0 ],  
	// Array
	38, [ 60,  60,  60,  60,  
		60,  60 ],  
	// Array
	39, [ 0.0,  0.0,  0.0,  0.0,  
		0.0,  0.0 ],  
	// Array
	40, [ 0.7,  0.7,  0.7,  0.7,  
		0.7,  0.7 ],  
	// Array
	41, [ 0.0,  0.0,  0.0,  0.0,  
		0.0,  0.0 ],  
	// Array
	42, [ 2,  4,  0,  7,  
		8,  3 ]
];
prUnarchive(o,p);
