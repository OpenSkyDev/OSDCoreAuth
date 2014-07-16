/*!
 * OSDCoreAuthSignatureGenerator.h
 *
 * Copyright (c) 2014 OpenSky, LLC
 *
 * Created by Skylar Schipper on 7/15/14
 */

#ifndef OSDCoreAuthSignatureGenerator_h
#define OSDCoreAuthSignatureGenerator_h

@import Foundation;

@protocol OSDCoreAuthNonceGenerator;
@class OSDCoreAuthContext;

@interface OSDCoreAuthSignatureGenerator : NSObject

@property (nonatomic, strong) OSDCoreAuthContext *context;
@property (nonatomic, strong) NSURL *URL;
@property (nonatomic, strong) NSString *HTTPMethod; // GET
@property (nonatomic, strong) NSString *signatureVersion; // 1.0
@property (nonatomic, strong) NSString *signatureMethod; // HMAC-SHA1

@property (nonatomic, strong) id<OSDCoreAuthNonceGenerator> nonceGenerator;

@property (nonatomic, strong) NSDictionary *otherParameters;

- (NSString *)generateSignature;

- (NSString *)verifySignatureBaseStringBeforeHashing:(NSString *)baseString;

@end

FOUNDATION_EXTERN NSString *const kOSDCoreAuthSignatureHTTPMethodGet;
FOUNDATION_EXTERN NSString *const kOSDCoreAuthSignatureHTTPMethodPost;
FOUNDATION_EXTERN NSString *const kOSDCoreAuthSignatureHTTPMethodPatch;
FOUNDATION_EXTERN NSString *const kOSDCoreAuthSignatureHTTPMethodPut;
FOUNDATION_EXTERN NSString *const kOSDCoreAuthSignatureHTTPMethodDelete;

FOUNDATION_EXTERN NSString *const kOSDCoreAuthSignatureMethodPlainText;
FOUNDATION_EXTERN NSString *const kOSDCoreAuthSignatureMethodHMACSHA1;

FOUNDATION_EXPORT NSString *const kOSDCoreAuthSignatureVersion1_0;

#endif
