/*!
 * OSDCoreAuthSignatureGenerator.m
 *
 * Copyright (c) 2014 OpenSky, LLC
 *
 * Created by Skylar Schipper on 7/15/14
 */

#import "OSDCoreAuthSignatureGenerator.h"
#import "OSDCoreAuthContext.h"
#import "OSDCoreAuthUserContext.h"
#import "OSDCoreAuthNonceGenerator.h"
#import "OSDCoreAuthPercentEncoder.h"
#import "OSDCoreAuthHMACSHA1.h"

static NSString *const kOSDCoreAuthSignatureConsumerKey = @"oauth_consumer_key";
static NSString *const kOSDCoreAuthSignatureNonce       = @"oauth_nonce";
static NSString *const kOSDCoreAuthSignatureSigMethod   = @"oauth_signature_method";
static NSString *const kOSDCoreAuthSignatureTimestamp   = @"oauth_timestamp";
static NSString *const kOSDCoreAuthSignatureToken       = @"oauth_token";
static NSString *const kOSDCoreAuthSignatureVersion     = @"oauth_version";
static NSString *const kOSDCoreAuthSignature            = @"oauth_signature";

@interface _OSDCoreAuthSignatureGeneratorBasicNonce : NSObject <OSDCoreAuthNonceGenerator>

@end

@interface OSDCoreAuthSignatureGenerator ()

@property (nonatomic, strong) NSURLComponents *components;

@end

@implementation OSDCoreAuthSignatureGenerator

#pragma mark -
#pragma mark - Setters
- (void)setURL:(NSURL *)URL {
    _URL = URL;
    if (_URL) {
        self.components = [NSURLComponents componentsWithURL:URL resolvingAgainstBaseURL:NO];
    } else {
        self.components = nil;
    }
}

#pragma mark -
#pragma mark - Lazy Loaders
- (id<OSDCoreAuthNonceGenerator>)nonceGenerator {
    if (!_nonceGenerator) {
        _nonceGenerator = [[_OSDCoreAuthSignatureGeneratorBasicNonce alloc] init];
    }
    return _nonceGenerator;
}
- (NSString *)HTTPMethod {
    if (!_HTTPMethod) {
        _HTTPMethod = kOSDCoreAuthSignatureHTTPMethodGet;
    }
    return _HTTPMethod;
}
- (NSString *)signatureVersion {
    if (!_signatureVersion) {
        _signatureVersion = kOSDCoreAuthSignatureVersion1_0;
    }
    return _signatureVersion;
}
- (NSString *)signatureMethod {
    if (!_signatureMethod) {
        _signatureMethod = kOSDCoreAuthSignatureMethodHMACSHA1;
    }
    return _signatureMethod;
}

#pragma mark -
#pragma mark - Helpers
- (NSString *)newTimestampString {
    return [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]];
}

#pragma mark -
#pragma mark - Generators
- (NSString *)generateSignature {
    NSMutableDictionary *oauth = [self newOAuthDictionary];
    NSMutableDictionary *params = [oauth mutableCopy];
    
    if ([self.signatureMethod isEqualToString:kOSDCoreAuthSignatureMethodPlainText]) {
        params[kOSDCoreAuthSignature] = [self signingKey];
        return nil;
    }
    
    for (NSURLQueryItem *item in self.components.queryItems) {
        oauth[item.name] = item.value;
    }
    for (NSString *key in [self.otherParameters allKeys]) {
        oauth[key] = [OSDCoreAuthPercentEncoder stringByRemovingPercentEscapes:self.otherParameters[key]];
    }
    
    NSDictionary *encoded = [self dictionaryByEscapingKeysAndValues:oauth];
    
    NSArray *keys = [self sortedKeysForDictionary:encoded];
    
    NSMutableString *paramString = [NSMutableString string];
    for (NSString *key in keys) {
        [paramString appendFormat:@"%@=%@&",key,encoded[key]];
    }
    [paramString replaceCharactersInRange:NSMakeRange(paramString.length - 1, 1) withString:@""];
    
    NSString *base = [self newSignatureBaseStringWithParameterString:paramString];
    base = [self verifySignatureBaseStringBeforeHashing:base];
    
    NSString *base64EncodedSig = [self makeSignatureForBaseString:base];
    
    params[kOSDCoreAuthSignature] = base64EncodedSig;
    
    NSLog(@"%@",params);
    NSLog(@"%@",base);
    
    return [self newOauthHeaderStringForParams:params];
}

- (NSString *)newOauthHeaderStringForParams:(NSDictionary *)params {
    NSMutableString *string = [NSMutableString stringWithString:@"OAuth "];
    
    NSArray *allKeys = [self sortedKeysForDictionary:params];
    
    for (NSString *key in allKeys) {
        NSString *encVal = [OSDCoreAuthPercentEncoder stringByAddingPercentEscapes:params[key]];
        [string appendFormat:@"%@=\"%@\", ",key,encVal];
    }
    
    [string replaceCharactersInRange:NSMakeRange(string.length - 2, 2) withString:@""];
    
    return [string copy];
}

- (NSString *)verifySignatureBaseStringBeforeHashing:(NSString *)baseString {
    return baseString;
}

#pragma mark -
#pragma mark - Make Signature
- (NSString *)signingKey {
    NSString *key = [NSString stringWithFormat:@"%@&",self.context.consumerSecret];
    if (self.context.userContext.accessTokenSecret) {
        key = [key stringByAppendingString:self.context.userContext.accessTokenSecret];
    }
    return key;
}
- (NSString *)makeSignatureForBaseString:(NSString *)base {
    NSString *key = [self signingKey];
    
    NSLog(@"%@",[self signingKey]);
    
    NSData *data = (__bridge_transfer id)OSDCoreAuthCreateHMACSHA1Data((__bridge CFStringRef)key, (__bridge CFStringRef)base);
    
    return [data base64EncodedStringWithOptions:0];
}

#pragma mark -
#pragma mark - Oauth Helpers
- (NSMutableDictionary *)newOAuthDictionary {
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    info[kOSDCoreAuthSignatureConsumerKey] = self.context.consumerKey;
    info[kOSDCoreAuthSignatureNonce] = [self.nonceGenerator newNonceForGenerator:self];
    info[kOSDCoreAuthSignatureSigMethod] = self.signatureMethod;
    info[kOSDCoreAuthSignatureTimestamp] = [self newTimestampString];
    info[kOSDCoreAuthSignatureVersion] = self.signatureVersion;
    if (self.context.userContext.accessToken) {
        info[kOSDCoreAuthSignatureToken] = self.context.userContext.accessToken;
    }
    return info;
}
- (NSString *)newSignatureBaseStringWithParameterString:(NSString *)params {
    NSURLComponents *components = [self.components copy];
    components.query = nil;
    
    NSString *URL = [OSDCoreAuthPercentEncoder stringByAddingPercentEscapes:[[components URL] absoluteString]];
    params = [OSDCoreAuthPercentEncoder stringByAddingPercentEscapes:params];
    
    return [NSString stringWithFormat:@"%@&%@&%@",self.HTTPMethod,URL,params];
}
- (NSDictionary *)dictionaryByEscapingKeysAndValues:(NSDictionary *)dictonary {
    NSMutableDictionary *tmp = [NSMutableDictionary dictionaryWithCapacity:dictonary.count];
    for (NSString *key in [dictonary allKeys]) {
        NSString *eKey = [OSDCoreAuthPercentEncoder stringByAddingPercentEscapes:key];
        NSString *eVal = [OSDCoreAuthPercentEncoder stringByAddingPercentEscapes:dictonary[key]];
        tmp[eKey] = eVal;
    }
    return [tmp copy];
}
- (NSArray *)sortedKeysForDictionary:(NSDictionary *)dictionary {
    return [[dictionary allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
}


@end

NSString *const kOSDCoreAuthSignatureHTTPMethodGet = @"GET";
NSString *const kOSDCoreAuthSignatureHTTPMethodPost = @"POST";
NSString *const kOSDCoreAuthSignatureHTTPMethodPatch = @"PATCH";
NSString *const kOSDCoreAuthSignatureHTTPMethodPut = @"PUT";
NSString *const kOSDCoreAuthSignatureHTTPMethodDelete = @"DELETE";

NSString *const kOSDCoreAuthSignatureMethodHMACSHA1 = @"HMAC-SHA1";
NSString *const kOSDCoreAuthSignatureMethodPlainText = @"PLAINTEXT";

NSString *const kOSDCoreAuthSignatureVersion1_0 = @"1.0";

@implementation _OSDCoreAuthSignatureGeneratorBasicNonce

- (NSString *)newNonceForGenerator:(OSDCoreAuthSignatureGenerator *)generator {
    return [[[NSUUID UUID] UUIDString] stringByReplacingOccurrencesOfString:@"-" withString:@""];
}

@end
