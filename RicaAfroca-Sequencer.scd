
/*
RicaAfroca Sequencer - Pro Version 2.5 (9-Track Edition, Tracks 7-8 Choir)
Matancera montuno is missing
Fix coro5 and coro6 length
Add reverb
Add chorus master
Only one NEXT button fot both chorus tracks
Add breaks for montuno change
*/
(

// Kill any lingering server instances to avoid UDP port conflicts
Server.killAll;

// Auto-close previous GUI on re-execute
Window.allWindows.do({ |w| if(w.name.contains("RicaAfroca")) { w.close } });
~numTracks.do({ |i| try { Tdef(("chan"++i).asSymbol).stop } });
try { ~chorusGroup.free };
try { ~myPort.close };
try { ~serialRoutine.stop };
// Discard old buffer references (server was killed above, buffers already freed)
~samples = nil;

s.waitForBoot({

	/////////////////////////////////////////////////////////////////
	// VARIABLES & INITIALIZATION
	/////////////////////////////////////////////////////////////////

	var win, startBtn, tempoSlid, bpmDisplay, saveBtn, loadBtn,
	presetNameField, presetMenu, refreshBtn,
	masterMuteBtn, masterCol, peakMeter, meterRoutine, hLayout, vRuler,
	masterHumTime, masterHumPitch, masterHumAmp, humGroup, woodImg,
	currentPresetName = "newPreset";
	var patRefBtn;

	var masterSlid, masterDisplay;

	// Round Robin dictionaries for all llamador dynamics
	~samplesDictionary = Dictionary.new;
	~samplesDictionaryLastIdx = Dictionary.new;
	~samplesDictionaryB = Dictionary.new;

	// Scaled from 7 to 8 tracks (Indices 0 to 7, track 7 is dedicated choir)
	~numTracks = 9;
	~tempo = TempoClock.new(120/60).permanent_(true);
	~masterVol = 0.8;
	~dbSpec = ControlSpec(-60, 3.5, \db, 0, 0);

	// Original BPM of the chorus samples (per-song in ~cancionRefBpms, default 105)
	~chorusRefBpm = 105;

	// Chorus patterns (separated from rhythmAndNames)
	~chorus = [
	["Ta Jose",
		["Coro0", [[4,"coro0",0]]], // Inicio en blanco
		["Coro1", [[64,"coro1",1]]], // Caminando yo venía
		["Coro2", [[32,"coro2",1]]],         // Estoy llamando un congo pa bailar bembé
		["Coro3", [[16,"coro3",1]]],   // Llámalo con la tumba llámalo Ta José
		["Coro4", [[16,"coro4",1]]],   // Eh eh Ta José todos me llaman Ta José
		["Coro5", [[8,"coro5",1]]],           // Wao wao wao Ta José (8-beat loop)
		["Coro6", [[32,"coro6",1]]],          // Sálvalo Ta José sálvalo
		["Coro7", [[8,"coro7",1]]],           // Vence batalla Ta José
		["Coro8", [[8,"coro8",1]]]            // Arriba nganga Ta José
		],
	["Alla en los Hollos",
		["Coro0", [[4,"coro0",0]]], // Inicio en blanco
		["Coro1", [[88,"coro1",1]]], // Alla en los Hollos
		["Coro2", [[16,"coro2",1]]]          // Lorenzo David
		]
	];

	~currentSongIdx = 0;

	// Logic arrays
	~temaIndices = Array.fill(~numTracks, { 0 });
	~montunoIndices = Array.fill(~numTracks, { 0 });
	~rhythmIndices = ~temaIndices;
	~seccion = \tema;
	~temaBpm = 120;
	~rhythms = Array.fill(~numTracks, { |i|
		if((i == 7) || (i == 8)) { ~chorus[0].drop(1)[0][1] } { [[0.5, 0, 1], [0.5, 0, 1]] }
	});
	~mutes = Array.fill(~numTracks, { false });
	~solos = Array.fill(~numTracks, { false });
	~pitches = Array.fill(~numTracks, { 60 });
	~volumes = Array.fill(~numTracks, { 0.7 });
	~sampleIndices = Array.fill(~numTracks, { |i| i });

	~varRequests = Array.fill(~numTracks, { false });

	// Humanize Logic Arrays
	~humanizeTime = Array.fill(~numTracks, { 0.0 });
	~humanizePitch = Array.fill(~numTracks, { 0.0 });
	~humanizeAmp = Array.fill(~numTracks, { 0.0 });

	// GUI arrays (UPDATED: ~sampleMenus changed to ~trackLabels)
	~muteButtons = Array.newClear(~numTracks);
	~soloButtons = Array.newClear(~numTracks);
	~rhythmMenus = Array.newClear(~numTracks);
	~pendingRhythmIndices = Array.fill(~numTracks, { nil });
	~pitchSliders = Array.newClear(~numTracks);
	~volSliders = Array.newClear(~numTracks);
	~trackMeters = Array.newClear(~numTracks);
	~trackLabels = Array.newClear(~numTracks);
	~volDisplays = Array.newClear(~numTracks);
	~varButtons = Array.newClear(~numTracks);
	~choirSetIdx = 0;
	~choirSetMenu = nil;
	~choirSetIdx2 = 0;
	~choirSetMenu2 = nil;
	~humTimeSliders = Array.newClear(~numTracks);
	~humPitchSliders = Array.newClear(~numTracks);
	~humAmpSliders = Array.newClear(~numTracks);
	~choirSynth = nil;
	~choirSynth2 = nil;
	~choirTriggerBtn2 = nil;

	~chorusMasterVol = 1.0;
	~chorusMasterSlider = nil;
	~chorusMasterDisplay = nil;
	~chorusMasterMeter = nil;

	// EQ system variables
	~trackAudioBuses = Array.newClear(~numTracks);
	~eqParams = Array.fill(~numTracks, {
		Dictionary.newFrom([
			\lowFreq, 200, \lowGain, 0, \lowQ, 0.707,
			\midFreq, 1000, \midGain, 0, \midQ, 0.707,
			\highFreq, 5000, \highGain, 0, \highQ, 0.707,
			\bypass, false,
			\gain, 0
		])
	});
	~eqSynths = Array.newClear(~numTracks);
	~eqWindows = Array.newClear(~numTracks);
	~eqButtons = Array.newClear(~numTracks);
	~gainKnobs = Array.newClear(~numTracks);
	~gainNbs = Array.newClear(~numTracks);
	~eqGroup = nil;

	/////////////////////////////////////////////////////////////////
	// RHYTHMS AND VARIATIONS
	/////////////////////////////////////////////////////////////////

	(  // Don't erase this enclosing parenthesis. They are for selecting the rhythms only
		~rhythmAndNames = [

		//blank
		["----", [[4, 0, 0]]],

		// Claves
		["Clave4/4", [[0.75,2,1], [1,2,1], [0.7,2,1], [0.55,2,1], [1,2,1]]],
		["ClaveMatanzas", [[0.75,2,1], [0.25,2,1], [0.75,2,1], [0.25,2,1], [0.5,2,1], [0.5,2,1], [1,2,1]]],
		["Clave6/8", [[2/3,4,1], [3/3,4,1], [2/3,4,1], [2/3,4,1], [3/3,4,1]]],
		["ClaveAfricana", [[2/3,4,1], [2/3,4,1], [1/3,4,1], [2/3,4,1], [2/3,4,1], [2/3,4,1], [1/3,4,1]]],

		// Catas
		["Cata1", [[0.25,"cf",1], [0.5,"cf",1], [0.25,"cf",1], [0.25,"cf",1], [0.5,"cf",1], [0.25,"cf",1], [0.5,"cf",1], [0.5,"cf",1], [0.25,"cf",1], [0.5,"cf",1], [0.25,"cf",1]]],
		["Cata2", [[0.5,"cf",1], [0.25,"cf",1], [0.5,"cf",1], [0.5,"cf",1],[0.25,"cf",1], [0.5,"cf",1], [0.5,"cf",1], [0.25,"cf",1], [0.5,"cf",1], [0.25,"cf",1]]],
		["CataColumbia", [[0.5,"cf",1], [0.25,"cf",1], [0.5,"cf",1], [0.5,"cf",1], [0.25,"cf",1], [0.5,"cf",1], [0.5,"cf",1], [0.25,"cf",1], [0.25,"cf",1], [0.25,"cf",1], [0.25,"cf",1]]],
		["Cata Yuka", [[2/3,"cf",1], [2/3,"cf",1], [2/3,"cf",1], [1/3,"cf",1], [1/3,"cf",1], [4/3,"cf",1]]],
		["Cata2 Yuka", [[2/3,"cf",1], [2/3,"cf",1], [2/3,"cf",1], [6/3,"cf",1]]],

		// Shékeres
		["ShekereBin 1/1", [[2+1.75,7,1], [0.25,8,1]]],
		["ShekereBin 1/2", [[1.75,7,1], [0.25,8,1]]],
		["ShekereBin 1/4 ", [[0.75,7,1], [0.25,8,1]]],
		["Shekere6/8", [[2/3,7,1], [1/3,8,1]]],

		// Golpes
		["PaloYukaGolpe", [[0.75,0,1], [0.25,0,1], [-1,0,0]]],
		["GolpeGuaguanco", [[1,"llcp",0.25], [0.5,"llcp",0.25], [0.5,"llap",1],
				            [1,"llcp",0.25], [0.5,"llcp",0.25], [0.5,"llap",1]]],

		["GolpeCol", [[2/3,"llcmf",0.43], [1/3,"llsmf",1],  [1/3,"llcmf",0.43], [1/3,"llamf",1], [1/3,"llamf",1]]],
		["GolpeMontunoCol", [[2/3,"llcp",1], [1/3,"llcf",1],  [1,"llcp",1],
				             [2/3,"llcp",1], [1/3,"llsmf",1], [1/3,"llcp",1], [2/3,"llaf",1]]],
		["GolpePalo", [[1/3,1,0], [2/3,"lltp",1],  [1/3,9,0], [2/3,"llaf",1.5]]],
		["Yuka Golpe", [[1,1,0.43], [1,3,1]]],

		// Cajon
		["Cajon1 Yambu ", [[0.75,0,0], [0.25,"cjncmf",1], [0.5,"cjncmf",1], [0.5,"cjndf",1]]],
		["Cajon2 Yambu ", [[0.25,0,0], [0.25,"cjndf",1], [0.25,"cjndf",1], [0.25,"cjncmf",1],
				           [0.25,"cjncmf",1], [0.5,"cjndf",1], [0.25,"cjndf",1],
				           [0.5,"cjndf",1], [0.25,"cjndf",1], [0.25,"cjncf",1],
				           [0.25,"cjncmf",1], [0.5,"cjndf",1], [0.25,"cjndf",1]]],


		// Llamadores
		["LlamadorGuaguanco", [[0.25,"llcp",0.3], [0.25,"llpp",0.125], [0.25,"llpp",0.125], [0.25,"llcp",0.3],
			                   [0.25,"llcp",0.3], [0.25,"llpp",0.125], [0.25,"llpp",0.125], [0.25,"lltp",0.5],
			                   [0.75,"llap",1],[0.25,"llcp",0.3],
			                   [0.25,"llcp",0.3], [0.25,"llpp",0.125], [0.25,"llpp",0.125], [0.25,"llcp",0.3]]],
		["Llamador Matancera", [[15/32, 0, 0],  [9/32, "llsp", 1], [8/32, "llsp", 1],
				                [15/32, 0, 0],  [9/32, "llaf", 1], [8/32, "llsp", 1]]],
		["Llamador Yambu", [[0.25, 0, 0],  [0.25, "llsmp", 1],  [0.25, "llsmp", 1],  [0.25, "llsmp", 1],
				            [0.25, 0, 0],  [0.25, "llsmp", 1],  [0.25, "llaf", 1],  [0.25, "llsmp", 1]]],
		["Llamador Columbia", [[2/3,"llcmf",1], [1/3,"llamf",1],  [1,"llamf",1]]],
		["LlamadorMontunoColumbia", [[2/3,"llcmp",1], [1/3,"lltp",1],  [1,"llaf",1],
				                     [2/3,"llcmp",1], [1/3,"lltp",1],  [1,"llaf",1]]],
		["Llamador Palo", [[2/3,"llaf",1.5], [1/3,"llsmp",1],  [1,"llsmp",1]]],
		["Yuka Llamador", [[1,1,0.43], [0.5,1,0.43], [0.5,3,1]]],

		// Pulsos
		["16ths", [[0.25,0,1]]],
		["8ths", [[0.5,0,1]]],
		["Quarters", [[1,0,1], [1,0,1]]]
	];

	~variations = [
		[ [[0.25, 0, 1], [0.25, 0, 0.6], [0.5, 0, 1]], [[0.5, 0, 1], [0.5, 0, 1]] ],
		[ [[0.25, 0, 1], [0.25, 0, 0.6], [0.5, 0, 1]], [[0.5, 0, 1], [0.5, 0, 1]] ],
		[ [[0.25, 0, 1], [0.25, 0, 0.6], [0.5, 0, 1]], [[0.5, 0, 1], [0.5, 0, 1]] ],
		[ [[0.25, 0, 1], [0.25, 0, 0.6], [0.5, 0, 1]], [[0.5, 0, 1], [0.5, 0, 1]] ],
		[ [[0.25, 0, 1], [0.25, 0, 0.6], [0.5, 0, 1]], [[0.5, 0, 1], [0.5, 0, 1]] ],
		// Track 5 (Golpe Variations)
		[
			/* Var 1 */
			[[1, 1, 0.5], [0.5,1,0.5], [0.5,3,1], [1, 1, 0.5]] ++ ([0.25, 3, 1]!3)
			.addFirst([0.25, 3, 0]) ++ [[1, 3, 1], [0.5,1,0.5], [0.5,3,1], [1,1,0.5], [0.5,1,0.5], [0.5,3,1]],
			/* Var 2 */
			[[1, 1, 0.5], [0.5,1,0.5], [0.5,3,1]] ++ ([0.25, 3, 1]!7)
			.addFirst([0.25, 3, 0]) ++ [[1, 3, 1], [0.5,1,0.5], [0.5,3,1], [1,1,0.5], [0.5,1,0.5], [0.5,3,1]],
			/* Var 3 */
			[[1, 1, 0.5]] ++ ([0.25, 3, 1]!11)
			.addFirst([0.25, 3, 0]) ++ [[1, 3, 1], [0.5,1,0.5], [0.5,3,1], [1,1,0.5], [0.5,1,0.5], [0.5,3,1]],
			/* Var 4 */
			([0.25, 3, 1]!15)
			.addFirst([0.25, 3, 0]) ++ [[1, 3, 1], [0.5,1,0.5], [0.5,3,1], [1,1,0.5], [0.5,1,0.5], [0.5,3,1]],
			/* Var 5 */
			[[1, 1, 0.5], [0.5,1,0.5], [0.5,3,1], [1, 1, 1], [0.5,1,0.5], [0.25,3,1], [0.25,3,1],
			 [0.5,3,0.5], [0.25,3,1], [0.25,3,1], [0.5,3,0.5], [0.5,3,0.5], [1, 1, 0.5], [0.5,1,0.5], [0.5,3,1]],
			/* Var 6 */
			[[1, 1, 0.5], [0.5,1,0.5], [0.5,3,1], [1, 1, 0.5], [0.25,1,0.5], [0.5,3,1], [0.25,3,1],
			 [1,10,0.75], [0.5,1,0.5], [0.5,3,1], [1, 1, 1], [0.5,1,0.5], [0.5,3,1]],
			/* Var 7 */
			[[1, 1, 0.5], [0.5,1,0.5], [0.5,3,1], [1, 1, 0.5], [0.25,1,0.5], [0.5,10,1], [0.25,10,1],
			 [1,3,1], [0.5,1,0.5], [0.5,3,1], [1, 1, 1], [0.5,1,0.5], [0.5,3,1]],
			/* Var 8 */
			[[1, 1, 0.5], [0.5,1,0.5], [0.5,3,1], [0.25,1,0.5], [0.5,10,1], [0.5,10,1], [0.5,10,1], [0.25,10,1],
			 [1,3,1], [0.5,1,0.5], [0.5,3,1], [1, 1, 1], [0.5,1,0.5], [0.5,3,1]],
			/* Var 9 */
			[[1, 1, 0.5], [0.25,1,0.5], [0.5,10,1], [0.5,10,1], [0.5,10,0.5], [0.5,10,1], [0.5,10,1], [0.25,10,1],
			 [1,3,1], [0.5,1,0.5], [0.5,3,1], [1, 1, 1], [0.5,1,0.5], [0.5,3,1]],
			/* Var 10 */
			[[0.25, 1, 0.5], [0.5,10,0.5], [0.5,10,1], [0.5,10,1], [0.5,10,0.5], [0.5,10,1], [0.5,10,1], [0.5,10,1], [0.25,10,1],
			 [1,3,1], [0.5,1,0.5], [0.5,3,1], [1, 1, 1], [0.5,1,0.5], [0.5,3,1]]
		],
		// Default Variation Array for Track 6
		[
			[[0.25, 0, 1], [0.25, 0, 0.6], [0.5, 0, 1]], [[0.5, 0, 1], [0.5, 0, 1]]
		],

		// Track 7 (Choir) — no variations
		[
			[[0.25, 0, 1], [0.25, 0, 0.6], [0.5, 0, 1]], [[0.5, 0, 1], [0.5, 0, 1]]
		]
	];
	);

	// Song (chorus folder) selection
	~canciones = ~chorus.collect({ |song| song[0] });
	~carpetasCanciones = ["taJose105bpm", "AllaEnLosHollos80bpm"];
	~cancionRefBpms = [105, 80];

	// Function to load chorus samples from a given folder (optional subFolder for choir sets)
	~loadChorusFolder = { |folderName, subFolder, dict|
		var folderPath, files;
		dict = dict ?? ~samplesDictionary;
		folderPath = if(subFolder.notNil) {
			~samplePath +/+ "coro" +/+ folderName +/+ subFolder;
		} {
			~samplePath +/+ "coro" +/+ folderName;
		};
		files = (folderPath +/+ "*.wav").pathMatch.sort;
		(1..8).do({ |i|
			var key = "coro" ++ i;
			if(dict[key].notNil) { dict[key].do({ |b| if(b.notNil and: { b.server.serverRunning }) { b.free } }) };
		});
		if(files.size > 0) {
			files.do({ |path, idx|
				dict["coro" ++ (idx+1)] = [Buffer.readChannel(s, path, 0, -1, [0])];
			});
		} {
			"--- No se encontraron .wav en " ++ folderPath ++ ", usando buffer silencioso.".postln;
			8.do({ |idx|
				dict["coro" ++ (idx+1)] = [Buffer.alloc(s, 44100, 1)];
			});
		};
	};

	// Scan for choir set sub-folders under a song's chorus folder
	~scanChoirSets = { |folderName|
		var path = ~samplePath +/+ "coro" +/+ folderName;
		var names = (path +/+ "*").pathMatch.collect({ |p|
			// Normalize backslashes to forward slashes and strip trailing /
			var clean = p.replace($\\, $/);
			while { clean.last == $/ } { clean = clean.drop(-1) };
			PathName(clean).fileName;
		}).select({ |n|
			n.endsWith(".wav").not and: { n.endsWith(".WAV").not } and: { n.endsWith(".DS_Store").not }
		});
		if(names.isEmpty) { names = ["Default"] };
		names;
	};

	~projectPath = if(thisProcess.nowExecutingPath.notNil) {
		PathName(thisProcess.nowExecutingPath).pathOnly;
	} {
		var p = Platform.userHomeDir +/+ "multitrack-sequencer";
		if(File.exists(p +/+ "samples").not) {
			p = Platform.userHomeDir +/+ "repos/multitrack-sequencer";
		};
		p;
	};

	~samplePath = ~projectPath +/+ "samples";
	~presetPath = ~projectPath +/+ "sequences";
	~imagePath  = ~projectPath +/+ "images";

	// Load initial chorus samples for both tracks
	if(~carpetasCanciones.size > 0) {
		var initialSets = ~scanChoirSets.value(~carpetasCanciones[0]);
		var setA = if(initialSets[0] == "Default") { nil } { initialSets[0] };
		var setB = if(initialSets.size > 1 && { initialSets[1] != "Default" }) { initialSets[1] } { setA };
		~loadChorusFolder.value(~carpetasCanciones[0], setA, ~samplesDictionary);
		~loadChorusFolder.value(~carpetasCanciones[0], setB, ~samplesDictionaryB);
	};

	File.mkdir(~presetPath);

	~sampleFiles = (~samplePath +/+ "*.wav").pathMatch;
	~sampleNames = ~sampleFiles.collect({ |path| PathName(path).fileNameWithoutExtension });
	~samples = ~sampleFiles.collect({ |path| Buffer.read(s, path) });

	if(~samples.isEmpty) {
		~sampleNames = ["empty"];
		~samples = [Buffer.alloc(s, 44100, 1)];
	};

	~loadRoundRobinFolder = { |subPath, logLabel|
		var folderPath = PathName(~samplePath +/+ subPath);
		var loadedBuffers = Array.new;
		if(File.exists(folderPath.fullPath)) {
			var files = (folderPath.fullPath +/+ "*.wav").pathMatch;
			if(files.size > 0) {
				loadedBuffers = files.collect({ |path| Buffer.read(s, path) });
			} {
				("ALERTA RicaAfroca: Sin archivos .wav en:" + folderPath.fullPath).postln;
			};
		} {
			("ALERTA RicaAfroca: Directorio no existe:" + folderPath.fullPath).postln;
		};
		loadedBuffers;
	};

	// Load all llamador dynamics folders (f, mf, mp, p) for each type
	~samplesDictionary["llaf"] = ~loadRoundRobinFolder.value("llamador/abierto/f", "llaf");
	~samplesDictionary["llamf"] = ~loadRoundRobinFolder.value("llamador/abierto/mf", "llamf");
	~samplesDictionary["llamp"] = ~loadRoundRobinFolder.value("llamador/abierto/mp", "llamp");
	~samplesDictionary["llap"] = ~loadRoundRobinFolder.value("llamador/abierto/p", "llap");
	~samplesDictionary["llsf"] = ~loadRoundRobinFolder.value("llamador/slap/f", "llsf");
	~samplesDictionary["llsmf"] = ~loadRoundRobinFolder.value("llamador/slap/mf", "llsmf");
	~samplesDictionary["llsmp"] = ~loadRoundRobinFolder.value("llamador/slap/mp", "llsmp");
	~samplesDictionary["llsp"] = ~loadRoundRobinFolder.value("llamador/slap/p", "llsp");
	~samplesDictionary["llpf"] = ~loadRoundRobinFolder.value("llamador/punta/f", "llpf");
	~samplesDictionary["llpmf"] = ~loadRoundRobinFolder.value("llamador/punta/mf", "llpmf");
	~samplesDictionary["llpmp"] = ~loadRoundRobinFolder.value("llamador/punta/mp", "llpmp");
	~samplesDictionary["llpp"] = ~loadRoundRobinFolder.value("llamador/punta/p", "llpp");
	~samplesDictionary["llcf"] = ~loadRoundRobinFolder.value("llamador/centro/f", "llcf");
	~samplesDictionary["llcmf"] = ~loadRoundRobinFolder.value("llamador/centro/mf", "llcmf");
	~samplesDictionary["llcmp"] = ~loadRoundRobinFolder.value("llamador/centro/mp", "llcmp");
	~samplesDictionary["llcp"] = ~loadRoundRobinFolder.value("llamador/centro/p", "llcp");
	~samplesDictionary["lltf"] = ~loadRoundRobinFolder.value("llamador/tapado/f", "lltf");
	~samplesDictionary["lltmf"] = ~loadRoundRobinFolder.value("llamador/tapado/mf", "lltmf");
	~samplesDictionary["lltmp"] = ~loadRoundRobinFolder.value("llamador/tapado/mp", "lltmp");
	~samplesDictionary["lltp"] = ~loadRoundRobinFolder.value("llamador/tapado/p", "lltp");

	// Backward-compatible aliases (old 3-letter codes -> /f variants)
	~samplesDictionary["lla"] = ~samplesDictionary["llaf"];
	~samplesDictionary["lls"] = ~samplesDictionary["llsf"];
	~samplesDictionary["llp"] = ~samplesDictionary["llpf"];
	~samplesDictionary["llc"] = ~samplesDictionary["llcf"];
	~samplesDictionary["llt"] = ~samplesDictionary["lltf"];

	// Backward-compatible aliases for cajon (type-only -> /f variants)
	~samplesDictionary["cjna"] = ~samplesDictionary["cjnaf"];
	~samplesDictionary["cjns"] = ~samplesDictionary["cjnsf"];
	~samplesDictionary["cjnd"] = ~samplesDictionary["cjndf"];
	~samplesDictionary["cjnc"] = ~samplesDictionary["cjncf"];
	~samplesDictionary["cjnt"] = ~samplesDictionary["cjntf"];

	// Load cata dynamics folders (f, mf, mp, p)
	~samplesDictionary["cf"] = ~loadRoundRobinFolder.value("cata/f", "cf");
	~samplesDictionary["cmf"] = ~loadRoundRobinFolder.value("cata/mf", "cmf");
	~samplesDictionary["cmp"] = ~loadRoundRobinFolder.value("cata/mp", "cmp");
	~samplesDictionary["cp"] = ~loadRoundRobinFolder.value("cata/p", "cp");

	// Load all cajon dynamics folders (f, mf, mp, p) for each strike type
	~samplesDictionary["cjnaf"] = ~loadRoundRobinFolder.value("cajon/abierto/f", "cjnaf");
	~samplesDictionary["cjnamf"] = ~loadRoundRobinFolder.value("cajon/abierto/mf", "cjnamf");
	~samplesDictionary["cjnamp"] = ~loadRoundRobinFolder.value("cajon/abierto/mp", "cjnamp");
	~samplesDictionary["cjnap"] = ~loadRoundRobinFolder.value("cajon/abierto/p", "cjnap");
	~samplesDictionary["cjnsf"] = ~loadRoundRobinFolder.value("cajon/slap/f", "cjnsf");
	~samplesDictionary["cjnsmf"] = ~loadRoundRobinFolder.value("cajon/slap/mf", "cjnsmf");
	~samplesDictionary["cjnsmp"] = ~loadRoundRobinFolder.value("cajon/slap/mp", "cjnsmp");
	~samplesDictionary["cjnsp"] = ~loadRoundRobinFolder.value("cajon/slap/p", "cjnsp");
	~samplesDictionary["cjndf"] = ~loadRoundRobinFolder.value("cajon/dedo/f", "cjndf");
	~samplesDictionary["cjndmf"] = ~loadRoundRobinFolder.value("cajon/dedo/mf", "cjndmf");
	~samplesDictionary["cjndmp"] = ~loadRoundRobinFolder.value("cajon/dedo/mp", "cjndmp");
	~samplesDictionary["cjndp"] = ~loadRoundRobinFolder.value("cajon/dedo/p", "cjndp");
	~samplesDictionary["cjncf"] = ~loadRoundRobinFolder.value("cajon/centro/f", "cjncf");
	~samplesDictionary["cjncmf"] = ~loadRoundRobinFolder.value("cajon/centro/mf", "cjncmf");
	~samplesDictionary["cjncmp"] = ~loadRoundRobinFolder.value("cajon/centro/mp", "cjncmp");
	~samplesDictionary["cjncp"] = ~loadRoundRobinFolder.value("cajon/centro/p", "cjncp");
	~samplesDictionary["cjntf"] = ~loadRoundRobinFolder.value("cajon/tapado/f", "cjntf");
	~samplesDictionary["cjntmf"] = ~loadRoundRobinFolder.value("cajon/tapado/mf", "cjntmf");
	~samplesDictionary["cjntmp"] = ~loadRoundRobinFolder.value("cajon/tapado/mp", "cjntmp");
	~samplesDictionary["cjntp"] = ~loadRoundRobinFolder.value("cajon/tapado/p", "cjntp");

	// Chorus samples are loaded dynamically via ~loadChorusFolder (see above)

	// Initialize last index tracking
	~samplesDictionary.keys.do({ |k|
		~samplesDictionaryLastIdx[k] = -1;
	});

	if(File.exists(~imagePath +/+ "wood-size.jpg")) {
		woodImg = Image.new(~imagePath +/+ "wood-size.jpg");
	} {
		woodImg = nil;
	};

	/////////////////////////////////////////////////////////////////
	// FUNCTION: SELECTOR EVOLUCIONADO MULTI-GOLPE (Round Robin)
	/////////////////////////////////////////////////////////////////
	~getBufferForStep = { |bufVal, fallbackIdx, dict|
		var chosenBuffer, strVal, arr;
		dict = dict ?? ~samplesDictionary;
		strVal = bufVal.asString;
		arr = dict[strVal];

		if(arr.notNil and: { arr.size > 0 }) {
			if(arr.size > 1) {
				var available = (0..(arr.size - 1));
				available.remove(~samplesDictionaryLastIdx[strVal]);
				~samplesDictionaryLastIdx[strVal] = available.choose;
				chosenBuffer = arr[~samplesDictionaryLastIdx[strVal]];
			} {
				chosenBuffer = arr[0];
			};
		} {
			chosenBuffer = ~samples[bufVal.asInteger.wrap(0, ~samples.size-1)];
		};

		chosenBuffer;
	};

	/////////////////////////////////////////////////////////////////
	// SOLO HELPERS
	/////////////////////////////////////////////////////////////////

	~soloActive = { ~solos.any(_ == true) };

	/////////////////////////////////////////////////////////////////
	// FUNCTIONS (UPDATED: Added \trackNames persistence)
	/////////////////////////////////////////////////////////////////

	~saveSettings = { |name|
		var data = Dictionary.new;
		var path = ~presetPath +/+ (name ++ ".scd");

		data.put(\rhythms, Array.fill(~numTracks, { |i| ~rhythms[i] }));
		data.put(\mutes, Array.fill(~numTracks, { |i| ~mutes[i] }));
		data.put(\solos, Array.fill(~numTracks, { |i| ~solos[i] }));
		data.put(\pitches, Array.fill(~numTracks, { |i| ~pitches[i] }));
		if(~seccion == \tema) { ~temaBpm = ~tempo.tempo * 60 };
		data.put(\temaBpm, ~temaBpm);
		data.put(\indices, Array.fill(~numTracks, { |i| ~temaIndices[i] }));
		data.put(\montunoIndices, Array.fill(~numTracks, { |i| ~montunoIndices[i] }));
		data.put(\seccion, ~seccion);
		data.put(\volumes, Array.fill(~numTracks, { |i| ~volumes[i] }));
		data.put(\sampleIndices, Array.fill(~numTracks, { |i| ~sampleIndices[i] }));
		data.put(\humTime, Array.fill(~numTracks, { |i| ~humanizeTime[i] }));
		data.put(\humPitch, Array.fill(~numTracks, { |i| ~humanizePitch[i] }));
		data.put(\humAmp, Array.fill(~numTracks, { |i| ~humanizeAmp[i] }));

		// CHANGED: Captura y guarda los strings escritos en la interfaz
		data.put(\trackNames, Array.fill(~numTracks, { |i| ~trackLabels[i].string }));

		data.put(\currentSongIdx, ~currentSongIdx);
		data.put(\chorusRefBpm, ~chorusRefBpm);
		data.put(\choirSetIdx, ~choirSetIdx);
		data.put(\choirSetIdx2, ~choirSetIdx2);

		// Save EQ params
		data.put(\eqParams, Array.fill(~numTracks, { |i|
			var p = ~eqParams[i];
			[p[\lowFreq], p[\lowGain], p[\lowQ],
			 p[\midFreq], p[\midGain], p[\midQ],
			 p[\highFreq], p[\highGain], p[\highQ],
			 p[\bypass], p[\gain]]
		}));

		data.writeArchive(path);
		("--- Preservado Preset Sólido de 9 Canales: " ++ name).postln;
	};

	~loadSettings = { |name|
		var path = ~presetPath +/+ (name ++ ".scd");
		var data = Object.readArchive(path);
		if(data.notNil) {
			currentPresetName = name;
			~temaBpm = data[\temaBpm] ?? data[\bpm] ?? 120;
			~tempo.tempo = ~temaBpm / 60;
			if(data[\currentSongIdx].notNil) {
				~tempoRatioBus.set(~temaBpm / (data[\chorusRefBpm] ?? ~cancionRefBpms[data[\currentSongIdx]]));
			} {
				~tempoRatioBus.set(~temaBpm / ~chorusRefBpm);
			};

			~rhythms = Array.fill(~numTracks, { |i| data[\rhythms].wrapAt(i) ?? [[0.5, 0, 1], [0.5, 0, 1]] });
			~mutes = Array.fill(~numTracks, { |i| data[\mutes].wrapAt(i) ?? false });
			~solos = Array.fill(~numTracks, { |i| (data[\solos] ?? { [] }).wrapAt(i) ?? false });
			~pitches = Array.fill(~numTracks, { |i| data[\pitches].wrapAt(i) ?? 60 });
			~temaIndices = Array.fill(~numTracks, { |i| data[\indices].wrapAt(i) ?? 0 });
			~montunoIndices = Array.fill(~numTracks, { |i| (data[\montunoIndices] ?? data[\indices]).wrapAt(i) ?? 0 });
			~seccion = data[\seccion] ?? \tema;
			~rhythmIndices = if(~seccion == \montuno) { ~montunoIndices } { ~temaIndices };
			~volumes = Array.fill(~numTracks, { |i| data[\volumes].wrapAt(i) ?? 0.7 });
			~sampleIndices = Array.fill(~numTracks, { |i| data[\sampleIndices].wrapAt(i) ?? i });
			~humanizeTime = Array.fill(~numTracks, { |i| data[\humTime].wrapAt(i) ?? 0.0 });
			~humanizePitch = Array.fill(~numTracks, { |i| data[\humPitch].wrapAt(i) ?? 0.0 });
			~humanizeAmp = Array.fill(~numTracks, { |i| data[\humAmp].wrapAt(i) ?? 0.0 });

			// Load EQ params
			~numTracks.do({ |i|
				if(data[\eqParams].notNil) {
					var ep = data[\eqParams].wrapAt(i);
					var p = ~eqParams[i];
					p[\lowFreq] = ep[0]; p[\lowGain] = ep[1]; p[\lowQ] = ep[2];
					p[\midFreq] = ep[3]; p[\midGain] = ep[4]; p[\midQ] = ep[5];
					p[\highFreq] = ep[6]; p[\highGain] = ep[7]; p[\highQ] = ep[8];
					p[\bypass] = if(ep[9].notNil) { ep[9] } { false };
					p[\gain] = if(ep[10].notNil) { ep[10] } { 0 };
				};
			});

			{
				var sets, choirSetFolder, choirSetFolder2;
				win.name = "RicaAfroca Sequencer Wood - Editing: " ++ name;
				presetNameField.string = name;
				presetMenu.value = presetMenu.items.indexOfEqual(name);
				bpmDisplay.value = ~tempo.tempo * 60;
				tempoSlid.value = ~tempo.tempo.linlin(1, 3.3, 0, 1);

				// Restore chorus song selection (only for presets that have saved song data)
				if(data[\currentSongIdx].notNil) {
					~currentSongIdx = data[\currentSongIdx];
					~choirSetIdx = data[\choirSetIdx] ?? 0;
					~choirSetIdx2 = data[\choirSetIdx2] ?? 0;
					if(~currentSongIdx >= 0) {
						~chorusRefBpm = data[\chorusRefBpm] ?? (~cancionRefBpms[~currentSongIdx] ?? ~chorusRefBpm ?? 105);
						~tempoRatioBus.set((~tempo.tempo * 60) / ~chorusRefBpm);
						// Pre-scan choir sets and populate menus before triggering cancionMenu action
						sets = ~scanChoirSets.value(~carpetasCanciones[~currentSongIdx]);
						~choirSetIdx = ~choirSetIdx.min(sets.size - 1).max(0);
					if(~choirSetMenu.notNil) {
						~choirSetMenu.items = sets;
						~choirSetMenu.value = ~choirSetIdx;
					};
					choirSetFolder = if(sets[~choirSetIdx] == "Default") { nil } { sets[~choirSetIdx] };
					choirSetFolder2 = if(sets[~choirSetIdx2] == "Default") { nil } { sets[~choirSetIdx2] };
					~loadChorusFolder.value(~carpetasCanciones[~currentSongIdx], choirSetFolder, ~samplesDictionary);
					~loadChorusFolder.value(~carpetasCanciones[~currentSongIdx], choirSetFolder2, ~samplesDictionaryB);

				};
				if(~cancionMenu.notNil) {
						~cancionMenu.value = ~currentSongIdx + 1;
						if(~currentSongIdx >= 0) {
							~rhythmMenus[7].items = ~chorus[~currentSongIdx].drop(1).collect({ |item| item[0] });
							~rhythmMenus[8].items = ~chorus[~currentSongIdx].drop(1).collect({ |item| item[0] });
						} {
							~rhythmMenus[7].items = ["----"];
							~rhythmMenus[8].items = ["----"];
						};
					};
				};

				~numTracks.do({ |i|
					~rhythmMenus[i].value = ~rhythmIndices[i];
					~muteButtons[i].value = ~mutes[i].asInteger;
					~soloButtons[i].value = ~solos[i].asInteger;

					if (data[\trackNames].notNil && (data[\trackNames].size > 0)) {
						~trackLabels[i].string = data[\trackNames].wrapAt(i) ?? ("Track " ++ i);
					} {
						~trackLabels[i].string = "Track " ++ i;
					};

					if(i < 7) {
						~pitchSliders[i].value = ~pitches[i].linlin(36, 72.0, 0, 1);
						~humTimeSliders[i].value = ~humanizeTime[i].linlin(0, 0.08, 0, 1);
						~humPitchSliders[i].value = ~humanizePitch[i].linlin(0, 1.5, 0, 1);
						~humAmpSliders[i].value = ~humanizeAmp[i].linlin(0, 0.3, 0, 1);
					};
					~volSliders[i].value = ~dbSpec.unmap(~volumes[i].ampdb);
					~volDisplays[i].value = ~volumes[i].ampdb.round(0.1);

					// Update EQ synth from loaded params
					if(~eqSynths[i].notNil) {
						var p = ~eqParams[i];
						~eqSynths[i].set(
							\lowFreq, p[\lowFreq], \lowGain, p[\lowGain], \lowQ, p[\lowQ],
							\midFreq, p[\midFreq], \midGain, p[\midGain], \midQ, p[\midQ],
							\highFreq, p[\highFreq], \highGain, p[\highGain], \highQ, p[\highQ],
							\bypass, p[\bypass].asInteger,
							\gain, p[\gain]
						);
					};
					~gainKnobs[i].value = ~eqParams[i][\gain].linlin(-12, 12, 0, 1).clip(0, 1);
					~gainNbs[i].value = ~eqParams[i][\gain];
				});
			}.defer;
		};
	};

	~updatePresetList = {
		var files = (~presetPath +/+ "*.scd").pathMatch;
		var names = files.collect({ |p| PathName(p).fileNameWithoutExtension });
		var currentIndex;

		if(names.isEmpty) { names = ["No Presets Found"] };

		currentIndex = names.indexOfEqual(currentPresetName) ?? 0;
		{ if(presetMenu.notNil) { presetMenu.items = names; presetMenu.value = currentIndex; } }.defer;
	};

	/////////////////////////////////////////////////////////////////
	// SERVER SIDE
	/////////////////////////////////////////////////////////////////

	~peakBus = Bus.control(s, 1);
	~trackPeakBuses = Array.fill(~numTracks, { Bus.control(s, 1) });
	~tempoRatioBus = Bus.control(s, 1);
	~chorusRefBpm = (~cancionRefBpms[~currentSongIdx] ?? ~chorusRefBpm ?? 105);
	~tempoRatioBus.set(120 / ~chorusRefBpm);
	~chorusGroup = Group.new(s);

	SynthDef(\masterOut, {
		arg amp=0.8;
		var sig = In.ar(0, 2);
		sig = sig * amp;
		sig = Limiter.ar(sig, 0.98);
		Out.kr(~peakBus, PeakFollower.kr(sig[0].abs.max(sig[1].abs), 0.999));
		ReplaceOut.ar(0, sig);
	}).add;

	SynthDef(\liveChannel, {
		arg out=0, buf=0, rate=1, amp=0.5, pan=0, rel=0.3, peakOut;
		var sig, env;
		env = EnvGen.kr(Env.perc(0.005, rel), 1, doneAction: 2);
		sig = PlayBuf.ar(1, buf, BufRateScale.kr(buf) * rate, loop: 0);
		sig = sig * 0.8 * env * amp;
		Out.kr(peakOut, PeakFollower.kr(sig.abs.max(sig.abs), 0.999));
		OffsetOut.ar(out, Pan2.ar(sig, pan));
	}).add;

	SynthDef(\chorusChannel, {
		arg out=0, buf=0, amp=0.5, pan=0, peakOut, tempoRatioBus;
		var sig, rate, pitched;

		rate = In.kr(tempoRatioBus, 1);
		sig = PlayBuf.ar(1, buf, BufRateScale.kr(buf) * rate);
		pitched = PitchShift.ar(sig, 0.2, rate.reciprocal, 0, 0.001);
		pitched = pitched * rate;
		sig = Select.ar((rate - 1).abs > 0.001, [sig, pitched]);
		sig = sig * amp;

		Out.kr(peakOut, PeakFollower.kr(sig.abs, 0.999));
		OffsetOut.ar(out, Pan2.ar(sig, pan));
	}).add;

	SynthDef(\trackEQ, {
		arg inBus, outBus=0,
		lowFreq=200, lowGain=0, lowQ=0.707,
		midFreq=1000, midGain=0, midQ=0.707,
		highFreq=5000, highGain=0, highQ=0.707,
		bypass=0, gain=0;
		var sig = In.ar(inBus, 2) * gain.dbamp;
		var dry = sig;
		sig = BLowShelf.ar(sig, lowFreq, lowQ, lowGain);
		sig = BPeakEQ.ar(sig, midFreq, midQ, midGain);
		sig = BHiShelf.ar(sig, highFreq, highQ, highGain);
		sig = Select.ar(bypass, [sig, dry]);
		Out.ar(outBus, sig);
	}).add;

	s.sync;

	// Create per-track audio busses
	~numTracks.do({ |i|
		~trackAudioBuses[i] = Bus.audio(s, 2);
	});

	// Create EQ group after default group
	~eqGroup = Group.after(s.defaultGroup);

	// Create per-track EQ synths
	~numTracks.do({ |i|
		var p = ~eqParams[i];
		~eqSynths[i] = Synth(\trackEQ, [
			\inBus, ~trackAudioBuses[i].index,
			\outBus, 0,
			\lowFreq, p[\lowFreq], \lowGain, p[\lowGain], \lowQ, p[\lowQ],
			\midFreq, p[\midFreq], \midGain, p[\midGain], \midQ, p[\midQ],
			\highFreq, p[\highFreq], \highGain, p[\highGain], \highQ, p[\highQ],
			\bypass, p[\bypass].asInteger,
			\gain, p[\gain]
		], ~eqGroup, \addToHead);
	});

	// MasterOut after EQ group
	Synth(\masterOut, [\amp, ~masterVol], ~eqGroup, \addAfter);

	/////////////////////////////////////////////////////////////////
	// ENGINE (EVENT-DRIVEN MATRIX PLAYER)
	/////////////////////////////////////////////////////////////////

	~scheduleRhythmChange = { |i, newIdx|
		if(startBtn.value == 1) {
			var nextBar = ~tempo.beats.roundUp(4);
			~tempo.schedAbs(nextBar, {
				~rhythmIndices[i] = newIdx;
				~rhythms[i] = if((i == 7) || (i == 8)) {
					if(~currentSongIdx >= 0) { ~chorus[~currentSongIdx].drop(1).wrapAt(newIdx)[1] } { [[4,0,0]] }
				} {
					~rhythmAndNames.wrapAt(newIdx)[1] ?? [[0.5,0,1],[0.5,0,1]]
				};
				nil;
			});
		} {
			~rhythmIndices[i] = newIdx;
			~rhythms[i] = if((i == 7) || (i == 8)) {
				if(~currentSongIdx >= 0) { ~chorus[~currentSongIdx].drop(1).wrapAt(newIdx)[1] } { [[4,0,0]] }
			} {
				~rhythmAndNames.wrapAt(newIdx)[1] ?? [[0.5,0,1],[0.5,0,1]]
			};
		};
	};

	~numTracks.do({ |i|
		Tdef( ("chan" ++ i).asSymbol, {
			var step = 0, samplesDict;
			samplesDict = if(i == 8) { ~samplesDictionaryB } { ~samplesDictionary };
			loop {
				var currentEvent, delta, bufOff, hitAmp, pbRate, targetBuffer;

				currentEvent = ~rhythms[i].wrapAt(step);
				delta  = currentEvent[0];
				bufOff = currentEvent[1];
				hitAmp = currentEvent[2];

				// VARIATION LOGIC
				if (~varRequests[i] && ((~tempo.beats % 4) < 0.01)) {
					~varRequests[i] = false;
					{ if(~varButtons[i].notNil) { ~varButtons[i].value = 0 } }.defer;
					step = 0;

					~variations.wrapAt(i).choose.do({ |vEvent|
						var vDelta = vEvent[0];
						var vBuf   = vEvent[1];
						var vAmp   = vEvent[2];
						var vTargetBuffer;

						if(vDelta > 0 && ~mutes[i].not && (~soloActive.value.not or: { ~solos[i] })) {
							var isChorus = vBuf.asString.beginsWith("coro");
							if(isChorus) {
								s.makeBundle(s.latency + ~humanizeTime[i].rand2, {
									var synth;
									if(i == 7 && ~choirSynth.notNil) { ~choirSynth.free };
									if(i == 8 && ~choirSynth2.notNil) { ~choirSynth2.free };
								synth = Synth(\chorusChannel, [\buf, ~getBufferForStep.value(vBuf, ~sampleIndices[i], samplesDict),
									\amp, (vAmp * ~volumes[i] + ~humanizeAmp[i].rand2).clip(0,2) * ~masterVol * ~chorusMasterVol,
										\peakOut, ~trackPeakBuses[i],
										\tempoRatioBus, ~tempoRatioBus,
										\out, ~trackAudioBuses[i].index,
									], ~chorusGroup, \addToHead);
									if(i == 7) { ~choirSynth = synth };
									if(i == 8) { ~choirSynth2 = synth };
								});
							} {
								pbRate = (~pitches[i] + ~humanizePitch[i].rand2 - 60).midiratio;
								vTargetBuffer = ~getBufferForStep.value(vBuf, ~sampleIndices[i], samplesDict);

								s.makeBundle(s.latency + ~humanizeTime[i].rand2, {
									Synth(\liveChannel, [
										\buf, vTargetBuffer,
										\rate, pbRate,
										\amp, (vAmp * ~volumes[i] + ~humanizeAmp[i].rand2).clip(0,2) * ~masterVol,
										\rel, (vDelta.abs / ~tempo.tempo) * 0.8,
										\peakOut, ~trackPeakBuses[i],
										\out, ~trackAudioBuses[i].index,
									]);
								});
							};
						};
						vDelta.abs.wait;
					});

					currentEvent = ~rhythms[i].wrapAt(step);
					delta = currentEvent[0]; bufOff = currentEvent[1]; hitAmp = currentEvent[2];
				};

				// NORMAL NOTE LOGIC
				if(delta > 0 && ~mutes[i].not && (~soloActive.value.not or: { ~solos[i] })) {
					var isChorus = bufOff.asString.beginsWith("coro");
					if(isChorus) {
					s.makeBundle(s.latency + ~humanizeTime[i].rand2, {
						var synth;
						if(i == 7 && ~choirSynth.notNil) { ~choirSynth.free };
						if(i == 8 && ~choirSynth2.notNil) { ~choirSynth2.free };
					synth = Synth(\chorusChannel, [\buf, ~getBufferForStep.value(bufOff, ~sampleIndices[i], samplesDict),
						\amp, (hitAmp * ~volumes[i] + ~humanizeAmp[i].rand2).clip(0,2) * ~masterVol * ~chorusMasterVol,
							\peakOut, ~trackPeakBuses[i],
							\tempoRatioBus, ~tempoRatioBus,
							\out, ~trackAudioBuses[i].index,
						], ~chorusGroup, \addToHead);
						if(i == 7) { ~choirSynth = synth };
						if(i == 8) { ~choirSynth2 = synth };
					});
					} {
						pbRate = (~pitches[i] + ~humanizePitch[i].rand2 - 60).midiratio;
						targetBuffer = ~getBufferForStep.value(bufOff, ~sampleIndices[i], samplesDict);

						s.makeBundle(s.latency + ~humanizeTime[i].rand2, {
							Synth(\liveChannel, [
								\buf, targetBuffer,
								\rate, pbRate,
								\amp, (hitAmp * ~volumes[i] + ~humanizeAmp[i].rand2).clip(0,2) * ~masterVol,
								\rel, (delta.abs / ~tempo.tempo) * 0.8,
								\peakOut, ~trackPeakBuses[i],
								\out, ~trackAudioBuses[i].index,
							]);
						});
					};
				};

				step = step + 1;
				if(step >= ~rhythms[i].size) { step = 0 };
				delta.abs.wait;
			}
		}).quant = 4;
	});

	/////////////////////////////////////////////////////////////////
	// EQ WINDOW FUNCTION
	/////////////////////////////////////////////////////////////////

	~openEQWindow = { |trackIdx|
		var eqWin, bypassBtn, resetBtn, bottomRow;
		var p = ~eqParams[trackIdx];
		var winTitle = "EQ - " + ~trackLabels[trackIdx].string;

		// Close existing window if open
		if(~eqWindows[trackIdx].notNil and: { ~eqWindows[trackIdx].isClosed.not }) {
			~eqWindows[trackIdx].close;
		};

		eqWin = Window(winTitle, Rect(100, 100, 540, 440)).front;
		eqWin.view.decorator = FlowLayout(eqWin.view.bounds, 3@5, 0@5);
		eqWin.view.background = Color.grey(0.2);

		// --- Band columns ---
		[
			["LOW", "low", 20, 500],
			["MID", "mid", 200, 5000],
			["HIGH", "high", 1000, 20000]
		].do({ |cfg|
			var name = cfg[0], key = cfg[1], freqMin = cfg[2], freqMax = cfg[3];
			var col, knGain, knQ, knFreq, nbGain, nbQ, nbFreq;
			var w = 170, nw = 60, pad = ((w - nw) * 0.5).asInteger;

			col = CompositeView(eqWin, (w+6)@372);
			col.background = Color.grey(0.45);
			col.decorator = FlowLayout(col.bounds, 1@1, 2@2);
			col = CompositeView(col, (w+4)@370);
			col.background = Color.grey(0.28);
			col.decorator = FlowLayout(col.bounds, 2@4, 2@2);

			StaticText(col, w@24).string_(name).font_(Font(size: 16, bold: true)).align_(\center).stringColor_(Color.white);

			StaticText(col, w@16).string_("GAIN").font_(Font(size: 13)).align_(\center).stringColor_(Color.white);
			StaticText(col, pad@26).string_("");
			nbGain = NumberBox(col, nw@26).align_(\center).font_(Font(size: 14)).normalColor_(Color.yellow).background_(Color.grey(0.18)).value_(p[(key ++ "Gain").asSymbol]).decimals_(1).clipLo_(-24).clipHi_(24)
				.action_({ |nb|
					var val = nb.value.clip(-24, 24);
					p[(key ++ "Gain").asSymbol] = val;
					knGain.value = val.linlin(-24, 24, 0, 1).clip(0, 1);
					~eqSynths[trackIdx].set((key ++ "Gain").asSymbol, val);
				});
			knGain = Knob(col, w@60)
				.value_(p[(key ++ "Gain").asSymbol].linlin(-24, 24, 0, 1).clip(0, 1))
				.action_({ |k|
					var val = k.value.linlin(0, 1, -24, 24);
					p[(key ++ "Gain").asSymbol] = val;
					nbGain.value = val.round(0.1);
					~eqSynths[trackIdx].set((key ++ "Gain").asSymbol, val);
				});

			UserView(col, w@6).canFocus_(false);

			StaticText(col, w@16).string_("Q").font_(Font(size: 13)).align_(\center).stringColor_(Color.white);
			StaticText(col, pad@26).string_("");
			nbQ = NumberBox(col, nw@26).align_(\center).font_(Font(size: 14)).normalColor_(Color.yellow).background_(Color.grey(0.18)).value_(p[(key ++ "Q").asSymbol]).decimals_(2).clipLo_(0.1).clipHi_(10)
				.action_({ |nb|
					var val = nb.value.clip(0.1, 10);
					p[(key ++ "Q").asSymbol] = val;
					knQ.value = val.linlin(0.1, 10, 0, 1).clip(0, 1);
					~eqSynths[trackIdx].set((key ++ "Q").asSymbol, val);
				});
			knQ = Knob(col, w@60)
				.value_(p[(key ++ "Q").asSymbol].linlin(0.1, 10, 0, 1).clip(0, 1))
				.action_({ |k|
					var val = k.value.linlin(0, 1, 0.1, 10);
					p[(key ++ "Q").asSymbol] = val;
					nbQ.value = val.round(0.01);
					~eqSynths[trackIdx].set((key ++ "Q").asSymbol, val);
				});

			UserView(col, w@6).canFocus_(false);

			StaticText(col, w@16).string_("FREQ").font_(Font(size: 13)).align_(\center).stringColor_(Color.white);
			StaticText(col, pad@26).string_("");
			nbFreq = NumberBox(col, nw@26).align_(\center).font_(Font(size: 14)).normalColor_(Color.yellow).background_(Color.grey(0.18)).value_(p[(key ++ "Freq").asSymbol]).decimals_(1).clipLo_(freqMin).clipHi_(freqMax)
				.action_({ |nb|
					var val = nb.value.clip(freqMin, freqMax);
					p[(key ++ "Freq").asSymbol] = val;
					knFreq.value = val.linlin(freqMin, freqMax, 0, 1).clip(0, 1);
					~eqSynths[trackIdx].set((key ++ "Freq").asSymbol, val);
				});
			knFreq = Knob(col, w@60)
				.value_(p[(key ++ "Freq").asSymbol].linlin(freqMin, freqMax, 0, 1).clip(0, 1))
				.action_({ |k|
					var val = k.value.linlin(0, 1, freqMin, freqMax);
					p[(key ++ "Freq").asSymbol] = val;
					nbFreq.value = val.round(1);
					~eqSynths[trackIdx].set((key ++ "Freq").asSymbol, val);
				});
		});

		eqWin.view.decorator.nextLine;

		// Bottom controls row
		bottomRow = CompositeView(eqWin, 520@36);
		bottomRow.decorator = FlowLayout(bottomRow.bounds, 15@0, 15@0);

		bypassBtn = Button(bottomRow, 130@32)
			.states_([["BYPASS", Color.black, Color.green], ["BYPASSED", Color.white, Color.red]])
			.value_(p[\bypass].asInteger)
			.action_({ |b|
				p[\bypass] = (b.value == 1);
				~eqSynths[trackIdx].set(\bypass, b.value);

				~eqButtons[trackIdx].value = b.value;
			});

		resetBtn = Button(bottomRow, 130@32)
			.states_([["RESET", Color.white, Color.grey(0.3)]])
			.action_({
				p[\lowFreq] = 200; p[\lowGain] = 0; p[\lowQ] = 0.707;
				p[\midFreq] = 1000; p[\midGain] = 0; p[\midQ] = 0.707;
				p[\highFreq] = 5000; p[\highGain] = 0; p[\highQ] = 0.707;
				p[\bypass] = false;
				~eqSynths[trackIdx].set(
					\lowFreq, 200, \lowGain, 0, \lowQ, 0.707,
					\midFreq, 1000, \midGain, 0, \midQ, 0.707,
					\highFreq, 5000, \highGain, 0, \highQ, 0.707,
					\bypass, 0
				);
				bypassBtn.value = 0;
				~eqButtons[trackIdx].value = 0;

			});

		// Track label sync (update window title if track renamed)
		~trackLabels[trackIdx].action = ~trackLabels[trackIdx].action.addFunc({
			eqWin.name = "EQ - " + ~trackLabels[trackIdx].string;
		});

		eqWin.onClose = {
			~eqWindows[trackIdx] = nil;
			~eqButtons[trackIdx].value = 0;
		};

		~eqWindows[trackIdx] = eqWin;
		~eqButtons[trackIdx].value = p[\bypass].asInteger;
	};

	/////////////////////////////////////////////////////////////////
	// GUI
	/////////////////////////////////////////////////////////////////

	if(File.exists(~imagePath +/+ "wood-size.jpg")) {
		woodImg = Image.new(~imagePath +/+ "wood-size.jpg");
	};

	win = Window("RicaAfroca Sequencer Wood", Rect(50, 50, 1500, 920)).front;
	~mainWindow = win;

	if(woodImg.notNil) {
		var backgroundCanvas = UserView(win, win.view.bounds)
			.resize_(5)
			.drawFunc_({ |view| woodImg.drawInRect(view.bounds); });
		backgroundCanvas.canFocus_(false);
	};

	win.view.decorator = FlowLayout(win.view.bounds, 15@15, 10@10);

	win.view.keyDownAction_({ |view, char, modifiers, unicode, keycode|
		if(keycode == 32) { startBtn.valueAction = 1 - startBtn.value };
	});

	startBtn = Button(win, 800@40).states_([["START ALL", Color.black, Color.green], ["STOP ALL", Color.white, Color.red]]).action_({ |b| if(b.value == 1) { ~numTracks.do({ |i| if(i < 7) { Tdef(("chan"++i).asSymbol).reset.play(~tempo, quant: 4) } }) } { ~numTracks.do({ |i| Tdef(("chan"++i).asSymbol).stop }); if(~chorusGroup.notNil) { ~chorusGroup.freeAll }; ~choirSynth = nil; ~choirSynth2 = nil; if(~choirTriggerBtn.notNil) { ~choirTriggerBtn.value = 0 } }; });
	startBtn.canFocus_(true);
	startBtn.focus;

	win.view.decorator.nextLine;

	Button(win, 30@30).states_([["-", Color.black, Color.grey(0.8)]]).action_({ var newBpm = (~tempo.tempo * 60) - 0.5; ~tempo.tempo = newBpm / 60; bpmDisplay.value = newBpm; tempoSlid.value = newBpm.linlin(60, 200, 0, 1); 	~tempoRatioBus.set(newBpm / (~cancionRefBpms[~currentSongIdx] ?? ~chorusRefBpm ?? 105)); }).canFocus_(false);
	bpmDisplay = NumberBox(win, 60@30).value_((~tempo.tempo * 60).round(0.1))
	    .decimals_(1)
		.background_(Color.black)
		.normalColor_(Color.yellow)
		.font_(Font(size: 18));
	Button(win, 30@30).states_([["+", Color.black, Color.grey(0.8)]]).action_({ var newBpm = (~tempo.tempo * 60) + 0.5; ~tempo.tempo = newBpm / 60; bpmDisplay.value = newBpm; tempoSlid.value = newBpm.linlin(60, 200, 0, 1); ~tempoRatioBus.set(newBpm / (~cancionRefBpms[~currentSongIdx] ?? ~chorusRefBpm ?? 105)); }).canFocus_(false);
	tempoSlid = Slider(win, 660@30).value_(~tempo.tempo.linlin(1, 3.3, 0, 1)).action_({ |s| var bpm = s.value.linlin(0, 1, 60, 200); ~tempo.tempo = bpm / 60; bpmDisplay.value = bpm; ~tempoRatioBus.set(bpm / (~cancionRefBpms[~currentSongIdx] ?? ~chorusRefBpm ?? 105)); }).canFocus_(false);

	win.view.decorator.nextLine;

	~numTracks.do({ |i|
		var comp = CompositeView(win, 115@700).background_(Color.grey(0.7));
		var cmHLayout, cmVRuler;
		comp.decorator = FlowLayout(comp.bounds, 5@5, 5@5);

		StaticText(comp, 105@15).string_(i).align_(\center).font_(Font(size: 16, bold: true)).stringColor_(Color.black);

		// TextField interactivo con desenfoque automático al presionar Enter
		~trackLabels[i] = TextField(comp, 105@25)
			.string_(if(i == 7) { "Choir" } { if(i == 8) { "Choir2" } { "Track " ++ i } })
			.align_(\center)
		.background_(Color.black)
		.stringColor_(Color.yellow)
			.font_(Font(size: 18))
			.action_({ |tf|
				// 1. Guarda el texto inmediatamente en la variable lógica si lo deseas
				("Track " ++ i ++ " renombrado a: " ++ tf.string).postln;

				// 2. Le quita el foco al TextField devolviéndoselo al botón START ALL
				if(startBtn.notNil) { startBtn.focus };
			});
		~muteButtons[i] = Button(comp, 50@40).states_([["ON", Color.black, Color.green], ["MUTE", Color.white, Color.red]]).action_({ |b| ~mutes[i] = (b.value == 1); if(i == 7 && ~choirSynth.notNil) { ~choirSynth.set(\amp, if(b.value == 1) { 0 } { (~volumes[i] * ~masterVol * ~chorusMasterVol).clip(0,2) }) }; if(i == 8 && ~choirSynth2.notNil) { ~choirSynth2.set(\amp, if(b.value == 1) { 0 } { (~volumes[i] * ~masterVol * ~chorusMasterVol).clip(0,2) }) }; });
		~soloButtons[i] = Button(comp, 50@40).states_([["SOLO", Color.black, Color.yellow], ["SOLO", Color.white, Color.red(0.8)]]).action_({ |b| ~solos[i] = (b.value == 1); });
		if(i != 8) {
			if(i == 7) {
				~choirSetMenu = PopUpMenu(comp, 105@30)
					.items_(~scanChoirSets.value(~carpetasCanciones[~currentSongIdx.max(0)]))
					.action_({ |m|
						var songFolder, sets, choirSetFolder;
						songFolder = ~carpetasCanciones[~currentSongIdx];
						sets = ~scanChoirSets.value(songFolder);
						~choirSetIdx = m.value;
						choirSetFolder = if(sets[~choirSetIdx] == "Default") { nil } { sets[~choirSetIdx] };
						~loadChorusFolder.value(songFolder, choirSetFolder, ~samplesDictionary);
						~loadChorusFolder.value(songFolder, choirSetFolder, ~samplesDictionaryB);
					});
			} {
				~rhythmMenus[i] = PopUpMenu(comp, 105@30).items_(~rhythmAndNames.collect({ |item| item[0] })).action_({ |m| ~scheduleRhythmChange.value(i, m.value); });
			};
		} {
			~choirSetMenu2 = PopUpMenu(comp, 105@30)
				.items_(~scanChoirSets.value(~carpetasCanciones[~currentSongIdx.max(0)]))
				.action_({ |m|
					var songFolder, sets, choirSetFolder;
					songFolder = ~carpetasCanciones[~currentSongIdx];
					sets = ~scanChoirSets.value(songFolder);
					~choirSetIdx2 = m.value;
					choirSetFolder = if(sets[~choirSetIdx2] == "Default") { nil } { sets[~choirSetIdx2] };
					~loadChorusFolder.value(songFolder, choirSetFolder, ~samplesDictionaryB);
				});
			~rhythmMenus[i] = PopUpMenu(Window("", 0@0), 0@0);
		};
		if(i < 7) {
			~varButtons[i] = Button(comp, 105@40).states_([["VARIATION", Color.black, Color.grey(0.8)], ["QUEUED", Color.white, Color.red(0.6)]]).action_({ |b| ~varRequests[i] = (b.value == 1); });

			StaticText(comp, 105@20).string_("Pitch").align_(\center);
			~pitchSliders[i] = Slider(comp, 105@30).value_(0.5).action_({ |s| ~pitches[i] = s.value.linlin(0, 1, 36, 72).round; });

			~eqButtons[i] = Button(comp, 105@20)
				.states_([["EQ", Color.black, Color.grey(0.8)], ["EQ", Color.white, Color.blue(0.6)]])
				.action_({ |b|
					if(~eqWindows[i].isNil or: { ~eqWindows[i].isClosed }) {
						~openEQWindow.value(i);
					} {
						~eqWindows[i].front;
					};
				})
				.canFocus_(false);

			~gainKnobs[i] = Knob(comp, 105@30)
				.value_(~eqParams[i][\gain].linlin(-12, 12, 0, 1).clip(0, 1))
				.action_({ |k|
					var val = k.value.linlin(0, 1, -12, 12).round(0.1);
					~eqParams[i][\gain] = val;
					~gainNbs[i].value = val;
					if(~eqSynths[i].notNil) { ~eqSynths[i].set(\gain, val) };
				});
			~gainNbs[i] = NumberBox(comp, 105@18)
				.value_(~eqParams[i][\gain])
				.decimals_(1).clipLo_(-12).clipHi_(12)
				.align_(\center).font_(Font(size: 11))
				.normalColor_(Color.yellow).background_(Color.black)
				.action_({ |nb|
					var val = nb.value.clip(-12, 12);
					~eqParams[i][\gain] = val;
					~gainKnobs[i].value = val.linlin(-12, 12, 0, 1).clip(0, 1);
					if(~eqSynths[i].notNil) { ~eqSynths[i].set(\gain, val) };
				});
		};
		if(i == 7) {
			UserView(comp, 105@40).canFocus_(false);
			UserView(comp, 105@20).canFocus_(false);
			UserView(comp, 105@30).canFocus_(false);

			~eqButtons[i] = Button(comp, 105@20)
				.states_([["EQ", Color.black, Color.grey(0.8)], ["EQ", Color.white, Color.blue(0.6)]])
				.action_({ |b|
					if(~eqWindows[i].isNil or: { ~eqWindows[i].isClosed }) {
						~openEQWindow.value(i);
					} {
						~eqWindows[i].front;
					};
				})
				.canFocus_(false);

			~gainKnobs[i] = Knob(comp, 105@30)
				.value_(~eqParams[i][\gain].linlin(-12, 12, 0, 1).clip(0, 1))
				.action_({ |k|
					var val = k.value.linlin(0, 1, -12, 12).round(0.1);
					~eqParams[i][\gain] = val;
					~gainNbs[i].value = val;
					if(~eqSynths[i].notNil) { ~eqSynths[i].set(\gain, val) };
				});
			~gainNbs[i] = NumberBox(comp, 105@18)
				.value_(~eqParams[i][\gain])
				.decimals_(1).clipLo_(-12).clipHi_(12)
				.align_(\center).font_(Font(size: 11))
				.normalColor_(Color.yellow).background_(Color.black)
				.action_({ |nb|
					var val = nb.value.clip(-12, 12);
					~eqParams[i][\gain] = val;
					~gainKnobs[i].value = val.linlin(-12, 12, 0, 1).clip(0, 1);
					if(~eqSynths[i].notNil) { ~eqSynths[i].set(\gain, val) };
				});
		};
		if(i == 8) {
			UserView(comp, 105@40).canFocus_(false);
			UserView(comp, 105@20).canFocus_(false);
			UserView(comp, 105@30).canFocus_(false);

			~eqButtons[i] = Button(comp, 105@20)
				.states_([["EQ", Color.black, Color.grey(0.8)], ["EQ", Color.white, Color.blue(0.6)]])
				.action_({ |b|
					if(~eqWindows[i].isNil or: { ~eqWindows[i].isClosed }) {
						~openEQWindow.value(i);
					} {
						~eqWindows[i].front;
					};
				})
				.canFocus_(false);

			~gainKnobs[i] = Knob(comp, 105@30)
				.value_(~eqParams[i][\gain].linlin(-12, 12, 0, 1).clip(0, 1))
				.action_({ |k|
					var val = k.value.linlin(0, 1, -12, 12).round(0.1);
					~eqParams[i][\gain] = val;
					~gainNbs[i].value = val;
					if(~eqSynths[i].notNil) { ~eqSynths[i].set(\gain, val) };
				});
			~gainNbs[i] = NumberBox(comp, 105@18)
				.value_(~eqParams[i][\gain])
				.decimals_(1).clipLo_(-12).clipHi_(12)
				.align_(\center).font_(Font(size: 11))
				.normalColor_(Color.yellow).background_(Color.black)
				.action_({ |nb|
					var val = nb.value.clip(-12, 12);
					~eqParams[i][\gain] = val;
					~gainKnobs[i].value = val.linlin(-12, 12, 0, 1).clip(0, 1);
					if(~eqSynths[i].notNil) { ~eqSynths[i].set(\gain, val) };
				});
		};

		StaticText(comp, 105@20).string_("Peak / dB").align_(\center).font_(Font(size:10));

		// NumberBox digital amarillo/negro
		~volDisplays[i] = NumberBox(comp, 105@20)
			.value_(0.7.ampdb.round(0.1)) // Valor inicial uniforme al evaluar
			.clipLo_(-60).clipHi_(3.5)
			.decimals_(1)
			.align_(\center)
			.background_(Color.black)
			.normalColor_(Color.yellow)
			.action_({ |nb|
				var targetAmp = ~dbSpec.map(~dbSpec.unmap(nb.value)).dbamp;
				~volumes[i] = targetAmp;
				// Sincroniza la posición física del slider
				~volSliders[i].value = ~dbSpec.unmap(nb.value);
				if(i == 7 && ~choirSynth.notNil) { ~choirSynth.set(\amp, (targetAmp * ~masterVol * ~chorusMasterVol).clip(0,2)) };
				if(i == 8 && ~choirSynth2.notNil) { ~choirSynth2.set(\amp, (targetAmp * ~masterVol * ~chorusMasterVol).clip(0,2)) };
			})
			.canFocus_(true);


		hLayout = CompositeView(comp, 105@200);
		hLayout.decorator = FlowLayout(hLayout.bounds, 0@0, 2@0);

		~trackMeters[i] = LevelIndicator(hLayout, 15@200).warning_(0.8).critical_(0.95).background_(Color.black);

		vRuler = CompositeView(hLayout, 25@200);
		[3.5, 0, -12, -24, -40, -60].do({ |db|
			var yPos = ~dbSpec.unmap(db);
			StaticText(vRuler, Rect(0, (1 - yPos) * 180, 25, 20)).string_(db.asString).font_(Font(size: 7)).align_(\right).stringColor_(if(db > 0) { Color.red } { Color.black });
		});




		// Slider de volumen interactivo
		~volSliders[i] = Slider(hLayout, 55@200)
			.value_(~dbSpec.unmap(0.7.ampdb))
			.action_({ |s|
				var currentDb = ~dbSpec.map(s.value);
				~volumes[i] = currentDb.dbamp;
				// Actualiza el NumberBox en tiempo real al arrastrar
				~volDisplays[i].value = currentDb.round(0.1);
				if(i == 7 && ~choirSynth.notNil) { ~choirSynth.set(\amp, (~volumes[i] * ~masterVol * ~chorusMasterVol).clip(0,2)) };
				if(i == 8 && ~choirSynth2.notNil) { ~choirSynth2.set(\amp, (~volumes[i] * ~masterVol * ~chorusMasterVol).clip(0,2)) };
			});
		~volSliders[i].canFocus_(false);




		if(i < 7) {
			humGroup = CompositeView(comp, 105@140).background_(Color.grey(0.6));
			humGroup.decorator = FlowLayout(humGroup.bounds, 2@2, 2@2);
			StaticText(humGroup, 100@15).string_("HUMANIZATION").align_(\center).font_(Font(size:9, bold:true));
			StaticText(humGroup, 40@15).string_("Time").font_(Font(size:9));
			~humTimeSliders[i] = Slider(humGroup, 55@15).value_(0.0).action_({ |s| ~humanizeTime[i] = s.value.linlin(0, 1, 0, 0.08); });
			StaticText(humGroup, 40@15).string_("Pitch").font_(Font(size:9));
			~humPitchSliders[i] = Slider(humGroup, 55@15).value_(0.0).action_({ |s| ~humanizePitch[i] = s.value.linlin(0, 1, 0, 1.5); });
			StaticText(humGroup, 40@15).string_("Amp").font_(Font(size:9));
			~humAmpSliders[i] = Slider(humGroup, 55@15).value_(0.0).action_({ |s| ~humanizeAmp[i] = s.value.linlin(0, 1, 0, 0.3); });
		};
		if(i >= 7) {
			UserView(comp, 105@140).canFocus_(false);
		};

		// Se remueven focos innecesarios excepto para las cajas de texto que sí requieren tipeo
		if(i == 7) {
			[~muteButtons[i], ~soloButtons[i], ~volSliders[i]].select(_.notNil).do(_.canFocus_(false));
		};
		if(i == 8) {
			[~muteButtons[i], ~soloButtons[i], ~rhythmMenus[i], ~volSliders[i]].select(_.notNil).do(_.canFocus_(false));
		};
		if(i < 7) {
			[~muteButtons[i], ~soloButtons[i], ~rhythmMenus[i], ~varButtons[i], ~pitchSliders[i], ~volSliders[i], ~humTimeSliders[i], ~humPitchSliders[i], ~humAmpSliders[i]].select(_.notNil).do(_.canFocus_(false));
		};
		if(i == 6) {
			var chorusMasterCol = CompositeView(win, 115@700).background_(Color.grey(0.55));
			chorusMasterCol.decorator = FlowLayout(chorusMasterCol.bounds, 5@5, 5@5);
			UserView(chorusMasterCol, 105@15).canFocus_(false);
			StaticText(chorusMasterCol, 105@25).string_("CHORUS").align_(\center).background_(Color.black).stringColor_(Color.yellow).font_(Font(size: 18));
			UserView(chorusMasterCol, 105@40).canFocus_(false);
			~rhythmMenus[7] = PopUpMenu(chorusMasterCol, 105@30).items_(if(~currentSongIdx >= 0) { ~chorus[~currentSongIdx].drop(1).collect({ |item| item[0] }) } { ["----"] }).action_({ |m| ~scheduleRhythmChange.value(7, m.value); ~scheduleRhythmChange.value(8, m.value); });
			~choirTriggerBtn = Button(chorusMasterCol, 105@40).states_([["CHORUS", Color.black, Color.grey(0.8)], ["STOP", Color.white, Color.green]]).action_({ |b|
				if(b.value == 1) {
					if(startBtn.value == 0) {
						"CHORUS: Cannot start while sequencer is stopped. Press START ALL first.".postln;
						b.value = 0;
					} {
						Tdef(\chan7).reset.play(~tempo, quant: 4);
						Tdef(\chan8).reset.play(~tempo, quant: 4);
					};
				} {
					Tdef(\chan7).stop;
					Tdef(\chan8).stop;
					if(~chorusGroup.notNil) { ~chorusGroup.freeAll };
					~choirSynth = nil;
					~choirSynth2 = nil;
				};
			});
			~cancionMenu = PopUpMenu(chorusMasterCol, 105@20).items_(["----"] ++ ~canciones).action_({ |m|
				var idx, sets, choirSetFolder, choirSetFolder2;
				if(m.value == 0) {
					~currentSongIdx = -1;
					~rhythmMenus[7].items = ["----"];
					~rhythmMenus[7].valueAction = 0;
					~rhythms[7] = [[4, 0, 0]];
					~rhythmMenus[8].items = ["----"];
					~scheduleRhythmChange.value(8, 0);
					~rhythms[8] = [[4, 0, 0]];
				} {
					idx = m.value - 1;
					~currentSongIdx = idx;
					~chorusRefBpm = ~cancionRefBpms[idx];
					sets = ~scanChoirSets.value(~carpetasCanciones[idx]);
					~choirSetIdx = ~choirSetIdx.min(sets.size - 1).max(0);
					~choirSetIdx2 = ~choirSetIdx2.min(sets.size - 1).max(0);
					if(~choirSetMenu.notNil) {
						~choirSetMenu.items = sets;
						~choirSetMenu.value = ~choirSetIdx;
					};
					if(~choirSetMenu2.notNil) {
						~choirSetMenu2.items = sets;
						~choirSetMenu2.value = ~choirSetIdx2;
					};
					choirSetFolder = if(sets[~choirSetIdx] == "Default") { nil } { sets[~choirSetIdx] };
					choirSetFolder2 = if(sets[~choirSetIdx2] == "Default") { nil } { sets[~choirSetIdx2] };
					~loadChorusFolder.value(~carpetasCanciones[idx], choirSetFolder, ~samplesDictionary);
					~loadChorusFolder.value(~carpetasCanciones[idx], choirSetFolder2, ~samplesDictionaryB);
					~rhythmMenus[7].items = ~chorus[idx].drop(1).collect({ |item| item[0] });
					~rhythmMenus[7].valueAction = 0;
					~tempoRatioBus.set((~tempo.tempo * 60) / ~chorusRefBpm);
				};
			});
			~nextChorusBtn = Button(chorusMasterCol, 105@30).states_([["NEXT", Color.black, Color.grey(0.8)]]).action_({
				var patterns, next;
				if(~currentSongIdx >= 0) {
					patterns = ~chorus[~currentSongIdx].drop(1);
					next = (~rhythmIndices[7] + 1) % patterns.size;
					~rhythmMenus[7].valueAction = next;
				};
			});
			UserView(chorusMasterCol, 105@30).canFocus_(false);
			UserView(chorusMasterCol, 105@43).canFocus_(false);
			StaticText(chorusMasterCol, 105@20).string_("Peak / dB").align_(\center).font_(Font(size:10));
			~chorusMasterDisplay = NumberBox(chorusMasterCol, 105@20)
				.value_(0.0)
				.clipLo_(-60).clipHi_(3.5)
				.decimals_(1)
				.align_(\center)
				.background_(Color.black)
				.normalColor_(Color.yellow)
				.action_({ |nb|
					var targetAmp = ~dbSpec.map(~dbSpec.unmap(nb.value)).dbamp;
					~chorusMasterVol = targetAmp;
					~chorusMasterSlider.value = ~dbSpec.unmap(nb.value);
					if(~choirSynth.notNil) { ~choirSynth.set(\amp, (~volumes[7] * ~masterVol * ~chorusMasterVol).clip(0,2)) };
					if(~choirSynth2.notNil) { ~choirSynth2.set(\amp, (~volumes[8] * ~masterVol * ~chorusMasterVol).clip(0,2)) };
				})
				.canFocus_(false);
			cmHLayout = CompositeView(chorusMasterCol, 105@200);
			cmHLayout.decorator = FlowLayout(cmHLayout.bounds, 0@0, 2@0);
			~chorusMasterMeter = LevelIndicator(cmHLayout, 15@200).warning_(0.8).critical_(0.95).background_(Color.black);
			cmVRuler = CompositeView(cmHLayout, 25@200);
			[3.5, 0, -12, -24, -40, -60].do({ |db|
				var yPos = ~dbSpec.unmap(db);
				StaticText(cmVRuler, Rect(0, (1 - yPos) * 180, 25, 20)).string_(db.asString).font_(Font(size: 7)).align_(\right).stringColor_(if(db > 0) { Color.red } { Color.black });
			});
			~chorusMasterSlider = Slider(cmHLayout, 55@200)
				.value_(~dbSpec.unmap(0))
				.action_({ |s|
					var db = ~dbSpec.map(s.value);
					~chorusMasterVol = db.dbamp;
					~chorusMasterDisplay.value = db.round(0.1);
					if(~choirSynth.notNil) { ~choirSynth.set(\amp, (~volumes[7] * ~masterVol * ~chorusMasterVol).clip(0,2)) };
					if(~choirSynth2.notNil) { ~choirSynth2.set(\amp, (~volumes[8] * ~masterVol * ~chorusMasterVol).clip(0,2)) };
				})
				.canFocus_(false);
			UserView(chorusMasterCol, 105@140).canFocus_(false);
			[~rhythmMenus[7], ~chorusMasterSlider, ~chorusMasterDisplay].select(_.notNil).do(_.canFocus_(false));
		};
	});

	if(~cancionMenu.notNil) { ~cancionMenu.value = 1 };

	masterCol = CompositeView(win, 150@700).background_(Color.grey(0.6));
	masterCol.decorator = FlowLayout(masterCol.bounds, 5@5, 5@5);
	UserView(masterCol, 140@15).canFocus_(false);
	TextField(masterCol, 140@25).string_("MASTER").align_(\center).background_(Color.black).stringColor_(Color.yellow).font_(Font(size:18)).canFocus_(false);
	masterMuteBtn = Button(masterCol, 140@40).states_([["ON", Color.black, Color.green], ["UNMUTE ALL", Color.white, Color.red]]).action_({ |b| ~numTracks.do({ |i| ~muteButtons[i].valueAction_(b.value); }); }).canFocus_(false);
	StaticText(masterCol, 140@15).string_("GLOBAL HUMAN").align_(\center).font_(Font(size:9, bold:true));
	StaticText(masterCol, 140@12).string_("Time").font_(Font(size:8));
	Slider(masterCol, 140@15).value_(0.0).action_({ |s| ~numTracks.do({ |i| ~humanizeTime[i] = s.value.linlin(0, 1, 0, 0.08); if(~humTimeSliders[i].notNil) { {~humTimeSliders[i].value = s.value}.defer }; }); }).canFocus_(false);
	StaticText(masterCol, 140@12).string_("Pitch").font_(Font(size:8));
	Slider(masterCol, 140@15).value_(0.0).action_({ |s| ~numTracks.do({ |i| ~humanizePitch[i] = s.value.linlin(0, 1, 0, 1.5); if(~humPitchSliders[i].notNil) { {~humPitchSliders[i].value = s.value}.defer }; }); });
	StaticText(masterCol, 140@12).string_("Amp").font_(Font(size:8));
	Slider(masterCol, 140@15).value_(0.0).action_({ |s| ~numTracks.do({ |i| ~humanizeAmp[i] = s.value.linlin(0, 1, 0, 0.3); if(~humAmpSliders[i].notNil) { {~humAmpSliders[i].value = s.value}.defer }; }); });
	UserView(masterCol, 140@4).canFocus_(false);

	// SECTION TOGGLE (TEMA / MONTUNO)
	~seccionBtn = Button(masterCol, 140@30)
		.states_([["TEMA", Color.black, Color.green], ["MONTUNO", Color.white, Color.blue(0.6)]])
		.value_(0)
		.action_({ |b|
			if(b.value == 1) {
				~rhythmIndices = ~montunoIndices;
				~seccion = \montuno;
			} {
				~rhythmIndices = ~temaIndices;
				~seccion = \tema;
				~tempo.tempo = ~temaBpm / 60;
				bpmDisplay.value = ~temaBpm;
				tempoSlid.value = ~temaBpm.linlin(60, 200, 0, 1);
				~tempoRatioBus.set(~temaBpm / ~cancionRefBpms[~currentSongIdx.max(0)]);
			};
			~numTracks.do({ |i|
				~rhythmMenus[i].value = ~rhythmIndices[i];
			});
			if(startBtn.value == 1) {
				var nextBar = ~tempo.beats.roundUp(4);
				~tempo.schedAbs(nextBar, {
					~numTracks.do({ |i|
						var newIdx = ~rhythmIndices[i];
						if((i == 7) || (i == 8)) {
							if(~currentSongIdx >= 0) {
								~rhythms[i] = ~chorus[~currentSongIdx].drop(1).wrapAt(newIdx)[1] ?? [[4,0,0]];
							} {
								~rhythms[i] = [[4,0,0]];
							};
						} {
							~rhythms[i] = ~rhythmAndNames.wrapAt(newIdx)[1] ?? [[0.5,0,1],[0.5,0,1]];
						};
					});
					nil;
				});
			} {
				~numTracks.do({ |i|
					var newIdx = ~rhythmIndices[i];
					if((i == 7) || (i == 8)) {
						if(~currentSongIdx >= 0) {
							~rhythms[i] = ~chorus[~currentSongIdx].drop(1).wrapAt(newIdx)[1] ?? [[4,0,0]];
						} {
							~rhythms[i] = [[4,0,0]];
						};
					} {
						~rhythms[i] = ~rhythmAndNames.wrapAt(newIdx)[1] ?? [[0.5,0,1],[0.5,0,1]];
					};
				});
			};
		})
		.canFocus_(false);

	StaticText(masterCol, 140@20).string_("Peak / dB / Master").align_(\center).font_(Font(size:10));

	// =========================================================================
	// NUEVO: NumberBox Maestro insertado antes del layout del slider/medidor
	// =========================================================================
	~masterDisplay = NumberBox(masterCol, 140@20)
		.value_(0.0) // Corresponde al valor inicial de 0 dB que tiene tu slider abajo
		.clipLo_(-60).clipHi_(3.5)
		.decimals_(1)
		.align_(\center)
		.background_(Color.black)
		.normalColor_(Color.yellow)
		.action_({ |nb|
			var targetAmp = ~dbSpec.map(~dbSpec.unmap(nb.value)).dbamp;
			~masterVol = targetAmp; // Actualiza la amplitud del motor
			~masterSlider.value = ~dbSpec.unmap(nb.value); // Mueve el slider físicamente
		if(~choirSynth.notNil) { ~choirSynth.set(\amp, (~volumes[7] * ~masterVol * ~chorusMasterVol).clip(0,2)) };
		if(~choirSynth2.notNil) { ~choirSynth2.set(\amp, (~volumes[8] * ~masterVol * ~chorusMasterVol).clip(0,2)) };
	})
		.canFocus_(true);
	// =========================================================================

	hLayout = CompositeView(masterCol, 140@310);
	hLayout.decorator = FlowLayout(hLayout.bounds, 0@0, 2@0);
	peakMeter = LevelIndicator(hLayout, 20@305).warning_(0.8).critical_(0.95).background_(Color.black);
	vRuler = CompositeView(hLayout, 40@305);
	[3.5, 0, -6, -12, -24, -40, -60].do({ |db|
		var yPos = ~dbSpec.unmap(db);
		StaticText(vRuler, Rect(0, (1 - yPos) * 285, 40, 20)).string_(db.asString).font_(Font(size: 10)).align_(\right).stringColor_(if(db > 0) { Color.red } { Color.white });
	});

	// MODIFICADO: Asignado a ~masterSlider e interactúa con el NumberBox en tiempo real
	~masterSlider = Slider(hLayout, 70@305)
		.value_(~dbSpec.unmap(0))
		.action_({ |s|
			var db = ~dbSpec.map(s.value);
			~masterVol = db.dbamp;
			~masterDisplay.value = db.round(0.1); // Actualiza el número amarillo al arrastrar
		if(~choirSynth.notNil) { ~choirSynth.set(\amp, (~volumes[7] * ~masterVol * ~chorusMasterVol).clip(0,2)) };
		if(~choirSynth2.notNil) { ~choirSynth2.set(\amp, (~volumes[8] * ~masterVol * ~chorusMasterVol).clip(0,2)) };
	})
		.canFocus_(false);

	meterRoutine = {
		loop {
			var peakChorus = 0;
			~peakBus.get({ |val| { if(peakMeter.notNil) { peakMeter.value = val } }.defer; });
			~numTracks.do({ |i|
				~trackPeakBuses[i].get({ |val| { if(~trackMeters[i].notNil) { ~trackMeters[i].value = val; }; }.defer; });
			});
			~trackPeakBuses[7].get({ |v7|
				~trackPeakBuses[8].get({ |v8|
					{ if(~chorusMasterMeter.notNil) { ~chorusMasterMeter.value = (v7 + v8).clip(0, 1) } }.defer;
				});
			});
			0.05.wait;
		}
	}.fork(AppClock);

	win.view.decorator.nextLine;
	presetNameField = TextField(win, 150@40).string_(currentPresetName)
		.background_(Color.black)
		.stringColor_(Color.yellow)
		.font_(Font(size: 18));
	saveBtn = Button(win, 100@40).states_([["SAVE", Color.black, Color.yellow]]).action_({ var n = presetNameField.string.stripWhiteSpace; if(n == "") { n = currentPresetName }; ~saveSettings.value(n); currentPresetName = n; ~updatePresetList.value; });
	presetMenu = PopUpMenu(win, 200@40)
		.items_(["Scanning..."])
		.background_(Color.black)
		.stringColor_(Color.yellow)
		.font_(Font(size: 18))
		.action_({ |menu| if(menu.item != "No Presets Found") { ~loadSettings.value(menu.item); } });
	loadBtn = Button(win, 100@40).states_([["LOAD", Color.black, Color.cyan]]).action_({ if(presetMenu.item != "No Presets Found") { ~loadSettings.value(presetMenu.item) }; });
	refreshBtn = Button(win, 100@40).states_([["REFRESH", Color.white, Color.grey(0.3)]]).action_({ ~updatePresetList.value });
	patRefBtn = Button(win, 105@40).states_([["PATTERNS", Color.black, Color.grey(0.8)]]).action_({
		~numTracks.do({ |i|
			if((i == 7) || (i == 8)) {
				~rhythmMenus[i].items = if(~currentSongIdx >= 0) { ~chorus[~currentSongIdx].drop(1).collect({ |item| item[0] }) } { ["----"] };
			} {
				~rhythmMenus[i].items = ~rhythmAndNames.collect({ |item| item[0] });
			};
			~rhythmMenus[i].valueAction = ~rhythmIndices[i];
		});
	});

	[tempoSlid, presetMenu, loadBtn, saveBtn, refreshBtn, patRefBtn, masterMuteBtn].do(_.canFocus_(false));

	~updatePresetList.value;

	s.doWhenBooted({
		{
			if(File.exists(~presetPath +/+ "guaguanco.scd")) { ~loadSettings.value("guaguanco"); };
		}.defer(0.5);
	});

	win.onClose = {
		meterRoutine.stop;
		if(~serialRoutine.notNil) { ~serialRoutine.stop };
		if(~myPort.notNil) { ~myPort.close };
		if(~chorusGroup.notNil) { ~chorusGroup.free };
		// Cleanup EQ resources
		~eqWindows.do({ |w| if(w.notNil and: { w.isClosed.not }) { w.close } });
		~eqSynths.do(_.free);
		~trackAudioBuses.do(_.free);
		if(~eqGroup.notNil) { ~eqGroup.free };
		~numTracks.do({ |i| Tdef(("chan"++i).asSymbol).stop });
		"Sequencer and Serial Port closed safely.".postln;
	};

	/////////////////////////////////////////////////////////////////
	// ARDUINO
	/////////////////////////////////////////////////////////////////
	try {
		~myPort = SerialPort("COM3", baudrate: 9600, crtscts: true);
		~serialRoutine = {
			var byte;
			while { ~myPort.notNil } {
				byte = ~myPort.read;
				if (byte.notNil) {
					byte = byte.asAscii;
					{
						case
						{ byte == $s } { startBtn.valueAction = 1 - startBtn.value }
						{ byte == $p } { var newBpm = (~tempo.tempo * 60) + 0.5; ~tempo.tempo = newBpm / 60; bpmDisplay.value = newBpm; tempoSlid.value = newBpm.linlin(60, 200, 0, 1); ~tempoRatioBus.set(newBpm / (~cancionRefBpms[~currentSongIdx] ?? ~chorusRefBpm ?? 105)); }
						{ byte == $m } { var newBpm = (~tempo.tempo * 60) - 0.5; ~tempo.tempo = newBpm / 60; bpmDisplay.value = newBpm; tempoSlid.value = newBpm.linlin(60, 200, 0, 1); ~tempoRatioBus.set(newBpm / (~cancionRefBpms[~currentSongIdx] ?? ~chorusRefBpm ?? 105)); }
						{ byte == $v } { if(~seccionBtn.notNil) { ~seccionBtn.valueAction = 1 - ~seccionBtn.value; } };
					}.defer;
				};
				0.001.wait;
			};
		}.fork(AppClock);
	} { |error|
		"WARNING: Arduino port exception. Sequencer running in GUI mode.".postln;
		~myPort = nil;
	};

});
)