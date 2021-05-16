//
//  GostEngine.h
//  IrohaCrypto
//
//  Created by Ruslan Rezin on 15.05.2021.
//

#import <Foundation/Foundation.h>
#include "evp.h"

@interface GostEngine : NSObject

+ (nonnull ENGINE*)globalWithError:(NSError* _Nullable * _Nullable)error;

@end
