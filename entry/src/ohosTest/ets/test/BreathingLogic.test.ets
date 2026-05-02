import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { PRESET_TECHNIQUES } from '../../../main/ets/model/BreathingTechnique';

export default function breathingLogicTest() {
  describe('BreathingLogicTest', () => {
    it('testPresetTechniques', 0, () => {
      expect(PRESET_TECHNIQUES.length).assertLarger(0);
      const box = PRESET_TECHNIQUES.find(t => t.id === 'box');
      expect(box).assertEntity();
      expect(box?.phases.length).assertEqual(4);
    })

    it('test478Technique', 0, () => {
      const tech = PRESET_TECHNIQUES.find(t => t.id === '4-7-8');
      expect(tech).assertEntity();
      expect(tech?.phases[0].duration).assertEqual(4);
      expect(tech?.phases[1].duration).assertEqual(7);
      expect(tech?.phases[2].duration).assertEqual(8);
    })
  })
}
