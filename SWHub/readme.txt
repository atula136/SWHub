一、规范
嵌套类型仅用在Model定义中
二、功能
条件中的搜索
三、问题
1. log
2. 隐藏键盘顶部工具栏
4. RxOptional
8. 更换SWFrame的Label/Button/ImageView
10. Parchment源码/ReactorKit源码
11. 自定义下拉刷新/加载效果，采用ScrollViewController运行时方式
12. hashValue
15. requestArray为空的error
16. 适配iPhoneX
17. 首页 重名 趋势（Trending）
18. 嵌套类型全路径
20. 下拉刷新/加载更多，自定义UI
21. 折叠说明文本
测试模拟数据
暗黑模式：下拉刷新活动指示器、Since文本
设置页的暗黑模式的切换按钮的状态应该是单向的
state -> refresh ui效果
languageColor
首次安装、首页网络错误
开机广告
默认头像
首页底部没显示完整
Button/Label
更新与xx小时前/homepage跳转
UILocalizedImage
pod版本号 ~> 自动更新
NavigationBar运行时修改theme在模拟器上会crash
StringTransform -> IDTransform

https://api.github.com/user/starred/rxhanson/Rectangle


issues:
https://api.github.com/repos/rxhanson/Rectangle/issues?page=1&state=open|closed
pullRequests:
https://api.github.com/repos/rxhanson/Rectangle/pulls?page=1&state=open
branches:
https://api.github.com/repos/rxhanson/Rectangle/branches?page=1
user
https://api.github.com/users/KalleHallden
checkFollowing/followUser/unfollowUser
https://api.github.com/user/following/KalleHallden
userRepositories
https://api.github.com/users/KalleHallden/repos?page=1
userFollowers
https://api.github.com/users/KalleHallden/followers?page=1
userFollowing
https://api.github.com/users/KalleHallden/following?page=1
userStarredRepositories
https://api.github.com/users/KalleHallden/starred?page=1
userWatchingRepositories
https://api.github.com/users/KalleHallden/subscriptions?page=1
userReceivedEvents
https://api.github.com/users/KalleHallden/received_events?page=1

2、User
checkFollowing/followUser/unfollowUser
https://api.github.com/user/following/onevcat
branches
https://api.github.com/repos/khoren93/SwiftHub/branches?page=1


登录
筛选
首页
设置


一、框架
采用RxSwift和ReactorKit的响应式单向流框架，详情参见：
https://github.com/ReactorKit/ReactorKit
二、存储
采用UserDefaults和Realm数据库方案
1、部分全局数据（与用户无关），如App主题等，使用UserDefaults
2、用户数据使用Realm，以便切换用户后，能还原用户的状态
三、第三方框架
1、RxSwift：响应式框架
2、ReactorKit：单向流框架
3、RealmSwift：Realm数据库

