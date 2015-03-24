SOXE
====

Sox Erlang library to (firstly and mainly) convert files between formats. In a very early version this library only do conversions.

```erlang
soxe:start(),
soxe:convert("audio.wav", "audio.mp3").
```

NOTE: the sox library is required and all the codecs you want to use for conversion (for example, mp3lame, ffmpeg, ...).
