/*!
 * OSDCoreAuthRequestSigner.h
 *
 * Copyright (c) 2014 OpenSky, LLC
 *
 * Created by Skylar Schipper on 7/15/14
 */

#ifndef OSDCoreAuthRequestSigner_h
#define OSDCoreAuthRequestSigner_h

@import Foundation;

@class OSDCoreAuthContext;

@interface OSDCoreAuthRequestSigner : NSObject

+ (void)signRequest:(NSMutableURLRequest *)request context:(OSDCoreAuthContext *)context;
+ (void)signRequest:(NSMutableURLRequest *)request context:(OSDCoreAuthContext *)context otherParameters:(NSDictionary *)oParams;

@end

#endif
