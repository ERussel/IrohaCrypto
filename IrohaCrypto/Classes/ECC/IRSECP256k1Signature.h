//
//  IRECC255k1Signature.h
//  Pods
//
//  Created by Ruslan Rezin on 28.02.2020.
//

#import <Foundation/Foundation.h>
#import "IRSignature.h"

@interface IRSECP256k1Signature : NSObject<IRSignatureProtocol>

+ (NSUInteger)length;

@end
