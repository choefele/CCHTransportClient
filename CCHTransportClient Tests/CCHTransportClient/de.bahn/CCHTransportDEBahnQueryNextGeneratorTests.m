//
//  CCHTransportDEBahnQueryNextGeneratorTests.m
//  CCHTransportClient
//
//  Copyright (C) 2015 Claus Höfele
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "CCHTransportDEBahnQueryNextGenerator.h"

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

@interface CCHTransportDEBahnQueryNextGeneratorTests : XCTestCase

@end

@implementation CCHTransportDEBahnQueryNextGeneratorTests

- (void)testGenerateContext
{
    NSString *context = [CCHTransportDEBahnQueryNextGenerator generateContextWithRequestID:@"requestID" sequenceNumber:123 ld:@"ld"];
    XCTAssertTrue([context containsString:@"ident=requestID"]);
    XCTAssertTrue([context containsString:@"seqnr=123"]);
    XCTAssertTrue([context containsString:@"ld=ld"]);
}

- (void)testDate
{
    NSString *context = [CCHTransportDEBahnQueryNextGenerator generateContextWithRequestID:@"requestID" sequenceNumber:123 ld:@"ld"];
    CCHTransportDEBahnQueryNextGenerator *generator = [[CCHTransportDEBahnQueryNextGenerator alloc] initWithContext:context laterTrips:YES];
    NSURLRequest *request = [generator generateRequest];
    NSString *URLString = request.URL.query;
    XCTAssertTrue([URLString containsString:@"REQ0HafasScrollDir=1"]);
}

@end
