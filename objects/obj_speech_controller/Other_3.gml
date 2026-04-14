// Game End — stop any active mic recording so the OS releases the device
if (rec_buffer != -1) {
    audio_stop_recording(rec_channel);
    rec_buffer = -1;
}
