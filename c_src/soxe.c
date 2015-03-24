#include <sox.h>
#include <unistd.h>

#include "erl_nif.h"

#define MAX_SAMPLES ((size_t) 4096)
#define MAX_STRING_SIZE 1028

sox_bool always_true(const char* str) {
    return sox_true;
}

static int sox_status = 0;

static ERL_NIF_TERM soxe_start(ErlNifEnv* env, int argc, const ERL_NIF_TERM argv[]) {
    if (!sox_status) {
        sox_init();
        sox_status = 1;
        return enif_make_atom(env, "ok");
    }
    return enif_make_atom(env, "already_started");
}

static ERL_NIF_TERM soxe_stop(ErlNifEnv* env, int argc, const ERL_NIF_TERM argv[]) {
    if (sox_status) {
        sox_quit();
        sox_status = 0;
        return enif_make_atom(env, "ok");
    }
    return enif_make_atom(env, "already_stopped");
}

static ERL_NIF_TERM soxe_convert(ErlNifEnv* env, int argc, const ERL_NIF_TERM argv[]) {
    sox_format_t *in, *out;
    sox_sample_t samples[MAX_SAMPLES];
    char fsrc[MAX_STRING_SIZE], fdst[MAX_STRING_SIZE];

    if (argc != 2) {
        return enif_make_badarg(env);
    }

    if (!sox_status) {
        return enif_make_atom(env, "not_started");
    }

    enif_get_string(env, argv[0], fsrc, MAX_STRING_SIZE, ERL_NIF_LATIN1);
    enif_get_string(env, argv[1], fdst, MAX_STRING_SIZE, ERL_NIF_LATIN1);

    in = sox_open_read(fsrc, NULL, NULL, NULL);
    if (!in) {
        /* FIXME: change this to another kind of error */
        return enif_make_badarg(env);
    }
    out = sox_open_write(fdst, &in->signal, NULL, NULL, NULL, &always_true);
    if (!out) {
        /* FIXME: change this to another kind of error */
        sox_close(in);
        return enif_make_badarg(env);
    }

    while (sox_read(in, samples, MAX_SAMPLES)) {
        if (!sox_write(out, samples, MAX_SAMPLES)) {
            /* FIXME: change this to another kind of error */
            sox_close(in);
            sox_close(out);
            return enif_make_badarg(env);
        }
    }

    sox_close(in);
    sox_close(out);

    return enif_make_atom(env, "ok");
}

static ErlNifFunc nif_funcs[] = {
    {"start", 0, soxe_start},
    {"stop", 0, soxe_stop},
    {"convert", 2, soxe_convert}
};

ERL_NIF_INIT(soxe, nif_funcs, NULL, NULL, NULL, NULL)
