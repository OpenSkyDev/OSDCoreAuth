/*!
 * OSDCoreAuthNonceGenerator.h
 *
 * Copyright (c) 2014 OpenSky, LLC
 *
 * Created by Skylar Schipper on 7/15/14
 */

#ifndef OSDCoreAuthNonceGenerator_h
#define OSDCoreAuthNonceGenerator_h

@class OSDCoreAuthSignatureGenerator;

@protocol OSDCoreAuthNonceGenerator <NSObject>

- (NSString *)newNonceForGenerator:(OSDCoreAuthSignatureGenerator *)generator;

@end

#endif
