//
//  IRBIP39TestData+Load.m
//  IrohaCryptoTests
//
//  Created by Ruslan Rezin on 27.02.2020.
//  Copyright © 2020 Ruslan Rezin. All rights reserved.
//

#import "IRBIP39TestData+Load.h"

@implementation IRBIP39TestData (Load)

+ (nonnull NSArray<IRBIP39TestData*>*)loadFromFilename:(nonnull NSString*)filename
                                              language:(nonnull NSString*)language
                                                 error:(NSError*_Nullable*_Nullable)error {

    NSString *filePath = [[NSBundle bundleForClass:[self class]] pathForResource:[filename stringByDeletingPathExtension]
                                                         ofType:[filename pathExtension]];
    if (!filePath) {
        if (error != nil) {
            NSString *message = @"File doesn't exists";
            *error = [NSError errorWithDomain:NSStringFromClass([self class])
                                         code:IRIRBIP39DataLoadingInvalidFilename
                                     userInfo:@{NSLocalizedDescriptionKey: message}];
        }

        return nil;
    }

    NSData *data = [NSData dataWithContentsOfFile:filePath options:0 error:error];

    if (!data) {
        return nil;
    }

    id result = [NSJSONSerialization JSONObjectWithData:data options:0 error:error];

    if (![result isKindOfClass:[NSDictionary class]]) {
        if (error != nil) {
            NSString *message = @"Invalid json format: expected root dict";
            *error = [NSError errorWithDomain:NSStringFromClass([self class])
                                         code:IRIRBIP39DataLoadingFormat
                                     userInfo:@{NSLocalizedDescriptionKey: message}];
        }

        return nil;
    }

    if (![[result objectForKey:language] isKindOfClass:[NSArray<NSArray<NSString*>*> class]]) {
        if (error != nil) {
            NSString *message = @"Invalid json format: expected list of test data";
            *error = [NSError errorWithDomain:NSStringFromClass([self class])
                                         code:IRIRBIP39DataLoadingFormat
                                     userInfo:@{NSLocalizedDescriptionKey: message}];
        }

        return nil;
    }

    NSArray *testDataList = (NSArray*)[result objectForKey:language];

    NSMutableArray<IRBIP39TestData*> *tests = [NSMutableArray array];

    for (NSArray<NSString*> *testData in testDataList) {
        if ([testData count] < 3) {
            continue;
        }

        IRBIP39TestData *data = [[IRBIP39TestData alloc] initWithEntropy:testData[0]
                                                                mnemonic:testData[1]
                                                                    seed:testData[2]];

        [tests addObject:data];
    }

    return tests;
}

@end
