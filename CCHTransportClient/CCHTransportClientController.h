//
//  CCHTransportClientController.h
//  Departures
//
//  Created by Hoefele, Claus on 07.08.14.
//  Copyright (c) 2014 Option-U Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CCHTransportGenerator;
@protocol CCHTransportParser;
@protocol CCHTransportClient;
@protocol CCHTransportClientDelegate;

@interface CCHTransportClientController : NSObject

@property (nonatomic, readonly) NSURLSession *session;
@property (nonatomic, weak) NSObject<CCHTransportClientDelegate> *delegate;

- (instancetype)init NS_DESIGNATED_INITIALIZER;

- (NSURLSessionDataTask *)executeDataTaskWithGenerator:(id<CCHTransportGenerator>)generator parser:(id<CCHTransportParser>)parser client:(NSObject<CCHTransportClient> *)client completionHandler:(void (^)(id result, NSError *error))completionHandler;

@end
