@Component
export default struct Schedule {

  @Prop typeIndex : number = 0;
  typeList : Array<string> = ['填写订单', '在线支付', '专人服务', '服务完成']
  typeWidth: Array<number> = [15, 35, 65, 100]

  build() {
    Column() {
      // 进度条外部
      Row() {
        //进度条内部
        Text()
          .backgroundColor(this.typeIndex > 3 ? Color.Gray : '#ff409252')
          .width(`${this.typeIndex > 3 ? 100 : this.typeWidth[this.typeIndex]}%`)
          .height('100%')
          .borderRadius(20)
      }
      .width('100%')
      .height(15)
      .backgroundColor(Color.White)
      .borderRadius(20)
      .padding(2)

      //订单状态显示
      Row(){
        ForEach(this.typeList, (item: string, index) => {
          Text(item)
            .fontColor(Color.White)
            .fontSize(15)
            .fontWeight(FontWeight.Bold)
            .opacity(this.typeIndex == index ? 1 : 0.7)
        })
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')
      .padding(10)

    }
    .padding({top:'10%',left:10,right:10})
    .height(120)
    .width('100%')
    .backgroundColor('#ff409252')
  }
}