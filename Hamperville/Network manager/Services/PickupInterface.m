//
//  PickupInterface.m
//  Hamperville
//
//  Created by stplmacmini11 on 18/04/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "PickupInterface.h"
#import "APIInteractorProvider.h"
#import "IHampervilleAPIInteractor.h"

@implementation PickupInterface

- (void)getSchedulePickupWithPickupRequest:(PickupRequest *)pickupRequest andCompletionBlock:(pickupInterfaceCompletionBlock)block {
    _block = block;
    id apiInteractorProvider = [[APIInteractorProvider sharedInterface] getAPIInetractor];
    [apiInteractorProvider getSchedulePickupWithRequest:pickupRequest
                                     andCompletionBlock:^(BOOL success, id response) {
                                         [self parseGetSchedulePickup:response];
                                     }];
}

#pragma mark - Parsing methods

- (void)parseGetSchedulePickup:(id)response {
    if ([response isKindOfClass:[NSDictionary class]])
    {
        NSString *success = nil;
        if ([response hasValueForKey:kSuccessStatus]) {
            success = [response valueForKey:kSuccessStatus];
            if (success == kSuccess)
            {
                self.block(YES, [response valueForKey:@"data"]);
            }
            else
            {
                NSString *errorMessage = nil;
                if([response hasValueForKey:@"message"])
                {
                    errorMessage = [response valueForKey:@"message"];
                }
                _block(NO, errorMessage);
            }
        }
    }
    else if([response isKindOfClass:[NSError class]])
    {
        NSString *errorMessage = ((NSError *)response).localizedDescription;
        _block(NO, errorMessage);
    }
    else
    {
        _block(NO, nil);
    }
}

@end
