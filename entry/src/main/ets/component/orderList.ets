import { getOrderList, return_order_type } from "../api/orders";
import counter from "./counter";
import LoadingMoreView, { LoadingMoreStatus } from "./loadingMoreView";
import { router } from "@kit.ArkUI";

@Component
export default struct OrderList {
  @Prop orderTypeIdx: number;
  @State list: Array<return_order_type> | undefined = undefined;
  @State refreshing: boolean = false;
  @State promptText: string = '';
  @State loadingMore: boolean = false;
  @State reachStatus: LoadingMoreStatus = LoadingMoreStatus.prepare;
  private initCompleted: boolean = false;
  @State loadingMoveVisible: boolean = false;

  colorList: Record<string, string> = {
    '待支付': '#ffffa200',
    '已取消': '#999999',
    '已完成': '#ff21b121',
    '待服务': '#ff1da6fd'
  }

  aboutToAppear(): void {
    this.getList();
  }

  //加载第一页
  async getList() {
    let data = await getOrderList({ state: this.orderTypeIdx });
    this.list = data.map(item => {
      if (item.trade_state === '待支付') {
        item.order_start_time = item.order_start_time + 7200000 - Date.now()
      }
      return item;
    })
    this.initCompleted = true;
  }

  // 加载更多也
  async handleLoadingMore(){
    if(this.loadingMore){
      return
    }
    this.loadingMore = true;
    this.reachStatus = LoadingMoreStatus.loading;

    // 下一页请求
    let data = await getOrderList({ state: this.orderTypeIdx });
    if (data && data.length > 0) {
        setTimeout(() => {
          this.list = data;
          //追加数据
          //this.list = this.list?.concat(data);
          this.loadingMore = false;
          this.reachStatus = LoadingMoreStatus.prepare;
        },1000)
    }
    //到底了
    else {
      this.loadingMore = false;
      this.reachStatus = LoadingMoreStatus.reachEnd;
    }
  }

  @Builder
  listItem(item: return_order_type){
    // 列表项
    ListItem() {
      Row() {
        Row() {
          Image(item.serviceImg).width(100).height(100).padding(5).borderRadius(5)
          Column() {
            Text(item.service_name).fontSize(15).padding(5).fontWeight(FontWeight.Bold)
            Text(item.hospital_name).fontSize(12).padding(5)
            Text(item.starttime).fontSize(12).padding(5)
          }
          .padding({ left: 5 })
          .alignItems(HorizontalAlign.Start)
          .justifyContent(FlexAlign.Start)
        }

        Column() {
          //订单状态
          Text(item.trade_state)
            .fontSize(15)
            .fontColor(this.colorList[item.trade_state])

          // 待支付时候显示倒计时
          if (item.trade_state === '待支付') {
            counter({ allSeconds: item.order_start_time })
          }
        }.margin({ top: 10, right: 10 })
        .padding(5)

      }
      .backgroundColor(Color.White)
      .width('100%')
      .margin(5)
      .borderRadius(5)
      .justifyContent(FlexAlign.SpaceBetween)
      .alignItems(VerticalAlign.Top)
    }.onClick(() => this._2DetailPage(item))
  }

  _2DetailPage(item: return_order_type){
    router.pushUrl({
      url: 'pages/OrderDetailPage',
      params: {
        oid: item.out_trade_no,
      }
    })
  }

  build() {
    Column() {
      Refresh({refreshing: this.refreshing,promptText: this.promptText}){
        List() {
          ForEach(this.list, (item: return_order_type, index: number) => {
          this.listItem(item)
          },(item: return_order_type, index: number) => index.toString())

          //加载更多
          LoadingMoreView({ visible: this.loadingMoveVisible, status: this.reachStatus})
          // ListItem() {
          //   Row() {
          //     Text('没有更多了').width('100%').textAlign(TextAlign.Center)
          //   }.width('100%').margin({ bottom: 50, top: 20 })
          // }
        }.height('100%')
        //.scrollBar(BarState.Off)
        .onReachEnd(() => {
          if(this.initCompleted && this.reachStatus != LoadingMoreStatus.reachEnd){
            this.loadingMoveVisible = true;
            this.handleLoadingMore();
          }
        })
      }
      .onStateChange(async (state) => {
        switch (state){
          case RefreshStatus.Drag:
            this.promptText = '下拉可以刷新'
            break;
          case RefreshStatus.OverDrag:
            this.promptText = '释放立即刷新'
            break;
          case RefreshStatus.Refresh:
            this.promptText = '正在刷新'
            this.getList();
            break;
        }
      })
    }.padding(5)
    .justifyContent(FlexAlign.Start)
  }
}