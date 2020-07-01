//
//  Blake2sTests.m
//  IrohaCryptoTests
//
//  Created by Ruslan Rezin on 01.07.2020.
//  Copyright © 2020 Ruslan Rezin. All rights reserved.
//

@import XCTest;
@import IrohaCrypto;

static const int MESSAGES_COUNT = 4;

static NSString * const MESSAGES[] = {
    @"",
    @"hello world!",
    @"привет!",
    @"69217a3079908094e11121d042354a7c1f55b6482ca1a51e1b250dfd1ed0eef96b07ae5278b0eb87df625c2cc592988ecfe4d70fa43867ccf23c0b46bf694479"
};

static NSString * const BLAKE2s_256[] = {
    @"69217a3079908094e11121d042354a7c1f55b6482ca1a51e1b250dfd1ed0eef9",
    @"6b07ae5278b0eb87df625c2cc592988ecfe4d70fa43867ccf23c0b46bf694479",
    @"f6d028d866efc9ad8a253292238dc19968d9025ba896a8f5ae8ec1dce58a663c",
    @"27cf83347905093044e264277f7afb4e190702f33778ad40362a51ae78db9f77"
};

static NSString * const BLAKE2b_512[] = {
    @"786a02f742015903c6c6fd852552d272912f4740e15847618a86e217f71f5419d25e1031afee585313896444934eb04b903a685b1448b755d56f701afe9be2ce",
    @"fa02d55d26bc5cda1e2d67fb7424f6132c58fed81a52816342795de54d3b2d8b91749f267d2491ed05ca0cbbd0e641cc1758b92e99eb1d8771060ebacbc83c25",
    @"49edcb3b81213bc6f79c6cc028441055ffa9bf5ce11c820a866b3b7da5dfc8ef3e9f3a005f936b86e0c75281349e8dd88dae439bc000b8e44e23e798cee8f314",
    @"5e915cb4de04ba439b7035d49eac96bac9c76c1763c96fcc535b22c0f8ebfe4b2e35a12d401b6b53bf4ccc5737975a820a7ab9dda0ac045602eec02e03b7f7f3"
};

@interface Blake2sTests : XCTestCase

@end

@implementation Blake2sTests

- (void)testBlake2s {

    NSError *error;
    for (int i = 0; i < MESSAGES_COUNT; i++) {
        NSData *message = [MESSAGES[i] dataUsingEncoding:NSUTF8StringEncoding];
        NSData *hashedMessage = [message blake2sWithError:&error];

        if (error != nil) {
            NSString *message = [error localizedDescription];
            XCTFail("%@", message);
            return;
        }

        XCTAssertEqualObjects(BLAKE2s_256[i], [hashedMessage toHexString]);
    }
}

- (void)testBlake2b {

    NSError *error;
    for (int i = 0; i < MESSAGES_COUNT; i++) {
        NSData *message = [MESSAGES[i] dataUsingEncoding:NSUTF8StringEncoding];
        NSData *hashedMessage = [message blake2bWithError:&error];

        if (error != nil) {
            NSString *message = [error localizedDescription];
            XCTFail("%@", message);
            return;
        }

        XCTAssertEqualObjects(BLAKE2b_512[i], [hashedMessage toHexString]);
    }
}

@end
