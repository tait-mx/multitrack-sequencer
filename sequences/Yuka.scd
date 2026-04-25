var o, p;
o = [
	Dictionary.prNew,  Array.prNew(32),  Array.prNew(6),  Array.prNew(6),  
	Array.prNew(6),  Array.prNew(6),  Array.prNew(2),  Array.prNew(6),  
	Array.prNew(11),  Array.prNew(2),  Array.prNew(1),  Array.prNew(3),  
	Array.prNew(6),  Array.prNew(6)
];
p = [
	// Dictionary
	0, [ array: o[1],  size: 7 ],  
	// Array
	1, [ 'pitches',  o[2],  nil,  nil,  
		nil,  nil,  'volumes',  o[3],  
		nil,  nil,  nil,  nil,  
		nil,  nil,  'mutes',  o[4],  
		'rhythms',  o[5],  'sampleIndices',  o[12],  
		'bpm',  136.65492957746,  'indices',  o[13],  
		nil,  nil,  nil,  nil,  
		nil,  nil,  nil,  nil ],  
	// Array
	2, [ 59.0,  53.0,  51.0,  60,  
		60,  62.0 ],  
	// Array
	3, [ 1.0,  0.58538536481818,  1.0,  0.38655322624632,  
		0.43025005075584,  0.38141287482832 ],  
	// Array
	4, [ false,  false,  true,  true,  
		true,  false ],  
	// Array
	5, [ o[6],  o[7],  o[8],  o[9],  
		o[10],  o[11] ],  
	// Array
	6, [ 1,  1 ],  
	// Array
	7, [ 0.66666666666667,  0.66666666666667,  0.66666666666667,  0.33333333333333,  
		0.33333333333333,  1.3333333333333 ],  
	// Array
	8, [ 0.5,  0.25,  0.5,  0.5,  
		0.25,  0.5,  0.5,  0.25,  
		0.25,  0.25,  0.25 ],  
	// Array
	9, [ 0.5,  0.5 ],  
	// Array
	10, [ 2 ],  
	// Array
	11, [ -1,  -0.5,  0.5 ],  
	// Array
	12, [ 0,  0,  2,  3,  
		2,  2 ],  
	// Array
	13, [ 14,  5,  3,  0,  
		6,  8 ]
];
prUnarchive(o,p);
