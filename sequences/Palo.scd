var o, p;
o = [
	Dictionary.prNew,  Array.prNew(64),  Array.prNew(6),  Array.prNew(6),  
	Array.prNew(5),  Array.prNew(7),  Array.prNew(11),  Array.prNew(2),  
	Array.prNew(2),  Array.prNew(1),  Array.prNew(6),  Array.prNew(6),  
	Array.prNew(6),  Array.prNew(6),  Array.prNew(6),  Array.prNew(6),  
	Array.prNew(6)
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
		'bpm',  129.55457227139,  'indices',  o[10],  
		nil,  nil,  'humAmp',  o[11],  
		nil,  nil,  nil,  nil,  
		'pitches',  o[12],  'humTime',  o[13],  
		nil,  nil,  'volumes',  o[14],  
		nil,  nil,  nil,  nil,  
		'humPitch',  o[15],  nil,  nil,  
		nil,  nil,  'sampleIndices',  o[16],  
		nil,  nil,  nil,  nil,  
		nil,  nil,  nil,  nil,  
		nil,  nil,  nil,  nil ],  
	// Array
	2, [ true,  false,  true,  true,  
		false,  false ],  
	// Array
	3, [ o[4],  o[5],  o[6],  o[7],  
		o[8],  o[9] ],  
	// Array
	4, [ 0.75,  1,  0.75,  0.5,  
		1 ],  
	// Array
	5, [ 0.66666666666667,  0.66666666666667,  0.33333333333333,  0.66666666666667,  
		0.66666666666667,  0.66666666666667,  0.33333333333333 ],  
	// Array
	6, [ 0.25,  0.5,  0.25,  0.25,  
		0.5,  0.25,  0.5,  0.5,  
		0.25,  0.5,  0.25 ],  
	// Array
	7, [ -1.75,  0.25 ],  
	// Array
	8, [ 1,  1 ],  
	// Array
	9, [ 2 ],  
	// Array
	10, [ 0,  2,  2,  7,  
		15,  11 ],  
	// Array
	11, [ 0.073728813559322,  0.15454545454545,  0.073728813559322,  0.073728813559322,  
		0.073728813559322,  0.081818181818182 ],  
	// Array
	12, [ 46.0,  59.0,  58.0,  49.0,  
		55.0,  70.0 ],  
	// Array
	13, [ 0.0033898305084746,  0.012121212121212,  0.0033898305084746,  0.0033898305084746,  
		0.0096969696969697,  0.029090909090909 ],  
	// Array
	14, [ 0.50118723362727,  0.65730337078652,  1.0,  0.50118723362727,  
		0.50118723362727,  0.39325842696629 ],  
	// Array
	15, [ 0.1271186440678,  0.090909090909091,  0.1271186440678,  0.1271186440678,  
		0.1271186440678,  0.1271186440678 ],  
	// Array
	16, [ 1,  3,  0,  5,  
		4,  2 ]
];
prUnarchive(o,p);
