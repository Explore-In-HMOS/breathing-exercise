import { LengthUnit } from '@kit.ArkUI'
import { BreathingTechnique, PRESET_TECHNIQUES } from '../model/BreathingTechnique'

@Component
export struct TechniquesPage {
  @Consume('pageStack') pageStack: NavPathStack;
  @StorageLink('selectedTechniqueId') selectedTechniqueId: string = '4-7-8';
  @StorageLink('customInhale') customInhale: number = 4;
  @StorageLink('customHold') customHold: number = 4;
  @StorageLink('customExhale') customExhale: number = 4;

  getPhasesText(item: BreathingTechnique): string {
    if (item.id === 'custom') {
      return `${this.customInhale}s - ${this.customHold}s - ${this.customExhale}s`;
    }
    return item.phases.map(p => `${p.duration}s`).join(' - ');
  }

  build() {
    NavDestination() {
      Column() {
        Text('Techniques').fontSize(22).fontColor('#006064').fontWeight(FontWeight.Bold).margin({ bottom: 10 })

        List({ space: 8 }) {
        ForEach(PRESET_TECHNIQUES, (item: BreathingTechnique) => {
          ListItem() {
            Column({ space: 2 }) {
              Text(item.name)
                .fontSize(16)
                .fontColor(this.selectedTechniqueId === item.id ? '#4EB8DA' : '#006064')
                .fontWeight(FontWeight.Bold)
              Text(this.getPhasesText(item))
                .fontSize(12)
                .fontColor('#546E7A')
              Text(item.description)
                .fontSize(10)
                .fontColor('#006064')
                .textAlign(TextAlign.Center)
                .opacity(0.8)
            }
            .width('90%')
            .padding(8)
            .backgroundColor('#1A4EB8DA')
            .borderRadius(15)
            .onClick(() => {
              this.selectedTechniqueId = item.id;
              this.pageStack.pop();
            })
          }
        }, (item: BreathingTechnique) => item.id)
      }
      .height('85%')
    }
    .width('100%')
    .height('100%')
    .padding(12)
    .backgroundColor('#E0F7FA')
    }
    .hideTitleBar(true)
  }
}
