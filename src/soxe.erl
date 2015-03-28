-module(soxe).
-export([start/0, stop/0, convert/2, info/1]).
-on_load(init/0).

-include("soxe.hrl").

load_path(File) ->
    MapFilter = fun(Ebin) ->
        Priv = filename:absname(Ebin) ++ "/../priv/",
        case file:read_file_info(Priv ++ File ++ ".so") of
            {ok, _} -> {true, Priv ++ File};
            _ -> false
        end
    end,
    case lists:zf(MapFilter, code:get_path()) of
    [Dir|_] ->
        erlang:load_nif(Dir, 0);
    [] ->
        error_logger:format("Error: ~s not found in code path\n", [File]),
        throw(enoent)
    end.

init() ->
    ok = load_path("soxe_drv").

start() ->
    exit(nif_library_not_loaded).

stop() ->
    exit(nif_library_not_loaded).

convert(_Src, _Dst) ->
    exit(nif_library_not_loaded).

info(_Filename) ->
    exit(nif_library_not_loaded).
