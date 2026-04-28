var o, p;
o = [
	Dictionary.prNew,  Array.prNew(64),  Array.prNew(6),  Array.prNew(6),  
	Array.prNew(2),  Array.prNew(6),  Array.prNew(4),  Array.prNew(3),  
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
		'bpm',  174.61267605634,  'indices',  o[8],  
		nil,  nil,  'humAmp',  o[9],  
		nil,  nil,  nil,  nil,  
		'pitches',  o[10],  'humTime',  o[11],  
		nil,  nil,  'volumes',  o[12],  
		nil,  nil,  nil,  nil,  
		'humPitch',  o[13],  nil,  nil,  
		nil,  nil,  'sampleIndices',  o[14],  
		nil,  nil,  nil,  nil,  
		nil,  nil,  nil,  nil,  
		nil,  nil,  nil,  nil ],  
	// Array
	2, [ false,  false,  false,  false,  
		true,  false ],  
	// Array
	3, [ o[4],  o[5],  o[6],  o[4],  
		o[4],  o[7] ],  
	// Array
	4, [ 1,  1 ],  
	// Array
	5, [ 0.66666666666667,  0.66666666666667,  0.66666666666667,  0.33333333333333,  
		0.33333333333333,  1.3333333333333 ],  
	// Array
	6, [ 0.66666666666667,  0.66666666666667,  0.66666666666667,  -2.0 ],  
	// Array
	7, [ -1,  -0.5,  0.5 ],  
	// Array
	8, [ 15,  5,  6,  15,  
		15,  8 ],  
	// Array
	9, [ 0.022881355932203,  0.022881355932203,  0.022881355932203,  0.022881355932203,  
		0.022881355932203,  0.022881355932203 ],  
	// Array
	10, [ 62.0,  52.0,  51.0,  60.0,  
		59.0,  62.0 ],  
	// Array
	11, [ 0.0054237288135593,  0.0054237288135593,  0.0054237288135593,  0.0054237288135593,  
		0.0054237288135593,  0.0054237288135593 ],  
	// Array
	12, [ 1.0,  0.58538536481818,  1.0,  1.0,  
		0.43025005075584,  0.38141287482832 ],  
	// Array
	13, [ 0.11440677966102,  0.11440677966102,  0.11440677966102,  0.11440677966102,  
		0.11440677966102,  0.11440677966102 ],  
	// Array
	14, [ 0,  0,  0,  0,  
		2,  2 ]
];
prUnarchive(o,p);
