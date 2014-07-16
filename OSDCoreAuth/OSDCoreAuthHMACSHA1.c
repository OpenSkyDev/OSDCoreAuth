//
//  OSDCoreAuthHMACSHA1.c
//  OSDCoreAuth
//
//  Created by Skylar Schipper on 7/15/14.
//  Copyright (c) 2014 OpenSky, LLC. All rights reserved.
//

#import "OSDCoreAuthHMACSHA1.h"
#import <CommonCrypto/CommonCrypto.h>

CFDataRef OSDCoreAuthCreateHMACSHA1Data(CFStringRef key, CFStringRef base) {
    CFDataRef keyData = CFStringCreateExternalRepresentation(kCFAllocatorDefault, key, kCFStringEncodingUTF8, 0);
    CFDataRef baseData = CFStringCreateExternalRepresentation(kCFAllocatorDefault, base, kCFStringEncodingUTF8, 0);
    
    const void *cKey = CFDataGetBytePtr(keyData);
    CC_LONG cKeyLen = (CC_LONG)CFDataGetLength(keyData);
    
    const void *cBase = CFDataGetBytePtr(baseData);
    CC_LONG cBaseLen = (CC_LONG)CFDataGetLength(baseData);
    
    unsigned char *buffer = malloc(CC_SHA1_DIGEST_LENGTH);
    
    CCHmac(kCCHmacAlgSHA1, cKey, cKeyLen, cBase, cBaseLen, buffer);
    
    CFDataRef ref = CFDataCreateWithBytesNoCopy(kCFAllocatorDefault, buffer, CC_SHA1_DIGEST_LENGTH, NULL);
    
    CFRelease(keyData);
    CFRelease(baseData);
    
    if (ref == NULL) {
        free(buffer);
    }
    
    return ref;
}
