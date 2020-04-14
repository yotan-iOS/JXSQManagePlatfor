//
//  AutocompletionTableView.h
//  AutoLayout
//
//  Created by TestGhost on 2018/8/6.
//

#import <UIKit/UIKit.h>
#define ACOCaseSensitive @"ACOCaseSensitive"
#define ACOUseSourceFont @"ACOUseSourceFont"
#define ACOHighlightSubstrWithBold @"ACOHighlightSubstrWithBold"
#define ACOShowSuggestionsOnTop @"ACOShowSuggestionsOnTop"

@protocol AutocompletionTableViewDelegate;

@interface AutocompletionTableView : UITableView<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *suggestionsDictionary;
@property (nonatomic, strong) NSDictionary *options;
@property (nonatomic, strong) UIButton *deleButton;
- (void)hideOptionsView;

@property (nonatomic, assign) id<AutocompletionTableViewDelegate>  tabDelegate;

- (UITableView *)initWithTextField:(UITextField *)textField inViewController:(UIViewController *) parentViewController withOptions:(NSDictionary *)options;

@end

@protocol AutocompletionTableViewDelegate <NSObject>

- (void)autoCompletionTableView:(AutocompletionTableView *)completionView deleteString:(NSString *) sString;

- (void)autoCompletionTableView:(AutocompletionTableView *)completionView didSelectString:(NSString *) sString;



@end
