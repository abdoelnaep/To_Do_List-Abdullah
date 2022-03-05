//
//  DataModel.h
//  ToDoList
//
//  Created by Abdullah on 05/03/2022.
//  Copyright © 2022 Abdullah MAhmoud. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DataModel : NSObject
@property NSString * name;
@property NSString * priority;
@property NSDate * remainderDate;
@property NSString * dataDescription;
@property NSDate * createdDate;
@property NSString* isReminded;

@end

NS_ASSUME_NONNULL_END
