export interface Phase {
  name: string;
  duration: number; // in seconds
}

export interface BreathingTechnique {
  id: string;
  name: string;
  description: string;
  phases: Phase[];
}

export const PRESET_TECHNIQUES: BreathingTechnique[] = [
  {
    id: '4-7-8',
    name: '4-7-8 Breathing',
    description: 'Relaxes the nervous system. Good for sleep.',
    phases: [
      { name: 'Inhale', duration: 4 },
      { name: 'Hold', duration: 7 },
      { name: 'Exhale', duration: 8 }
    ]
  },
  {
    id: 'box',
    name: 'Box Breathing',
    description: 'Relieves stress and improves focus.',
    phases: [
      { name: 'Inhale', duration: 4 },
      { name: 'Hold', duration: 4 },
      { name: 'Exhale', duration: 4 },
      { name: 'Hold', duration: 4 }
    ]
  },
  {
    id: 'wim-hof',
    name: 'Wim Hof Style',
    description: 'Increases energy and reduces inflammation.',
    phases: [
      { name: 'Inhale', duration: 2 },
      { name: 'Exhale', duration: 2 }
    ]
  },
  {
    id: 'custom',
    name: 'Custom',
    description: 'Your own custom rhythm.',
    phases: [] // Will be populated dynamically
  }
];
