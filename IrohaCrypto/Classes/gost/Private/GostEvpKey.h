//
//  GostEvpKey.h
//  Pods
//
//  Created by Ruslan Rezin on 16.05.2021.
//

#import <Foundation/Foundation.h>
#import "GostPublicKey.h"
#import "GostPrivateKey.h"
#include "evp.h"

@protocol GostEvpKeyProtocol

+ (nullable instancetype)createFromEVP:(nonnull EVP_PKEY*)key error:(NSError*_Nullable*_Nullable)error;

- (nonnull EVP_PKEY*)toEVPKeyWithError:(NSError*_Nullable*_Nullable)error;

@end

@interface GostPrivateKey(EVP)<GostEvpKeyProtocol>

@end


@interface GostPublicKey(EVP)<GostEvpKeyProtocol>

@end
