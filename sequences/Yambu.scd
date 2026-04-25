var o, p;
o = [
	Dictionary.prNew,  Array.prNew(32),  Array.prNew(6),  Array.prNew(6),  
	Array.prNew(6),  Array.prNew(6),  Array.prNew(7),  Array.prNew(1),  
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
		'bpm',  92.380281690141,  'indices',  o[13],  
		nil,  nil,  nil,  nil,  
		nil,  nil,  nil,  nil ],  
	// Array
	2, [ 43.0,  71.0,  59.0,  54.0,  
		52.0,  58.0 ],  
	// Array
	3, [ 0.50118723362727,  0.50118723362727,  1.0,  0.50118723362727,  
		0.50118723362727,  0.50118723362727 ],  
	// Array
	4, [ false,  true,  false,  false,  
		false,  false ],  
	// Array
	5, [ o[6],  o[7],  o[8],  o[9],  
		o[10],  o[11] ],  
	// Array
	6, [ 0.75,  0.25,  0.75,  0.25,  
		0.5,  0.5,  1 ],  
	// Array
	7, [ 0.25 ],  
	// Array
	8, [ 0.25,  0.5,  0.25,  0.25,  
		0.5,  0.25,  0.5,  0.5,  
		0.25,  0.5,  0.25 ],  
	// Array
	9, [ -1.75,  0.25 ],  
	// Array
	10, [ 2 ],  
	// Array
	11, [ -1,  -0.5,  0.5 ],  
	// Array
	12, [ 1,  3,  0,  5,  
		4,  2 ],  
	// Array
	13, [ 1,  8,  2,  7,  
		6,  4 ]
];
prUnarchive(o,p);
