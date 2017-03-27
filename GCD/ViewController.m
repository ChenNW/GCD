//
//  ViewController.m
//  GCD
//
//  Created by Cnw on 2017/3/24.
//  Copyright © 2017年 Cnw. All rights reserved.
//

#import "ViewController.h"
#import "Tool.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
/** imageview */
@property(nonatomic ,strong)UIImageView *imageView;
/** 图片1 */
@property(nonatomic ,strong)UIImage *image1;
/** 图片2 */
@property(nonatomic ,strong)UIImage *image2;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.imageView];
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    [self railings];
    Tool * t1 = [Tool shareTool];
    Tool * t2 = [Tool shareTool];
    Tool * t3 = [Tool shareTool];
    Tool * t4 = [t1 copy];
    Tool * t5 = [t2 mutableCopy];
    NSLog(@"%p,%p,%p,%p,%p",t1,t2,t3,t4,t5);
}
#pragma mark - 异步并行队列
-(void)asyncConcurrent
{

    // 创建队列
    // 第一个参数是标识,第二个是并行队列
//    dispatch_queue_t queue = dispatch_queue_create("cnw", DISPATCH_QUEUE_CONCURRENT);
    
    // 创建全局队列,第一个参数是队列的优先级,这个是获得队列,就已经存在
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    // 封装任务,把任务放在队列中执行
    dispatch_async(queue, ^{
        NSLog(@"1-------当前队列%@",[NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"2-------当前队列%@",[NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"3-------当前队列%@",[NSThread currentThread]);
    });

}
#pragma mark - 异步串行队列
-(void)asyncSerial
{
    // 创建队列
    dispatch_queue_t queue = dispatch_queue_create("cnw0", DISPATCH_QUEUE_SERIAL);
    
    // 封装任务
    dispatch_async(queue, ^{
        NSLog(@"1-------当前队列%@",[NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"2-------当前队列%@",[NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"3-------当前队列%@",[NSThread currentThread]);
    });

}
#pragma mark - 同步串行队列
-(void)syncSerial
{
    // 创建队列
    dispatch_queue_t queue = dispatch_queue_create("cnw0", DISPATCH_QUEUE_SERIAL);
    
    // 封装任务
    dispatch_sync(queue, ^{
        NSLog(@"1-------当前队列%@",[NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"2-------当前队列%@",[NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"3-------当前队列%@",[NSThread currentThread]);
    });
    
}
#pragma mark - 同步并行队列
-(void)syncConcurrent
{
    // 创建队列
    dispatch_queue_t queue = dispatch_queue_create("cnw0", DISPATCH_QUEUE_CONCURRENT);
    
    // 封装任务
    dispatch_sync(queue, ^{
        NSLog(@"1-------当前队列%@",[NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"2-------当前队列%@",[NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"3-------当前队列%@",[NSThread currentThread]);
    });
    
}
#pragma mark - 异步主队列
-(void)asyncMain
{
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    // 封装任务,把任务放在队列中执行
    dispatch_async(queue, ^{
        NSLog(@"1-------当前队列%@",[NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"2-------当前队列%@",[NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"3-------当前队列%@",[NSThread currentThread]);
    });
    
}
#pragma mark - 同步主队列
-(void)syncMain
{
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    
    NSLog(@"开始执行");
    // 封装任务,把任务放在队列中执行
    dispatch_sync(queue, ^{
        NSLog(@"1-------当前队列%@",[NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"2-------当前队列%@",[NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"3-------当前队列%@",[NSThread currentThread]);
    });
    NSLog(@"完成执行");
}
#pragma mark - GCD线程间通信
-(void)threadMes
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        UIImage * image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1490352377321&di=57b814f647287d559e264311887c5e9c&imgtype=0&src=http%3A%2F%2Fimg.sj33.cn%2Fuploads%2Fallimg%2F201402%2F102J0KJ-24.jpg"]]];
        
        // 加载好数据以后,在UI界面显示回到主线程
        //        dispatch_sync(dispatch_get_main_queue()
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageView.image = image;
            NSLog(@"当前线程是00%@",[NSThread currentThread]);
        });
        
        NSLog(@"当前线程是01%@",[NSThread currentThread]);
    });
    

}
#pragma mark - GCD延时操作
-(void)delay
{
    NSLog(@"开始任务");
    // 第一种方法
//    [self performSelector:@selector(run) withObject:self afterDelay:2.0];
    // 第二种方法
//    [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(run) userInfo:nil repeats:YES];
    
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    // 第三种方法GCD
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), queue, ^{
        // 可以在主线程,也可以现在子线程
         NSLog(@"%@",[NSThread currentThread]);
        
    });

}
#pragma mark - GCD只会创建一次的操作
-(void)once
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSLog(@"打印了几次🐒🐒🐒🐒🐒🐒");
    });

}
#pragma mark - 栅栏函数
-(void)railings
{
//    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_queue_t queue = dispatch_queue_create("cnw01", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queue, ^{
        NSLog(@"thread1--------%@",[NSThread currentThread]);
    });
    
    dispatch_async(queue, ^{
        NSLog(@"thread2--------%@",[NSThread currentThread]);
    });
    
    dispatch_barrier_async(queue, ^{
        
        NSLog(@"thread3🐛--------%@",[NSThread currentThread]);
    });
    
    dispatch_async(queue, ^{
        NSLog(@"thread4--------%@",[NSThread currentThread]);
    });
    
    dispatch_async(queue, ^{
        NSLog(@"thread5--------%@",[NSThread currentThread]);
    });

   
}
#pragma mark - 快速迭代
-(void)apply
{
    // 首先获得需要剪切的文件夹
    NSString * frome = @"/Users/chenningwei/Desktop/屏幕截图";
    // 剪切到的文件夹
    NSString * to = @"/Users/chenningwei/Desktop/目标文件";
    // 得到需要剪切文件夹内的元素
    NSArray * files =  [[NSFileManager defaultManager] subpathsAtPath:frome];
    
    // 遍历数组中的元素
    NSInteger count = files.count;
    dispatch_apply(count, dispatch_get_global_queue(0, 0), ^(size_t index) {
        
        // 获得剪切文件内文件的全路径
        NSString * fromePath = [frome stringByAppendingPathComponent:files[index]];
        // 剪切到文件夹文件全路径
        NSString * toPath = [to stringByAppendingPathComponent:files[index]];
        // 剪切
        [[NSFileManager defaultManager] moveItemAtPath:fromePath toPath:toPath error:nil];
        NSLog(@"%@----%@-----%@",fromePath,toPath,[NSThread currentThread]);
    });
    

}
#pragma mark - 队列组下载图片
-(void)queues
{
    // 创建队列组
    dispatch_group_t group = dispatch_group_create();
    // 全局队列
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    // 下载第一张图片
    dispatch_group_async(group, queue, ^{
        NSURL * url = [NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1490352377321&di=57b814f647287d559e264311887c5e9c&imgtype=0&src=http%3A%2F%2Fimg.sj33.cn%2Fuploads%2Fallimg%2F201402%2F102J0KJ-24.jpg"];
        NSData * data = [NSData dataWithContentsOfURL:url];
        self.image1= [UIImage imageWithData:data];
        
    });
    dispatch_group_async(group, queue, ^{
        NSURL * url = [NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1490352377321&di=57b814f647287d559e264311887c5e9c&imgtype=0&src=http%3A%2F%2Fimg.sj33.cn%2Fuploads%2Fallimg%2F201402%2F102J0KJ-24.jpg"];
        NSData * data = [NSData dataWithContentsOfURL:url];
        self.image2= [UIImage imageWithData:data];
        
    });
    
    // 等两张图片下载完以后进行合成
    dispatch_group_notify(group, queue, ^{
        
        // 开始图形上下文
        UIGraphicsBeginImageContext(CGSizeMake(200, 200));
        
        //画图
        [self.image1 drawInRect:CGRectMake(0, 0, 200, 100)];
        self.image1 = nil;
        [self.image2 drawInRect:CGRectMake(0, 100, 200, 100)];
        self.image2 = nil;
        // 根据图形上下文得到一张图片
        UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
        // 关闭图形上下文
        UIGraphicsEndPDFContext();
        
        // 设置图片
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageView1.image = image;
        });
        
        
    });

    
}
-(void)run
{
    NSLog(@"%@",[NSThread currentThread]);
}
@end
