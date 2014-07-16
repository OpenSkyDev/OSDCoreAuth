/*!
 * OSDCoreAuthPercentEncoder.h
 *
 * Copyright (c) 2014 OpenSky, LLC
 *
 * Created by Skylar Schipper on 7/15/14
 */

#ifndef OSDCoreAuthPercentEncoder_h
#define OSDCoreAuthPercentEncoder_h

@import Foundation;

@interface OSDCoreAuthPercentEncoder : NSObject

+ (NSString *)stringByAddingPercentEscapes:(NSString *)string;
+ (NSString *)stringByRemovingPercentEscapes:(NSString *)string;

@end

#endif
