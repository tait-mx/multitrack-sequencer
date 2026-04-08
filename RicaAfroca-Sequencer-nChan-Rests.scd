

////////////////////////////////////////////////////////////
//
//              Initial conditions variables and buffers
//
////////////////////////////////////////////////////////////

(
~numTracks=6;
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
        arg out=0, buf=0, freq=440, amp=0.5, ffreq=2000, rq=0.5, pan=0, rel=0.3;
        var sig, osc, smpl, env;
        env = EnvGen.kr(Env.perc(0.005, rel), 1, doneAction: 2);
		// osc = MoogFF.ar(Pulse.ar(freq, 0.5), ffreq, rq);
        smpl = PlayBuf.ar(2, buf, BufRateScale.kr(buf), loop: 0);
		// sig = (osc * 0.2) + (smpl * 0.8);
        sig = (smpl * 0.8);
        Out.ar(out, Pan2.ar(sig * env * amp, pan));
    }).add;

    ~tempo = TempoClock.new(120/60).permanent_(true);
});
);




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
//              THE GUI!!!!
//
////////////////////////////////////////////////////////////

(
var win, startBtn, tempoSlid, bpmDisplay;
var rhythmOptions = [
	[0.75,1,0.75,0.5,1], // Clave
    [0.25,0.5,0.25,0.25,0.5,0.25,0.5,0.5,0.25,0.5,0.25], // Cascara1
	[-1,-0.5,0.5],            // Golpe
	[2],                      // ShekereTiempo
	[-1.75,0.25],            // ShekereAnacruza
    [0.25],                   // 16ths
    [0.5],                    // 8ths
    [0.5, 0.25, 0.25],        // Swing-ish
    [1, 1],                   // Quarter notes
    [0.75, 0.25],             // Dotted
    [0.33, 0.33, 0.34]        // Triplets
];

win = Window("n-Channel Performance Rig", Rect(100, 100, 500, 900)).front;
win.view.decorator = FlowLayout(win.view.bounds, 15@15, 10@10);

// GLOBAL CONTROLS
startBtn = Button(win, 470@40)
    .states_([["START ALL", Color.black, Color.green], ["STOP ALL", Color.white, Color.red]])
    .action_({ |b|
        ~numTracks.do({ |i|
            if(b.value == 1) { Tdef(("chan"++i).asSymbol).play(~tempo) } { Tdef(("chan"++i).asSymbol).stop };
        });
    });

tempoSlid = Slider(win, 350@30).value_(0.5).action_({ |s|
    var bpm = s.value.linlin(0, 1, 60, 200);
    ~tempo.tempo = bpm / 60;
    bpmDisplay.value = bpm;
});
bpmDisplay = NumberBox(win, 100@30).value_(130);

win.view.decorator.nextLine;

// CHANNEL CONTROLS (Loop to create n strips)
~numTracks.do({ |i|
    var composite = CompositeView(win, 110@300).background_(Color.grey(0.8));
    composite.decorator = FlowLayout(composite.bounds, 5@5, 5@5);

    StaticText(composite, 100@20).string_("INST " + i).align_(\center);

    // Mute Button
    Button(composite, 100@40)
        .states_([[ "ON", Color.black, Color.green], ["MUTE", Color.white, Color.red]])
        .action_({ |b| ~mutes[i] = (b.value == 1) });

    // Rhythm Selector
    PopUpMenu(composite, 100@30)
	.items_(["Clave", "Cascara1", "Golpe", "ShekereTiempo", "ShekereAnacruza", "16ths", "8ths", "Swing", "Quarters", "Dotted", "Triplets"])
        .action_({ |m| ~rhythms[i] = rhythmOptions[m.value] });

    // Pitch Slider (MIDI)
    StaticText(composite, 100@20).string_("Pitch");
    Slider(composite, 100@30).value_(0.5).action_({ |s|
        ~pitches[i] = s.value.linlin(0, 1, 36, 72).round;
    });

    win.view.decorator.shift(5, 0);
});

win.onClose = { ~numTracks.do({ |i| Tdef(("chan"++i).asSymbol).stop }) };
)





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

    data.writeArchive("/home/ernesto/Documents/SuperColliderCodes/RicaAfroca/mySettings.scd");
    "Settings Saved!".postln;
};

~loadSettings = {
    var data = Object.readArchive("/home/ernesto/Documents/SuperColliderCodes/RicaAfroca/mySettings.scd");
    if(data.notNil) {
        ~rhythms = data[\rhythms];
        ~mutes = data[\mutes];
        ~pitches = data[\pitches];
        ~tempo.tempo = data[\bpm] / 60;
        "Settings Loaded!".postln;
    } {
        "No save file found".postln;
    };
};
)