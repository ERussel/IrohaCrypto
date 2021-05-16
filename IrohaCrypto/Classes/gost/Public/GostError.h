//
//  GostError.h
//  Pods
//
//  Created by Ruslan Rezin on 15.05.2021.
//

#ifndef GostError_h
#define GostError_h

typedef NS_ENUM(NSInteger, GostErrorCode) {
    GostEngineCode,
    GostKeyFactoryCode,
    GostPrivateKeyCode,
    GostPublicKeyCode,
    GostSignatureCode,
    GostSignerCode,
    GostSignatureVerifierCode
};

#define ENGINE_SUCCESS 1

#endif /* GostError_h */
