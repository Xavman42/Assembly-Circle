(
s.options.numOutputBusChannels = 8;
s.options.outDevice_("MME : Out 1-24 (MOTU Pro Audio)"); // This one for Windows in Studio A
s.options.numWireBufs = 256;
s.options.memSize = 65536;
Buffer.freeAll;
s.waitForBoot({
	b = Buffer.read(s, "C:/Users/xavie/OneDrive/Documents/SuperCollider/Recordings/SC_230424_182617 take 4.wav");
	s.sync;
	b.playOnce(out:0); // For Studio X mounted interface, switch this to 2
});
)