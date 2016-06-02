//
//  UserRequest.h
//  Hamperville
//
//  Created by stplmacmini11 on 13/04/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "Request.h"
#import "User.h"

@interface UserRequest : Request

@property(strong, nonatomic) User *user;

- (id)initWithUser:(User *)user shouldUpdate:(BOOL)shouldUpdate;
- (id)initWithUserID:(NSString *)userID;
- (id)initWithEmail:(NSString *)email;
- (id)initWithOldPassword:(NSString *)oldPass andNwPassword:(NSString *)nwPass;
- (id)initWithUserToLogout:(User *)user;

- (id)initWithGetPickAndDeliverWithUser:(User *)user;
- (id)initWithPostPickAndDeliverWithUser:(User *)user andMethod:(NSString *)method;

- (id)initWithGetNotificationPrefOfUser:(User *)user;
- (id)initWithPostNotificationPrefWithAppNotification:(BOOL)app textNotifications:(BOOL)text andEmail:(BOOL)email;

- (id)initWithPermanentPreferences;
- (id)initWithPostPermanentPreferencesWithDetergentID:(NSString *)detergentID softnerID:(NSString *)softnerID drySheetID:(NSString *)drySheetID;

- (id)initWithGetWashAndFoldPreferences;
- (id)initWithPostWashAndFoldPreferencesWithDataDictionary:(NSDictionary *)dataDictionary;

- (id)initWithGetSpecialCarePreferences;
- (id)initWithPostSpecialCarePreferencesWithDataDictionary:(NSDictionary *)dataDictionary;

- (id)initWithGetSubscription;
- (id)initWithPostSubscriptionWithStatus:(BOOL)status andSubscriptionID:(NSString *)subscriptionID;

- (id)initWithGetAddressPreferences;
- (id)initWithPostAddressWithDataDictionary:(NSDictionary *)dataDictionary;

- (id)initWithPostAddCreditWithDataDictionary:(NSDictionary *)dataDictionary;
- (id)initWithDeleteCreditCard:(NSString *)creditCardID;
- (id)initWithPostSetPrimaryCreditCard:(NSString *)creditCardID;
- (id)initWithGetAlreadyAddedCreditCards;

- (id)initWithGetPriceList;

- (id)initWithPostHelpWithDataDictionary:(NSDictionary *)dataDictionary;

- (NSDictionary *)getParams;

@end
