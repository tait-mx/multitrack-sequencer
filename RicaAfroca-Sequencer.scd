
/*
RicaAfroca Sequencer - Pro Version 2.5 (8-Track Edition, Track 7 Choir)
*/
(

s.waitForBoot({

	/////////////////////////////////////////////////////////////////
	// VARIABLES & INITIALIZATION
	/////////////////////////////////////////////////////////////////

	var win, startBtn, tempoSlid, bpmDisplay, saveBtn, loadBtn,
	presetNameField, presetMenu, refreshBtn,
	masterMuteBtn, masterCol, peakMeter, meterRoutine, hLayout, vRuler,
	masterHumTime, masterHumPitch, masterHumAmp, humGroup, woodImg,
	currentPresetName = "newPreset";

	var masterSlid, masterDisplay;

	// Round Robin dictionaries for all llamador dynamics
	~samplesDictionary = Dictionary.new;
	~samplesDictionaryLastIdx = Dictionary.new;

	// Scaled from 7 to 8 tracks (Indices 0 to 7, track 7 is dedicated choir)
	~numTracks = 8;
	~tempo = TempoClock.new(120/60).permanent_(true);
	~masterVol = 0.8;
	~dbSpec = ControlSpec(-60, 3.5, \db, 0, 0);

	// Original BPM of the chorus sample (adjust if playback is off-tempo at 105 BPM)
	~chorusRefBpm = 105;

	// Logic arrays
	~rhythmIndices = Array.fill(~numTracks, { |i| if(i == 7) { 28 } { 0 } });
	~rhythms = Array.fill(~numTracks, { |i|
		if(i == 7) { [[2,0,0],[30,"c1TJ",1]] } { [[0.5, 0, 1], [0.5, 0, 1]] }
	});
	~mutes = Array.fill(~numTracks, { false });
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
	~rhythmMenus = Array.newClear(~numTracks);
	~pitchSliders = Array.newClear(~numTracks);
	~volSliders = Array.newClear(~numTracks);
	~trackMeters = Array.newClear(~numTracks);
	~trackLabels = Array.newClear(~numTracks);
	~volDisplays = Array.newClear(~numTracks);
	~varButtons = Array.newClear(~numTracks);
	~humTimeSliders = Array.newClear(~numTracks);
	~humPitchSliders = Array.newClear(~numTracks);
	~humAmpSliders = Array.newClear(~numTracks);
	~choirSynth = nil;

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
		["ClaveAfricana", [[2/3,4,1], [2/3,4,1], [1/3,4,1], [2/3,4,1], [2/3,4,1], [2/3,0,1], [1/3,0,1]]],

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
		["GolpeMatancera", [[0.75,1,0.35], [0.25,1,0.35], [0.5,1,0.35], [0.5,3,1],
				            [0.75,1,0.35], [0.25,1,0.35], [0.5,1,0.35], [0.5,3,1]]],
		["GolpeCol", [[2/3,1,0.43], [1/3,9,1],  [1/3,1,0.43], [1/3,3,1], [1/3,3,1],
				      [2/3,1,0.43], [1/3,9,1], [1/3,1,0.43], [1/3,3,1], [1/3,3,1]]],
		["GolpePalo", [[1/3,1,0], [2/3,"lltmp",1],  [1/3,9,0], [2/3,"llaf",1.5]]],
		["Yuka Golpe", [[1,1,0.43], [1,3,1]]],

		// Llamadores
		["LlamadorGuaguanco", [[0.25,"llcp",0.3], [0.25,"llpp",0.125], [0.25,"llpp",0.125], [0.25,"llcp",0.3],
			                   [0.25,"llcp",0.3], [0.25,"llpp",0.125], [0.25,"llpp",0.125], [0.25,"lltp",0.5],
			                   [0.75,"llap",1],[0.25,"llcp",0.3],
			                   [0.25,"llcp",0.3], [0.25,"llpp",0.125], [0.25,"llpp",0.125], [0.25,"llcp",0.3]]],
		["Llamador Matancera", [[15/32, 0, 0],  [9/32, "llsp", 1], [8/32, "llsp", 1],
				                [15/32, 0, 0],  [9/32, "llap", 1], [8/32, "llsp", 1]]],
		["Llamador Columbia", [[2/3,1,0.43], [1/3,3,1],  [1,3,1]]],
		["Llamador Palo", [[2/3,"llaf",1.5], [1/3,"llsmp",1],  [1,"llsmp",1]]],
		["Yuka Llamador", [[1,1,0.43], [0.5,1,0.43], [0.5,3,1]]],

		// Pulsos
		["16ths", [[0.25,0,1]]],
		["8ths", [[0.5,0,1]]],
		["Quarters", [[1,0,1], [1,0,1]]],

		// Chorus (tempo-synced time-stretched loop)
		["Coro1", [[2,0,0],[30,"c1TJ",1]]],
		["Coro2", [[2,0,0],[30,"c1TJ",1]]]
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
	/////////////////////////////////////////////////////////////////
	// PATHS & ASSET LOADING (100% RELATIVAS)
	/////////////////////////////////////////////////////////////////

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
				("--- RicaAfroca: Cargadas" + loadedBuffers.size + "muestras para" + logLabel).postln;
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

	// Load cata dynamics folders (f, mf, mp, p)
	~samplesDictionary["cf"] = ~loadRoundRobinFolder.value("cata/f", "cf");
	~samplesDictionary["cmf"] = ~loadRoundRobinFolder.value("cata/mf", "cmf");
	~samplesDictionary["cmp"] = ~loadRoundRobinFolder.value("cata/mp", "cmp");
	~samplesDictionary["cp"] = ~loadRoundRobinFolder.value("cata/p", "cp");

	// Chorus sample for time-stretched playback (tempo-synced without pitch change)
	~chorusFile = ~samplePath +/+ "coro/coro1-TaJose-105bpm.wav";
	if(File.exists(~chorusFile)) {
		~chorusBuffer = Buffer.readChannel(s, ~chorusFile, 0, -1, [0]);
		~samplesDictionary["c1TJ"] = [~chorusBuffer];
		("--- RicaAfroca: Cargado chorus sample desde " ++ ~chorusFile).postln;
	} {
		"--- RicaAfroca: coro1-TaJose-105bpm.wav no encontrado en samples/coro/, usando buffer silencioso.".postln;
		~chorusBuffer = Buffer.alloc(s, 44100, 1);
		~samplesDictionary["c1TJ"] = [~chorusBuffer];
	};

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
	~getBufferForStep = { |bufVal, fallbackIdx|
		var chosenBuffer, strVal = bufVal.asString;
		var arr = ~samplesDictionary[strVal];

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
	// FUNCTIONS (UPDATED: Added \trackNames persistence)
	/////////////////////////////////////////////////////////////////

	~saveSettings = { |name|
		var data = Dictionary.new;
		var path = ~presetPath +/+ (name ++ ".scd");

		data.put(\rhythms, Array.fill(~numTracks, { |i| ~rhythms[i] }));
		data.put(\mutes, Array.fill(~numTracks, { |i| ~mutes[i] }));
		data.put(\pitches, Array.fill(~numTracks, { |i| ~pitches[i] }));
		data.put(\bpm, ~tempo.tempo * 60);
		data.put(\indices, Array.fill(~numTracks, { |i| ~rhythmIndices[i] }));
		data.put(\volumes, Array.fill(~numTracks, { |i| ~volumes[i] }));
		data.put(\sampleIndices, Array.fill(~numTracks, { |i| ~sampleIndices[i] }));
		data.put(\humTime, Array.fill(~numTracks, { |i| ~humanizeTime[i] }));
		data.put(\humPitch, Array.fill(~numTracks, { |i| ~humanizePitch[i] }));
		data.put(\humAmp, Array.fill(~numTracks, { |i| ~humanizeAmp[i] }));

		// CHANGED: Captura y guarda los strings escritos en la interfaz
		data.put(\trackNames, Array.fill(~numTracks, { |i| ~trackLabels[i].string }));

		data.writeArchive(path);
		("--- Preservado Preset Sólido de 8 Canales: " ++ name).postln;
	};

	~loadSettings = { |name|
		var path = ~presetPath +/+ (name ++ ".scd");
		var data = Object.readArchive(path);
		if(data.notNil) {
			currentPresetName = name;
			~tempo.tempo = (data[\bpm] ?? {120}) / 60;

			~rhythms = Array.fill(~numTracks, { |i| data[\rhythms].wrapAt(i) ?? [[0.5, 0, 1], [0.5, 0, 1]] });
			~mutes = Array.fill(~numTracks, { |i| data[\mutes].wrapAt(i) ?? false });
			~pitches = Array.fill(~numTracks, { |i| data[\pitches].wrapAt(i) ?? 60 });
			~rhythmIndices = Array.fill(~numTracks, { |i| data[\indices].wrapAt(i) ?? 0 });
			~volumes = Array.fill(~numTracks, { |i| data[\volumes].wrapAt(i) ?? 0.7 });
			~sampleIndices = Array.fill(~numTracks, { |i| data[\sampleIndices].wrapAt(i) ?? i });
			~humanizeTime = Array.fill(~numTracks, { |i| data[\humTime].wrapAt(i) ?? 0.0 });
			~humanizePitch = Array.fill(~numTracks, { |i| data[\humPitch].wrapAt(i) ?? 0.0 });
			~humanizeAmp = Array.fill(~numTracks, { |i| data[\humAmp].wrapAt(i) ?? 0.0 });

			{
				win.name = "RicaAfroca Sequencer Wood - Editing: " ++ name;
				presetNameField.string = name;
				presetMenu.value = presetMenu.items.indexOfEqual(name);
				bpmDisplay.value = ~tempo.tempo * 60;
				tempoSlid.value = ~tempo.tempo.linlin(1, 3.3, 0, 1);

				~numTracks.do({ |i|
					~rhythmMenus[i].value = ~rhythmIndices[i];
					~muteButtons[i].value = ~mutes[i].asInteger;

					// CORRECCIÓN CLAVE: Blindaje absoluto si data[\trackNames] viene vacío de versiones previas
					if (data[\trackNames].notNil && (data[\trackNames].size > 0)) {
						~trackLabels[i].string = data[\trackNames].wrapAt(i) ?? ("Track " ++ i);
					} {
						~trackLabels[i].string = "Track " ++ i;
					};

					if(i != 7) {
						~pitchSliders[i].value = ~pitches[i].linlin(36, 72.0, 0, 1);
						~humTimeSliders[i].value = ~humanizeTime[i].linlin(0, 0.08, 0, 1);
						~humPitchSliders[i].value = ~humanizePitch[i].linlin(0, 1.5, 0, 1);
						~humAmpSliders[i].value = ~humanizeAmp[i].linlin(0, 0.3, 0, 1);
					};
					~volSliders[i].value = ~dbSpec.unmap(~volumes[i].ampdb);
					~volDisplays[i].value = ~volumes[i].ampdb.round(0.1);
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
		arg out=0, buf=0, amp=0.5, pan=0, peakOut;
		var sig;

		sig = PlayBuf.ar(1, buf, BufRateScale.kr(buf), doneAction: 2);
		sig = sig * amp;

		Out.kr(peakOut, PeakFollower.kr(sig.abs, 0.999));
		OffsetOut.ar(out, Pan2.ar(sig, pan));
	}).add;

	s.sync;
	Synth(\masterOut, [\amp, ~masterVol], addAction: \addAfter);

	/////////////////////////////////////////////////////////////////
	// ENGINE (EVENT-DRIVEN MATRIX PLAYER)
	/////////////////////////////////////////////////////////////////

	~numTracks.do({ |i|
		Tdef( ("chan" ++ i).asSymbol, {
			var step = 0;
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

						if(vDelta > 0 && ~mutes[i].not) {
							var isChorus = (vBuf.asString == "c1TJ");
							if(isChorus) {
								s.makeBundle(s.latency + ~humanizeTime[i].rand2, {
									var synth;
									if(i == 7 && ~choirSynth.notNil) { ~choirSynth.free };
									synth = Synth(\chorusChannel, [\buf, ~chorusBuffer,
										\amp, (vAmp * ~volumes[i] + ~humanizeAmp[i].rand2).clip(0,2) * ~masterVol,
										\peakOut, ~trackPeakBuses[i],
									], ~chorusGroup, \addToHead);
									if(i == 7) { ~choirSynth = synth };
								});
							} {
								pbRate = (~pitches[i] + ~humanizePitch[i].rand2 - 60).midiratio;
								vTargetBuffer = ~getBufferForStep.value(vBuf, ~sampleIndices[i]);

								s.makeBundle(s.latency + ~humanizeTime[i].rand2, {
									Synth(\liveChannel, [
										\buf, vTargetBuffer,
										\rate, pbRate,
										\amp, (vAmp * ~volumes[i] + ~humanizeAmp[i].rand2).clip(0,2) * ~masterVol,
										\rel, (vDelta.abs / ~tempo.tempo) * 0.8,
										\peakOut, ~trackPeakBuses[i]
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
				if(delta > 0 && ~mutes[i].not) {
					var isChorus = (bufOff.asString == "c1TJ");
					if(isChorus) {
					s.makeBundle(s.latency + ~humanizeTime[i].rand2, {
						var synth;
						if(i == 7 && ~choirSynth.notNil) { ~choirSynth.free };
						synth = Synth(\chorusChannel, [\buf, ~chorusBuffer,
							\amp, (hitAmp * ~volumes[i] + ~humanizeAmp[i].rand2).clip(0,2) * ~masterVol,
							\peakOut, ~trackPeakBuses[i],
						], ~chorusGroup, \addToHead);
						if(i == 7) { ~choirSynth = synth };
					});
					} {
						pbRate = (~pitches[i] + ~humanizePitch[i].rand2 - 60).midiratio;
						targetBuffer = ~getBufferForStep.value(bufOff, ~sampleIndices[i]);

						s.makeBundle(s.latency + ~humanizeTime[i].rand2, {
							Synth(\liveChannel, [
								\buf, targetBuffer,
								\rate, pbRate,
								\amp, (hitAmp * ~volumes[i] + ~humanizeAmp[i].rand2).clip(0,2) * ~masterVol,
								\rel, (delta.abs / ~tempo.tempo) * 0.8,
								\peakOut, ~trackPeakBuses[i]
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
	// GUI
	/////////////////////////////////////////////////////////////////

	if(File.exists(~imagePath +/+ "wood-size.jpg")) {
		woodImg = Image.new(~imagePath +/+ "wood-size.jpg");
	};

	win = Window("RicaAfroca Sequencer Wood", Rect(50, 50, 1260, 920)).front;

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

	startBtn = Button(win, 800@40).states_([["START ALL", Color.black, Color.green], ["STOP ALL", Color.white, Color.red]]).action_({ |b| if(b.value == 1) { ~numTracks.do({ |i| Tdef(("chan"++i).asSymbol).play(~tempo) }) } { ~numTracks.do({ |i| Tdef(("chan"++i).asSymbol).stop }); if(~chorusGroup.notNil) { ~chorusGroup.freeAll } }; });
	startBtn.canFocus_(true);
	startBtn.focus;

	win.view.decorator.nextLine;

	Button(win, 30@30).states_([["-", Color.black, Color.grey(0.8)]]).action_({ var newBpm = (~tempo.tempo * 60) - 1; ~tempo.tempo = newBpm / 60; bpmDisplay.value = newBpm; tempoSlid.value = newBpm.linlin(60, 200, 0, 1); ~tempoRatioBus.set(newBpm / ~chorusRefBpm); }).canFocus_(false);
	bpmDisplay = NumberBox(win, 60@30).value_((~tempo.tempo * 60).round(0.1))
	    .decimals_(1)
		.background_(Color.black)
		.normalColor_(Color.yellow)
		.font_(Font(size: 18));
	Button(win, 30@30).states_([["+", Color.black, Color.grey(0.8)]]).action_({ var newBpm = (~tempo.tempo * 60) + 1; ~tempo.tempo = newBpm / 60; bpmDisplay.value = newBpm; tempoSlid.value = newBpm.linlin(60, 200, 0, 1); ~tempoRatioBus.set(newBpm / ~chorusRefBpm); }).canFocus_(false);
	tempoSlid = Slider(win, 660@30).value_(~tempo.tempo.linlin(1, 3.3, 0, 1)).action_({ |s| var bpm = s.value.linlin(0, 1, 60, 200); ~tempo.tempo = bpm / 60; bpmDisplay.value = bpm; ~tempoRatioBus.set(bpm / ~chorusRefBpm); }).canFocus_(false);

	win.view.decorator.nextLine;

	~numTracks.do({ |i|
		var comp = CompositeView(win, 115@700).background_(Color.grey(0.7));
		comp.decorator = FlowLayout(comp.bounds, 5@5, 5@5);

		// TextField interactivo con desenfoque automático al presionar Enter
		~trackLabels[i] = TextField(comp, 105@25)
			.string_(if(i == 7) { "Choir" } { "Track " ++ i })
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
		~muteButtons[i] = Button(comp, 105@40).states_([["ON", Color.black, Color.green], ["MUTE", Color.white, Color.red]]).action_({ |b| ~mutes[i] = (b.value == 1); if(i == 7 && ~choirSynth.notNil) { ~choirSynth.set(\amp, if(b.value == 1) { 0 } { (~volumes[i] * ~masterVol).clip(0,2) }) }; });
		~rhythmMenus[i] = PopUpMenu(comp, 105@30).items_(~rhythmAndNames.collect({ |item| item[0] })).action_({ |m| ~rhythms[i] = ~rhythmAndNames[m.value][1]; ~rhythmIndices[i] = m.value; });
		if(i != 7) {
			~varButtons[i] = Button(comp, 105@40).states_([["VARIATION", Color.black, Color.grey(0.8)], ["QUEUED", Color.white, Color.red(0.6)]]).action_({ |b| ~varRequests[i] = (b.value == 1); });

			StaticText(comp, 105@20).string_("Pitch").align_(\center);
			~pitchSliders[i] = Slider(comp, 105@30).value_(0.5).action_({ |s| ~pitches[i] = s.value.linlin(0, 1, 36, 72).round; });
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
				if(i == 7 && ~choirSynth.notNil) { ~choirSynth.set(\amp, (targetAmp * ~masterVol).clip(0,2)) };
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
				if(i == 7 && ~choirSynth.notNil) { ~choirSynth.set(\amp, (~volumes[i] * ~masterVol).clip(0,2)) };
			});
		~volSliders[i].canFocus_(false);




		if(i != 7) {
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

		// Se remueven focos innecesarios excepto para las cajas de texto que sí requieren tipeo
		if(i == 7) {
			[~muteButtons[i], ~rhythmMenus[i], ~volSliders[i]].do(_.canFocus_(false));
		} {
			[~muteButtons[i], ~rhythmMenus[i], ~varButtons[i], ~pitchSliders[i], ~volSliders[i], ~humTimeSliders[i], ~humPitchSliders[i], ~humAmpSliders[i]].do(_.canFocus_(false));
		};
	});

	masterCol = CompositeView(win, 150@700).background_(Color.grey(0.6));
	masterCol.decorator = FlowLayout(masterCol.bounds, 5@5, 5@5);
	StaticText(masterCol, 140@20).string_("MASTER").align_(\center).font_(Font(bold:true));
	masterMuteBtn = Button(masterCol, 140@40).states_([["MUTE ALL", Color.black, Color.yellow], ["UNMUTE ALL", Color.white, Color.red]]).action_({ |b| ~numTracks.do({ |i| ~muteButtons[i].valueAction_(b.value); }); }).canFocus_(false);
	StaticText(masterCol, 140@15).string_("GLOBAL HUMAN").align_(\center).font_(Font(size:9, bold:true));
	StaticText(masterCol, 140@12).string_("Time").font_(Font(size:8));
	Slider(masterCol, 140@15).value_(0.0).action_({ |s| ~numTracks.do({ |i| ~humanizeTime[i] = s.value.linlin(0, 1, 0, 0.08); if(~humTimeSliders[i].notNil) { {~humTimeSliders[i].value = s.value}.defer }; }); }).canFocus_(false);
	StaticText(masterCol, 140@12).string_("Pitch").font_(Font(size:8));
	Slider(masterCol, 140@15).value_(0.0).action_({ |s| ~numTracks.do({ |i| ~humanizePitch[i] = s.value.linlin(0, 1, 0, 1.5); if(~humPitchSliders[i].notNil) { {~humPitchSliders[i].value = s.value}.defer }; }); });
	StaticText(masterCol, 140@12).string_("Amp").font_(Font(size:8));
	Slider(masterCol, 140@15).value_(0.0).action_({ |s| ~numTracks.do({ |i| ~humanizeAmp[i] = s.value.linlin(0, 1, 0, 0.3); if(~humAmpSliders[i].notNil) { {~humAmpSliders[i].value = s.value}.defer }; }); });
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
			if(~choirSynth.notNil) { ~choirSynth.set(\amp, (~volumes[7] * ~masterVol).clip(0,2)) };
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
			if(~choirSynth.notNil) { ~choirSynth.set(\amp, (~volumes[7] * ~masterVol).clip(0,2)) };
		})
		.canFocus_(false);

	meterRoutine = {
		loop {
			~peakBus.get({ |val| { if(peakMeter.notNil) { peakMeter.value = val } }.defer; });
			~numTracks.do({ |i|
				~trackPeakBuses[i].get({ |val| { if(~trackMeters[i].notNil) { ~trackMeters[i].value = val; }; }.defer; });
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

	[tempoSlid, presetMenu, loadBtn, saveBtn, refreshBtn, masterMuteBtn].do(_.canFocus_(false));

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
						{ byte == $p } { var newBpm = (~tempo.tempo * 60) + 1; ~tempo.tempo = newBpm / 60; bpmDisplay.value = newBpm; tempoSlid.value = newBpm.linlin(60, 200, 0, 1); ~tempoRatioBus.set(newBpm / ~chorusRefBpm); }
						{ byte == $m } { var newBpm = (~tempo.tempo * 60) - 1; ~tempo.tempo = newBpm / 60; bpmDisplay.value = newBpm; tempoSlid.value = newBpm.linlin(60, 200, 0, 1); ~tempoRatioBus.set(newBpm / ~chorusRefBpm); }
						{ byte == $v } { if(~varButtons[5].notNil) { ~varButtons[5].valueAction = 1 - ~varButtons[5].value; } };
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