-module(soxe).
-export([start/0, stop/0, convert/2]).
-on_load(init/0).

init() ->
    ok = erlang:load_nif("priv/soxe_drv", 0).

start() ->
    exit(nif_library_not_loaded).

stop() ->
    exit(nif_library_not_loaded).

convert(_Src, _Dst) ->
    exit(nif_library_not_loaded).
