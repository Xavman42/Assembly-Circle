//Performance script for Assembly Circle

//Wait for the server to be booted, then run the following block
(
~my_ip = NetAddr.new("127.0.0.1", 57120); //my ip address (for windows, go to cmd, then type ipconfig.
~server_ip = NetAddr.new("127.0.0.1", 57120); //ip of the server
~username = "Xavier0";//Your username goes here
~speaker_number = 0;//Coordinate your speaker number with the ensemble. They must all be unique!
"Client.scd".resolveRelative.load;
)

~server_ip.sendMsg('/fx_msg', ~speaker_number, "~reso_synth", \freq, 700);
~server_ip.sendMsg('/fx_msg', ~speaker_number, "~reso_synth", \freq, 220);
~server_ip.sendMsg('/fx_msg', ~speaker_number, "~reso_synth", \bwr, 0.01);
~server_ip.sendMsg('/fx_msg', ~speaker_number, "~reso_synth", \bwr, 0.1);
~server_ip.sendMsg('/fx_msg', ~speaker_number, "~reso_synth", \mix, 0.9);
~server_ip.sendMsg('/fx_msg', ~speaker_number, "~reso_synth", \mix, 0.1);

~server_ip.sendMsg('/fx_msg', ~speaker_number, "~chorus_synth", \mix, 0.0);
~server_ip.sendMsg('/fx_msg', ~speaker_number, "~chorus_synth", \mix, 0.5);
~server_ip.sendMsg('/fx_msg', ~speaker_number, "~chorus_synth", \depth, 0.5);
~server_ip.sendMsg('/fx_msg', ~speaker_number, "~chorus_synth", \depth, 0.1);

~server_ip.sendMsg('/fx_msg', ~speaker_number, "~distortion_synth", \mix, 1.0);
~server_ip.sendMsg('/fx_msg', ~speaker_number, "~distortion_synth", \lvl, 200);
~server_ip.sendMsg('/fx_msg', ~speaker_number, "~distortion_synth", \lvl, 40);

~server_ip.sendMsg('/fx_msg', ~speaker_number, "~reverb_synth", \mix, 1.0);
~server_ip.sendMsg('/fx_msg', ~speaker_number, "~reverb_synth", \mix, 0.1);
~server_ip.sendMsg('/fx_msg', ~speaker_number, "~reverb_synth", \revtime, 0.1);

~server_ip.sendMsg('/pattern_msg', ~speaker_number, \mylen, (Pwhite(0.5, 0.5)).asCompileString);
~server_ip.sendMsg('/pattern_msg', ~speaker_number, \mylen, (Pwhite(0.05, 0.07)).asCompileString);
~server_ip.sendMsg('/pattern_msg', ~speaker_number, \mydur, (Pwhite(0.05, 0.05)).asCompileString);
~server_ip.sendMsg('/pattern_msg', ~speaker_number, \mydur, (1).asCompileString);
~server_ip.sendMsg('/pattern_msg', ~speaker_number, \myrate, (Pwhite(0.1, 4.0)).asCompileString);
~server_ip.sendMsg('/pattern_msg', ~speaker_number, \myrate, (Pexprand(0.1, 2.0)).asCompileString);
~server_ip.sendMsg('/pattern_msg', ~speaker_number, \mypos, (Pwhite(0.5, 0.6)).asCompileString);
~server_ip.sendMsg('/pattern_msg', ~speaker_number, \mypos, (Pgauss(0.5, 0.35)).asCompileString);



//fx signal flow
// ~reso_synth -> ~chorus_synth -> ~distortion_synth -> ~reverb_synth

//fx_msg
// ~reso_synth    resonant filter
// \in            input bus, should be ~reso_bus  NO TOUCH
// \out           output bus, sends to ~chorus_bus NO TOUCH
// \freq          resonant frequency
// \bwr           bandwidth reciprocal of q value (sharpness of resonant peak)
// \mul           wet amplitude
// \mix           dry to wet ratio. 0 is dry, 1 is wet

//fx_msg
// ~chorus_synth  chorus effect
// \in            input bus, should be ~chorus_bus  NO TOUCH
// \out           output bus, sends to ~distortion_bus NO TOUCH
// \predelay
// \speed         rate of oscillation. typically small positive number < 1
// \depth         oscillation amplitude. typically 0 < n < 1
// \ph_diff
// \mul           wet amplitude
// \mix           dry to wet ratio. 0 is dry, 1 is wet

//fx_msg
// ~distortion_synth    distortion effect using amplitude multiplication
// \in            input bus, should be ~distortion_bus  NO TOUCH
// \out           output bus, sends to ~reverb_bus NO TOUCH
// \lvl           amount by which input signal is multiplied. higher numbers = more clipping
// \mul           wet amplitude
// \mix           dry to wet ratio. 0 is dry, 1 is wet

//fx_msg
// ~reverb_synth reverb effect
// \in           input bus, should be ~reso_bus  NO TOUCH
// \out          output bus, sends to ~snd_bus NO TOUCH
// \predelay
// \revtime      time until reverb fades away
// \lpf          low pass filter. Reduces boominess
// \mul           wet amplitude
// \mix           dry to wet ratio. 0 is dry, 1 is wet

//pattern_msg
// \mytrigger    how many grains per second. should be 1. NO TOUCH
// \mylen        grain length
// \mydur        duration between pattern events
// \myrate       grain buffer playback rate
// \mypos        starting position in the buffer
// \mymul        signal amplitude/volume
// \myout        output bus/channel, should be ~reso_bus NO TOUCH
