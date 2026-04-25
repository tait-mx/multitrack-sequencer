/*
RicaAfroca Sequencer - Complete Thread-Safe Version
Poner Vol Master
Poner foot swithces para subir y bajar el tiempo
Escribir las letras de todas las canciones
Poner variaciones de amplitud, timbre y precision en todos los patromnes
*/

(
s.waitForBoot({

	/////////////////////////////////////////////////////////////////
	// VARIABLES & INITIALIZATION
	/////////////////////////////////////////////////////////////////

	var win, startBtn, tempoSlid, tempoUp, tempoDown, bpmDisplay, saveBtn, loadBtn, presetNameField, presetMenu, refreshBtn, rhythmOptions, rhythmNames, masterMuteBtn, masterCol;

	~numTracks = 6;
	~tempo = TempoClock.new(120/60).permanent_(true);


	// 1. Initialize logic arrays
	~rhythmIndices = Array.fill(~numTracks, { 0 });
	~rhythms = Array.fill(~numTracks, { [0.5, 0.5] });
	~mutes = Array.fill(~numTracks, { false });
	~pitches = Array.fill(~numTracks, { 60 });
	~volumes = Array.fill(~numTracks, { -6.dbamp });
	~sampleIndices = Array.fill(~numTracks, { |i| i }); // Stores the current sample index
	~golpeRequest = false;

	// 2. Initialize GUI arrays
	~muteButtons = Array.newClear(~numTracks);
	~rhythmMenus = Array.newClear(~numTracks);
	~pitchSliders = Array.newClear(~numTracks);
	~volSliders = Array.newClear(~numTracks);
	~sampleMenus = Array.newClear(~numTracks);

	// 3. Paths (Ubuntu/Linux)
// --- DYNAMIC PATH SETUP ---
// This finds the folder where "RicaAfroca-Sequencer.scd" is currently saved
~projectPath = PathName(thisProcess.nowExecutingPath).pathOnly;

// These will now automatically point to the folders in your screenshot
~samplePath = ~projectPath ++ "samples/";
~presetPath = ~projectPath ++ "sequences/";

// Ensure the directory exists (it will skip if it's already there)
File.mkdir(~presetPath);

"Project Path: ".post; ~projectPath.postln;
"Samples found: ".post; (~samplePath ++ "*.wav").pathMatch.size.postln;

	// Load Samples with fallback
	~sampleFiles = (~samplePath ++ "*.wav").pathMatch;
	~sampleNames = ~sampleFiles.collect({ |path| PathName(path).fileNameWithoutExtension });
	~samples = ~sampleFiles.collect({ |path| Buffer.read(s, path) });

	if(~samples.isEmpty) {
		"!!! WARNING: No samples found in: ".post; ~samplePath.postln;
		~sampleNames = ["empty"];
		~samples = [Buffer.alloc(s, 44100, 2)];
	};

	s.makeGui;
	s.meter;

	/////////////////////////////////////////////////////////////////
	// SYNTHDEF
	/////////////////////////////////////////////////////////////////

	SynthDef(\liveChannel, {
		arg out=0, buf=0, freq=440, amp=0.5, pan=0, rel=0.3;
		var sig, env, rate;
		rate = freq / 60.midicps;
		env = EnvGen.kr(Env.perc(0.005, rel), 1, doneAction: 2);
		sig = PlayBuf.ar(2, buf, BufRateScale.kr(buf) * rate, loop: 0);
		Out.ar(out, Pan2.ar(sig * 0.8 * env * amp, pan));
	}).add;

	/////////////////////////////////////////////////////////////////
	// SAVE & LOAD SETTINGS
	/////////////////////////////////////////////////////////////////

	~saveSettings = { |name|
		var data = Dictionary.new;
		var path = ~presetPath ++ name ++ ".scd";
		data.put(\rhythms, ~rhythms);
		data.put(\mutes, ~mutes);
		data.put(\pitches, ~pitches);
		data.put(\bpm, ~tempo.tempo * 60);
		data.put(\indices, ~rhythmIndices);
		data.put(\volumes, ~volumes);
		data.put(\sampleIndices, ~sampleIndices); // Save the raw indices

		data.writeArchive(path);
		("--- Saved to: " ++ path ++ " ---").postln;
	};

	~loadSettings = { |name|
		var path = ~presetPath ++ name ++ ".scd";
		var data = Object.readArchive(path);

		if(data.notNil) {
			// Update Logic Variables immediately
			~rhythms = data[\rhythms];
			~mutes = data[\mutes];
			~pitches = data[\pitches];
			~tempo.tempo = (data[\bpm] ?? {120}) / 60;
			~rhythmIndices = data[\indices] ?? { Array.fill(~numTracks, {0}) };
			~volumes = data[\volumes] ?? { Array.fill(~numTracks, { 0.7 }) };
			if(data[\sampleIndices].notNil) { ~sampleIndices = data[\sampleIndices] };

			// Update GUI Elements on AppClock
			{
				bpmDisplay.value = ~tempo.tempo * 60;
				tempoSlid.value = ~tempo.tempo.linlin(1, 3.3, 0, 1);

				~numTracks.do({ |i|
					~rhythmMenus[i].value = ~rhythmIndices[i];
					~muteButtons[i].value = ~mutes[i].asInteger;
					if(data[\sampleIndices].notNil) { ~sampleMenus[i].value = ~sampleIndices[i] };
					~pitchSliders[i].value = ~pitches[i].linlin(36, 72, 0, 1);
					~volSliders[i].value = if(~volumes[i] <= 0.001) { 0 } { ~volumes[i].ampdb.linlin(-30, 0, 0, 1) };
				});
				("--- Loaded: " ++ name ++ " ---").postln;
			}.defer;
		} { ("!!! Preset " ++ name ++ " not found !!!").warn; };
	};

	~updatePresetList = {
		var path = ~presetPath ++ "*.scd";
		var files = path.pathMatch;
		var names = files.collect({ |p| PathName(p).fileNameWithoutExtension });
		if(names.isEmpty) { names = ["No Presets Found"] };
		{ if(presetMenu.notNil) { presetMenu.items = names } }.defer;
	};

	/////////////////////////////////////////////////////////////////
	// TDEF GENERATION (Fixed for Synchronized Return)
	/////////////////////////////////////////////////////////////////

~numTracks.do({ |i|
		Tdef( ("chan" ++ i).asSymbol, {
			var step = 0;
			var varPattern = [-1, -0.5, 0.5, -1, -0.5, 0.25, 0.25] ++ [0.5, 0.25, 0.25, 0.5, 0.5, -1, -0.5, 0.5];

			loop {
				var currentPattern, delta;

				// --- NEW: QUANTIZED ENTRY CHECK ---
				// Only check for the variation when we are at the START of a pattern cycle
				if (i == 5 && step == 0 && ~golpeRequest) {
					~golpeRequest = false;
					"--- BAR SYNC: STARTING GOLPE VAR ---".postln;

					varPattern.do({ |vDelta|
						var currentBuf = ~samples[~sampleIndices[i].wrap(0, ~samples.size - 1)];
						if(vDelta > 0 && ~mutes[i].not) {
							s.makeBundle(s.latency, {
								Synth(\liveChannel, [
									\buf, currentBuf,
									\freq, ~pitches[i].midicps,
									\amp, ~volumes[i],
									\rel, (vDelta.abs / ~tempo.tempo) * 0.8
								]);
							});
						};
						vDelta.abs.wait;
					});

					// --- SYNC RETURN ---
					step = 0;
					(4 - (~tempo.beats % 4)).wait;
				};

				// --- DEFAULT BASE RHYTHM LOGIC ---
				currentPattern = ~rhythms[i];
				delta = currentPattern.wrapAt(step);

				if(delta > 0 && ~mutes[i].not) {
					s.makeBundle(s.latency, {
						Synth(\liveChannel, [
							\buf, ~samples[~sampleIndices[i].wrap(0, ~samples.size - 1)],
							\freq, ~pitches[i].midicps,
							\amp, ~volumes[i],
							\rel, (delta.abs / ~tempo.tempo) * 0.8
						]);
					});
				};

				step = step + 1;

				// Reset step if we reach the end of the base pattern
				if(step >= currentPattern.size) { step = 0 };

				delta.abs.wait;
			}
		}).quant = 4; // This keeps the whole Tdef on the 4-beat grid
	});

	/////////////////////////////////////////////////////////////////
	// RHYTHMS
	/////////////////////////////////////////////////////////////////

	rhythmOptions = [
		[0.75, 1, 0.75, 0.5, 1], //Clave4/4
		[0.75, 0.25,0.75, 0.25, 0.5, 0.5, 1], //ClaveMatanzas
		[2,2,1,2,2,2,1]/3, //Clave6/8
		[0.25, 0.5, 0.25, 0.25, 0.5, 0.25, 0.5, 0.5, 0.25, 0.5, 0.25], //Cascara1
		[0.5, 0.25, 0.5, 0.5, 0.25, 0.5, 0.5, 0.25, 0.25, 0.25, 0.25], //Cascara2
		[2, 2, 2, 1, 1, 4]/3, // cascara Yuka
		[-1, -0.5, 0.5, -1, -0.5, 0.5],   //Golpe
		[-1.0, -0.33333333333333, 0.33333333333333, 0.33333333333333], //GolpeCol
		[-1, -0.5, 0.5], // Yuka Llamador
		[-1, 1], // Yuka Golpe
		[2], //ShekereT
		[-1.75, 0.25], //ShekereA
		[0.25], //16ths
		[0.5], //8ths
		[1, 1] //Quarters
	];
	rhythmNames = [
		"Clave4/4",
		"ClaveMatanzas",
		"Clave6/8",
		"Cascara1",
		"Cascara2",
		"cascara Yuka",
		"Golpe",
		"GolpeCol",
		"Yuka Llamador",
		"Yuka Golpe",
		"ShekereT",
		"ShekereA",
		"16ths",
		"8ths",
		"Quarters"

	];

	/////////////////////////////////////////////////////////////////
	// GUI
	/////////////////////////////////////////////////////////////////

	win = Window("RicaAfroca Sequencer", Rect(100, 100, 950, 820)).front;
	win.view.decorator = FlowLayout(win.view.bounds, 15@15, 10@10);

	startBtn = Button(win, 800@40)
		.states_([["START ALL", Color.black, Color.green], ["STOP ALL", Color.white, Color.red]])
		.canFocus_(false)
		.action_({ |b|
			~numTracks.do({ |i|
				if(b.value == 1) { Tdef(("chan"++i).asSymbol).play(~tempo) } { Tdef(("chan"++i).asSymbol).stop };
			});
		});

	bpmDisplay = NumberBox(win, 110@30).value_(~tempo.tempo * 60);

	tempoSlid = Slider(win, 590@30).value_(~tempo.tempo.linlin(1, 3.3, 0, 1)).action_({ |s|
		var bpm = s.value.linlin(0, 1, 60, 200);
		~tempo.tempo = bpm / 60;
		bpmDisplay.value = bpm;
	}).canFocus_(false);

	tempoDown = Button(win, 40@30).states_([["-1", Color.black, Color.grey(0.8)]]).canFocus_(false)
		.action_({
			var newBpm = (~tempo.tempo * 60) - 1;
			~tempo.tempo = newBpm.max(20) / 60;
			{ bpmDisplay.value = ~tempo.tempo * 60; tempoSlid.value = ~tempo.tempo.linlin(1, 3.3, 0, 1); }.defer;
		});

	tempoUp = Button(win, 40@30).states_([["+1", Color.black, Color.grey(0.8)]]).canFocus_(false)
		.action_({
			var newBpm = (~tempo.tempo * 60) + 1;
			~tempo.tempo = newBpm.min(300) / 60;
			{ bpmDisplay.value = ~tempo.tempo * 60; tempoSlid.value = ~tempo.tempo.linlin(1, 3.3, 0, 1); }.defer;
		});



	win.view.decorator.nextLine;

	// TRACK LOOP
	~numTracks.do({ |i|
		var comp = CompositeView(win, 115@520).background_(Color.grey(0.7));
		comp.decorator = FlowLayout(comp.bounds, 5@5, 5@5);

		StaticText(comp, 105@20).string_("TRACK " + i).align_(\center).font_(Font(bold:true));

		// Sample Selector Menu
		~sampleMenus[i] = PopUpMenu(comp, 105@25)
			.items_(~sampleNames)
			.value_(~sampleIndices[i].wrap(0, ~sampleNames.size-1))
			.canFocus_(false)
			.background_(Color.white)
			.action_({ |menu| ~sampleIndices[i] = menu.value }); // Update logic array

		~muteButtons[i] = Button(comp, 105@40)
			.states_([["ON", Color.black, Color.green], ["MUTE", Color.white, Color.red]])
			.canFocus_(false)
			.value_(~mutes[i].asInteger)
			.action_({ |b| ~mutes[i] = (b.value == 1) });

		~rhythmMenus[i] = PopUpMenu(comp, 105@30)
			.items_(rhythmNames)
			.canFocus_(false)
			.value_(~rhythmIndices[i])
			.action_({ |m|
				~rhythms[i] = rhythmOptions[m.value];
				~rhythmIndices[i] = m.value;
			});

		StaticText(comp, 105@20).string_("Pitch").align_(\center);
		~pitchSliders[i] = Slider(comp, 105@30)
			.canFocus_(false)
			.value_(~pitches[i].linlin(36, 72, 0, 1))
			.action_({ |s| ~pitches[i] = s.value.linlin(0, 1, 36, 72).round; });

		StaticText(comp, 105@20).string_("Vol (dB)").align_(\center);
		~volSliders[i] = Slider(comp, 105@280)
			.canFocus_(false)
			.value_(~volumes[i].ampdb.linlin(-30, 0, 0, 1))
			.action_({ |s|
				var db = s.value.linlin(0, 1, -30, 0);
				~volumes[i] = if(s.value <= 0.001) { 0 } { db.dbamp };
			});
	});

	// MASTER COLUMN
	masterCol = CompositeView(win, 115@520);
	masterCol.decorator = FlowLayout(masterCol.bounds, 5@5, 5@5);
	StaticText(masterCol, 105@20).string_("");
	masterMuteBtn = Button(masterCol, 105@40)
		.states_([["MUTE ALL", Color.black, Color.yellow], ["UNMUTE ALL", Color.white, Color.red]])
		.canFocus_(false)
		.action_({ |b| ~numTracks.do({ |i| ~muteButtons[i].valueAction_(b.value); }); });

	Button(masterCol, 105@60)
	.states_([["GOLPE VAR (Trigger)", Color.black, Color.green(0.8)]])
	.canFocus_(false)
	.action_({
		~golpeRequest = true;
		"Variation queued for next pulse...".postln;
	});



	win.view.decorator.nextLine;

// PRESET FOOTER
	presetNameField = TextField(win, 150@40)
		.string_("newPreset")
		.align_(\center)
		.canFocus_(true)
		.action_({ |tf|
			// When you hit Enter, it releases focus
			// and focuses on the Window instead
			win.view.focus;
			("Preset name set to: " ++ tf.string).postln;
		});

	saveBtn = Button(win, 100@40)
		.states_([["SAVE", Color.black, Color.yellow]])
		.canFocus_(false)
		.action_({
			~saveSettings.value(presetNameField.string);
			~updatePresetList.value;
		});

	presetMenu = PopUpMenu(win, 200@40)
		.items_(["Scanning..."])
		.background_(Color.white)
		.canFocus_(false);

	loadBtn = Button(win, 100@40)
		.states_([["LOAD", Color.black, Color.cyan]])
		.canFocus_(false)
		.action_({
			var selectedName = presetMenu.item;
			// Ensure we don't try to load the "Scanning" or "No Presets" placeholder
			if(selectedName.notNil && (selectedName != "No Presets Found") && (selectedName != "Scanning...")) {
				~loadSettings.value(selectedName);
			};
		});

	refreshBtn = Button(win, 100@40)
		.states_([["REFRESH", Color.white, Color.grey(0.3)]])
		.canFocus_(false)
		.action_({ ~updatePresetList.value });

	// Initial population of the menu
	~updatePresetList.value;

	win.view.keyDownAction = { |view, char, modifiers, unicode, keycode|
		if (unicode == 32) { startBtn.valueAction = (startBtn.value + 1) % 2; };
	};

	win.onClose = { ~numTracks.do({ |i| Tdef(("chan"++i).asSymbol).stop }) };
});
)