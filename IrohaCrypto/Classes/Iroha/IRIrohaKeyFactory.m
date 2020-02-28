//
//  IRCryptoKeyFactory.m
//  IrohaCrypto
//
//  Created by Ruslan Rezin on 07/10/2018.
//

#import "IRIrohaKeyFactory.h"
#import "ed25519.h"
#import "IRIrohaPrivateKey.h"
#import "IRIrohaPublicKey.h"

@implementation IRIrohaKeyFactory

- (id<IRCryptoKeypairProtocol> _Nullable)createRandomKeypair {
    public_key_t public_key;
    private_key_t private_key;

    int result = ed25519_create_keypair(&private_key, &public_key);

    NSData *publicKeyData = [[NSData alloc] initWithBytes:public_key.data
                                                   length:ed25519_pubkey_SIZE];
    NSData *privateKeyData = [[NSData alloc] initWithBytes:private_key.data
                                                    length:ed25519_privkey_SIZE];

    if (result == 0) {
        return nil;
    }

    IRIrohaPublicKey *publicKey = [[IRIrohaPublicKey alloc] initWithRawData:publicKeyData];

    if (!publicKey) {
        return nil;
    }

    IRIrohaPrivateKey *privateKey = [[IRIrohaPrivateKey alloc] initWithRawData:privateKeyData];

    if (!privateKey) {
        return nil;
    }

    return [[IRCryptoKeypair alloc] initPublicKey:publicKey privateKey:privateKey];
}

- (id<IRCryptoKeypairProtocol> _Nullable)deriveFromPrivateKey:(nonnull id<IRPrivateKeyProtocol>)privateKey {
    public_key_t public_key;
    private_key_t private_key;

    memcpy(private_key.data, privateKey.rawData.bytes, ed25519_privkey_SIZE);

    ed25519_derive_public_key(&private_key, &public_key);

    NSData *publicKeyData = [[NSData alloc] initWithBytes:public_key.data length:ed25519_pubkey_SIZE];
    IRIrohaPublicKey *publicKey = [[IRIrohaPublicKey alloc] initWithRawData:publicKeyData];

    if (!publicKey) {
        return nil;
    }

    return [[IRCryptoKeypair alloc] initPublicKey:publicKey
                                       privateKey:privateKey];
}

@end
