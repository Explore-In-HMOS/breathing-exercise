import { TextModifier } from '../modifier/TextModifier'
import { Main } from './Main'
import { SettingsPage } from './Settings'
import { StatsPage } from './StatsPage'
import { TechniquesPage } from './TechniquesPage'
import { SummaryPage } from './SummaryPage'

@Entry
@Component
struct Index {
  @Provide('pageStack') pageStack: NavPathStack = new NavPathStack();
  @State textModifier: TextModifier = new TextModifier();

  @Builder
  PageMap(name: string) {
    if (name === 'Main') {
      Main()
    } else if (name === 'Settings') {
      SettingsPage()
    } else if (name === 'StatsPage') {
      StatsPage()
    } else if (name === 'TechniquesPage') {
      TechniquesPage()
    } else if (name === 'SummaryPage') {
      SummaryPage()
    }
  }

  @Builder
  MenuButton(title: string, onClick?: () => void) {
    Row() {
      Text(title)
        .attributeModifier(this.textModifier)
        .fontColor('#006064')
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
    }
    .width(140)
    .height(30)
    .justifyContent(FlexAlign.Center)
    .borderRadius(15)
    .backgroundColor('#A9DDE8')
    .onClick(() => {
      if (onClick) {
        onClick()
      }
    })
  }

  build() {
    Navigation(this.pageStack) {
      Column() {
        Column({ space: 8 }) {

          Text('Breathing Exercises')
            .fontSize(17)
            .fontWeight(FontWeight.Bold)
            .fontColor('#006064')
            .textAlign(TextAlign.Center)

          this.MenuButton('Start', () => {
            this.pageStack.pushPathByName('Main', null)
          })

          this.MenuButton('Techniques', () => {
            this.pageStack.pushPathByName('TechniquesPage', null)
          })

          this.MenuButton('Statistics', () => {
            this.pageStack.pushPathByName('StatsPage', null)
          })

          this.MenuButton('Settings', () => {
            this.pageStack.pushPathByName('Settings', null)
          })

        }
        .width('100%')
        .alignItems(HorizontalAlign.Center)

      }
      .width('100%')
      .height('100%')
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)
      .padding({ top: 6, bottom: 6 })
      .backgroundColor('#E0F7FA')
    }
    .hideTitleBar(true)
    .navDestination(this.PageMap)
  }
}