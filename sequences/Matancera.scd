var o, p;
o = [
	Dictionary.prNew,  Array.prNew(64),  Array.prNew(7),  Array.prNew(7),  
	Array.prNew(7),  Array.prNew(3),  Array.prNew(3),  Array.prNew(3),  
	Array.prNew(3),  Array.prNew(3),  Array.prNew(3),  Array.prNew(3),  
	Array.prNew(10),  Array.prNew(3),  Array.prNew(3),  Array.prNew(3),  
	Array.prNew(3),  Array.prNew(3),  Array.prNew(3),  Array.prNew(3),  
	Array.prNew(3),  Array.prNew(3),  Array.prNew(3),  Array.prNew(2),  
	Array.prNew(3),  Array.prNew(3),  Array.prNew(2),  Array.prNew(3),  
	Array.prNew(3),  Array.prNew(2),  Array.prNew(3),  Array.prNew(3),  
	Array.prNew(6),  Array.prNew(3),  Array.prNew(3),  Array.prNew(3),  
	Array.prNew(3),  Array.prNew(3),  "lla",  Array.prNew(3),  
	Array.prNew(8),  Array.prNew(3),  Array.prNew(3),  Array.prNew(3),  
	Array.prNew(3),  Array.prNew(3),  Array.prNew(3),  Array.prNew(3),  
	Array.prNew(3),  Array.prNew(7),  Array.prNew(7),  Array.prNew(7),  
	Array.prNew(7),  Array.prNew(7),  Array.prNew(7),  Array.prNew(7)
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
		'bpm',  87.429467084639,  'indices',  o[49],  
		nil,  nil,  'humAmp',  o[50],  
		nil,  nil,  nil,  nil,  
		'pitches',  o[51],  'humTime',  o[52],  
		nil,  nil,  'volumes',  o[53],  
		nil,  nil,  nil,  nil,  
		'humPitch',  o[54],  nil,  nil,  
		nil,  nil,  'sampleIndices',  o[55],  
		nil,  nil,  nil,  nil,  
		nil,  nil,  nil,  nil,  
		nil,  nil,  nil,  nil ],  
	// Array
	2, [ true,  true,  true,  true,  
		true,  false,  true ],  
	// Array
	3, [ o[4],  o[12],  o[23],  o[26],  
		o[29],  o[32],  o[40] ],  
	// Array
	4, [ o[5],  o[6],  o[7],  o[8],  
		o[9],  o[10],  o[11] ],  
	// Array
	5, [ 0.75,  2,  1 ],  
	// Array
	6, [ 0.25,  2,  1 ],  
	// Array
	7, [ 0.75,  2,  1 ],  
	// Array
	8, [ 0.25,  2,  1 ],  
	// Array
	9, [ 0.5,  2,  1 ],  
	// Array
	10, [ 0.5,  2,  1 ],  
	// Array
	11, [ 1,  2,  1 ],  
	// Array
	12, [ o[13],  o[14],  o[15],  o[16],  
		o[17],  o[18],  o[19],  o[20],  
		o[21],  o[22] ],  
	// Array
	13, [ 0.5,  0,  1 ],  
	// Array
	14, [ 0.25,  0,  1 ],  
	// Array
	15, [ 0.5,  0,  1 ],  
	// Array
	16, [ 0.5,  0,  1 ],  
	// Array
	17, [ 0.25,  0,  1 ],  
	// Array
	18, [ 0.5,  0,  1 ],  
	// Array
	19, [ 0.5,  0,  1 ],  
	// Array
	20, [ 0.25,  0,  1 ],  
	// Array
	21, [ 0.5,  0,  1 ],  
	// Array
	22, [ 0.25,  0,  1 ],  
	// Array
	23, [ o[24],  o[25] ],  
	// Array
	24, [ 3.75,  7,  1 ],  
	// Array
	25, [ 0.25,  8,  1 ],  
	// Array
	26, [ o[27],  o[28] ],  
	// Array
	27, [ 1,  0,  1 ],  
	// Array
	28, [ 1,  0,  1 ],  
	// Array
	29, [ o[30],  o[31] ],  
	// Array
	30, [ 3.75,  7,  1 ],  
	// Array
	31, [ 0.25,  8,  1 ],  
	// Array
	32, [ o[33],  o[34],  o[35],  o[36],  
		o[37],  o[39] ],  
	// Array
	33, [ 0.46875,  0,  0 ],  
	// Array
	34, [ 0.28125,  9,  1 ],  
	// Array
	35, [ 0.25,  9,  1 ],  
	// Array
	36, [ 0.46875,  0,  0 ],  
	// Array
	37, [ 0.28125,  o[38],  1 ],  
	// Array
	39, [ 0.25,  9,  1 ],  
	// Array
	40, [ o[41],  o[42],  o[43],  o[44],  
		o[45],  o[46],  o[47],  o[48] ],  
	// Array
	41, [ 0.75,  1,  0.35 ],  
	// Array
	42, [ 0.25,  1,  0.35 ],  
	// Array
	43, [ 0.5,  1,  0.35 ],  
	// Array
	44, [ 0.5,  3,  1 ],  
	// Array
	45, [ 0.75,  1,  0.35 ],  
	// Array
	46, [ 0.25,  1,  0.35 ],  
	// Array
	47, [ 0.5,  1,  0.35 ],  
	// Array
	48, [ 0.5,  3,  1 ],  
	// Array
	49, [ 1,  5,  9,  25,  
		15,  20,  15 ],  
	// Array
	50, [ 0.027966101694915,  0.027966101694915,  0.027966101694915,  0.027966101694915,  
		0.027966101694915,  0.027966101694915,  0.027966101694915 ],  
	// Array
	51, [ 47.0,  60,  59.0,  60,  
		59.0,  56.0,  63.0 ],  
	// Array
	52, [ 0.0088135593220339,  0.0088135593220339,  0.0088135593220339,  0.0088135593220339,  
		0.0088135593220339,  0.0088135593220339,  0.0088135593220339 ],  
	// Array
	53, [ 1.1057207257138,  0.7,  1.3648527477948,  1.3971321692305,  
		0.7,  0.97957614457689,  0.97957614457689 ],  
	// Array
	54, [ 0.15254237288136,  0.15254237288136,  0.15254237288136,  0.15254237288136,  
		0.15254237288136,  0.15254237288136,  0.15254237288136 ],  
	// Array
	55, [ 0,  1,  2,  3,  
		4,  5,  0 ]
];
prUnarchive(o,p);
