//
//  IRNumberSerializer.m
//  IrohaCrypto
//
//  Created by Ruslan Rezin on 28.02.2020.
//

#import "IRNumberSerializer.h"

@implementation IRBigIndianSerializer

- (nonnull NSData*)serialize:(uint32_t)value bufferLength:(NSUInteger)length {
    NSMutableData *result = [NSMutableData dataWithLength:length];
    uint8_t* buffer = result.mutableBytes;

    uint32_t current = value;
    NSUInteger index = length - 1;

    while (current > 0 && index >= 0) {
        buffer[index] = current % 256;
        current = current / 256;
    }

    return result;
}

@end
