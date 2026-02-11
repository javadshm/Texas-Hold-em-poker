# Visual Card Selector - How It Works

## Card Selector Dialog

When a user clicks on any empty card slot (showing a + icon) or an existing card, 
a dialog opens showing all 52 playing cards organized by suit.

### Layout:

```
┌────────────────────────────────────────────────────┐
│  Select a Card                              [X]    │
├────────────────────────────────────────────────────┤
│                                                     │
│  ♥ Hearts                                          │
│  ┌───┐ ┌───┐ ┌───┐ ┌───┐ ┌───┐ ┌───┐ ┌───┐       │
│  │ A │ │ K │ │ Q │ │ J │ │10 │ │ 9 │ │ 8 │ ...   │
│  │ ♥ │ │ ♥ │ │ ♥ │ │ ♥ │ │ ♥ │ │ ♥ │ │ ♥ │       │
│  └───┘ └───┘ └───┘ └───┘ └───┘ └───┘ └───┘       │
│                                                     │
│  ♦ Diamonds                                        │
│  ┌───┐ ┌───┐ ┌───┐ ┌───┐ ┌───┐ ┌───┐ ┌───┐       │
│  │ A │ │ K │ │ Q │ │ J │ │10 │ │ 9 │ │ 8 │ ...   │
│  │ ♦ │ │ ♦ │ │ ♦ │ │ ♦ │ │ ♦ │ │ ♦ │ │ ♦ │       │
│  └───┘ └───┘ └───┘ └───┘ └───┘ └───┘ └───┘       │
│                                                     │
│  ♣ Clubs                                           │
│  ┌───┐ ┌───┐ ┌───┐ ┌───┐ ┌───┐ ┌───┐ ┌───┐       │
│  │ A │ │ K │ │ Q │ │ J │ │10 │ │ 9 │ │ 8 │ ...   │
│  │ ♣ │ │ ♣ │ │ ♣ │ │ ♣ │ │ ♣ │ │ ♣ │ │ ♣ │       │
│  └───┘ └───┘ └───┘ └───┘ └───┘ └───┘ └───┘       │
│                                                     │
│  ♠ Spades                                          │
│  ┌───┐ ┌───┐ ┌───┐ ┌───┐ ┌───┐ ┌───┐ ┌───┐       │
│  │ A │ │ K │ │ Q │ │ J │ │10 │ │ 9 │ │ 8 │ ...   │
│  │ ♠ │ │ ♠ │ │ ♠ │ │ ♠ │ │ ♠ │ │ ♠ │ │ ♠ │       │
│  └───┘ └───┘ └───┘ └───┘ └───┘ └───┘ └───┘       │
│                                                     │
└────────────────────────────────────────────────────┘
```

### Card States:

**Available Card (white background, clickable):**
```
┌───┐
│ K │  ← Red text for Hearts/Diamonds
│ ♥ │  ← Red suit symbol
└───┘
```

**Available Card (white background, clickable):**
```
┌───┐
│ A │  ← Black text for Spades/Clubs
│ ♠ │  ← Black suit symbol
└───┘
```

**Disabled Card (gray background, not clickable):**
```
┌───┐
│ 7 │  ← Gray text
│ ♦ │  ← Gray suit symbol
└───┘
```

**Empty Card Slot (before selection):**
```
┌───┐
│   │
│ + │  ← Plus icon in white/gold
│   │
└───┘
```

## Example: Evaluate Tab Flow

### Initial State:
```
Player Cards:
┌───┐  ┌───┐
│   │  │   │
│ + │  │ + │  ← Click to select
└───┘  └───┘

Community Cards:
┌───┐  ┌───┐  ┌───┐  ┌───┐  ┌───┐
│ + │  │ + │  │ + │  │ + │  │ + │
└───┘  └───┘  └───┘  └───┘  └───┘
```

### After Selecting Some Cards:
```
Player Cards:
┌───┐  ┌───┐
│ K │  │   │
│ ♠ │  │ + │  ← Click to select (K♠ will be disabled in selector)
└───┘  └───┘

Community Cards:
┌───┐  ┌───┐  ┌───┐  ┌───┐  ┌───┐
│ A │  │ 6 │  │   │  │   │  │   │
│ ♣ │  │ ♦ │  │ + │  │ + │  │ + │
└───┘  └───┘  └───┘  └───┘  └───┘
```

### After "Load Example" Button:
```
Player Cards:
┌───┐  ┌───┐
│ K │  │ A │
│ ♠ │  │ ♣ │
└───┘  └───┘

Community Cards:
┌───┐  ┌───┐  ┌───┐  ┌───┐  ┌───┐
│ 6 │  │ 9 │  │ 4 │  │ 3 │  │ 2 │
│ ♦ │  │ ♠ │  │ ♥ │  │ ♠ │  │ ♣ │
└───┘  └───┘  └───┘  └───┘  └───┘
```

### After Evaluation - Result Display:
```
┌──────────────────────────────────┐
│           🏆                      │
│                                   │
│        High Card                  │  ← Large gold text
│                                   │
│        Best Hand:                 │
│                                   │
│  ┌───┐ ┌───┐ ┌───┐ ┌───┐ ┌───┐  │
│  │ A │ │ K │ │ 9 │ │ 6 │ │ 4 │  │
│  │ ♣ │ │ ♠ │ │ ♠ │ │ ♦ │ │ ♥ │  │
│  └───┘ └───┘ └───┘ └───┘ └───┘  │
│                                   │
└──────────────────────────────────┘
```

## Color Scheme

- **Background**: Dark green poker table (#0A5F38)
- **Cards**: White with shadows
- **Hearts/Diamonds**: Red (#FF0000)
- **Spades/Clubs**: Black (#000000)
- **Buttons**: Gold (#D4AF37)
- **Winner**: Green background
- **Loser**: Red background
- **Progress bars**: Green (win), Orange (tie), Red (loss)

## Interactive Features

1. **Click empty slot** → Opens card selector
2. **Click filled slot** → Opens card selector (current card excluded from disabled set)
3. **Click card in selector** → Selects card, closes dialog
4. **Click "Load Example"** → Auto-fills all cards with test data
5. **Disabled cards** → Visually grayed out, not clickable
6. **Loading state** → Shows spinner in button during API calls
