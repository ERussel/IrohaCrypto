//
//  GostSignature.h
//  IrohaCrypto
//
//  Created by Ruslan Rezin on 16.05.2021.
//

#import <Foundation/Foundation.h>
#import "IRSignature.h"

@interface GostSignature : NSObject<IRSignatureProtocol>

+ (NSUInteger)size;

@end
