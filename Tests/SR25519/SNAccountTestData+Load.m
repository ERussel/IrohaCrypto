//
//  SNAccountTestData+Load.m
//  IrohaCryptoTests
//
//  Created by Ruslan Rezin on 26.06.2020.
//  Copyright © 2020 Ruslan Rezin. All rights reserved.
//

#import "SNAccountTestData+Load.h"

@implementation SNAccountTestData (Load)

+ (nonnull NSArray<SNAccountTestData*>*)loadFromFilename:(nonnull NSString*)filename
                                                language:(nonnull NSString*)language
                                                   error:(NSError*_Nullable*_Nullable)error {
    NSString *filePath = [[NSBundle bundleForClass:[self class]] pathForResource:[filename stringByDeletingPathExtension]
                                                         ofType:[filename pathExtension]];
    if (!filePath) {
        if (error != nil) {
            NSString *message = @"File doesn't exists";
            *error = [NSError errorWithDomain:NSStringFromClass([self class])
                                         code:SNAccountTestDataLoadingInvalidFilename
                                     userInfo:@{NSLocalizedDescriptionKey: message}];
        }

        return nil;
    }

    NSData *data = [NSData dataWithContentsOfFile:filePath options:0 error:error];

    if (!data) {
        return nil;
    }

    id result = [NSJSONSerialization JSONObjectWithData:data options:0 error:error];

    if (![result isKindOfClass:[NSArray class]]) {
        if (error != nil) {
            NSString *message = @"Invalid json format: expected root array";
            *error = [NSError errorWithDomain:NSStringFromClass([self class])
                                         code:SNAccountTestDataLoadingFormat
                                     userInfo:@{NSLocalizedDescriptionKey: message}];
        }

        return nil;
    }

    NSMutableArray<SNAccountTestData*> *tests = [NSMutableArray array];

    for (NSArray<NSString*> *testData in (NSArray*)result) {
        if ([testData count] < 3) {
            continue;
        }

        SNAccountTestData *data = [[SNAccountTestData alloc] initWithMnemonic:testData[0]
                                                                         seed:testData[1]
                                                                    publicKey:testData[2]];

        [tests addObject:data];
    }

    return tests;
}

@end
