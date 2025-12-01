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