//
//  UpdateProtocol.h
//  ToDoList
//
//  Created by Abdullah on 05/03/2022.
//  Copyright © 2022 Abdullah MAhmoud. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol UpdateProtocol <NSObject>

-(void) updateMehodDic :(NSMutableDictionary *) updatedDict :(NSInteger) index :(NSInteger) indexSearch;

@end

NS_ASSUME_NONNULL_END
