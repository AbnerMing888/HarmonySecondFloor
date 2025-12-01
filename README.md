## 介绍

<p align="center">
<img src="https://vipandroid-image.oss-cn-beijing.aliyuncs.com/harmony/abner.jpg" width="100px" /><br/>
<span style="font-size:12px;color:red;">扫码关注，千帆起航，共筑鸿蒙！</span>
</p>

second_floor是一个便捷的下滑进入二楼组件，通过简单属性配置即可实现，除此之外，还支持下滑进入半楼功能，支持自定义刷新头功能。

## 支持Api版本

Api适用版本：**>=12**

## 效果

<img src="https://vipandroid-image.oss-cn-beijing.aliyuncs.com/harmony/refresh/refresh_sf.gif" width="300px" />


## 快速使用


方式一：在Terminal窗口中，执行如下命令安装三方包，DevEco Studio会自动在工程的oh-package.json5中自动添加三方包依赖。

**建议：在使用的模块路径下进行执行命令。**

```
ohpm install @abner/second_floor
```

方式二：在工程的oh-package.json5中设置三方包依赖，配置示例如下：

```
"dependencies": { "@abner/second_floor": "^1.0.0"}
```

## 代码使用


```typescript

SecondFloorView({
  childScroller: this.scroller,
  firstFloorView: () => { //一楼视图
    this.firstFloorView()
  },
  isNeedHalfFloor: true, //是否需要半楼功能
  secondFloorView: () => {
    this.secondFloorView()
  }, //二楼视图
  enableScrollInteraction: (isInteraction: boolean) => {
    //用于解决嵌套的滑动组件冲突
    this.mScrollInteraction = isInteraction
  },
  topFixedView: () => {
    //顶部固定视图
    this.topFixedView()
  },
  refreshController: this.refreshController, //刷新控制器
  refreshHeaderAttribute: (attr) => {
    //刷新头及二楼滑动属性配置
    attr.fontColor = Color.White
    attr.timeFontColor = Color.White
  },
  onRefresh: () => {
    //下拉刷新，模拟数据加载
    setTimeout(() => {
      this.refreshController.finishRefresh()
    }, 2000)
  },
  onScrollStatus: (status) => {
    //当前的滑动状态
  }
})

```

**属性介绍**

| 属性                      | 类型                                     | 概述                   |
|-------------------------|----------------------------------------|----------------------|
| firstFloorView          | @BuilderParam                          | 一楼视图View 不可为空        |
| secondFloorView         | @BuilderParam                          | 二楼视图View 不为空         |
| topFixedView            | @BuilderParam                          | 顶部固定视图View 可以为空      |
| refreshHeaderView       | @BuilderParam                          | 自定义刷新HeaderView 可以为空 |
| refreshHeaderAttribute  | (attribute: RefreshHeaderAttr) => void | 刷新头属性                |
| isNeedHalfFloor         | boolean                                | 是否需要半楼功能，默认false不需要  |
| refreshController       | RefreshController                      | 刷新控制器                |
| enableScrollInteraction | (interaction: boolean) => void         | 拦截回调                 |
| onRefresh               | () => void                             | 下拉刷新                 |
| enableRefresh           | boolean                                | 是否禁止刷新               |
| halfFloorHeight         | number                                 | 半楼的高度                |
| halfFloorGap            | number                                 | 半楼的差距                |
| opacityDistance         | number                                 | 透明的距离                |
| pullDownDistance        | number                                 | 下拉的距离                |
| releaseDistance         | number                                 | 释放的距离                |
| onScrollDistance        | (distance: number) => void             | 滑动距离                 |
| onChangeScrollStatus    | (status: RefreshLayoutStatus) => void  | 滑动状态改变监听             |
| onScrollStatus          | (status: RefreshLayoutStatus) => void  | 滑动状态                 |

## 完整案例
```typescript
import {
  SecondFloorView,
  RefreshController,
  WindowFullScreenUtil,
  RefreshLayoutStatusModel
} from '@abner/floor'
import { window } from '@kit.ArkUI'

@Entry
@ComponentV2
struct Index {
  private refreshController: RefreshController = new RefreshController()
  @Local topViewHeight: number = 44
  @Local statusBarHeight: number = 0
  @Local mScrollInteraction: boolean = true
  scroller: Scroller = new Scroller()

  onPageShow(): void {

    let sysBarProps: window.SystemBarProperties = {
      statusBarColor: "#00000000",
      navigationBarColor: '#00000000',
      // 以下两个属性从API Version 8开始支持
      statusBarContentColor: '#ffffff',
      navigationBarContentColor: '#ffffff'
    }

    WindowFullScreenUtil.changeWindowFullScreen(true, {
      sysBarProps: sysBarProps,
      success: (win) => {
        // 2. 获取布局避让遮挡的区域
        let area = win.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM)
        this.statusBarHeight = px2vp(area.topRect.height)
        this.topViewHeight = this.topViewHeight + this.statusBarHeight
      }
    })
  }

  onBackPress(): boolean | void {
    let sysBarProps: window.SystemBarProperties = {
      statusBarColor: "#ff0000",
      navigationBarColor: '#ff0000',
      // 以下两个属性从API Version 8开始支持
      statusBarContentColor: '#ffffff',
      navigationBarContentColor: '#ffffff'
    };
    WindowFullScreenUtil.changeWindowFullScreen(false, { sysBarProps: sysBarProps })

  }

  /*
  * Author:AbnerMing
  * Describe:一楼视图
  */
  @Builder
  firstFloorView() {
    Scroll(this.scroller) {
      Image($r("app.media.taobao_index"))
        .width("100%")
    }
    .width("100%")
    .height("100%")
    .scrollBar(BarState.Off)
    .enableScrollInteraction(this.mScrollInteraction)
  }

  /*
 * Author:AbnerMing
 * Describe:二楼视图
 */
  @Builder
  secondFloorView() {
    Column() {
      Image($r("app.media.taobao_second_floor"))
        .width("100%")
        .height("100%")
    }
    .width("100%")
    .height("100%")
  }

  /*
 * Author:AbnerMing
 * Describe:顶部固定视图
 */
  @Builder
  topFixedView() {
    Column() {
      Text("淘宝二楼")
        .fontColor(Color.White)
    }
    .width("100%")
    .height(this.topViewHeight)
    .padding({ top: this.statusBarHeight })
    .backgroundColor(Color.Red)
    .justifyContent(FlexAlign.Center)
  }

  @Builder
  refreshHeaderView(model: RefreshLayoutStatusModel) {
    Column() {
      Text(model.status?.toString())
        .fontColor(Color.White)
    }.height(80)
  }

  build() {
    RelativeContainer() {
      SecondFloorView({
        childScroller: this.scroller,
        firstFloorView: () => { //一楼视图
          this.firstFloorView()
        },
        isNeedHalfFloor: true, //是否需要半楼功能
        secondFloorView: () => {
          this.secondFloorView()
        }, //二楼视图
        enableScrollInteraction: (isInteraction: boolean) => {
          //用于解决嵌套的滑动组件冲突
          this.mScrollInteraction = isInteraction
        },
        topFixedView: () => {
          //顶部固定视图
          this.topFixedView()
        },
        refreshController: this.refreshController, //刷新控制器
        refreshHeaderAttribute: (attr) => {
          //刷新头及二楼滑动属性配置
          attr.fontColor = Color.White
          attr.timeFontColor = Color.White
        },
        onRefresh: () => {
          //下拉刷新，模拟数据加载
          setTimeout(() => {
            this.refreshController.finishRefresh()
          }, 2000)
        },
        onChangeScrollStatus: (status) => {
          //当前的滑动状态监听

        }
      })
        .id('SecondFloorView')
        .alignRules({
          center: { anchor: '__container__', align: VerticalAlign.Center },
          middle: { anchor: '__container__', align: HorizontalAlign.Center }
        })
    }
    .height('100%')
    .width('100%')
  }
}
```

## 咨询作者

如果您在使用上有问题，解决不了，或者查看精华的鸿蒙技术文章，可扫码进行操作。

<p><img src="https://vipandroid-image.oss-cn-beijing.aliyuncs.com/harmony/abner.jpg" width="150"></p>

## License

```
Copyright (C) AbnerMing, HarmonyOSFloor Open Source Project

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
