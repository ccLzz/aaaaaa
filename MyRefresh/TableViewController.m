//
//  TableViewController.m
//  MyRefresh
//
//  Created by 软通 on 16/4/20.
//  Copyright © 2016年 软通. All rights reserved.
//

#import "TableViewController.h"
#import "HeadView.h"
#import "MyHeadView.h"
@interface TableViewController ()
@property (strong,nonatomic)MyHeadView *headView;
@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];


    
    self.navigationController.navigationBar.translucent = NO;//去除毛玻璃效果后，tableview就不需要滑动到navigationbar下面了，所以tableview的frame.y会下移到navbar下，contentInset.top变为0
    self.navigationController.navigationBarHidden=YES;
    self.headView=[[MyHeadView alloc]initWithScrollView:self.tableView andStartBlock:^{
        NSLog(@"start refresh");
    } endBlock:^{
        NSLog(@"end refresh");
    }];
    //[self.tableView addSubview:self.headView];
    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:0.2];
    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setBackgroundColor:[UIColor yellowColor]];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.headView startRefresh];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
             [self.headView endRefresh];
    });
   

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    /**
     *  消除回弹效果,但是允许越界
     */
    if (scrollView.decelerating) {
        scrollView.bounces=NO;
    }
}
-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    //下拉后松手立刻走这个方法，然后如果不允许越界，会立刻回弹到无越界状态
   // scrollView.bounces=NO;
    //松手走完本方法，然后didscroll，bouces=no，headview的kvo调用，改变inset，然后didenddecelerating，bounces=yes
}

/**
 *  消除回弹效果,但是允许越界
 */
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    scrollView.bounces=YES;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.backgroundColor=[UIColor yellowColor];
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
