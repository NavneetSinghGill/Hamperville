//
//  APIInteractorProvider.m
//  Hamperville
//
//  Created by stplmacmini11 on 07/04/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "APIInteractorProvider.h"
#import "RealHampervilleAPI.h"
#import "TestHampervilleAPI.h"

@implementation APIInteractorProvider

+ (APIInteractorProvider *)sharedInterface
{
    static APIInteractorProvider *singleton = nil;
    
    @synchronized(self)
    {
        if (!singleton)
        {
            singleton = [[APIInteractorProvider alloc] init];
        }
    }
    
    return singleton;
}

#pragma mark init method

- (id)init
{
    self = [super init];
    return self;
}

- (iHampervilleAPIInteractor *) getAPIInetractor
{
//    if ([Util isLiveMode])
//    {
        return (iHampervilleAPIInteractor *)[RealHampervilleAPI alloc];
//    }
//    else
//    {
//        return (iHampervilleAPIInteractor *)[TestHampervilleAPI alloc];
//    }
}

@end
