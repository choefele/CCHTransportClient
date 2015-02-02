//
//  CCHTransportClientVBBSTBReqGenerator.m
//  Abfahrt Berlin
//
//  Created by Hoefele, Claus on 26.06.14.
//  Copyright (c) 2014 Option-U Software. All rights reserved.
//

#import "CCHTransportDEVBBSTBReqGenerator.h"

#import "CCHTransportDEVBBClientUtils.h"

@interface CCHTransportDEVBBSTBReqGenerator()

@property (nonatomic, copy) NSString *accessID;
@property (nonatomic, copy) NSDate *date;
@property (nonatomic, copy) NSString *stationID;
@property (nonatomic) NSUInteger maxNumberOfResults;

@end

@implementation CCHTransportDEVBBSTBReqGenerator

- (instancetype)initWithAccessID:(NSString *)accessID date:(NSDate *)date stationID:(NSString *)stationID maxNumberOfResults:(NSUInteger)maxNumberOfResults
{
    self = [super init];
    if (self) {
        _accessID = accessID;
        _date = date;
        _stationID = stationID;
        _maxNumberOfResults = maxNumberOfResults;
    }
    
    return self;
}

- (NSURLRequest *)generateRequest
{
    NSString *payloadFormat = @"<STBReq boardType='DEP' maxJourneys='%tu'><Time>%@</Time><Period><DateBegin>%@</DateBegin></Period><TableStation externalId='%@' /></STBReq>";
    NSString *timeString = [CCHTransportDEVBBClientUtils timeStringFromDate:self.date];
    NSString *dateString = [CCHTransportDEVBBClientUtils dateStringFromDate:self.date];
    NSString *payLoad = [NSString stringWithFormat:payloadFormat, self.maxNumberOfResults, timeString, dateString, self.stationID];

    return [CCHTransportDEVBBClientUtils URLRequestWithData:payLoad accessID:self.accessID];
}

@end
