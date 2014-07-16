//
//  OSDCoreAuthTests.m
//  OSDCoreAuthTests
//
//  Created by Skylar Schipper on 7/15/14.
//  Copyright (c) 2014 OpenSky, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <OSDCoreAuth/OSDCoreAuth.h>

// Tweets made with @E8EBA347 https://twitter.com/E8EBA347
#import "TwitterTests.h"

@interface OSDCoreAuthTests : XCTestCase

@end

@implementation OSDCoreAuthTests

- (void)testAuthStringGeneration {
    OSDCoreAuthUserContext *user = [[OSDCoreAuthUserContext alloc] init];
    user.accessToken = @"test_token";
    user.accessTokenSecret = @"test_token_secret";
    
    OSDCoreAuthContext *context = [[OSDCoreAuthContext alloc] initWithConsumerKey:@"test_key" consumerSecret:@"test_secret"];
    context.userContext = user;
    
    OSDCoreAuthSignatureGenerator *generator = [[OSDCoreAuthSignatureGenerator alloc] init];
    generator.context = context;
    generator.HTTPMethod = kOSDCoreAuthSignatureHTTPMethodPost;
    generator.URL = [NSURL URLWithString:@"https://api.twitter.com/1/statuses/update.json?include_entities=true"];
    
    NSString *string = [generator generateSignature];
    
    XCTAssertNotNil(string);
}

- (void)testTwitterCreds {
    OSDCoreAuthUserContext *user = [[OSDCoreAuthUserContext alloc] init];
    user.accessToken = ACCESS_TOKEN;
    user.accessTokenSecret = ACCESS_TOKEN_SEC;
    
    OSDCoreAuthContext *context = [[OSDCoreAuthContext alloc] initWithConsumerKey:CONSUMER_KEY consumerSecret:CONSUMER_KEY_SEC];
    context.userContext = user;
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://api.twitter.com/1.1/account/verify_credentials.json"]];
    
    [OSDCoreAuthRequestSigner signRequest:request context:context];
    
    XCTestExpectation *expect = [self expectationWithDescription:@"test-creds"];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSUInteger status = [((NSHTTPURLResponse *)response) statusCode];
        XCTAssertEqual(status, 200);
        XCTAssertNil(error);
        if (status != 200) {
            NSLog(@"%@",response);
            NSLog(@"%@",[NSJSONSerialization JSONObjectWithData:data options:0 error:nil]);
        }
        [expect fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError *error) {
        XCTAssertNil(error);
    }];
}

- (void)testTwitter {
    OSDCoreAuthUserContext *user = [[OSDCoreAuthUserContext alloc] init];
    user.accessToken = ACCESS_TOKEN;
    user.accessTokenSecret = ACCESS_TOKEN_SEC;
    
    OSDCoreAuthContext *context = [[OSDCoreAuthContext alloc] initWithConsumerKey:CONSUMER_KEY consumerSecret:CONSUMER_KEY_SEC];
    context.userContext = user;
    
    NSDictionary *statusDict = @{@"status": [[NSUUID UUID] UUIDString]};
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://api.twitter.com/1.1/statuses/update.json"]];
    request.HTTPMethod = @"POST";
    request.HTTPBody = [[NSString stringWithFormat:@"status=%@",statusDict[@"status"]] dataUsingEncoding:NSUTF8StringEncoding];
    [request setValue:[NSString stringWithFormat:@"%lu",(unsigned long)request.HTTPBody.length] forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    
    [OSDCoreAuthRequestSigner signRequest:request context:context otherParameters:statusDict];
    
    NSLog(@"%@",request.allHTTPHeaderFields);
    
    XCTestExpectation *expect = [self expectationWithDescription:@"test"];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSUInteger status = [((NSHTTPURLResponse *)response) statusCode];
        XCTAssertEqual(status, 200);
        XCTAssertNil(error);
        if (status != 200) {
            NSLog(@"%@",response);
            NSLog(@"%@",[NSJSONSerialization JSONObjectWithData:data options:0 error:nil]);
        }
        [expect fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError *error) {
        XCTAssertNil(error);
    }];
}

@end
