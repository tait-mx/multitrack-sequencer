

////////////////////////////////////////////////////////////
//
//              Initial conditions variables and buffers
//
////////////////////////////////////////////////////////////

(

// GUI vars
var win, startBtn, tempoSlid, bpmDisplay;
var saveBtn, loadBtn;
var rhythmOptions;


(
~numTracks = 6;
~muteButtons = Array.newClear(~numTracks);
~tempo = TempoClock.new(120/60).permanent_(true);
// Pre-initialize these so the GUI never finds them as 'nil'
~rhythmMenus = Array.newClear(~numTracks);
~rhythmIndices = Array.fill(~numTracks, { 0 });
~rhythms = Array.fill(~numTracks, { [0.5, 0.5] });
~mutes = Array.fill(~numTracks, { false });
~pitches = Array.fill(~numTracks, { 60 });
);

s.waitForBoot({
	s.makeGui;
	s.meter;
    // 1. Load n distinct sounds (Replace with your own paths)
    ~samples = [
		Buffer.read(s, "/home/ernesto/Documents/SuperColliderCodes/RicaAfroca/multitrack-sequencer/Clave.wav"), // Ch 0: Kick-ish
        Buffer.read(s, "/home/ernesto/Documents/SuperColliderCodes/RicaAfroca/multitrack-sequencer/Cowbell.wav"),  // Ch 1: Perc-ish
        Buffer.read(s, "/home/ernesto/Documents/SuperColliderCodes/RicaAfroca/multitrack-sequencer/Cata.wav"),  // Ch 1: Perc-ish
        Buffer.read(s, "/home/ernesto/Documents/SuperColliderCodes/RicaAfroca/multitrack-sequencer/Shaker3.wav"), // Ch 2: Snare-ish
        Buffer.read(s, "/home/ernesto/Documents/SuperColliderCodes/RicaAfroca/multitrack-sequencer/Shaker1.wav"),   // Ch 3: Hi-hat-ish
        Buffer.read(s, "/home/ernesto/Documents/SuperColliderCodes/RicaAfroca/multitrack-sequencer/Conga.wav")   // Ch 3: Hi-hat-ish
    ];

    // 2. Arrays to hold state for n channels
    ~mutes = Array.fill(~numTracks, { false });
    ~rhythms = Array.fill(~numTracks, { [0.5, 0.5] }); // Default to 8th notes
    ~pitches = Array.fill(~numTracks, { 60 });         // Default middle C

    // 3. Updated SynthDef
    SynthDef(\liveChannel, {
    arg out=0, buf=0, freq=440, amp=0.5, pan=0, rel=0.3;
    var sig, env, rate;
    // Calculate rate based on incoming freq vs base pitch (MIDI 60)
    rate = freq / 60.midicps;
    env = EnvGen.kr(Env.perc(0.005, rel), 1, doneAction: 2);
    // Apply the rate to PlayBuf
    sig = PlayBuf.ar(2, buf, BufRateScale.kr(buf) * rate, loop: 0);
    sig = sig * 0.8;
    Out.ar(out, Pan2.ar(sig * env * amp, pan));
}).add;

    ~tempo = TempoClock.new(120/60).permanent_(true);

	// Attempt to load settings automatically
    ~loadSettings.value;

    // If no file exists, set defaults only if ~rhythms is still nil
    if(~rhythms.isNil) {
        ~rhythms = Array.fill(~numTracks, { [0.5, 0.5] });
    };
});




////////////////////////////////////////////////////////////
//
//              The Tdef Sequencers
//
////////////////////////////////////////////////////////////

(
~numTracks.do({ |i|
    Tdef( ("chan" ++ i).asSymbol, {
        var step = 0;
        loop {
            var delta = ~rhythms[i].wrapAt(step);

            // Removed the ~activeBeats.at check
            if(delta > 0 && ~mutes[i].not) {
                Synth(\liveChannel, [
                    \buf, ~samples[i],
                    \freq, ~pitches[i].midicps,
                    \amp, 0.7,
                    \rel, delta.abs * 0.8
                ]);
            };

            step = step + 1;
            delta.abs.wait;
        }
    }).quant = 4;
});
);





////////////////////////////////////////////////////////////
//
//              SAVE & LOAD SETTINGS
//
////////////////////////////////////////////////////////////

(
~saveSettings = {
    var data = Dictionary.new;
    data.put(\rhythms, ~rhythms);
    data.put(\mutes, ~mutes);
    data.put(\pitches, ~pitches);
    data.put(\bpm, ~tempo.tempo * 60);
    data.put(\indices, ~rhythmIndices);

    data.writeArchive("/home/ernesto/Documents/SuperColliderCodes/RicaAfroca/mySettings.scd");
    "--- Settings Saved to Disk ---".postln;
};

~loadSettings = {
    var data = Object.readArchive("/home/ernesto/Documents/SuperColliderCodes/RicaAfroca/mySettings.scd");
    if(data.notNil) {
        ~rhythms = data[\rhythms];
        ~mutes = data[\mutes];
        ~pitches = data[\pitches];
        ~tempo.tempo = (data[\bpm] ?? {120}) / 60;
        ~rhythmIndices = data[\indices] ?? { Array.fill(~numTracks, {0}) };
        "--- Settings Loaded from Disk ---".postln;
    } {
        "!!! No save file found !!!".postln;
    };
};
);

////////////////////////////////////////////////////////////
//
//              THE GUI!!!!
//
////////////////////////////////////////////////////////////

(
rhythmOptions = [
    [0.75, 1, 0.75, 0.5, 1], // Clave
    [0.25, 0.5, 0.25, 0.25, 0.5, 0.25, 0.5, 0.5, 0.25, 0.5, 0.25], // Cascara1
    [-1, -0.5, 0.5],             // Golpe
    [2],                       // ShekereTiempo
    [-1.75, 0.25],             // ShekereAnacruza
    [0.25], [0.5], [0.5, 0.25, 0.25], [1, 1], [0.75, 0.25], [0.33, 0.33, 0.34]
];

// 1. WIDER WINDOW: 800 pixels wide, shorter height
win = Window("RicaAfroca Sequencer", Rect(100, 100, 800, 550)).front;
win.view.decorator = FlowLayout(win.view.bounds, 15@15, 10@10);

// Global Start (Stretched to fit the new width)
startBtn = Button(win, 770@40)
    .states_([["START ALL", Color.black, Color.green], ["STOP ALL", Color.white, Color.red]])
    .action_({ |b|
        ~numTracks.do({ |i|
            if(b.value == 1) { Tdef(("chan"++i).asSymbol).play(~tempo) } { Tdef(("chan"++i).asSymbol).stop };
        });
    });

// Tempo Section
tempoSlid = Slider(win, 640@30).value_(0.5).action_({ |s|
    var bpm = s.value.linlin(0, 1, 60, 200);
    ~tempo.tempo = bpm / 60;
    bpmDisplay.value = bpm;
});
bpmDisplay = NumberBox(win, 110@30).value_(~tempo.tempo * 60);

win.view.decorator.nextLine;

// 2. TRACK CHANNELS: These will now stay in a single row
~numTracks.do({ |i|
    var comp = CompositeView(win, 115@320).background_(Color.grey(0.7));
    comp.decorator = FlowLayout(comp.bounds, 5@5, 5@5);

    StaticText(comp, 105@20).string_("TRACK " + i).align_(\center).font_(Font(bold:true));

    // Mute
    ~muteButtons[i] = Button(comp, 105@40)
        .states_([["ON", Color.black, Color.green], ["MUTE", Color.white, Color.red]])
        .value_(~mutes[i].asInteger)
        .action_({ |b| ~mutes[i] = (b.value == 1) });

    // Menu
    ~rhythmMenus[i] = PopUpMenu(comp, 105@30)
        .items_(["Clave", "Cascara1", "Golpe", "ShekereT", "ShekereA", "16ths", "8ths", "Swing", "Quarters", "Dotted", "Triplets"])
        .action_({ |m|
            ~rhythms[i] = rhythmOptions[m.value];
            ~rhythmIndices[i] = m.value;
        });

    ~rhythmMenus[i].value = ~rhythmIndices[i];

    // Pitch
    StaticText(comp, 105@20).string_("Pitch").align_(\center);
    Slider(comp, 105@30).value_(~pitches[i].linlin(36, 72, 0, 1)).action_({ |s|
        ~pitches[i] = s.value.linlin(0, 1, 36, 72).round;
    });
});

win.view.decorator.nextLine; // Move to the bottom for Save/Load

// 3. Save/Load Buttons
saveBtn = Button(win, 380@40).states_([["SAVE SETTINGS", Color.black, Color.yellow]]).action_({ ~saveSettings.value });

loadBtn = Button(win, 380@40).states_([["LOAD SETTINGS", Color.black, Color.cyan]]).action_({
    ~loadSettings.value;
    {
        bpmDisplay.value = ~tempo.tempo * 60;
        ~numTracks.do({ |i|
            if(~rhythmMenus[i].notNil) { ~rhythmMenus[i].value = ~rhythmIndices[i] };
            if(~muteButtons[i].notNil) { ~muteButtons[i].value = ~mutes[i].asInteger };
        });
    }.defer;
});

win.onClose = { ~numTracks.do({ |i| Tdef(("chan"++i).asSymbol).stop }) };
)


)

