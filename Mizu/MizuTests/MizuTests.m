//
//  MizuTests.m
//  MizuTests
//
//  Created by Apisit Toompakdee on 6/29/14.
//  Copyright (c) 2014 Mizu. All rights reserved.
//

#import <XCTest/XCTest.h>
#define TestNeedsToWaitForBlock() __block BOOL blockFinished = NO
#define BlockFinished() blockFinished = YES
#define WaitForBlock() while (CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0, true) && !blockFinished)
@interface MizuTests : XCTestCase

@end

@implementation MizuTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample
{
    XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}

- (void)testGetBusiness{
    TestNeedsToWaitForBlock();
    __block NSArray* result;
    [MZBusiness businessesNearby:CLLocationCoordinate2DMake(0, 0) block:^(NSArray *list, NSError *error) {
        result = list;
        BlockFinished();
    }];
    WaitForBlock();
    XCTAssertTrue(result!=nil);
}

@end
