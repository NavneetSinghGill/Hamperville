//
//  Request.h
//  Hamperville
//
//  Created by stplmacmini11 on 07/04/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, RequestType){
    RequestGET,
    RequestPOST,
    RequestMutiPartPost,
    RequestDELETE,
    RequestPUT
};

@interface Request : NSObject

@property (nonatomic, strong) NSString *urlPath;
@property (nonatomic, assign) NSInteger requestType;

@property (nonatomic, strong) NSData *fileData;
@property (nonatomic, strong) NSString *dataFilename;
@property (nonatomic, strong) NSString *fileName;
@property (nonatomic, strong) NSString *mimeType;

- (NSMutableDictionary *)getParams;

@end
