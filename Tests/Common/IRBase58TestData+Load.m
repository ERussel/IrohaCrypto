//
//  IRBase58TestData+Load.m
//  IrohaCryptoTests
//
//  Created by Ruslan Rezin on 01.07.2020.
//  Copyright © 2020 Ruslan Rezin. All rights reserved.
//

#import "IRBase58TestData+Load.h"

@implementation IRBase58TestData (Load)

+ (nonnull NSArray<IRBase58TestData*>*)loadFromFilename:(nonnull NSString*)filename
                                                  error:(NSError*_Nullable*_Nullable)error {
    NSString *filePath = [[NSBundle bundleForClass:[self class]] pathForResource:[filename stringByDeletingPathExtension]
                                                         ofType:[filename pathExtension]];
    if (!filePath) {
        if (error != nil) {
            NSString *message = @"File doesn't exists";
            *error = [NSError errorWithDomain:NSStringFromClass([self class])
                                         code:IRBase58TestDataLoadingInvalidFilename
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
                                         code:IRBase58TestDataLoadingFormat
                                     userInfo:@{NSLocalizedDescriptionKey: message}];
        }

        return nil;
    }

    NSMutableArray<IRBase58TestData*> *tests = [NSMutableArray array];

    for (NSArray<NSString*> *testData in (NSArray*)result) {
        if ([testData count] < 2) {
            continue;
        }

        IRBase58TestData *data = [[IRBase58TestData alloc] initWithHex:testData[0]
                                                                base58:testData[1]];

        [tests addObject:data];
    }

    return tests;
}

@end
