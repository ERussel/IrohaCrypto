//
//  IRHDWallet.h
//  IrohaCrypto
//
//  Created by Ruslan Rezin on 27.02.2020.
//

#import <Foundation/Foundation.h>
#import "IRCryptoKeypair.h"

typedef NS_ENUM(NSUInteger, IRBIP32HDWalletError) {
    IRBIP32HDWalletPrivateKeyFailed,
    IRBIP32HDWalletKeypairFailed,
    IRBIP32HDWalletInvalidMasterKey,
    IRBIP32HDWalletInvalidIndex
};

@interface IRBIP32HDWallet: NSObject

- (nullable instancetype)initWithSeed:(nonnull NSData*)seed error:(NSError*_Nullable*_Nullable)error;

- (nullable instancetype)hardenedWithIndex:(uint32_t)index error:(NSError*_Nullable*_Nullable)error;
- (nullable instancetype)normalWithIndex:(uint32_t)index error:(NSError*_Nullable*_Nullable)error;

@property(nonatomic, readonly)id<IRCryptoKeypairProtocol> _Nonnull keypair;

@end
