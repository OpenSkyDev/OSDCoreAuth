/*!
 * OSDCoreAuthContext.h
 *
 * Copyright (c) 2014 OpenSky, LLC
 *
 * Created by Skylar Schipper on 7/15/14
 */

#ifndef OSDCoreAuthContext_h
#define OSDCoreAuthContext_h

@import Foundation;

@class OSDCoreAuthUserContext;

@interface OSDCoreAuthContext : NSObject

@property (nonatomic, strong, readonly) NSString *consumerKey;
@property (nonatomic, strong, readonly) NSString *consumerSecret;

@property (nonatomic, strong) OSDCoreAuthUserContext *userContext;

- (instancetype)initWithConsumerKey:(NSString *)key consumerSecret:(NSString *)secret;

@end

#endif
