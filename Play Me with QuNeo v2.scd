//Performance script for Assembly Circle

//Wait for the server to be booted, then run the following block
(
~my_ip = NetAddr.new("127.0.0.1", 57120); //my ip address (for windows, go to cmd, then type ipconfig.
~server_ip = NetAddr.new("127.0.0.1", 57120); //ip of the server
~username = "Xavier2";//Your username goes here
~speaker_number = 7;//Coordinate your speaker number with the ensemble. They must all be unique!
"Client.scd".resolveRelative.load;

MIDIClient.init;
MIDIIn.connectAll;
m = MIDIOut(1);

~long_slider_location = 63;
~long_slider_width = 0;
~lr_1_sum = 0.5;
~lr_2_sum = 0.5;
~lr_3_sum = 0.5;
~lr_4_sum = 5;

//QuNeo Preset 1 mapping
//transport buttons
MIDIdef.cc(\diamond_pressure, { arg data; }, 84);
MIDIdef.cc(\stop_pressure, { arg data;}, 85);
MIDIdef.cc(\play_pressure, { arg data;}, 86);

//horizontal slider 1 //effect 1
MIDIdef.cc(\left_1_pressure, { arg data; data.postln;
	~lr_1_sum = (data.linlin(0, 127, 0.0, -0.05) + ~lr_1_sum).clip(0.01, 1.0);
	~server_ip.sendMsg('/fx_msg', ~speaker_number, "~reso_synth", \bwr, ~lr_1_sum);
}, 71);
MIDIdef.cc(\right_1_pressure, { arg data; data.postln;
	~lr_1_sum = (data.linlin(0, 127, 0.0, 0.05) + ~lr_1_sum).clip(0.01, 1.0);
	~server_ip.sendMsg('/fx_msg', ~speaker_number, "~reso_synth", \bwr, ~lr_1_sum);
}, 72);
MIDIdef.cc(\slider_1_pressure, { arg data; }, 12);
MIDIdef.cc(\slider_1_location, { arg data; ~server_ip.sendMsg('/fx_msg', ~speaker_number, "~reso_synth", \mix, data.linlin(0, 127, 0.0, 0.5));
}, 0); //effect wetness

//horizontal slider 2 //effect 2
MIDIdef.cc(\left_2_pressure, { arg data;
	~lr_2_sum = (data.linexp(0, 127, 0.001, 0.1).neg + ~lr_2_sum).clip(0.0001, 1.0);
	~server_ip.sendMsg('/fx_msg', ~speaker_number, "~chorus_synth", \depth, ~lr_2_sum);
}, 73);
MIDIdef.cc(\right_2_pressure, { arg data;
	~lr_2_sum = (data.linexp(0, 127, 0.001, 0.1) + ~lr_2_sum).clip(0.0001, 1.0);
	~server_ip.sendMsg('/fx_msg', ~speaker_number, "~chorus_synth", \depth, ~lr_2_sum);
}, 74);
MIDIdef.cc(\slider_2_pressure, { arg data; data.postln;}, 13);
MIDIdef.cc(\slider_2_location, { arg data; ~server_ip.sendMsg('/fx_msg', ~speaker_number, "~chorus_synth", \mix, data.linlin(0, 127, 0.0, 0.8));
}, 1);

//horizontal slider 3
MIDIdef.cc(\left_3_pressure, { arg data;
	~lr_3_sum = (data.linexp(0, 127, 1, 70).neg + ~lr_3_sum).clip(2, 300);
	~server_ip.sendMsg('/fx_msg', ~speaker_number, "~distortion_synth", \lvl, ~lr_3_sum);
}, 75);
MIDIdef.cc(\right_3_pressure, { arg data;
	~lr_3_sum = (data.linexp(0, 127, 1, 70) + ~lr_3_sum).clip(2, 300);
	~server_ip.sendMsg('/fx_msg', ~speaker_number, "~distortion_synth", \lvl, ~lr_3_sum);
}, 76);
MIDIdef.cc(\slider_3_pressure, { arg data; data.postln;}, 14);
MIDIdef.cc(\slider_3_location, { arg data; ~server_ip.sendMsg('/fx_msg', ~speaker_number, "~distortion_synth", \mix, data.linlin(0, 127, 0.0, 1.0));
}, 2);

//horizontal slider 4
MIDIdef.cc(\left_4_pressure, { arg data;
	~lr_4_sum = (data.linexp(0, 127, 0.1, 1.0).neg + ~lr_4_sum).clip(0.1, 10.0);
	~server_ip.sendMsg('/fx_msg', ~speaker_number, "~reverb_synth", \revtime, ~lr_4_sum);
}, 77);
MIDIdef.cc(\right_4_pressure, { arg data;
	~lr_4_sum = (data.linexp(0, 127, 0.1, 1.0) + ~lr_4_sum).clip(0.1, 10.0);
	~server_ip.sendMsg('/fx_msg', ~speaker_number, "~reverb_synth", \revtime, ~lr_4_sum);
}, 78);
MIDIdef.cc(\slider_4_pressure, { arg data; data.postln;}, 15);
MIDIdef.cc(\slider_4_location, { arg data; ~server_ip.sendMsg('/fx_msg', ~speaker_number, "~reverb_synth", \mix, data.linlin(0, 127, 0.0, 0.8));
}, 3);

//left circle
MIDIdef.cc(\left_circle_pressure, { arg data;
	~server_ip.sendMsg('/pattern_msg', ~speaker_number, \mydur, (Pwhite(0.2, 2.0)).asCompileString);
	~server_ip.sendMsg('/pattern_msg', ~speaker_number, \mylen, (Pwhite(2.2, 3.0)).asCompileString);
}, 16);
MIDIdef.cc(\left_circle_direction, { arg data; data.postln;}, 4);

//right circle
MIDIdef.cc(\right_circle_pressure, { arg data;
	~server_ip.sendMsg('/pattern_msg', ~speaker_number, \myrate, (Pwhite(0.2, 2.0)).asCompileString);
	~server_ip.sendMsg('/pattern_msg', ~speaker_number, \mypos, (Pgauss(0.5, 0.5)).asCompileString);
}, 17);
MIDIdef.cc(\right_circle_direction, { arg data; data.postln;}, 5);

//rhombus
MIDIdef.cc(\rhombus_pressure, { arg data;}, 79);


//vertical sliders
MIDIdef.cc(\vertical_slider_1_pressure, {arg data;}, 18);
MIDIdef.cc(\vertical_slider_1_location, {arg data;
	~server_ip.sendMsg('/pattern_msg', ~speaker_number, \mylen, (~patterns[(data+1)/4-1]).asCompileString);
}, 6);
MIDIdef.cc(\vertical_slider_2_pressure, {arg data;}, 19);
MIDIdef.cc(\vertical_slider_2_location, {arg data;
	~server_ip.sendMsg('/pattern_msg', ~speaker_number, \mydur, (~patterns[(data+1)/4-1]).asCompileString);
}, 7);
MIDIdef.cc(\vertical_slider_3_pressure, {arg data;}, 20);
MIDIdef.cc(\vertical_slider_3_location, {arg data;
	~server_ip.sendMsg('/pattern_msg', ~speaker_number, \myrate, (~patterns[(data+1)/4-1]*10).asCompileString)
}, 8);
MIDIdef.cc(\vertical_slider_4_pressure, {arg data;}, 21);
MIDIdef.cc(\vertical_slider_4_location, {arg data;
	~server_ip.sendMsg('/pattern_msg', ~speaker_number, \mypos, (~patterns[(data+1)/4-1].wrap(0.0, 1.0)).asCompileString)
}, 9);

//pad 1-16 pressure, x, and y
MIDIdef.cc(\pad_1_pressure, {arg data; ~pad_1_pressure = data}, 23);
MIDIdef.cc(\pad_1_x, {arg data; ~pad_1_x = data;}, 24);
MIDIdef.cc(\pad_1_y, {arg data; ~pad_1_y = data;
	~server_ip.sendMsg('/phone_override_msg',
		~speaker_number,
		0/16 + ~pad_1_x.linlin(0, 127, 0, 1/16), //buffer position
		~pad_1_y.linexp(0, 127, 0.2, 12.0), //playback rate
		~long_slider_location.linexp(0, 127, 0.01, 1.0), //length
		~pad_1_pressure.linlin(0, 127, 0.8, 1.0) //amplitude
	);
}, 25);

MIDIdef.cc(\pad_2_pressure, {arg data; ~pad_2_pressure = data}, 26);
MIDIdef.cc(\pad_2_x, {arg data; ~pad_2_x = data;}, 27);
MIDIdef.cc(\pad_2_y, {arg data; ~pad_2_y = data;
	~server_ip.sendMsg('/phone_override_msg',
		~speaker_number,
		1/16 + ~pad_2_x.linlin(0, 127, 0, 1/16), //buffer position
		~pad_2_y.linexp(0, 127, 0.2, 12.0), //playback rate
		~long_slider_location.linexp(0, 127, 0.01, 1.0), //length
		~pad_2_pressure.linlin(0, 127, 0.8, 1.0) //amplitude
	);
}, 28);

MIDIdef.cc(\pad_3_pressure, {arg data; ~pad_3_pressure = data}, 29);
MIDIdef.cc(\pad_3_x, {arg data; ~pad_3_x = data;}, 30);
MIDIdef.cc(\pad_3_y, {arg data; ~pad_3_y = data;
	~server_ip.sendMsg('/phone_override_msg',
		~speaker_number,
		2/16 + ~pad_3_x.linlin(0, 127, 0, 1/16), //buffer position
		~pad_3_y.linexp(0, 127, 0.2, 12.0), //playback rate
		~long_slider_location.linexp(0, 127, 0.01, 1.0), //length
		~pad_3_pressure.linlin(0, 127, 0.8, 1.0) //amplitude
	);
}, 31);

MIDIdef.cc(\pad_4_pressure, {arg data; ~pad_4_pressure = data}, 32);
MIDIdef.cc(\pad_4_x, {arg data; ~pad_4_x = data;}, 33);
MIDIdef.cc(\pad_4_y, {arg data; ~pad_4_y = data;
	~server_ip.sendMsg('/phone_override_msg',
		~speaker_number,
		3/16 + ~pad_4_x.linlin(0, 127, 0, 1/16), //buffer position
		~pad_4_y.linexp(0, 127, 0.2, 12.0), //playback rate
		~long_slider_location.linexp(0, 127, 0.01, 1.0), //length
		~pad_4_pressure.linlin(0, 127, 0.8, 1.0) //amplitude
	);
}, 34);

MIDIdef.cc(\pad_5_pressure, {arg data; ~pad_5_pressure = data}, 35);
MIDIdef.cc(\pad_5_x, {arg data; ~pad_5_x = data;}, 36);
MIDIdef.cc(\pad_5_y, {arg data; ~pad_5_y = data;
	~server_ip.sendMsg('/phone_override_msg',
		~speaker_number,
		4/16 + ~pad_5_x.linlin(0, 127, 0, 1/16), //buffer position
		~pad_5_y.linexp(0, 127, 0.2, 12.0), //playback rate
		~long_slider_location.linexp(0, 127, 0.01, 1.0), //length
		~pad_5_pressure.linlin(0, 127, 0.8, 1.0) //amplitude
	);
}, 37);

MIDIdef.cc(\pad_6_pressure, {arg data; ~pad_6_pressure = data}, 38);
MIDIdef.cc(\pad_6_x, {arg data; ~pad_6_x = data;}, 39);
MIDIdef.cc(\pad_6_y, {arg data; ~pad_6_y = data;
	~server_ip.sendMsg('/phone_override_msg',
		~speaker_number,
		5/16 + ~pad_6_x.linlin(0, 127, 0, 1/16), //buffer position
		~pad_6_y.linexp(0, 127, 0.2, 12.0), //playback rate
		~long_slider_location.linexp(0, 127, 0.01, 1.0), //length
		~pad_6_pressure.linlin(0, 127, 0.8, 1.0) //amplitude
	);
}, 40);

MIDIdef.cc(\pad_7_pressure, {arg data; ~pad_7_pressure = data}, 41);
MIDIdef.cc(\pad_7_x, {arg data; ~pad_7_x = data;}, 42);
MIDIdef.cc(\pad_7_y, {arg data; ~pad_7_y = data;
	~server_ip.sendMsg('/phone_override_msg',
		~speaker_number,
		6/16 + ~pad_7_x.linlin(0, 127, 0, 1/16), //buffer position
		~pad_7_y.linexp(0, 127, 0.2, 12.0), //playback rate
		~long_slider_location.linexp(0, 127, 0.01, 1.0), //length
		~pad_7_pressure.linlin(0, 127, 0.8, 1.0) //amplitude
	);
}, 43);

MIDIdef.cc(\pad_8_pressure, {arg data; ~pad_8_pressure = data}, 44);
MIDIdef.cc(\pad_8_x, {arg data; ~pad_8_x = data;}, 45);
MIDIdef.cc(\pad_8_y, {arg data; ~pad_8_y = data;
	~server_ip.sendMsg('/phone_override_msg',
		~speaker_number,
		7/16 + ~pad_8_x.linlin(0, 127, 0, 1/16), //buffer position
		~pad_8_y.linexp(0, 127, 0.2, 12.0), //playback rate
		~long_slider_location.linexp(0, 127, 0.01, 1.0), //length
		~pad_8_pressure.linlin(0, 127, 0.8, 1.0) //amplitude
	);
}, 46);

MIDIdef.cc(\pad_9_pressure, {arg data; ~pad_9_pressure = data}, 47);
MIDIdef.cc(\pad_9_x, {arg data; ~pad_9_x = data;}, 48);
MIDIdef.cc(\pad_9_y, {arg data; ~pad_9_y = data;
	~server_ip.sendMsg('/phone_override_msg',
		~speaker_number,
		8/16 + ~pad_9_x.linlin(0, 127, 0, 1/16), //buffer position
		~pad_9_y.linexp(0, 127, 0.2, 12.0), //playback rate
		~long_slider_location.linexp(0, 127, 0.01, 1.0), //length
		~pad_9_pressure.linlin(0, 127, 0.8, 1.0) //amplitude
	);
}, 49);

MIDIdef.cc(\pad_10_pressure, {arg data; ~pad_10_pressure = data}, 50);
MIDIdef.cc(\pad_10_x, {arg data; ~pad_10_x = data;}, 51);
MIDIdef.cc(\pad_10_y, {arg data; ~pad_10_y = data;
	~server_ip.sendMsg('/phone_override_msg',
		~speaker_number,
		9/16 + ~pad_10_x.linlin(0, 127, 0, 1/16), //buffer position
		~pad_10_y.linexp(0, 127, 0.2, 12.0), //playback rate
		~long_slider_location.linexp(0, 127, 0.01, 1.0), //length
		~pad_10_pressure.linlin(0, 127, 0.8, 1.0) //amplitude
	);
}, 52);

MIDIdef.cc(\pad_11_pressure, {arg data; ~pad_11_pressure = data}, 53);
MIDIdef.cc(\pad_11_x, {arg data; ~pad_11_x = data;}, 54);
MIDIdef.cc(\pad_11_y, {arg data; ~pad_11_y = data;
	~server_ip.sendMsg('/phone_override_msg',
		~speaker_number,
		10/16 + ~pad_11_x.linlin(0, 127, 0, 1/16), //buffer position
		~pad_11_y.linexp(0, 127, 0.2, 12.0), //playback rate
		~long_slider_location.linexp(0, 127, 0.01, 1.0), //length
		~pad_11_pressure.linlin(0, 127, 0.8, 1.0) //amplitude
	);
}, 55);

MIDIdef.cc(\pad_12_pressure, {arg data; ~pad_12_pressure = data}, 56);
MIDIdef.cc(\pad_12_x, {arg data; ~pad_12_x = data;}, 57);
MIDIdef.cc(\pad_12_y, {arg data; ~pad_12_y = data;
	~server_ip.sendMsg('/phone_override_msg',
		~speaker_number,
		11/16 + ~pad_12_x.linlin(0, 127, 0, 1/16), //buffer position
		~pad_12_y.linexp(0, 127, 0.2, 12.0), //playback rate
		~long_slider_location.linexp(0, 127, 0.01, 1.0), //length
		~pad_12_pressure.linlin(0, 127, 0.8, 1.0) //amplitude
	);
}, 58);

MIDIdef.cc(\pad_13_pressure, {arg data; ~pad_13_pressure = data}, 59);
MIDIdef.cc(\pad_13_x, {arg data; ~pad_13_x = data;}, 60);
MIDIdef.cc(\pad_13_y, {arg data; ~pad_13_y = data;
	~server_ip.sendMsg('/phone_override_msg',
		~speaker_number,
		12/16 + ~pad_13_x.linlin(0, 127, 0, 1/16), //buffer position
		~pad_13_y.linexp(0, 127, 0.2, 12.0), //playback rate
		~long_slider_location.linexp(0, 127, 0.01, 1.0), //length
		~pad_13_pressure.linlin(0, 127, 0.8, 1.0) //amplitude
	);
}, 61);

MIDIdef.cc(\pad_14_pressure, {arg data; ~pad_14_pressure = data}, 62);
MIDIdef.cc(\pad_14_x, {arg data; ~pad_14_x = data;}, 63);
MIDIdef.cc(\pad_14_y, {arg data; ~pad_14_y = data;
	~server_ip.sendMsg('/phone_override_msg',
		~speaker_number,
		13/16 + ~pad_14_x.linlin(0, 127, 0, 1/16), //buffer position
		~pad_14_y.linexp(0, 127, 0.2, 12.0), //playback rate
		~long_slider_location.linexp(0, 127, 0.01, 1.0), //length
		~pad_14_pressure.linlin(0, 127, 0.8, 1.0) //amplitude
	);
}, 64);

MIDIdef.cc(\pad_15_pressure, {arg data; ~pad_15_pressure = data}, 65);
MIDIdef.cc(\pad_15_x, {arg data; ~pad_15_x = data;}, 66);
MIDIdef.cc(\pad_15_y, {arg data; ~pad_15_y = data;
	~server_ip.sendMsg('/phone_override_msg',
		~speaker_number,
		14/16 + ~pad_15_x.linlin(0, 127, 0, 1/16), //buffer position
		~pad_15_y.linexp(0, 127, 0.2, 12.0), //playback rate
		~long_slider_location.linexp(0, 127, 0.01, 1.0), //length
		~pad_15_pressure.linlin(0, 127, 0.8, 1.0) //amplitude
	);
}, 67);

MIDIdef.cc(\pad_16_pressure, {arg data; ~pad_16_pressure = data}, 68);
MIDIdef.cc(\pad_16_x, {arg data; ~pad_16_x = data;}, 69);
MIDIdef.cc(\pad_16_y, {arg data; ~pad_16_y = data;
	~server_ip.sendMsg('/phone_override_msg',
		~speaker_number,
		15/16 + ~pad_16_x.linlin(0, 127, 0, 1/16), //buffer position
		~pad_16_y.linexp(0, 127, 0.2, 12.0), //playback rate
		~long_slider_location.linexp(0, 127, 0.01, 1.0), //length
		~pad_16_pressure.linlin(0, 127, 0.8, 1.0) //amplitude
	);
}, 70);

//up-down left
MIDIdef.cc(\up_left_pressure, {arg data;}, 80);
MIDIdef.cc(\down_left_pressure, {arg data;}, 81);

//big slider
MIDIdef.cc(\long_slider_pressure, {arg data;}, 22);
MIDIdef.cc(\long_slider_location, {arg data; ~long_slider_location = data;}, 10);
MIDIdef.cc(\long_slider_width, {arg data; ~long_slider_width = data;}, 11);

//up-down left
MIDIdef.cc(\up_right_pressure, {arg data;}, 82);
MIDIdef.cc(\down_right_pressure, {arg data;}, 83);

~patterns = List.new();
~patterns.add(1/10);
~patterns.add(1/9);
~patterns.add(1/8);
~patterns.add(1/7);
~patterns.add(1/6);
~patterns.add(1/5);
~patterns.add(1/4);
~patterns.add(1/3);
~patterns.add(1/2);
~patterns.add(1);
~patterns.add(Pwhite(0.2, 1.5));
~patterns.add(Pwhite(0.05, 0.07));
~patterns.add(Pwhite(0.1, 3.0));
~patterns.add(Pwhite(0.02, 0.4));
~patterns.add(Pwhite(2.0, 3.0));
~patterns.add(Pexprand(0.01, 2.0));
~patterns.add(Pexprand(0.01, 0.2));
~patterns.add(Pexprand(0.1, 3.0));
~patterns.add(Pgauss(0.5, 0.1));
~patterns.add(Pgauss(0.3, 0.02));
~patterns.add(Pn(Pseries(0.01, 0.02, 20)));
~patterns.add(Pn(Pseries(0.01, 0.1, 10)));
~patterns.add(Pn(Pseries(0.01, 0.01, 40)));
~patterns.add(Pbrown(0.1, 3.0, 0.1));
~patterns.add(Pbrown(0.01, 1.0, 0.01));
~patterns.add(Pn(Pgeom(0.01, 1.1, 20)));
~patterns.add(Pn(Pgeom(0.2, 1.3, 8)));
~patterns.add(Pseq([Pwhite(0.01, 2.0, 1), 1, 1/2, 1/3, 1/4], inf));
~patterns.add(Pseq([Pshuf([1, 1/2, 1/3, 1/4, 1/5, 1/6, 1/7, 1/8, 1/9, 1/10])], inf));
~patterns.add(Pseq([0.5, 0.5, 0.5, 0.25, 0.25, 0.5, 0.5, 1], inf));
~patterns.add(Pseq([1, Pn(1/2, 2)], inf));
~patterns.add(Pseq([Pn(0.5, 3), Pn(0.25, 4), Pn(0.5, 3)], inf));
~patterns.size.postln;
)