//
//  IRSeedCreator.m
//  IrohaCrypto
//
//  Created by Ruslan Rezin on 16/11/2018.
//

#import "IRSeedCreator.h"
#import "crypto_pwhash_scryptsalsa208sha256.h"

static const NSUInteger MEMORY_COST = 16384;
static const NSUInteger PARALELIZATION_FACTOR = 1;
static const NSUInteger BLOCK_SIZE = 8;
static NSString* const WORDS_SEPARATOR = @" ";

@interface IRBIP39ScryptSeedCreator()

@property(strong, nonatomic)IRBIP39MnemonicCreator* _Nonnull mnemonicCreator;

@end

@implementation IRBIP39ScryptSeedCreator

#pragma mark - Initialize

+ (instancetype)defaultCreator {
    IRBIP39MnemonicCreator* mnemonicCreator = [[IRBIP39MnemonicCreator alloc] initWithLanguage:IREnglish];
    return [[IRBIP39ScryptSeedCreator alloc] initWithMnemonicCreator:mnemonicCreator];
}

- (instancetype)initWithMnemonicCreator:(IRBIP39MnemonicCreator*)mnemonicCreator {
    if (self = [super init]) {
        _mnemonicCreator = mnemonicCreator;
    }

    return self;
}

#pragma mark - IRSeedCreatorProtocol

- (nullable NSData*)randomSeedWithMnemonicStrength:(IRMnemonicStrength)strength
                                          password:(nonnull NSString*)password
                                           project:(nonnull NSString*)project
                                           purpose:(nonnull NSString*)purpose
                                            length:(NSUInteger)seedLength
                                    resultMnemonic:(id<IRMnemonicProtocol> *)mnemonic
                                             error:(NSError**)error {
    NSData* saltData = [IRBIP39ScryptSeedCreator createSaltFromPassword:password
                                                                project:project
                                                                purpose:purpose
                                                                  error:error];

    if (!saltData) {
        return nil;
    }

    return [self randomSeedWithMnemonicStrength:strength
                                           salt:saltData
                                         length:seedLength
                                 resultMnemonic:mnemonic
                                          error:error];
}

- (nullable NSData*)randomSeedWithMnemonicStrength:(IRMnemonicStrength)strength
                                              salt:(nonnull NSData*)salt
                                            length:(NSUInteger)seedLength
                                    resultMnemonic:(id<IRMnemonicProtocol> *)mnemonic
                                             error:(NSError**)error {
    *mnemonic = [_mnemonicCreator randomMnemonic:strength error:error];

    if (!(*mnemonic)) {
        return nil;
    }

    NSString* normalizedMnemonic = [[*mnemonic toString] decomposedStringWithCompatibilityMapping];
    NSData* password = [normalizedMnemonic dataUsingEncoding:NSUTF8StringEncoding];

    if (!password) {
        if (error) {
            *error = [NSError errorWithDomain:NSStringFromClass([self class])
                                         code:IRPasswordFromMnemonicFailed
                                     userInfo:@{NSLocalizedDescriptionKey: @"Can't create password from mnemonic"}];
        }

        return nil;
    }

    return [IRBIP39ScryptSeedCreator createSeedWithPassword:password
                                                       salt:salt
                                                     length:seedLength
                                                      error:error];
}

- (nullable NSData*)deriveSeedFromMnemonicPhrase:(nonnull NSString*)mnemonicPhrase
                                        password:(nonnull NSString*)password
                                         project:(nonnull NSString*)project
                                         purpose:(nonnull NSString*)purpose
                                          length:(NSUInteger)seedLength
                                           error:(NSError**)error {
    NSData* saltData = [IRBIP39ScryptSeedCreator createSaltFromPassword:password
                                                                project:project
                                                                purpose:purpose
                                                                  error:error];

    if (!saltData) {
        return nil;
    }

    return [self deriveSeedFromMnemonicPhrase:mnemonicPhrase
                                         salt:saltData
                                       length:(NSUInteger)seedLength
                                        error:error];
}

- (nullable NSData*)deriveSeedFromMnemonicPhrase:(nonnull NSString*)mnemonicPhrase
                                            salt:(nonnull NSData*)salt
                                          length:(NSUInteger)seedLength
                                           error:(NSError**)error {
    NSArray<NSString*>* wordList = [mnemonicPhrase componentsSeparatedByString:WORDS_SEPARATOR];
    id<IRMnemonicProtocol> mnemonic = [_mnemonicCreator mnemonicFromList:wordList
                                                                   error:error];

    if (!mnemonic) {
        return nil;
    }

    NSString* normalizedMnemonic = [[mnemonic toString] decomposedStringWithCompatibilityMapping];
    NSData* password = [normalizedMnemonic dataUsingEncoding:NSUTF8StringEncoding];

    if (!password) {
        if (error) {
            *error = [NSError errorWithDomain:NSStringFromClass([self class])
                                         code:IRPasswordFromMnemonicFailed
                                     userInfo:@{NSLocalizedDescriptionKey: @"Can't create password from mnemonic"}];
        }

        return nil;
    }


    return [IRBIP39ScryptSeedCreator createSeedWithPassword:password
                                                       salt:salt
                                                     length:seedLength
                                                      error:error];
}

#pragma mark - Helpers

+ (nullable NSData*)createSeedWithPassword:(nonnull NSData*)password
                                      salt:(nonnull NSData*)salt
                                    length:(NSUInteger)length
                                     error:(NSError**)error {
    uint8_t result[length];

    int status = crypto_pwhash_scryptsalsa208sha256_ll((uint8_t*)(password.bytes),
                                                       password.length,
                                                       (uint8_t*)(salt.bytes),
                                                       salt.length,
                                                       MEMORY_COST,
                                                       BLOCK_SIZE,
                                                       PARALELIZATION_FACTOR,
                                                       result,
                                                       length);

    if (status != 0) {
        if (error) {
            NSString *message = [NSString stringWithFormat:@"Unexpected scrypt status %@ received", @(status)];
            *error = [NSError errorWithDomain:NSStringFromClass([self class])
                                         code:IRScryptFailed
                                     userInfo:@{NSLocalizedDescriptionKey: message}];
        }

        return nil;
    }

    return [NSData dataWithBytes:result length:length];
}

+ (nullable NSData*)createSaltFromPassword:(nonnull NSString*)password
                                   project:(nonnull NSString*)project
                                   purpose:(nonnull NSString*)purpose
                                     error:(NSError**)error {
    NSString* normalizedSalt = [[NSString stringWithFormat:@"%@|%@|%@", project, purpose, password]
                                decomposedStringWithCompatibilityMapping];

    NSData* saltData = [normalizedSalt dataUsingEncoding:NSUTF8StringEncoding];

    if (!saltData) {
        if (error) {
            *error = [NSError errorWithDomain:NSStringFromClass([self class])
                                         code:IREmptySalt
                                     userInfo:@{NSLocalizedDescriptionKey: @"Unexpected nil salt"}];
        }
    }

    return saltData;
}

@end
