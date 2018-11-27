//
//  IRSeedCreator.h
//  IrohaCrypto
//
//  Created by Ruslan Rezin on 16/11/2018.
//

#import <Foundation/Foundation.h>
#import "IRMnemonicCreator.h"

@protocol IRSeedCreatorProtocol <NSObject>

- (nullable NSData*)randomSeedWithMnemonicStrength:(IRMnemonicStrength)strength
                                          password:(nonnull NSString*)password
                                           project:(nonnull NSString*)project
                                           purpose:(nonnull NSString*)purpose
                                            length:(NSUInteger)seedLength
                                    resultMnemonic:(id<IRMnemonicProtocol> *)mnemonic
                                             error:(NSError**)error;

- (nullable NSData*)randomSeedWithMnemonicStrength:(IRMnemonicStrength)strength
                                              salt:(nonnull NSData*)salt
                                            length:(NSUInteger)seedLength
                                    resultMnemonic:(id<IRMnemonicProtocol> *)mnemonic
                                             error:(NSError**)error;

- (nullable NSData*)deriveSeedFromMnemonicPhrase:(nonnull NSString*)mnemonicPhrase
                                        password:(nonnull NSString*)password
                                         project:(nonnull NSString*)project
                                         purpose:(nonnull NSString*)purpose
                                          length:(NSUInteger)seedLength
                                           error:(NSError**)error;

- (nullable NSData*)deriveSeedFromMnemonicPhrase:(nonnull NSString*)mnemonicPhrase
                                            salt:(nonnull NSData*)salt
                                          length:(NSUInteger)seedLength
                                           error:(NSError**)error;

@end

typedef NS_ENUM(NSUInteger, IRSeedError) {
    IREmptySalt,
    IRPasswordFromMnemonicFailed,
    IRScryptFailed
};

@interface IRBIP39ScryptSeedCreator : NSObject<IRSeedCreatorProtocol>

+ (nonnull instancetype)defaultCreator;

- (nonnull instancetype)initWithMnemonicCreator:(nonnull IRBIP39MnemonicCreator*)mnemonicCreator;

@end
