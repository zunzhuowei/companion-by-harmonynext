
@Extend(Text)
function textStyle() {
  .fontSize(13).fontColor('#999').lineHeight(20)
}

export enum LoadingMoreStatus{
  prepare,
  loading,
  reachEnd
}

@Component
export default struct LoadingMoreView {
  @Link visible : boolean
  @Prop @Require status: LoadingMoreStatus;


  build() {
    Row(){
      //初始态
      if (this.status === LoadingMoreStatus.prepare){
        Text('--- 上拉加载更多 ----').textStyle()
      }
      // 加载中
      else if (this.status === LoadingMoreStatus.loading){
        Row({space:5}) {
          Image($r('app.media.startIcon'))
            .width(20)
            .transition(TransitionEffect.rotate({angle:-360}))
            .animation({duration: 2000,curve: Curve.Linear,iterations:-1})
          Text('正在加载...').textStyle()
        }
      }
      else if(this.status === LoadingMoreStatus.reachEnd){
        Text('--- 已经到底了 ---').textStyle()
      }
    }.width('100%')
    .justifyContent(FlexAlign.Center)
    .padding(5)
    .visibility(this.visible ? Visibility.Visible : Visibility.None)
  }
}