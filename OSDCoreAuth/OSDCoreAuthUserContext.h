/*!
 * OSDCoreAuthUserContext.h
 *
 * Copyright (c) 2014 OpenSky, LLC
 *
 * Created by Skylar Schipper on 7/15/14
 */

#ifndef OSDCoreAuthUserContext_h
#define OSDCoreAuthUserContext_h

#import <Foundation/Foundation.h>

@interface OSDCoreAuthUserContext : NSObject

@property (nonatomic, strong) NSString *accessToken;
@property (nonatomic, strong) NSString *accessTokenSecret;

@end

#endif
