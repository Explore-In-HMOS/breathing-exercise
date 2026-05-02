import { SessionResult } from '../model/SessionModel'

@Component
export struct SummaryPage {
  @Consume('pageStack') pageStack: NavPathStack;
  @State result: SessionResult = {
    techniqueName: '4-7-8 Breathing',
    duration: 1,
    totalBreaths: 15,
    timestamp: Date.now()
  };

  build() {
    NavDestination() {
      Column({ space: 20 }) {
      Text('Session Summary')
        .fontSize(22)
        .fontColor('#006064')
        .fontWeight(FontWeight.Bold)

      Column({ space: 10 }) {
        Text(`Technique: ${this.result.techniqueName}`)
          .fontColor('#006064')
        Text(`Duration: ${this.result.duration} min`)
          .fontColor('#006064')
        Text(`Total Cycles: ${this.result.totalBreaths}`)
          .fontColor('#006064')
      }
      .padding(20)
      .backgroundColor('#1A4EB8DA')
      .borderRadius(20)

        Button('Done')
          .onClick(() => {
            this.pageStack.clear();
          })
          .backgroundColor('#4EB8DA')
          .fontColor(Color.White)
      }
      .width('100%')
      .height('100%')
      .padding(20)
      .backgroundColor('#E0F7FA')
      .justifyContent(FlexAlign.Center)
    }
    .hideTitleBar(true)
    .onReady((context: NavDestinationContext) => {
      if (context.pathInfo.param) {
        this.result = context.pathInfo.param as SessionResult;
      }
    })
  }
}
