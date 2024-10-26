import { it } from '@ohos/hypium';
import { getHomeData, hospitals, nav2s, return_home_type, slides } from '../api/home';
import { router } from '@kit.ArkUI';

@Component
struct HomePage {
  @State
  homeData: return_home_type | null = null;
  scroller: Scroller = new Scroller()
  @State isLoading: boolean = true;

  aboutToAppear(): void {
    getHomeData().then((value: return_home_type) => {
      this.homeData = value;
    })
  }

  onPageShow(): void {

  }

  onDidBuild(): void {
    this.isLoading = false;
  }

  build() {
    if (this.isLoading) {
      Progress({value: 50,total: 100,type: ProgressType.Ring}).width('30%').height('30%')
        .onClick(() => {
          this.isLoading = false;
        })
    } else {
      Scroll(this.scroller) {
        Column() {
          // 头部
          Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
            Text('中部地区>')
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
              .fontColor('#666666')
              .margin({ left: 10 })
            Search({ placeholder: '搜索医院' }).width('60%')
          }.padding({ left: 10, right: 10 })

          // 轮播
          Swiper() {
            ForEach(this.homeData?.slides, (item: slides, index) => {
              Image(item.pic_image_url).width('100%').padding(5).borderRadius(10)
            })
          }
          .autoPlay(true)
          .loop(true)

          // 导航
          Flex() {
            ForEach(this.homeData?.nav2s, (item: nav2s) => {
              Image(item.pic_image_url).margin({ left: 5, right: 5 })
            })
          }

          // 医院列表
          List({ space: 10 }) {
            ForEach(this.homeData?.hospitals, (item: hospitals) => {
              ListItem() {
                Row() {
                  Image(item.avatar_url).width('30%').borderRadius(5)
                  Column() {
                    Text(item.name).fontSize(18).fontWeight(FontWeight.Bold)
                    Row() {
                      Text(item.rank)
                        .fontSize(15)
                        .fontColor('#666666')
                        .margin({ right: 10 })
                        .fontWeight(FontWeight.Bold)
                        .fontColor('#0ca7ae')
                      Text(item.label).fontSize(15).fontColor('#666666')
                        .fontWeight(FontWeight.Bold)
                        .fontColor('#0ca7ae')
                    }
                    .margin({ top: 5 })
                    Text(item.intro).fontSize(15).fontColor('#666666').margin({ top: 10 })
                  }
                  .alignItems(HorizontalAlign.Start)
                  .justifyContent(FlexAlign.Start)
                  //.height('100%')
                  .padding(10)
                }
                .width('100%')
                .padding(5)
              }
              //.height('40%')
              .borderStyle(BorderStyle.Solid)
              .border({
                width: {
                  bottom: 2,
                  top: 1,
                  left: 1,
                  right: 1
                },
                color: '#e5e5e5'
              })
              .borderRadius(10)
              .onClick(() => {
                router.pushUrl({
                  url: 'pages/CreateOrderPage',
                  params: {
                    id: item.id,
                  }
                })
              })
            })
          }
          .padding(5)
          .margin({ top: 10 })
        }
      }
      .scrollBar(BarState.Off)
    }
  }
}

export default HomePage;