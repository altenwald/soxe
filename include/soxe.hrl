-type bitrate() :: pos_integer().
-type channels() :: pos_integer().
-type encoding_text() :: string().
-type encoding_id() :: non_neg_integer().
-type audio_length() :: non_neg_integer().
-type duration() :: non_neg_integer().

-record(soxe_info,{
    filename :: string(),
    bitrate :: bitrate(),
    channels :: channels(),
    encoding_text :: encoding_text(),
    encoding_id :: encoding_id(),
    audio_length :: audio_length(),
    duration :: duration()
}).
