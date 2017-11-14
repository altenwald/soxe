-module(soxe_tests).
-compile([warnings_as_errors, debug_info]).
-author('manuel@altenwald.com').

-include_lib("eunit/include/eunit.hrl").
-include("soxe.hrl").

-define(AUDIO_WAV, "test/alesis_acoustic_bass.wav").
-define(AUDIO_GSM, "test/alesis_acoustic_bass.gsm").

info_test() ->
    ok = soxe:start(),
    Info = #soxe_info{ filename = ?AUDIO_WAV,
                       bitrate = 44100,
                       channels = 2,
                       encoding_text = "Signed PCM",
                       encoding_id = 1,
                       audio_length = 255564,
                       duration = 2 },
    ?assertEqual(Info, soxe:info(?AUDIO_WAV)),
    ok = soxe:stop(),
    ok.

convert_test() ->
    ok = soxe:start(),
    ok = soxe:convert(?AUDIO_WAV, ?AUDIO_GSM),
    Info = #soxe_info{ filename = ?AUDIO_GSM,
                       bitrate = 8000,
                       channels = 1,
                       encoding_text = "GSM",
                       encoding_id = 21,
                       audio_length = 0,
                       duration = 0 },
    ?assertEqual(Info, soxe:info(?AUDIO_GSM)),
    ok = soxe:stop(),
    ok.
