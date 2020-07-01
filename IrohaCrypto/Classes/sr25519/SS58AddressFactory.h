//
//  SS58AddressFactory.h
//  IrohaCrypto
//
//  Created by Ruslan Rezin on 01.07.2020.
//

#import <Foundation/Foundation.h>
#import "SNPublicKey.h"

typedef NS_ENUM(UInt8, SNAddressType) {
    SNAddressTypePolkadotMain = 0,
    SNAddressTypePolkadotSecondary = 1,
    SNAddressTypeKusamaMain = 2,
    SNAddressTypeKusamaSecondary = 3,
    SNAddressTypeGenericSubstrate = 42
};

typedef NS_ENUM(NSUInteger, SNAddressFactoryError) {
    SNAddressFactoryUnsupported,
    SNAddressFactoryIncorrectChecksum,
    SNAddressFactoryUnexpectedType
};

@protocol SS58AddressFactoryProtocol

- (nullable NSString*)addressFromPublicKey:(nonnull SNPublicKey*)publicKey
                                      type:(SNAddressType)type
                                     error:(NSError*_Nullable*_Nullable)error;

- (nullable SNPublicKey*)publicKeyFromAddress:(nonnull NSString*)address
                                         type:(SNAddressType)type
                                        error:(NSError*_Nullable*_Nullable)error;

@end

@interface SS58AddressFactory : NSObject<SS58AddressFactoryProtocol>

@end
