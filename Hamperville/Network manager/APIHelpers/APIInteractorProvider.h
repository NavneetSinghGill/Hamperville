//
//  APIInteractorProvider.h
//  Hamperville
//
//  Created by stplmacmini11 on 07/04/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import <Foundation/Foundation.h>
@class iHampervilleAPIInteractor;

@interface APIInteractorProvider : NSObject

+ (APIInteractorProvider *)sharedInterface;

- (iHampervilleAPIInteractor *) getAPIInetractor;

@end
