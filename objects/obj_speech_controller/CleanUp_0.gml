// Clean Up — stop the mic if the player leaves the room mid-recording
if (rec_buffer != -1) {
    audio_stop_recording(rec_channel);
    rec_buffer = -1;
}
