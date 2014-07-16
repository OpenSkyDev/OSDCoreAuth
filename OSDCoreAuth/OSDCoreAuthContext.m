/*!
 * OSDCoreAuthContext.m
 *
 * Copyright (c) 2014 OpenSky, LLC
 *
 * Created by Skylar Schipper on 7/15/14
 */

#import "OSDCoreAuthContext.h"
#import "OSDCoreAuthUserContext.h"

@interface OSDCoreAuthContext ()

@property (nonatomic, strong, readwrite) NSString *consumerKey;
@property (nonatomic, strong, readwrite) NSString *consumerSecret;

@end

@implementation OSDCoreAuthContext

- (instancetype)initWithConsumerKey:(NSString *)key consumerSecret:(NSString *)secret {
    self = [super init];
    if (self) {
        self.consumerKey = key;
        self.consumerSecret = secret;
    }
    return self;
}

@end
