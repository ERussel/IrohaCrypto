//
//  NSData+SHA3.h
//  IrohaCrypto
//
//  Created by Ruslan Rezin on 14/10/2018.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, IRBlake2sError) {
    IRBlake2sInvalidLength,
    IRBlake2sAlgoFailed
};

@interface NSData (Blake2s)

- (nullable NSData *)blake2s:(NSUInteger)length error:(NSError*_Nullable*_Nullable)error;

// runs blake2s with 32 length
- (nullable NSData *)blake2sWithError:(NSError*_Nullable*_Nullable)error;

@end
