/*!
 * OSDCoreAuthPercentEncoder.m
 *
 * Copyright (c) 2014 OpenSky, LLC
 *
 * Created by Skylar Schipper on 7/15/14
 */

#import "OSDCoreAuthPercentEncoder.h"

@interface OSDCoreAuthPercentEncoder ()

@end

@implementation OSDCoreAuthPercentEncoder

+ (NSString *)stringByAddingPercentEscapes:(NSString *)string {
    return (__bridge_transfer id)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)string, NULL, CFSTR("!*'();:@&=+$,/?%#[]"), kCFStringEncodingUTF8);
}
+ (NSString *)stringByRemovingPercentEscapes:(NSString *)string {
    return (__bridge_transfer id)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault, (__bridge CFStringRef)string, CFSTR(""), kCFStringEncodingUTF8);
}

@end
