//
//  Person.h
//  RunTimeDemo
//
//  Created by lidaojian on 2017/3/1.
//  Copyright © 2017年 lidaojian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithUserName:(NSString *)userName;

- (void)logUserName;

@end
