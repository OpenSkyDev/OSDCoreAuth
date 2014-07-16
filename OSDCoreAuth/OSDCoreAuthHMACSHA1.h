/*!
 * OSDCoreAuthHMACSHA1.h
 *
 * Copyright (c) 2014 OpenSky, LLC
 *
 * Created by Skylar Schipper on 7/15/14
 */

#ifndef OSDCoreAuthHMACSHA1_h
#define OSDCoreAuthHMACSHA1_h

#import <CoreFoundation/CoreFoundation.h>

CF_EXPORT
CFDataRef OSDCoreAuthCreateHMACSHA1Data(CFStringRef key, CFStringRef base);

#endif
