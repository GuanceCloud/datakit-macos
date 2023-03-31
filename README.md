[TOC]



### 页面生命周期

NSWindow 、NSWindowController、NSViewController、NSView之间的关系:

```objective-c
@interface NSWindowController : NSResponder <NSSeguePerforming>
@property (nullable, strong) NSWindow *window;
@property (nullable, strong) NSViewController *contentViewController;
- (void)windowWillLoad;
- (void)windowDidLoad;
- (void)close;
//NSWindowController管理 使 contentViewController 的view 展示在 window上
```

```objective-c
@interface NSWindow : NSResponder 
@property (nullable, strong) __kindof NSView *contentView;
@property (nullable, weak) __kindof NSWindowController *windowController;（弱引用，可能为空）
@property (nullable, strong) NSViewController *contentViewController;
- (void)makeKeyWindow;
- (void)makeMainWindow;
- (void)becomeKeyWindow;
- (void)resignKeyWindow;
- (void)becomeMainWindow;
- (void)resignMainWindow;
```

```objective-c
@interface NSViewController : NSResponder
@property (strong) IBOutlet NSView *view;
- (void)viewDidLoad;
- (void)viewWillAppear;
- (void)viewDidAppear;
- (void)viewWillDisappear;
- (void)viewDidDisappear;
```

```objective-c
@interface NSView : NSResponder 
@property (nullable, readonly, assign) NSWindow *window;
```



**注意**：

1. 但是少数开发也可以直接使用 nib 创建 window 绑定 view，此时无NSWindowController 如果未设置与 view 关联的 NSViewController 则也无 NSViewController。

2. `@interface NSCollectionViewItem : NSViewController` NSCollectionViewItem 继承自 NSViewController

     

**NSPanel** 继承自 NSWindow

- 默认情况下，面板在关闭时不会释放，因为它们通常是轻量级的并且经常重复使用。

Window -> View - > Action

**NSOpenPanel** 继承自 NSSavePanel ，面板关闭时会被释放，且点击事件无法用 NSApplication 采集


### 基本控件事件采集

#### 输入控件(NSSearchField、NSTextView、NSTextField)

* NSSearchField：
  * 搜索按钮的点击：**NSEvent: type=LMouseUp**
  * 输入框输入：**NSEvent: type=KeyUp**、**NSEvent: type=KeyDown**
  * clear按钮：**NSEvent: type=LMouseUp**

* NSTextView：无

* NSTextField：~~点击使成为第一响应（**NSEvent: type=LMouseDown**）~~ 无

#### 容器类（NSBox、NSTabView、NSSplitView、NSScrollView）

* NSBox：无点击事件采集

* NSTabView：切换 NSTabViewItem 点击，使用 NSTabViewDelegate 采集

* NSSplitView：无点击事件采集

* NSScrollView：NSScroller 滚动条点击、拖拽
  * **NSEvent: type=LMouseDragged**(拖拽不采集)
  * **NSEvent: type=LMouseUp**



#### 日历控件（NSDatePicker）

NSDatePickerStyle：

* NSDatePickerStyleClockAndCalendar :

  * 右上角的箭头与圆圈按钮：

    event： **NSEvent: type=LMouseUp**

    target：**NSDatePickerCell**

    action：**_clockAndCalendarReturnToHomeMonth**

  * 选择日期按钮：

    target：null

    action：null

    event：**NSEvent: type=LMouseDown** 、**NSEvent: type=LMouseUp**

* NSDatePickerStyleTextFieldAndStepper

  日期TextField填写：**NSEvent: type=KeyDown**

  Stepper：**NSEvent: type=LMouseDown** 两遍

  *  First

    | Key    | Value                              |
    | ------ | ---------------------------------- |
    | action | _stepperCellValueChanged:          |
    | target | <NSDatePickerCell: 0x600003715f80> |
    | sender | <NSDatePicker: 0x1005667a0>        |
    | event  | **NSEvent: type=LMouseDown**       |
    
  * Second 

    | Key    | Value                        |
  | ------ | ---------------------------- |
    | action | null                         |
  | target | null                         |
    | sender | <NSDatePicker: 0x1005667a0>  |
  | event  | **NSEvent: type=LMouseDown** |

* NSDatePickerStyleTextField

   日期TextField填写：

   | Key    | Value                       |
   | ------ | --------------------------- |
   | action | null                        |
   | target | null                        |
   | sender | <NSDatePicker: 0x1005667a0> |
   | event  | NSEvent: type=KeyDown       |
   
   
   

#### 其他常用控件

* NSButton：sender为button的事件不过滤直接采集。**NSEvent: type=LMouseUp**

* NSSegmentedControl:**NSEvent: type=LMouseUp**

* NSComboBox(下拉选择框 )： **NSEvent: type=LMouseUp** 可以获取到选项的title

* NSPopupButton(按钮菜单)：

  * 下拉按钮点击

    | Key    | Value                            |
    | ------ | -------------------------------- |
    | action | tableViewAction:                 |
    | target | <NSComboBoxCell: 0x6000037118c0> |
    | sender | <NSComboTableView: 0x100731510>  |
    | event  | NSEvent: type=LMouseUp           |

  * 选项点击

    | Key    | Value                     |
    | ------ | ------------------------- |
    | action | (null)                    |
    | target | (null)                    |
    | sender | <NSComboBox: 0x10073ba30> |
    | event  | NSEvent: type=LMouseUp    |

  

* NSSlider：**NSEvent: type=LMouseUp**

* NSStepper：**NSEvent: type=LMouseDown**

* NSProgressIndicator：无事件采集

  

* NSCollectionView：
  
  * NSCollectionViewItem继承自NSViewController 。==是否采集 item的 生命周期==



* NSTableView：

  * cell点击: 可以通过   NSApplication   ` - (BOOL)sendAction:(SEL)action to:(nullable id)target from:(nullable id)sender;` 采集

    **action (null)**

    **target (null)**

    **sender <NSTableView: 0x100566e80>**

    **event NSEvent: type=LMouseUp**

  * doubleAction: NSTableView 拥有的属性 

* NSOutlineView：继承自NSTableView

>  NSCollectionView和NSTableView 与 iOS 的 UICollectionView和UITableView 不同的是需要搭配 NSScrollView 使用

#### 面板和警告框

 也是容器

* NSAlert：(弹窗属于**NSPanel** 采集弹出收回 需要监控**becomeKeyWindow**)
* NSPanel：采集弹出收回 需要监控**becomeKeyWindow**

  点击事件具体看控件上的子控件。

#### 工具栏和菜单

* NSToolbar：

  **action (null)**

  **target (null)**

  **sender <NSToolbarItemViewer: 0x101814030 'NSToolbarShowColorsItem'>**

  **event NSEvent: type=LMouseUp**

* NSMenu：

  **action orderFrontStandardAboutPanel:**

  **target (null)**

  **sender <NSMenuItem: 0x6000029111f0 About Example>**

  **event NSEvent: type=LMouseUp**

* NSStatusBar：

​       **action itemClick:**

​       **target <AppDelegate: 0x600000239380>**

​       **sender <NSStatusBarButton: 0x100618e80>**

​       **event NSEvent: type=LMouseUp**

#### 手势采集

采集对象：

* Lable: 没有 NSLable macOS 中 lable 使用 NSTextField 来实现。

* NSImageView

方法：Hook `NSGestureRecognizer` 的 `setAction`与 `setTarget` 方法





RUM 采集结构预想：



Window与Panle :becomeKeyWindow  后可以接收事件响应



响应链： view ->视图层级下面的 view  ->...view -> ViewController(可能没有) -> window 





RUM

*  View

  - becomeKeyWindow
  - resignKeyWindow

  

* action

  

* resource



建议：
View 由用户手动控制，

Action 自动采集，ActionName 可由 路径+[控件titile]

