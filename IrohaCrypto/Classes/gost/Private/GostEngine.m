//
//  GostEngine.m
//  IrohaCrypto
//
//  Created by Ruslan Rezin on 15.05.2021.
//

#import "GostEngine.h"
#import "GostError.h"
#include "e_gost_err.h"
#include "gost_lcl.h"

@implementation GostEngine

+ (nonnull ENGINE*)globalWithError:(NSError* _Nullable * _Nullable)error {
    if (engine != NULL) {
        return engine;
    }

    engine = ENGINE_new();

    NSError *resultError = [self bindEngine:engine];

    if (resultError) {
        ENGINE_free(engine);
        engine = NULL;
    }

    if (error) {
        *error = resultError;
    }

    return engine;
}

+ (NSError*)createErrorWithMessage:(NSString*)message {
    return [NSError errorWithDomain:NSStringFromClass([self class])
                               code:GostEngineCode
                           userInfo:@{NSLocalizedDescriptionKey: message}];
}

+ (nullable NSError*)bindEngine:(nonnull ENGINE*)e {
    if (!ENGINE_set_id(e, "gost")) {
        return [GostEngine createErrorWithMessage:@"ENGINE_set_id failed!!!"];
    }

    if (!ENGINE_set_name(e, "GOST")) {
        return [GostEngine createErrorWithMessage:@"ENGINE_set_name failed!!!"];
    }

    if (!ENGINE_set_pkey_meths(e, gost_pkey_meths)) {
        return [GostEngine createErrorWithMessage:@"ENGINE_set_pkey_meths failed"];
    }

    if (!ENGINE_set_pkey_asn1_meths(e, gost_pkey_asn1_meths)) {
        return [GostEngine createErrorWithMessage:@"ENGINE_set_pkey_asn1_meths failed"];
    }

    /* Control function and commands */
    if (!ENGINE_set_cmd_defns(e, gost_cmds)) {
        return [GostEngine createErrorWithMessage:@"ENGINE_set_cmd_defns failed"];
    }
    if (!ENGINE_set_ctrl_function(e, gost_control_func)) {
        return [GostEngine createErrorWithMessage:@"ENGINE_set_ctrl_func failed"];
    }
    if (!ENGINE_set_destroy_function(e, gost_engine_destroy)
        || !ENGINE_set_init_function(e, gost_engine_init)
        || !ENGINE_set_finish_function(e, gost_engine_finish)) {
        return [GostEngine createErrorWithMessage:@"Can set lifecycle func"];
    }

    struct gost_meth_minfo *minfo = gost_meth_array;
    for (; minfo->nid; minfo++) {

        /* This skip looks temporary. */
        if (minfo->nid == NID_id_tc26_cipher_gostr3412_2015_magma_ctracpkm_omac)
            continue;

        if (!register_ameth_gost(minfo->nid, minfo->ameth, minfo->pemstr,
                minfo->info))
            return [GostEngine createErrorWithMessage:@"Can't create ameth"];

        if (!register_pmeth_gost(minfo->nid, minfo->pmeth, 0))
            return [GostEngine createErrorWithMessage:@"Can't create pmeth"];
    }

    if (!ENGINE_register_pkey_meths(e))
        return [GostEngine createErrorWithMessage:@"Can't register pmeth"];

    ENGINE_register_all_complete();

    ERR_load_GOST_strings();

    if (!EVP_PKEY_asn1_add0(ameth_GostR3410_2012_256)) {
        return [GostEngine createErrorWithMessage:@"Can't register ameth"];
    }

    return nil;
}

static ENGINE *engine = NULL;

static EVP_PKEY_METHOD* pmeth_GostR3410_2012_256 = NULL;

static EVP_PKEY_ASN1_METHOD* ameth_GostR3410_2012_256 = NULL;

static struct gost_meth_minfo {
    int nid;
    EVP_PKEY_METHOD **pmeth;
    EVP_PKEY_ASN1_METHOD **ameth;
    const char *pemstr;
    const char *info;
} gost_meth_array[] = {
    {
        NID_id_GostR3410_2012_256,
        &pmeth_GostR3410_2012_256,
        &ameth_GostR3410_2012_256,
        "GOST2012_256",
        "GOST R 34.10-2012 with 256 bit key",
    },
    { 0 },
};

#ifndef OSSL_NELEM
# define OSSL_NELEM(x) (sizeof(x)/sizeof((x)[0]))
#endif

/* `- 1' because of terminating zero element */
static int known_meths_nids[OSSL_NELEM(gost_meth_array) - 1];

static int gost_engine_init(ENGINE* e) {
    return 1;
}

static int gost_engine_finish(ENGINE* e) {
    return 1;
}

static int gost_engine_destroy(ENGINE* e) {
    gost_param_free();

    struct gost_meth_minfo *minfo = gost_meth_array;
    for (; minfo->nid; minfo++) {
        *minfo->pmeth = NULL;
        *minfo->ameth = NULL;
    }

    ERR_unload_GOST_strings();

    return 1;
}

static int gost_meth_nids(const int **nids)
{
    struct gost_meth_minfo *info = gost_meth_array;
    int *n = known_meths_nids;

    *nids = n;
    for (; info->nid; info++)
        *n++ = info->nid;
    return OSSL_NELEM(known_meths_nids);
}

/* ENGINE_PKEY_METHS_PTR installed by ENGINE_set_pkey_meths */
static int gost_pkey_meths(ENGINE *e, EVP_PKEY_METHOD **pmeth,
                           const int **nids, int nid)
{
    struct gost_meth_minfo *info;

    if (!pmeth)
        return gost_meth_nids(nids);

    for (info = gost_meth_array; info->nid; info++)
        if (nid == info->nid) {
            *pmeth = *info->pmeth;
            return 1;
        }
    *pmeth = NULL;
    return 0;
}

/* ENGINE_PKEY_ASN1_METHS_PTR installed by ENGINE_set_pkey_asn1_meths */
static int gost_pkey_asn1_meths(ENGINE *e, EVP_PKEY_ASN1_METHOD **ameth,
                                const int **nids, int nid)
{
    struct gost_meth_minfo *info;

    if (!ameth)
        return gost_meth_nids(nids);

    for (info = gost_meth_array; info->nid; info++)
        if (nid == info->nid) {
            *ameth = *info->ameth;
            return 1;
        }
    *ameth = NULL;
    return 0;
}

@end
