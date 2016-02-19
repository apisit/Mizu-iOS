//
//  MZSucceededTransactionView.h
//  MizuManager
//
//  Created by Apisit Toompakdee on 11/21/15.
//  Copyright © 2015 Mizu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^DidTapOk)();

@interface MZSucceededTransactionView : UIView

- (void)didTapOk:(DidTapOk)block;
- (void)show:(NSString*)description;
@end
