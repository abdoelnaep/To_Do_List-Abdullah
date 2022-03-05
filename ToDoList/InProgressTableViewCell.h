//
//  InProgressTableViewCell.h
//  ToDoList
//
//  Created by Abdullah on 05/03/2022.
//  Copyright © 2022 Abdullah MAhmoud. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface InProgressTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *inProgressNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *inProgressDateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *inProgressImage;

@end

NS_ASSUME_NONNULL_END
