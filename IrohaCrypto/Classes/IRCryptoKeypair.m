//
//  IRCryptoKeypair.m
//  IrohaCrypto
//
//  Created by Ruslan Rezin on 07/10/2018.
//

#import "IRCryptoKeypair.h"

@interface IRCryptoKeypair()

@property(nonatomic)_Nonnull id<IRPublicKeyProtocol> publicKey;
@property(nonatomic)_Nonnull id<IRPrivateKeyProtocol> privateKey;

@end


@implementation IRCryptoKeypair

- (instancetype)initPublicKey:(_Nonnull id<IRPublicKeyProtocol>)publicKey
                   privateKey:(_Nonnull id<IRPrivateKeyProtocol>)privateKey {
    if (self = [super init]) {
        _publicKey = publicKey;
        _privateKey = privateKey;
    }

    return self;
}

@end
