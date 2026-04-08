


/////////////////////////////////////////
//
//      Synths and Server stuff
//
/////////////////////////////////////////

(
s.waitForBoot({
    // 1. Load Samples into a Dictionary for easy access
    ~samples = Dictionary.new;
    ~samples.put(\kick, Buffer.read(s, "/home/ernesto/Documents/SuperColliderCodes/RicaAfroca/Cowbell_07_175_SP.wav")); // Replace with your paths
    ~samples.put(\perc, Buffer.read(s, "/home/ernesto/Documents/SuperColliderCodes/RicaAfroca/Clave_SP_01_376.wav"));

    // 2. The Hybrid SynthDef
	(
    SynthDef(\liveSynth, {
        arg out=0, buf=0, bufnum=1, freq=440, amp=0.5, gate=1, ffreq=2000, rq=0.5, pan=0;
        var sig, osc, smpl, env;

        env = EnvGen.kr(Env.perc(0.01, 0.4), gate, doneAction: 2);
        smpl = PlayBuf.ar(2, buf, BufRateScale.kr(buf), loop: 0);

		// sig = (osc * 0.3) + (smpl * 0.7);
        sig = (smpl * 0.7);
        Out.ar(out, Pan2.ar(sig * env * amp, pan));
    }).add;
	);

    // 3. Global Clock Variable
    ~tempo = TempoClock.new(120/60).permanent_(true);
});

s.makeGui;
s.meter;
);


(
~muteSynth = false;
~muteSample = false;

Tdef(\sequencer, {
    loop {
        // Step 1: Kick/Sample trigger
        if(~muteSample.not) {
            Synth(\liveSynth, [
                \buf, ~samples[\kick],
                \bufnum, ~samples[\kick].numChannels,
                \amp, 0.6,
                \freq, 0 // No pitch needed for raw sample
            ]);
        };

        0.5.wait; // Wait 8th note (relative to tempo clock)

        // Step 2: Synth trigger
        if(~muteSynth.not) {
            Synth(\liveSynth, [
                \buf, ~samples[\perc],
                \bufnum, ~samples[\perc].numChannels,
                \freq, [60, 63, 67].choose.midicps, // Random chord notes
                \ffreq, exprand(800, 4000)
            ]);
        };

        0.5.wait;
    }
}).quant = 4; // Syncs to the start of a 4-beat bar
);





/////////////////////////////////////////
//
//      GUI
//
/////////////////////////////////////////


(
var win, startBtn, tempoSlid, muteSyntBtn, muteSmplBtn, rhythmMenu, bpmDisplay;

win = Window("Live Performance Rig", Rect(200, 200, 320, 350)).front;
win.view.decorator = FlowLayout(win.view.bounds, 10@10, 10@10);

// START / STOP
startBtn = Button(win, 300@50)
    .states_([["START", Color.black, Color.green], ["STOP", Color.white, Color.red]])
    .action_({ |b|
        if(b.value == 1) { Tdef(\sequencer).play(~tempo) } { Tdef(\sequencer).stop };
    });

// TEMPO SECTION
StaticText(win, 300@20).string_("Tempo (BPM)");
bpmDisplay = NumberBox(win, 50@30).value_(120);
tempoSlid = Slider(win, 240@30)
    .value_(0.5)
    .action_({ |s|
        var bpm = s.value.linlin(0, 1, 60, 180);
        ~tempo.tempo = bpm / 60;
        bpmDisplay.value = bpm;
    });

// RHYTHM SELECTOR
StaticText(win, 300@20).string_("Select Rhythm Pattern");
rhythmMenu = PopUpMenu(win, 300@30)
    .items_(["Ti-ti-ta", "Dotted", "Straight 16ths"])
    .action_({ |menu|
        case
        { menu.value == 0 } { ~currentRhythm = ~rhythm1 }
        { menu.value == 1 } { ~currentRhythm = ~rhythm2 }
        { menu.value == 2 } { ~currentRhythm = ~rhythm3 };
    });

// MUTE BUTTONS
muteSmplBtn = Button(win, 145@40)
    .states_([["Samples ON", Color.black, Color.white], ["Samples MUTE", Color.white, Color.grey]])
    .action_({ |b| ~muteSample = b.value.asBoolean });

muteSyntBtn = Button(win, 145@40)
    .states_([["Synth ON", Color.black, Color.white], ["Synth MUTE", Color.white, Color.grey]])
    .action_({ |b| ~muteSynth = b.value.asBoolean });

win.onClose = { Tdef(\sequencer).stop; };
);



/////////////////////////////////////////
//
//      Sequencer
//
/////////////////////////////////////////

(
// Define some rhythmic presets (measured in beats)
~rhythm1 = [2, 2, 1, 2, 2, 2, 1]/3;           // "Ti-ti-ta"
~rhythm2 = [0.75, 0.25];                // Dotted feel
~rhythm3 = [0.25, 0.25, 0.25, 0.25];    // Straight 16ths
~currentRhythm = ~rhythm1;              // Default

Tdef(\sequencer, {
    var index = 0;
    loop {
        var delta = ~currentRhythm.wrapAt(index);

        // Trigger Logic
        if(~muteSample.not) {
            Synth(\liveSynth, [\buf, ~samples[\kick], \amp, 0.6, \freq, 0]);
        };

        if(~muteSynth.not) {
            Synth(\liveSynth, [
                \buf, ~samples[\perc],
                \freq, [60, 63, 67].choose.midicps,
                \ffreq, exprand(800, 4000)
            ]);
        };

        index = index + 1;
        delta.wait;
    }
}).quant = 4;
)