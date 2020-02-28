//
//  IRNumberSerializer.h
//  IrohaCrypto
//
//  Created by Ruslan Rezin on 28.02.2020.
//

#import <Foundation/Foundation.h>

@protocol IRNumberSerializerProtocol <NSObject>

- (nonnull NSData*)serialize:(uint32_t)value bufferLength:(NSUInteger)length;

@end

@interface IRBigIndianSerializer : NSObject <IRNumberSerializerProtocol>

@end
