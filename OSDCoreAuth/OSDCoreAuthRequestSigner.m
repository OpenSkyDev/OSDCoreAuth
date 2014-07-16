/*!
 * OSDCoreAuthRequestSigner.m
 *
 * Copyright (c) 2014 OpenSky, LLC
 *
 * Created by Skylar Schipper on 7/15/14
 */

#import "OSDCoreAuthRequestSigner.h"

#import "OSDCoreAuthSignatureGenerator.h"

@interface OSDCoreAuthRequestSigner ()

@end

@implementation OSDCoreAuthRequestSigner

+ (void)signRequest:(NSMutableURLRequest *)request context:(OSDCoreAuthContext *)context {
    [self signRequest:request context:context otherParameters:nil];
}
+ (void)signRequest:(NSMutableURLRequest *)request context:(OSDCoreAuthContext *)context otherParameters:(NSDictionary *)oParams {
    OSDCoreAuthSignatureGenerator *generator = [[OSDCoreAuthSignatureGenerator alloc] init];
    generator.context = context;
    generator.URL = request.URL;
    generator.HTTPMethod = request.HTTPMethod;
    generator.otherParameters = oParams;
    
    [request setValue:[generator generateSignature] forHTTPHeaderField:@"Authorization"];
}

@end
