//
//  CCHTransportClientDelegate.h
//  HereToThere
//
//  Created by Hoefele, Claus on 19.11.14.
//  Copyright (c) 2014 Option-U Software. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CCHTransportClient;

@protocol CCHTransportClientDelegate <NSObject>

@optional
- (void)transportClientWillStartRequest:(NSObject<CCHTransportClient> *)transportClient;
- (void)transportClientDidFinishRequest:(NSObject<CCHTransportClient> *)transportClient;

@end

NS_ASSUME_NONNULL_END