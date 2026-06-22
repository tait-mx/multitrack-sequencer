var o, p;
o = [
	Dictionary.prNew,  Array.prNew(64),  Array.prNew(8),  Array.prNew(8),  
	Array.prNew(7),  Array.prNew(3),  Array.prNew(3),  Array.prNew(3),  
	Array.prNew(3),  Array.prNew(3),  Array.prNew(3),  Array.prNew(3),  
	Array.prNew(10),  Array.prNew(3),  "cf",  Array.prNew(3),  
	"cf",  Array.prNew(3),  "cf",  Array.prNew(3),  
	"cf",  Array.prNew(3),  "cf",  Array.prNew(3),  
	"cf",  Array.prNew(3),  "cf",  Array.prNew(3),  
	"cf",  Array.prNew(3),  "cf",  Array.prNew(3),  
	"cf",  Array.prNew(2),  Array.prNew(3),  Array.prNew(3),  
	Array.prNew(1),  Array.prNew(3),  Array.prNew(6),  Array.prNew(3),  
	"llcp",  Array.prNew(3),  "llcp",  Array.prNew(3),  
	"llap",  Array.prNew(3),  "llcp",  Array.prNew(3),  
	"llcp",  Array.prNew(3),  "llap",  Array.prNew(8),  
	Array.prNew(3),  Array.prNew(3),  "llsmp",  Array.prNew(3),  
	"llsmp",  Array.prNew(3),  "llsmp",  Array.prNew(3),  
	Array.prNew(3),  "llsmp",  Array.prNew(3),  "llaf",  
	Array.prNew(3),  "llsmp",  Array.prNew(13),  Array.prNew(3),  
	Array.prNew(3),  "cjndf",  Array.prNew(3),  "cjndf",  
	Array.prNew(3),  "cjncmf",  Array.prNew(3),  "cjncmf",  
	Array.prNew(3),  "cjndf",  Array.prNew(3),  "cjndf",  
	Array.prNew(3),  "cjndf",  Array.prNew(3),  "cjndf",  
	Array.prNew(3),  "cjncf",  Array.prNew(3),  "cjncmf",  
	Array.prNew(3),  "cjndf",  Array.prNew(3),  "cjndf",  
	Array.prNew(1),  Array.prNew(3),  "coro2",  Array.prNew(8),  
	Array.prNew(8),  "Clave",  "Cáscara",  "Shekere",  
	"----",  "----",  "Llamador",  "Cajon",  
	"CORO",  Array.prNew(8),  Array.prNew(8),  Array.prNew(8),  
	Array.prNew(8),  Array.prNew(8),  Array.prNew(8)
];
p = [
	// Dictionary
	0, [ array: o[1],  size: 13 ],  
	// Array
	1, [ nil,  nil,  nil,  nil,  
		nil,  nil,  nil,  nil,  
		'chorusRefBpm',  80,  nil,  nil,  
		nil,  nil,  'mutes',  o[2],  
		'rhythms',  o[3],  nil,  nil,  
		'bpm',  79.968652037618,  'indices',  o[95],  
		'trackNames',  o[96],  'humAmp',  o[105],  
		nil,  nil,  nil,  nil,  
		'pitches',  o[106],  'humTime',  o[107],  
		nil,  nil,  'volumes',  o[108],  
		nil,  nil,  nil,  nil,  
		'humPitch',  o[109],  nil,  nil,  
		nil,  nil,  'sampleIndices',  o[110],  
		'currentSongIdx',  1,  nil,  nil,  
		nil,  nil,  nil,  nil,  
		nil,  nil,  nil,  nil ],  
	// Array
	2, [ false,  false,  false,  true,  
		true,  false,  false,  false ],  
	// Array
	3, [ o[4],  o[12],  o[33],  o[36],  
		o[38],  o[51],  o[66],  o[92] ],  
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
	12, [ o[13],  o[15],  o[17],  o[19],  
		o[21],  o[23],  o[25],  o[27],  
		o[29],  o[31] ],  
	// Array
	13, [ 0.5,  o[14],  1 ],  
	// Array
	15, [ 0.25,  o[16],  1 ],  
	// Array
	17, [ 0.5,  o[18],  1 ],  
	// Array
	19, [ 0.5,  o[20],  1 ],  
	// Array
	21, [ 0.25,  o[22],  1 ],  
	// Array
	23, [ 0.5,  o[24],  1 ],  
	// Array
	25, [ 0.5,  o[26],  1 ],  
	// Array
	27, [ 0.25,  o[28],  1 ],  
	// Array
	29, [ 0.5,  o[30],  1 ],  
	// Array
	31, [ 0.25,  o[32],  1 ],  
	// Array
	33, [ o[34],  o[35] ],  
	// Array
	34, [ 3.75,  7,  1 ],  
	// Array
	35, [ 0.25,  8,  1 ],  
	// Array
	36, [ o[37] ],  
	// Array
	37, [ 0.25,  0,  1 ],  
	// Array
	38, [ o[39],  o[41],  o[43],  o[45],  
		o[47],  o[49] ],  
	// Array
	39, [ 1,  o[40],  0.25 ],  
	// Array
	41, [ 0.5,  o[42],  0.25 ],  
	// Array
	43, [ 0.5,  o[44],  1 ],  
	// Array
	45, [ 1,  o[46],  0.25 ],  
	// Array
	47, [ 0.5,  o[48],  0.25 ],  
	// Array
	49, [ 0.5,  o[50],  1 ],  
	// Array
	51, [ o[52],  o[53],  o[55],  o[57],  
		o[59],  o[60],  o[62],  o[64] ],  
	// Array
	52, [ 0.25,  0,  0 ],  
	// Array
	53, [ 0.25,  o[54],  1 ],  
	// Array
	55, [ 0.25,  o[56],  1 ],  
	// Array
	57, [ 0.25,  o[58],  1 ],  
	// Array
	59, [ 0.25,  0,  0 ],  
	// Array
	60, [ 0.25,  o[61],  1 ],  
	// Array
	62, [ 0.25,  o[63],  1 ],  
	// Array
	64, [ 0.25,  o[65],  1 ],  
	// Array
	66, [ o[67],  o[68],  o[70],  o[72],  
		o[74],  o[76],  o[78],  o[80],  
		o[82],  o[84],  o[86],  o[88],  
		o[90] ],  
	// Array
	67, [ 0.25,  0,  0 ],  
	// Array
	68, [ 0.25,  o[69],  1 ],  
	// Array
	70, [ 0.25,  o[71],  1 ],  
	// Array
	72, [ 0.25,  o[73],  1 ],  
	// Array
	74, [ 0.25,  o[75],  1 ],  
	// Array
	76, [ 0.5,  o[77],  1 ],  
	// Array
	78, [ 0.25,  o[79],  1 ],  
	// Array
	80, [ 0.5,  o[81],  1 ],  
	// Array
	82, [ 0.25,  o[83],  1 ],  
	// Array
	84, [ 0.25,  o[85],  1 ],  
	// Array
	86, [ 0.25,  o[87],  1 ],  
	// Array
	88, [ 0.5,  o[89],  1 ],  
	// Array
	90, [ 0.25,  o[91],  1 ],  
	// Array
	92, [ o[93] ],  
	// Array
	93, [ 16,  o[94],  1 ],  
	// Array
	95, [ 2,  6,  10,  25,  
		15,  24,  21,  1 ],  
	// Array
	96, [ o[97],  o[98],  o[99],  o[100],  
		o[101],  o[102],  o[103],  o[104] ],  
	// Array
	105, [ 0.027966101694915,  0.027966101694915,  0.027966101694915,  0.027966101694915,  
		0.027966101694915,  0.027966101694915,  0.027966101694915,  0.027966101694915 ],  
	// Array
	106, [ 47.0,  56.0,  59.0,  60,  
		59.0,  59.0,  59.0,  47.0 ],  
	// Array
	107, [ 0.0088135593220339,  0.0088135593220339,  0.0088135593220339,  0.0088135593220339,  
		0.0088135593220339,  0.0088135593220339,  0.0088135593220339,  0.0088135593220339 ],  
	// Array
	108, [ 1.1057207257138,  1.0346965601279,  1.3648527477948,  1.3971321692305,  
		0.7,  1.3488546134867,  1.2858059189866,  0.96603200137215 ],  
	// Array
	109, [ 0.15254237288136,  0.15254237288136,  0.15254237288136,  0.15254237288136,  
		0.15254237288136,  0.15254237288136,  0.15254237288136,  0.15254237288136 ],  
	// Array
	110, [ 0,  1,  2,  3,  
		4,  5,  0,  0 ]
];
prUnarchive(o,p);
