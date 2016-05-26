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
#import "Order.h"

@implementation PickupInterface

- (void)getSchedulePickupWithPickupRequest:(PickupRequest *)pickupRequest andCompletionBlock:(pickupInterfaceCompletionBlock)block {
    _block = block;
    id apiInteractorProvider = [[APIInteractorProvider sharedInterface] getAPIInetractor];
    [apiInteractorProvider getSchedulePickupWithRequest:pickupRequest
                                     andCompletionBlock:^(BOOL success, id response) {
                                         [self parseGetSchedulePickup:response];
                                     }];
}

- (void)postRequestPickupWithPickupRequest:(PickupRequest *)pickupRequest andCompletionBlock:(pickupInterfaceCompletionBlock)block {
    _block = block;
    id apiInteractorProvider = [[APIInteractorProvider sharedInterface] getAPIInetractor];
    [apiInteractorProvider postRequestPickupWithRequest:pickupRequest
                                     andCompletionBlock:^(BOOL success, id response) {
                                         [self parseGetSchedulePickup:response];
                                     }];
}

- (void)getOrderHistoryWithPickupRequest:(PickupRequest *)pickupRequest andCompletionBlock:(pickupInterfaceCompletionBlock)block {
    _block = block;
    id apiInteractorProvider = [[APIInteractorProvider sharedInterface] getAPIInetractor];
    [apiInteractorProvider getOrderHistoryWithRequest:pickupRequest
                                   andCompletionBlock:^(BOOL success, id response) {
                                       [self parseOrderHistory:response];
                                   }];
}

- (void)postModifyOrderWithPickupRequest:(PickupRequest *)pickupRequest andCompletionBlock:(pickupInterfaceCompletionBlock)block {
    _block = block;
    id apiInteractorProvider = [[APIInteractorProvider sharedInterface] getAPIInetractor];
    [apiInteractorProvider postModifyOrderWithRequest:pickupRequest
                                   andCompletionBlock:^(BOOL success, id response) {
                                       [self parseGeneralDataResponse:response];
                                   }];
}

- (void)postCancelOrderWithPickupRequest:(PickupRequest *)pickupRequest andCompletionBlock:(pickupInterfaceCompletionBlock)block {
    _block = block;
    id apiInteractorProvider = [[APIInteractorProvider sharedInterface] getAPIInetractor];
    [apiInteractorProvider postCancelOrderWithRequest:pickupRequest
                                   andCompletionBlock:^(BOOL success, id response) {
                                       [self parseGeneralDataResponse:response];
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

- (void)parseOrderHistory:(id)response {
    if ([response isKindOfClass:[NSDictionary class]])
    {
        NSString *success = nil;
        if ([response hasValueForKey:kSuccessStatus]) {
            success = [response valueForKey:kSuccessStatus];
            if (success == kSuccess)
            {
                NSMutableArray *ordersDictionaries = [[response valueForKey:@"data"] valueForKey:@"order_history"];
                NSMutableArray *orders = [NSMutableArray array];
                for (NSDictionary *dict in ordersDictionaries) {
                    [orders addObject:[Order getOrderFromDictionary:dict]];
                }
                NSMutableDictionary *modifiedDictionary = [NSMutableDictionary dictionary];
                for (NSString *key in [[response valueForKey:@"data"] allKeys]) {
                    if ([key isEqualToString:@"order_history"]) {
                        [modifiedDictionary setObject:orders forKey:@"order_history"];
                    } else {
                        [modifiedDictionary setObject:[[response valueForKey:@"data"] valueForKey:key] forKey:key];
                    }
                }
                self.block(YES, modifiedDictionary);
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

- (void)parseGeneralDataResponse:(id)response
{
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
