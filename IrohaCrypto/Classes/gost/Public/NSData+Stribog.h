//
//  NSData+SHA3.h
//  IrohaCrypto
//
//  Created by Ruslan Rezin on 10/5/2021.
//

#import <Foundation/Foundation.h>

@interface NSData (Stribog)

- (nullable NSData *)stribogWithError:(NSError*_Nullable*_Nullable)error;

@end
