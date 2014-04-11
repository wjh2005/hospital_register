//
// Created by Zhao yang on 3/21/14.
//

#import <Foundation/Foundation.h>
#import "ToPortalNavigationViewController.h"
#import "RegisterOrder.h"

@interface RegisterConfirmViewController : ToPortalNavigationViewController<UIAlertViewDelegate>

@property (nonatomic, strong) RegisterOrder *registerOrder;

- (id)initWithRegisterOrder:(RegisterOrder *)registerOrder;

@end